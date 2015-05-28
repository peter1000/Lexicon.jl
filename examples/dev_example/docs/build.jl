import Lexicon.Elements: config, section, document, page

import Lexicon.Render: save, markdown

import Docile: Cache, Collector

out = document(:TestDocumentation,
    section("Introduction",
        page("index", "index.md"),
        ),
    section("Docile-API", config(style_obj="###"),
        page("Cache",
            "# Cache",
            "## Macros",
            "Some intermediate text describing more about macros.",
            (Cache, config(objfilter=[:macro])),
            "## Methods",
            (Cache, config(objfilter=[:method])),
            ),
        page(:Collector, config(objfilter=[:method, :macro]),
            "# Collector",
            "## Methods & Macros",
            Collector,
            ),
        ),
    )

save(markdown("out", out); remove_destination=true)
