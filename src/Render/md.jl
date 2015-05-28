["Markdown rendering."]

Formats.parsedocs(::Formats.Format{Formats.MarkdownFormatter}, raw, mod, obj) = Markdown.parse(raw)

immutable EmptyRenderError <: Exception
    msg :: AbstractString
end

type RenderedMarkdown
    outdir   :: UTF8String
    outpages :: Vector{Tuple{AbstractString, AbstractString}}   # outpath, outcontent
end

# Render Content
function render(children::Vector{Content})
    io = IOBuffer()
    for child in children
        child.typename == :module ? render!(io, child) : println(io, child.data)
        println(io)    
    end
    return takebuf_string(io)
end

function writemd(io::IO, docs::Interface.Docs{:md})
    println(io, docs.data)
end

# Render Content Module: only temporar till: TODO proper obj signature is done
function render!(io::IO, child::Content)
    mod = child.data
    config = child.config
    # Filter/Sorter
    objects = filter_sorter(mod, config)
    for obj in objects
        objname = string(obj)    # Replace that later
        println(io, "---\n")
        println(io, string(config.style_obj, " ",  objname))
        println(io)
        writemime(io, "text/plain", Cache.getparsed(mod, obj))
        println(io)
    end
end

function filter_sorter(mod::Module, config::Config)
    # just a dummy method for now: see TODO.md wait for `MichaelHatherly` implementation of [
    # filters and sorters](https://github.com/MichaelHatherly/Lexicon.jl/issues/109#issuecomment-102117235)
    objects = Cache.objects(mod)
    filter!((obj) -> Cache.getmeta(mod, obj)[:category] in config.objfilter, objects)
    return objects
end

# Render Sections / Page
function render!(outpages::Vector, children::Vector, outdir::UTF8String)
    for child in children
        isempty(child.children) && throw(EmptyRenderError("'$(getnodename(child))': '$(child.name) is empty."))
        if isa(child, Node{Section})
            abs_outdir = joinpath(outdir, string(child.name))  # new out subdir: account for any symbols
            render!(outpages, child.children, abs_outdir)
        elseif isa(child, Node{Page})
            outpath = joinpath(outdir, "$(child.name).md")
            child.meta[:outpath] = outpath
            push!(outpages, (outpath, render(child.children)))
        else
            throw(ArgumentError(string("wrong child type: '$(typeof(child))' must be one of: ",
                                       "`Section, Preformat, Pages or Page`")))
        end
    end
end

## Main
function markdown(outdir::AbstractString, document::Node{Document})
    abs_outdir = utf8(joinpath(abspath(outdir), string(document.name)))
    outpages = Vector()
    isempty(document.children) && throw(EmptyRenderError("document: '$(document.name) is empty."))

    render!(outpages, document.children, abs_outdir)
    return RenderedMarkdown(abspath(outdir), outpages)
end


"""
!!summary(Write the documentation stored in RenderedMarkdown to disk.)
"""
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
        pathdir = dirname(path)
        ispath(pathdir) || mkpath(pathdir)
        open(path, "w") do f
            info("writing documentation to $(path)")
            write(f, content)
        end
    end
end
