## Common render methods --------------------------------------------------------

"""
TODO: needs to be redone.
"""
type Entries
    savepath        :: UTF8String
    mod             :: Module
    savedconfig     :: Config               # config a page was saved with
    index_relpath   :: UTF8String
    # still missing
    
    Entries(savepath::AbstractString, mod::Module, savedconfig::Config) = 
        new(savepath, mod, savedconfig, "")
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
Saves the documentation of Moduel `mod` to the specified `file`.

The format is guessed from the `file`'s extension. Currently supported formats are `markdown`.
"""
function save(file::AbstractString, mod::Module, config::Config; args...)
    config = update_config!(deepcopy(config), Dict(args))
    mime = MIME("text/$(strip(last(splitext(file)), '.'))")
    index_entries = save(file, mime, mod, config)
    return index_entries
end
save(file::AbstractString, mod::Module; args...) = save(file, mod, Config(); args...)

## Format-specific rendering ------------------------------------------------------------
include("render/md.jl")
