OS_NAME == :Windows && Pkg.add("FactCheck") # Hack for appveyor.

module LexiconTests

using Docile

using Docile.Interface, Lexicon, FactCheck


include("testcases.jl")


end
