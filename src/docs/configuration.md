User adjustable Lexicon configuration with all relevant settings used for building standalone
documentation.

Most options are set as `:metadata` which can also be included in the documentation using
[Docile's](https://github.com/MichaelHatherly/Docile.jl) *Extensible Metadata Syntax*.

All options are accessable as metadata except where noted.

## Shared Options

These options are also used to generate 3rd party program
[MkDocs](https://github.com/mkdocs/mkdocs/) configuration files: `mkdocs.yml`. These have kept on
purpose the same or similar name and describtion with
[permission](https://github.com/mkdocs/mkdocs/pull/506#issuecomment-100324663) of MkDocs author.
NOTE: not all possible `mkdocs.yml` settings are included here.

### Project information

#### site_name

*mkdocs.yml*: This is the only **required setting** for generating a *mkdocs.yml*, and should be a
string that is used as the main title for the project documentation. When rendering the theme this
setting will be passed as the `site_name` context variable.

**default**: `""`

#### site_url

*mkdocs.yml*: uses this to set the canonical URL of the site which will add a link tag with the
canonical URL to the generated HTML header.

**default**: `""`

#### repo_url

*mkdocs.yml*: When set, provides a link to your GitHub or Bitbucket repository on each page.

**default**: `""`

#### site_description

*mkdocs.yml*: Set the site description. This will add a meta tag to the generated HTML header.

**default**: `""`

#### site_author

*mkdocs.yml*: Set the name of the author. This will add a meta tag to the generated HTML header.

**default**: `""`

#### site_favicon

Path to the favicon which will be copied to the place.

*mkdocs.yml*: Set the favicon to use.

**default**: `""`

#### copyright

*mkdocs.yml*: Set the copyright information to be included in the documentation by the theme.

**default**: `""`


#### google_analytics

*mkdocs.yml*: Set the Google analytics tracking configuration.

**default**: `[]`


### Documentation layout

#### pages

**TODO:** Add a full describtion how it works in Lexicon with the `:section metadata`.

*mkdocs.yml*:
This is setting is used to determine the set of pages that should be built for the documentation.
See MkDocs user guide for more info.

**default**: **TODO**


### Build directories


#### theme

*mkdocs.yml*: Sets the theme of your documentation site, for a list of available themes visit
MkDocs user guide for more info.

**default**: `"readthedocs"`


#### theme_dir

*mkdocs.yml*: Lets you set a directory to a custom theme.

**default**: `""`


#### docs_dir

**TODO**: add info how it is used for Lexicon root output dir


*mkdocs.yml*: Lets you set the directory containing the documentation source markdown files.
This can either be a relative directory, in which case it is resolved relative to the directory
containing you configuration file, or it can be an absolute directory path.

**default**: `"docs"`


#### site_dir

*mkdocs.yml*: Lets you set the directory where the output HTML and other files are created.
This can either be a relative directory, in which case it is resolved relative to the directory
containing you configuration file, or it can be an absolute directory path.

**default**: `"site"`

**Note**: If you are using source code control you will normally want to ensure that your *build output*
files are not commited into the repository, and only keep the *source* files under version control.
 For example, if using `git` you might add the following line to your `.gitignore` file:

    site/

If you're using another source code control you'll want to check its documentation on how to ignore
specific directories.


#### extra_css

*mkdocs.yml*: Set a list of css files to be included by the theme. By default `extra_css` will
contain a list of all the CSS files found within the `docs_dir`, if none are found it will be `[]`
(an empty list).

**default**: `[]`

#### extra_javascript

*mkdocs.yml*: Set a list of JavaScript files to be included by the theme. By default `extra_javascript`
will contain a list of all the JavaScript files found within the `docs_dir`, if none are found it
will be `[]` (an empty list).

**default**: `[]`


### Preview controls

**use_directory_urls** *mkdocs.yml*: is not an Lexicon configuration option and is set for
auto-generated *mkdocs.yml* always to `true`. See MkDocs user guide for more info.


#### strict

*mkdocs.yml*: Determines if a broken link to a page within the documentation is considered a warning
or an error (link to a page not listed in the pages setting).  Set to true to halt processing when
a broken link is found, false prints a warning.

**default**: `true`


### Formatting options

#### markdown_extensions

*mkdocs.yml*: MkDocs uses the [Python Markdown][pymkd] library to translate Markdown files into HTML.
Python Markdown supports a variety of [extensions][pymdk-extensions] that customize how pages are formatted.
This setting lets you enable a list of extensions beyond the ones that MkDocs uses by default
(`meta`, `toc`, `tables`, and `fenced_code`).

See MkDocs user guide for more info.


**default**: `[]`

## Options

These options are not shared with any included 3rd party support.







