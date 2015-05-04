OS_NAME == :Windows && Pkg.add("FactCheck") # Hack for appveyor.

module LexiconTests

using Docile, Docile.Interface, Lexicon, FactCheck

include("facts/config_check.jl")

end
