## markdown rendering  –––––––––––––––––––––––––––––––––––––

const (fmt, md) = (Docile.Formats, Markdown)
immutable MarkdownFormatter <: fmt.AbstractFormatter end
#=
"""
    import Docile.Formats, Markdown
    const (fmt, md) = (Docile.Formats, Markdown)

    immutable MarkdownFormatter <: fmt.AbstractFormatter end

    fmt.parsedocs(::fmt.Format{MarkdownFormatter}, raw) = md.parse(raw)
""" =#
function save(file::AbstractString, mime::MIME"text/md", modname::Module, config::Config)
    #ents = Entries(abspath(file), config)
    
    raw_ = Docile.Cache.getraw(modname)
    #Docile.Cache.getparsed(modname)
    #Docile.Cache.getmeta(modname)
    
    println("raw_: ", raw_ )
    # Write the main file.
    isfile(file) || mkpath(dirname(file))
    open(file, "w") do f
        info("writing documentation to $(file)")
    end
    #return ents
end
