import Lexicon.Elements:

    document,
    section,
    page,
    docs,
    config

import Lexicon.Render:

    getoutname!,
    checkconfig!

facts("Render.") do

    context("Get outname.") do

        out = document(section(title = "Section"), title = "Docile Documentation", outname = "this")
        @fact getoutname!(out.children[1]) => "section"
        @fact getoutname!(out)             => "this"

        out = document(section(title = "Section", outname = :myname), title = "Methods & Macros")
        @fact getoutname!(out.children[1])                     => "myname"
        @fact isa(out.children[1].data[:outname], UTF8String)  => true
        @fact getoutname!(out)                                 => "methods___macros"

        out = document(section(title = "Section", outname = "chinese 出名字"), title = "Documentation")
        @fact isa(getoutname!(out.children[1]), UTF8String) => true
        @fact getoutname!(out)                              => "documentation"

        out = document(section(page(docs(title = "docs"))))
        @fact getoutname!(out.children[1].children[1].children[1]) => "docs"

    end

    context("Check config.") do

        out = document(section(page("", title = :Page)))
        checkconfig!(out.children[1].children[1])

        @fact haskey(out.children[1].children[1].data, :outname)          => true
        @fact out.children[1].children[1].data[:title]                    => "Page"
        @fact out.children[1].children[1].data[:outname]                  => "page"
        @fact isa(out.children[1].children[1].data[:title], UTF8String)   => true
        @fact isa(out.children[1].children[1].data[:outname], UTF8String) => true

        @fact_throws ArgumentError checkconfig!(out.children[1])

        out = document(section(section(page(docs("", title = "docs"), title = :Page),
                        title = "Inner Section",  outname = "chinese 出名字"),
                        title = :Outer_Section), title = "Documentation")
        checkconfig!(out)

        @fact haskey(out.children[1].children[1].children[1].children[1].data, :outname) => false

        @fact out.children[1].children[1].children[1].data[:outname]         => "page"
        @fact out.children[1].children[1].data[:outname]                     => "chinese 出名字"
        @fact out.children[1].data[:outname]                                 => "outer_section"
        @fact out.data[:outname]                                             => "documentation"

    end

end
