module Extensions

"""
!!summary(Types, constructors and methods to extend how Lexicon generates documentation.)

These methods could just as easily be defined outside of the package and allow
for package authors to customise how their documentation is generated and presented to users.
"""
Extensions

export title, header, subheader, text, textfile, objs

import Docile: Cache, Collector, Interface

import ..Documents: ConfigNode, Config, PreConfig, Section, PageNode, Page, NullPage, ContentNode,
                    page,       autogenerate

import ..Render: Render, @RC_str, wrapstyle


include("contentnodes.jl")
include("autogenerated.jl")

end
