OS_NAME == :Windows && Pkg.add("FactCheck") # Hack for appveyor.

module LexiconTests

using Compat, FactCheck

import Lexicon

include("helpers.jl")
include(joinpath("Utilities", "facts.jl"))
include(joinpath("Elements", "facts.jl"))
include(joinpath("Render", "facts.jl"))

isinteractive() || FactCheck.exitstatus()

end
