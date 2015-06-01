import Lexicon.Elements:

    document,
    section,
    page,
    docs,
    config

import Lexicon.Render:

    markdown,
    save

## Testing. ##

out = document(
    section(
        page("index.md", title = "Introduction", outname = "index"),
        nosubdir = "",
        title  = "Section root",
    ),
    section(
        page("# HEADER Section1 page1", title = "First Page", outname = :page1),
        page("# HEADER Section1 page2", title = "Page2"),
        title  = "Section1",
        section(
            page(
                docs("# docs object Section Nested page1"), title = "Page1", outname = :page1),
            page("# HEADER Section Nested page2", title = "Page2", outname = "page2"),
            title  = "Section Nested",
            ),
        ),
    section(
        page("# HEADER Section2 page1", title = "Page1", outname = :page1),
        page("# HEADER Section2 page2", title = "Page2", outname = "page2"),
        title  = "Section2",
        ),
    title = "Example Documentation",

    mkdocsyaml          = true,
    site_name           = "Julia Documentation Example",
    repo_url            = "https://github.com/MichaelHatherly/Docile.jl",
    site_description    = "Julia package documentation system.",
    site_author         = "Michael Hatherly",
    theme               = "mkdocs",
    markdown_extensions = ["tables", "fenced_code", ("toc", Dict(:permalink => ""))],
    copyright           = """Copyright &copy; 2014-2015, Michael Hatherly and other contributors. <a ref="mailto:michaelhatherly@gmail.com">michaelhatherly@gmail.com</a>.""",
    google_analytics    = "['UA-xxxxxxxx-x', 'hostname']"
    )

save(markdown("docs_out", out); remove_destination=true)
