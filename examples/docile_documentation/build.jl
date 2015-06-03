import Lexicon.Elements: document, section, page, docs, config

import Lexicon.Utilities: iscategory, isexported

import Lexicon.Render: markdown, save


import Docile
import Docile: Cache, Collector, Extensions, Formats, Interface, Legacy, Runner, Utilities

cd(dirname(@__FILE__)) do

    pages  = [page(
                "# $m",
                "## External",
                "### Modules, Functions, Methods & Macros",
                docs(m, filter = obj -> iscategory(m, obj, [:module, :function, :method, :macro]) && isexported(m, obj)),
                "### Globals, Types, Asides",
                docs(m, filter = obj -> iscategory(m, obj, [:global, :type, :typealias, :aside]) && isexported(m, obj)),
                "## Internal",
                "### Modules, Functions, Methods & Macros",
                docs(m, filter = obj -> iscategory(m, obj, [:module, :function, :method, :macro]) && !isexported(m, obj)),
                "### Globals, Types, Asides",
                docs(m, filter = obj -> iscategory(m, obj, [:global, :type, :typealias, :aside]) && !isexported(m, obj)),
                title = "$m")

                for m in [
                    Docile,
                    Cache,
                    Collector,
                    Extensions,
                    Formats,
                    Interface,
                    Legacy,
                    Runner,
                    Utilities,
                    ]
            ]
    # Generate and save the documentation        
    out = document(
        section(
            page("index.md", title = "Introduction", outname = "index"),
            nosubdir = "",
            title  = "",
        ),
        section(
            page("manual.md",       title = "Overview",     outname = :manual),
            page("syntax.md",       title = "Syntax",       outname = :syntax),
            page("metamacros.md",   title = "Metamacros",   outname = :metamacros),
            title  = "Manual",
            ),
        section(
            pages...,
            title  = "API",
            ),
        title = "Docile.jl",

        mkdocsyaml          = true,
        repo_url            = "https://github.com/MichaelHatherly/Docile.jl",
        site_description    = "Julia package documentation system.",
        site_author         = "Michael Hatherly",
        theme               = "readthedocs",
        markdown_extensions = ["tables", "fenced_code", ("toc", Dict(:permalink => ""))],
        copyright           = """Copyright &copy; 2014-2015, Michael Hatherly and other contributors. <a ref="mailto:michaelhatherly@gmail.com">michaelhatherly@gmail.com</a>.""",
        )

    rmd = save(markdown("outdocs", out); remove_destination=true)

    # Add a reminder not to edit the generated files.
    open(joinpath(rmd.outdir, "README.md"), "w") do f
        print(f, """
        Files in this directory are generated using the `build.jl` script. Make
        all changes to the originating docstrings/files rather than these ones.

        Documentation should *only* be build directly on the `master` branch.
        Source links would otherwise become unavailable should a branch be
        deleted from the `origin`. This means potential pull request authors
        *should not* run the build script when filing a PR.
        """)
    end

end
