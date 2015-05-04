module Lexicon

import Docile.Formats, Markdown

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
include("render.jl")            # Render none format specific.

end 
