module Lexicon

import Docile.Formats

# Conditional importing of the `Markdown` module.
if VERSION < v"0.4-dev+1488"
    include("../deps/Markdown/src/Markdown.jl")
    import .Markdown
end

using

    Compat,
    Docile,
    Docile.Interface

export

    update!,
    save,

    Config,
    Index


include("config.jl")            # Configuration settings.
include("render.jl")            # Common render methods.

end 
