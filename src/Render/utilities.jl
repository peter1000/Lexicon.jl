["Helper functions."]

# Returns a generated outname from the node's configuration ``:title``. Internal usage.
function getoutname!(n::Node)
    haskey(n.data, :outname) && return utf8checked!(n.data, :outname)

    replace_chars = Set(Char[' ', '&', '-'])
    io = IOBuffer()
    for c in n.data[:title]
        c in replace_chars ? write(io, "_") : write(io, lowercase(string(c)))
    end
    n.data[:outname] = takebuf_string(io)
    utf8checked!(n.data, :outname)
end

"""
Checks the node's configuration settings.

* required keys and expected types
"""
function checkconfig!{T}(n::Node{T})
    haskey(n.data, :title) || throw(ArgumentError("'$(rename(T))' has no key ':title'."))
    utf8checked!(n.data, :title)
    getoutname!(n)
    for child in n.children
        checkinner!(child)
    end
end
checkinner!(n) = return
checkinner!(n::Node{Section}) = checkconfig!(n)
checkinner!(n::Node{Page})    = checkconfig!(n)

function getheadertype(s::AbstractString)
    for i in 1:min(length(s), 7)
        s[i] != '#' && return i < 2 ? :none : symbol("header$(i-1)")
    end
    return :none
end

function objectsfiltered(n::Node, m::Module)
    objects = Cache.objects(m)
    f = findconfig(n, :filter, Function)
    objects = isnull(f) ? objects : filter(get(f), objects)
end

# from base/methodshow.jl
function url(linesource::Tuple)
    line, file = linesource
    try
        d = dirname(file)
        u = Pkg.Git.readchomp(`config remote.origin.url`, dir=d)
        u = match(Pkg.Git.GITHUB_REGEX,u).captures[1]
        root = cd(d) do # dir=d confuses --show-toplevel, apparently
            Pkg.Git.readchomp(`rev-parse --show-toplevel`)
        end
        if startswith(file, root)
            commit = Pkg.Git.readchomp(`rev-parse HEAD`, dir=d)
            return "https://github.com/$u/tree/$commit/"*file[length(root)+2:end]*"#L$line"
        else
            return Base.fileurl(file)
        end
    catch
        return Base.fileurl(file)
    end
end
