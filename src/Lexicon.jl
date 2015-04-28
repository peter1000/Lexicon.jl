module Lexicon

import Markdown

import Docile.Interface:

    parsedocs,
    macroname,
    name

import Base:

    start,
    next,
    done,
    length,
    push!,
    run,
    writemime,
    ==

using

    Base.Meta,
    Compat,
    Docile,
    Docile.Interface

export

    @query,
    query,
    save,
    update!,

    doctest,
    failed,
    passed,
    skipped,
    EachEntry,
    Config,
    Index


@document

include("compat.jl")
include("query.jl")
include("render.jl")
include("doctest.jl")
include("filtering.jl")

__init__() = setup_help() # Hook into the REPL's `?`.



"TEST FUNCTION >>>> hello() <<<<"
function hello()
end

"TEST FUNCTION >>>> hello(a,b) <<<<"
function hello(a,b)
end

"TEST FUNCTION >>>> hello(a::ByteString,b::ByteString) <<<<"
function hello(a::ByteString,b::ByteString)
end


"TEST FUNCTION >>>> hello(a::ByteString,b::ByteString, default::Bool=true) <<<<"
function hello(a::ByteString,b::ByteString, default::Bool=true)
end

"TEST FUNCTION >>>> hello(a::ByteString,b::ByteString; optional::Bool=true) <<<<"
function hello(a::ByteString,b::ByteString; optional::Bool=true)
end
end # module
