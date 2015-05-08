module Lexicon

"""
!!author(Michael Hatherly)
!!copyright(Michael Hatherly and other contributors)
!!license([MIT](https://github.com/MichaelHatherly/Lexicon.jl/blob/master/LICENSE.md))

*Lexicon* is a [Julia](http://www.julialang.org) package documentation generator
and viewer.

It provides access to the documentation created by the `@doc` macro from
[*Docile*](https://github.com/MichaelHatherly/Docile.jl). *Lexicon* allows
querying of package documentation from the Julia REPL and building standalone
documentation that can be hosted on GitHub Pages or
[Read the Docs](https://readthedocs.org/).

!!section(Lexicon.md/Lexicon/1)
"""
Lexicon

using Docile, Docile.Interface


include("Utilities.jl")                         # Code useful across submodules.

isfile("../.docile") && include("../.docile")   # Central package documentation configuration.

include("Render/Render.jl")                     # Render-dispatch for output of docstrings.

include("ThirdParty/ThirdParty.jl")             # Code related to ease usage of 3rd-party programs.

end 
