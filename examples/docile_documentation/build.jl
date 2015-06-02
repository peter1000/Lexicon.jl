import Lexicon.Elements: document, section, page, docs, config

import Lexicon.Utilities: iscategory

import Lexicon.Render: markdown, save


import Docile
import Docile: Cache

cd(dirname(@__FILE__)) do

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
            page(
                "# Docile.Cache",
                "## Functions & Methods & Macros",
                docs(Cache, filter = obj -> iscategory(Cache, obj, [:function, :method, :macro])),
                "## Globals, Types",
                docs(Cache, filter = obj -> iscategory(Cache, obj, [:global, :type, :typealias])),
                "## Asides",
                docs(Cache, filter = obj -> iscategory(Cache, obj, [:aside])),
                title = "Cache"),
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
