["Markdown rendering."]

Formats.parsedocs(::Formats.Format{Formats.MarkdownFormatter}, raw, m, obj) = Markdown.parse(raw)

## Prepare methods
type RenderedMarkdown
    outdir   :: UTF8String
    outpages :: Dict{AbstractString, AbstractString}
    layout   :: Vector{Tuple{UTF8String, Vector}}
    document :: Node{Document}
end

function render!{T}(outpages::Dict, layout::Tuple, n::Node{T}, outdir::UTF8String)
    for child in n.children
        inner!(outpages, layout, child, outdir)
    end
end

function inner!(outpages::Dict, layout::Tuple, n::Node{Section}, outdir::UTF8String)
    haskey(n.data, :nosubdir) && return render!(outpages, layout, n, outdir)

    outdir = joinpath(outdir, get(findconfig(n, :outname, UTF8String)))
    curlayout = (get(findconfig(n, :title, UTF8String)), [])
    push!(layout[2], curlayout)
    render!(outpages, curlayout, n, outdir)
end

function inner!(outpages::Dict, layout::Tuple, n::Node{Page}, outdir::UTF8String)
    outpath = joinpath(outdir, "$(get(findconfig(n, :outname, UTF8String))).md")
    curlayout = (get(findconfig(n, :title, UTF8String)), outpath)
    push!(layout[2], curlayout)
    addconfig(n, :outpath,  outpath)
    outpages[outpath] = inner(n)
end


## Render methods
function inner(n::Node{Page})
    io = IOBuffer()
    emptyline = true    # avoids first line of page to be empty
    for child in n.children
        emptyline = innerpage!(io, n, child, emptyline)
    end
    return takebuf_string(io)
end

function innerpage!(io::IO, ::Node, s::AbstractString, emptyline::Bool)
    if getheadertype(s) == :none
        filename = abspath(s)
        isfile(filename) ? print(io, readall(filename)) : println(io, s)
        return false
    else
        emptyline ? println(io, s) : (println(io); println(io, s))
        println(io)
        return true
    end
end

function innerpage!(io::IO, ::Node, n::Node{Docs}, emptyline::Bool)
    for child in n.children
        emptyline = innerpage!(io, n, child, emptyline)
    end
    println(io)
    return true
end

function innerpage!(io::IO, n::Node, m::Module, emptyline::Bool)
    warn("!! TODO: `Page Docs Module` not finished yet!!")
    objects = Cache.objects(m)
    # get any filter config for this node
    f = findconfig(n, :filter, Function)
    objs = isnull(f) ? objects : filter(get(f), objects)
    for obj in objs
        objname = nameof(m, obj)    # Replace that later
        println(io, "---\n")
        println(io, "#### $(objname)")    # Replace that later
        println(io)
        writemime(io, "text/plain", Cache.getparsed(m, obj))
        println(io)
    end
    return true
end


## User interface
function markdown(outdir::AbstractString, document::Node{Document})
    checkconfig!(document)
    outpages = Dict()
    layout = Vector([(get(findconfig(document, :title, UTF8String)), [])])
    curlayout = layout[1]
    render!(outpages, curlayout, document, convert(UTF8String, ""))
    return RenderedMarkdown(abspath(outdir), outpages, layout, document)
end

function save(rmd::RenderedMarkdown; remove_destination = false)
    if ispath(rmd.outdir)
        if remove_destination
            rm(rmd.outdir; recursive = true)
        else
            throw(ArgumentError(string("""
               ``outdir`` exists.
               ``remove_destination = true`` is required to remove it before saving.
               outdir: $(rmd.outdir)
               """)))
        end
    end
    mkpath(rmd.outdir)
    for (path, content) in rmd.outpages
        abs_path = joinpath(rmd.outdir, path)
        pathdir = dirname(abs_path)
        ispath(pathdir) || mkpath(pathdir)
        open(abs_path, "w") do f
            info("writing documentation to $(abs_path)")
            write(f, content)
        end
    end
    # mkdocs yaml
    haskey(rmd.document.data, :mkdocsyaml) && rmd.document.data[:mkdocsyaml] && writemkdocs(rmd)
    return rmd
end
