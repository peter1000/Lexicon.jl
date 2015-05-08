require("Sandbox.jl")
require("Clouds.jl")
require("瀑布.jl")            # Waterfall - google translated simplified Chinese

using Lexicon

include(".docile")





const outdir = "api",
const modules = [Sandbox, Clouds, 瀑布]


cd(dirname(@__FILE__)) do
    # Save everthing according to the configuration
end
