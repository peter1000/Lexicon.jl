"""
TODO: needs to be redone.
"""
type Entries
    savepath        :: UTF8String
    modname         :: Module
    # name on purpose slightly different to avoid easily mixing it up with a passed argument in index
    savedconfig     :: Config
    index_relpath   :: UTF8String
    # still missing
    
    Entries(savepath::AbstractString, modname::Module, savedconfig::Config) = 
        new(savepath, modname, savedconfig, "")
end

"Collect saved module documentation for generating the Index."
type Index
    entries::Vector{Entries}
end
Index() = Index(Vector{Entries}[])

function update!(index::Index, ents::Entries)
    push!(index.entries, ents)
end

"""
Saves the documentation of Moduel `modname` to the specified `file`.

The format is guessed from the `file`'s extension. Currently supported formats are `markdown`.
"""
function save(file::AbstractString, modname::Module, config::Config; args...)
    config = update_config!(deepcopy(config), Dict(args))
    mime = MIME("text/$(strip(last(splitext(file)), '.'))")

    # `rootfile` is where module `modname ... end` is found. 
    # So for a package it would be `Pkg.dir("MODULENAME", "src", "MODULENAME.jl")`.
    modname_str = string(modname)
    rootfile = Pkg.dir(modname_str, "src", "$(modname_str).jl")
    # Register a package by specifying a root module and file. Use `PlaintextFormatter`
    Docile.Cache.register!(modname, rootfile; format = Docile.Formats.PlaintextFormatter) # TODO: extract
    index_entries = save(file, mime, modname, config)
    return index_entries
end
save(file::AbstractString, modname::Module; args...) = save(file, modname, Config(); args...)


## Format-specific rendering ------------------------------------------------------------
include("render/md.jl")
