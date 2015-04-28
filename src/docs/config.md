User adjustable Lexicon configuration.

##### Options

*General Options*

* `category_order`      (default: `[:module, :function, :method, :type, :typealias, :macro, :global, :comment]`)
  Categories  to include in the output in the defined order.
  *Index save uses the settings each document was saved with.*

* `include_internal`    (default: `true`): To exclude documentation for non-exported objects,
  the keyword argument `include_internal= false` should be set. This is only supported for `markdown`.
  *Index save uses the settings each document was saved with.*

*HTML only options*

* `mathjax`             (default: `false`): If MathJax support is required then the optional keyword
  argument `mathjax=true` can be given.
  MathJax uses `\(...\)` for in-line maths and `\[...\]` or `$$...$$` for display equations.

*Markdown only options*

Valid values for the `mdstyle_*` options listed below are.
*Headers Tags:* 1 to 6 `#` characters. *Emphasis  Tags:* 0 to 2 `*` characters.`

* `mdstyle_module`      (default: `"#"`):  style for the documentation module headers.
* `mdstyle_section`     (default: `"##"`):  style for the documentation section headers.
  "Exported" and "Internal"
* `mdstyle_category`    (default: `"####"`):  style for each documented category headers.
* `mdstyle_objname`     (default: `"#####"`):  style for each documented object.
* `mdstyle_obj_name`    (default: `"**"`):  emphasis style for the name of the object. 
  Only Emphasis Tags are allowed. Dependend on the choosen `mdstyle_objname` this might or might
  not give extra emphasis.
* `mdstyle_obj_sig`     (default: `"*"`):  style for each signature of the object.
  Only Emphasis Tags are allowed. Dependend on the choosen `mdstyle_objname` this might or might
  not give extra emphasis.
* `mdstyle_meta`        (default: `"*"`):  style for the metadata section on each documentation entry.

Permalinks

* `md_permalink`        (default: `true`):  Adds a permalink to each object.
* `md_permalink_header` (default: `true`):  Adds a permalink to documentation headers.
* `md_permalink_char`   (default: `¶`):  Can be used to set a different permalink char.

Output groups

* `md_section`          (default: `true`): if `md_section=true` section headers
  "Exported" and "Internal" are inserted. *Index save uses the settings each document was saved with.*

* `md_category`         (default: `true`): if `md_category=true` category headers are inserted.
  *Index save uses the settings each document was saved with.*

* `md_index_headers`    (default: `true`):  `md_index_headers=true` will add to the
  *Index Page* a section with links to the module `section and category` headers.

Others

* `md_module_prefix`    (default: `""`): This option sets the documentation module headers
  a "prefix" text. `md_module_prefix="Module: "` will output headers like **Module: Lexicon**

* `md_object_kwarg`     (default: `false`): This option enables the additional output of optional 
  keyword arguments of objects. This is currently not implemented.


Any option can be user adjusted by passing keyword arguments to the `save` method.


##### Config Usage

There are 3 ways to define user adjusted configuration settings.

*1. Config*

```julia
using Lexicon

# get default `Config`
config = Config()

# get a new adjusted `Config`
config = Config(md_permalink = false, mathjax = true)

```

*2. Document `save` method*

The document `save` method accepts also a 'Config' as argument or supplies internaly a default one.
Similar to the above 'Config usage' one can also pass otional `args...` which will overwrite a
deepcopy of config but not change config itself.
This allows using the same base configuration settings multiple times.

```julia
using Lexicon

# 1. get a new adjusted `Config`
config = Config(md_permalink = false, mathjax = true)

# 2.using the adjusted `Config`
save("docs/api/Lexicon.md", Lexicon, config);

# 3.overwrite a deepcopy of `config`
save("docs/api/Lexicon.md", Lexicon, config; md_permalink = true);

# 4. This uses the same configuration as set in '1.' (md_permalink is still `false`)
save("docs/api/Lexicon.md", Lexicon, config);

```

The document `save` also supplies a default 'Config'.

```julia
using Lexicon

# 1. using the default supplied Config of method `save`
save("docs/api/Lexicon.md", Lexicon);

# 2. this is the same as '1.'
config = Config()
save("docs/api/Lexicon.md", Lexicon, config);

```

The next three examples are all using the same configuration to save *Lexicon*

```julia
using Lexicon

# 1.
config = Config(md_permalink = false, mathjax = true)
save("docs/api/Lexicon.md", Lexicon, config);

# 2.
config = Config()
save("docs/api/Lexicon.md", Lexicon, config; md_permalink = false, mathjax = true);

# 3.
save("docs/api/Lexicon.md", Lexicon; md_permalink = false, mathjax = true);

```


*3. API-Index `save` method*

The configuration settings for the *API-Index* `save` method works similar to the above
*Document `save` method*

```
using Lexicon
index = Index([save("docs/api/Lexicon.md", Lexicon)]);

# 1.
config = Config(md_index_headers = false)
save("docs/api/index.md", index, config);

# 2. using the default supplied Config and overwrite a deepcopy
save("docs/api/index.md", index; md_index_headers = false);

# 3. using all defaults
save("docs/api/index.md", index);

```
