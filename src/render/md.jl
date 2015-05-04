## markdown rendering  –––––––––––––––––––––––––––––––––––––
immutable MarkdownFormatter <: Docile.Formats.AbstractFormatter end

Docile.Formats.parsedocs(::Docile.Formats.Format{MarkdownFormatter}, raw) = Markdown.parse(raw)

#=
"""

""" =#
function save(file::AbstractString, mime::MIME"text/md", modname::Module, config::Config)
    #ents = Entries(abspath(file), config)

    #raw_ = Docile.Cache.getraw(modname)
    #println("raw_: ", raw_ )
    #Docile.Cache.parse!(modname)
    #parsed_ = Docile.Cache.getparsed(modname)
    #println("parsed_: ", keys(parsed_))

    #meta_ = Docile.Cache.getmeta(modname)
    #println("meta_: ", keys(meta_ ))
    #println("meta_: ", meta_[Lexicon.Config])

    # Write the main file.
    isfile(file) || mkpath(dirname(file))
    open(file, "w") do f
        info("writing documentation to $(file)")
    end
    #return ents
end
