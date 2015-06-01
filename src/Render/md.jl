["Markdown rendering."]

Formats.parsedocs(::Formats.Format{Formats.MarkdownFormatter}, raw, mod, obj) = Markdown.parse(raw)

type RenderedMarkdown
    outdir      :: UTF8String
    outpages    :: Vector{Tuple{AbstractString, AbstractString}}
    layout      :: Vector{Tuple{UTF8String, Vector}}
    document    :: Node{Document}
end

function render!{T}(outpages::Vector, layout::Tuple, n::Node{T}, outdir::UTF8String)
    for child in n.children
        inner!(outpages, layout, child, outdir)
    end
end

function inner!(outpages::Vector, layout::Tuple, n::Node{Section}, outdir::UTF8String)
    haskey(n.data, :nosubdir) && return render!(outpages, layout, n, outdir)

    outdir = joinpath(outdir, getconfig(n, :outname))
    curlayout = (getconfig(n, :title), [])
    push!(layout[2], curlayout)
    render!(outpages, curlayout, n, outdir)
end

function inner!(outpages::Vector, layout::Tuple, n::Node{Page}, outdir::UTF8String)
    outpath = joinpath(outdir, "$(getconfig(n, :outname)).md")
    curlayout = (getconfig(n, :title), outpath)
    push!(layout[2], curlayout)
    addconfig(n, :outpath,  outpath)
    push!(outpages, (outpath, inner(n)))
end

function inner(n::Node{Page})
    io = IOBuffer()
    for child in n.children
        innerpage!(io, child)
        println(io)
    end
    return takebuf_string(io)
end

function inner!(io::IO, n::Node{Docs})
    println(io, "#### TODO: `Page Docs Nodes` not implemented yet")
end

function innerpage!(io::IO, v)
    println(io, "#### TODO: `Page Content` not implemented yet")
end

function markdown(outdir::AbstractString, document::Node{Document})
    checkconfig!(document)
    outpages = Vector()
    layout = Vector([(getconfig(document, :title), [])])
    curlayout = layout[1]
    render!(outpages, curlayout, document, convert(UTF8String, ""))
    return RenderedMarkdown(abspath(outdir), outpages, layout, deepcopy(document))
end

function save(rmd::RenderedMarkdown; remove_destination=false)
    if ispath(rmd.outdir)
        if remove_destination
            rm(rmd.outdir; recursive=true)
        else
            throw(ArgumentError(string("\n'save(): outdir' exists. `remove_destination=true` ",
                                       "is required to remove it before saving.\n",
                                       "outdir: $(rmd.outdir)\n\n")))
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
end
