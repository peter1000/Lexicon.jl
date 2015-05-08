module Lexicon

using

    Docile,
    Docile.Interface


include("Utilities.jl")             # Code useful across submodules.

include("Render/Render.jl")         # Render-dispatch for output of docstrings.

end 
