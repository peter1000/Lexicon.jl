module Lexicon

using

    Docile,
    Docile.Interface


include("Utilities.jl")                                 # Code useful across submodules.

isfile("../.docile") && include("../.docile")           # Central package documentation configuration.

include("Render/Render.jl")                             # Render-dispatch for output of docstrings.

end 
