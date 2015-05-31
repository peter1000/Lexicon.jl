import Lexicon.Elements:

    document,
    section,
    page,
    docs,
    config,
    Node,
    Document,
    Section,
    Page,
    Docs

facts("Elements.") do

    context("Tuple construction.") do

        @fact section() => (Section, (), Dict{Symbol, Any}())
        @fact page()    => (Page, (), Dict{Symbol, Any}())
        @fact docs()    => (Docs, (), Dict{Symbol, Any}())

        @fact section(section()) => (
            Section,
            ((Section, (), Dict{Symbol, Any}()),),
            Dict{Symbol, Any}())

        @fact section(page(), page()) => (
            Section,
            ((Page, (), Dict{Symbol, Any}()),
             (Page, (), Dict{Symbol, Any}()),),
            Dict{Symbol, Any}())

        @fact section(section(page(docs()))) => (
            Section,
            ((Section,
              ((Page,
                ((Docs,
                  (),
                  Dict{Symbol, Any}()),),
                Dict{Symbol, Any}()),),
              Dict{Symbol, Any}()),),
            Dict{Symbol, Any}())

        @fact page("", docs(), docs()) => (
            Page,
            ("",
             (Docs, (), Dict{Symbol, Any}()),
             (Docs, (), Dict{Symbol, Any}()),),
            Dict{Symbol, Any}())

    end

    context("Node construction.") do

        @fact document() => Node{Document}()

        @fact document(section()) => Node{Document}(
            Any[Node{Section}()],
            Dict{Symbol, Any}())

        @fact document(a = 1) => Node{Document}(
            Any[],
            @compat(Dict{Symbol, Any}(:a => 1)))

        @fact document(section(page(""))) => Node{Document}(
            Any[Node{Section}(
                    Any[Node{Page}(Any[""], Dict{Symbol, Any}())],
                    Dict{Symbol, Any}())],
            Dict{Symbol, Any}())

        @fact document(section(page(docs("")))) => Node{Document}(
            Any[Node{Section}(
                    Any[Node{Page}(
                            Any[Node{Docs}(
                                    Any[""],
                                    Dict{Symbol, Any}())],
                            Dict{Symbol, Any}())],
                    Dict{Symbol, Any}())],
            Dict{Symbol, Any}())

        @fact_throws ArgumentError document(page())
        @fact_throws ArgumentError document(page(section()))
        @fact_throws ArgumentError document(docs())
        @fact_throws ArgumentError document(section(section(section(""))))
        @fact_throws ArgumentError document(page(current_module()))
        @fact_throws ArgumentError document(section(current_module()))

    end

    context("Display.") do

        str_1 = """
        document(
            section(
                page(
                    docs(
                        Lexicon,
                    ),
                    title = "",
                ),
                page(
                    "a",
                ),
            ),
            section(
                page(
                    "a",
                ),
            ),
            section(
                page(
                    "a",
                ),
            ),
            b = :a,
        )
        """

        buf = IOBuffer()
        writemime(buf, "text/plain", eval(parse(str_1)))
        str_2 = takebuf_string(buf)

        @fact strip(str_1) => strip(str_2)

    end

    context("Display unicode.") do

        str_1 = """
        document(
            section(
                page(
                    "a",
                    outname = "russian из имя",
                    title   = "russian из имя",
                ),
                outname = "ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿŒœ‘’",
                title   = "s",
            ),
            section(
                page(
                    "a",
                    outname = "vietnamese chức năng kiểm tra",
                    title   = "punjabi ਫੰਕਸ਼ਨਲ ਚੈੱਕ",
                ),
                outname = "arabicماسم خارج",
                title   = "arabicماسم خارج",
            ),
            outname = "chinese 出名字",
            title   = "chinese 出名字",
        )
        """

        buf = IOBuffer()
        writemime(buf, "text/plain", eval(parse(str_1)))
        str_2 = takebuf_string(buf)

        @fact strip(str_1) => strip(str_2)

    end

    context("Parent reference.") do

        out = document(section(page(docs(""), title = "p"), title = "s"), title = "d")

        @fact (out.children[1].parent == out) => true

        @fact (out.children[1].children[1].parent == out.children[1]) => true

        @fact (out.children[1].children[1].children[1].parent == out.children[1].children[1]) => true

    end

    context("General.") do

        @fact config(; a = 20) => @compat(Dict{Symbol, Any}(:a => 20))

        @fact (config(; a = 20) == config(; a = 20)) => true
        @fact (config(; a = 20) == config(; a = 50)) => false

        @fact (document(a = 20, b = 30) == document(a = 2, b = 3)) => false
        @fact (document(section(), section(a = 20)) == document(section(), section())) => false

        @fact (document(section(page(docs(""), title = "p"), title = "s"), title = "d") ==
            document(section(page(docs(""), title = "p"), title = "s"), title = "d")) => true

    end

end
