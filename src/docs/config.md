User adjustable Lexicon configuration.

---

##### Options

*General Options*

* `category_order`      (default: `[:module, :function, :method, :type, :typealias, :macro, :global, :aside]`)
  Categories  to include in the output in the defined order.
  *Index save uses the settings each document was saved with.*

  * Valid categories are: [:module, :function, :method, :type, :typealias, :macro, :global, :aside]

* `metadata_order`      (default: `[]`) Metadata to include in the output in the defined order.
  To not output any metadate `metadata_order = []` should be set.
* `include_internal`    (default: `true`): To exclude documentation for non-exported objects,
  the keyword argument `include_internal= false` should be set.
  *Index save uses the settings each document was saved with.*

*Markdown only options*

Valid values for the `mdstyle_*` options listed below are.
* *Header Tags:* 1 to 6 `#` characters.
* *Emphasis Tags:* 1 to 2 `*` characters or 1 space `" "` for normal style.

An empty `mdstyle_*` disables the output of such items.

* `mdstyle_module`      (default: `"#"`):  style for the documentation module headers.
  NOTE: this is required and can not be set to an empty value.
* `mdstyle_section`     (default: `"##"`):  style for the documentation section headers
  "Exported" and "Internal".
* `mdstyle_category`    (default: `"####"`):  style for the documentation category headers.
* `mdstyle_index_ref`   (default: `"####"`):  style for the index reference section headers.

  If set a section with references to the module *section and category headers* will be added to the
  Index.

* `mdstyle_meta`        (default: `"*"`):  style for the metadata section on each documentation entry.
* `mdstyle_obj`         (default: `"#####"`):  style for each documented object.
  NOTE: this is required and can not be set to an empty value.
* `mdstyle_obj_name`    (default: `"**"`):  emphasis style for the name of the object.
  Only *Emphasis Tags* are allowed. Dependend on the choosen *mdstyle_obj* this might or might
  not give extra emphasis. To disable any emphasis use an empty value: `mdstyle_obj_name = ""`
* `mdstyle_obj_sig`     (default: `"*"`):  style for the signature of the object.
  Only *Emphasis Tags* are allowed. Dependend on the choosen *mdstyle_obj* this might or might
  not give extra emphasis. To disable any emphasis use an empty value: `mdstyle_obj_sig = ""`

Permalinks

* `md_permalink`        (default: `true`):  Adds a permalink to each object.
* `md_permalink_header` (default: `true`):  Adds a permalink to documentation headers.
* `md_permalink_char`   (default: `'¶'`):  Can be used to set a different permalink char.

Sourcelinks

* `md_textsource`       (default: `"txt"`):  Adds a link to documentation textsource.
  An empty string value `md_textsource = ""` does not add any textsource links.
* `md_codesource`       (default: `"code"`):  Adds a link to the source of the documented object.
  An empty string value `md_codesource = ""` does not add any codesource links.

Others

* `md_module_prefix`    (default: `""`): This option sets for the documentation module headers
  a "prefix" text. `md_module_prefix="Module: "` will output headers like **Module: Lexicon**
* `md_obj_signature`    (default: `:normal`): To shorten and simplify the object definition header
  line this can be set to false. Valid options are

  * `:normal`:  will output the complete object definition.
  * `:remove`:  will remove all content within curly brackets.
  * `:remove2`:  will remove all content within curly brackets and add below the
  header an extra line with the complete type signature without any emphasis. This is only done for
  definitions which had type parameters within curly brackets.

---

EXAMPLE **md_obj_sig_curly** using a config setting like:

* `mdstyle_obj=" "`: means normal style tags for object sections
* `mdstyle_obj_name="**"`: means object name will have bold emphasis
* `mdstyle_obj_sig="*"`: means object signature with in the parenthesis will have italic emphasis

> ```
> function newdesign{P <: Ptr, T < :Ptr}(::Union(Type{Ptr{P}}, Type{Ref{P}}), a::Array{T})
> end
> ```

`md_obj_signature = normal` will output the header complete.

> **newdesign**{P <: Ptr, T < :Ptr}(*::Union(Type{Ptr{P}}, Type{Ref{P}}), a::Array{T}*)

`md_obj_signature = remove` will remove all content within curly brackets.

> **newdesign**(*::Union(Type, Type), a::Array*)

`md_obj_signature = remove2` will remove all content within curly brackets and add below the
header an extra line with the complete type signature without any emphasis.

> **newdesign**(*::Union(Type, Type), a::Array*)
>
> newdesign{P <: Ptr, T < :Ptr}(::Union(Type{Ptr{P}}, Type{Ref{P}}), a::Array{T})


Any option can be user adjusted by passing keyword arguments to the `save` method.


##### Config Usage

There are 4 ways to define user adjusted configuration settings.

*1. Config*

```julia
using Lexicon

# get default `Config`
config = Config()

# get a new adjusted `Config`
config = Config(md_permalink = false)

# get a new adjusted `Config`
mysettings = Dict([(:category_order    , [:type, :function, :method]),
                   (:metadata_order    , [:date, :日期]),
                   (:include_internal  , false)])
config=Config(mydict)
config = Config(mysettings)

```

*2. Document `save` method*

The document `save` method accepts also a 'Config' as argument or supplies internaly a default one.
Similar to the above 'Config usage' one can also pass otional `args...` which will overwrite a
deepcopy of config but not change config itself.
This allows using the same base configuration settings multiple times.

```julia
using Lexicon

# 1. get a new adjusted `Config`
config = Config(md_permalink = false)

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
config = Config(md_permalink = false)
save("docs/api/Lexicon.md", Lexicon, config);

# 2.
config = Config()
save("docs/api/Lexicon.md", Lexicon, config; md_permalink = false);

# 3.
save("docs/api/Lexicon.md", Lexicon; md_permalink = false);

```


*3. API-Index `save` method*

The configuration settings for the *API-Index* `save` method works similar to the above
*Document `save` method*

```
using Lexicon
index = Index([save("docs/api/Lexicon.md", Lexicon)]);

# 1.
config = Config(mdstyle_index_ref = false)
save("docs/api/index.md", index, config);

# 2. using the default supplied Config and overwrite a deepcopy
save("docs/api/index.md", index; mdstyle_index_ref = false);

# 3. using all defaults
save("docs/api/index.md", index);

```
