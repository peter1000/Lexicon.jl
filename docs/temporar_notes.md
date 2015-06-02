# Render - Markdown

Required config options:

- each document, section, page must have a configuration key: `:title`
- additional a key: `:outname` can be if it is missing one is generated from the title

Optional config options:

- `:filter` for `docs` nodes.  is applied to a modules object

  ```julia
  objects = Cache.objects(mod)
  objs = filter(conf[:filter], objects
  ```

  Example: `docs(Docile.Cache, filter = obj -> isa(obj, Function) || isa(obj, Method))`

  Example: `docs(Cache, filter = obj -> iscategory(Cache, obj, [:function, :method, :macro])`


**Output structure**

- Section produce a subfolder named: after the value ofthe nodes configuration `:outname`

  * EXCEPTION: if a Section has a config option key: `nosubdir` than no new subdir will be created.
    Value can be anything.
    e.g. useful for setting an index page to the output root folder.


- Page produce a file named: after the value ofthe nodes configuration `:outname` ending in `.md`
  e.g. `:outname = "introduction`  than the page filename will be `introduction.md`

---

# External - MkDocs

To write an mkdocs yaml configuration file one can give the document root node additional config keys.

Only a subset of mkdocs configuration option is currently supported.

- Required
    - :mkdocsyaml           (Bool):  Extra added config option: `mkdocsyaml=true` will enable that a mkdocs.yml file is written.
    - :repo_url             (String)
    - :site_description     (String)
    - :site_author          (String)

- Optional
    - :site_name            (String)
    - :theme                (String)
    - :theme_dir            (String)
    - :copyright            (String)
    - :google_analytics     (String): "['UA-xxxxxxxx-x', 'hostname']"
    - :markdown_extensions  (Vector)

- Internal generated
    - :docs_dir
    - :pages

---

**site_name**

If it is not defined the documents `:title` will be used instead

**markdown_extensions**

Vector of extensions: `["tables", "fenced_code"]`
If an extension has options on e can use a tuple of ("extension", Dict(:optionname => optionvalue))

e.g.: markdown_extensions = ["tables", "fenced_code", ("toc", Dict(:permalink => ""))]

**docs_dir**

Is internal set.

**pages**

mkdocs page index is generated:

- title

- title, relative page file path
