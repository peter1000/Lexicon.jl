# Lexicon Experiment

**Usage**

Not useable at the moment.


## Roadmap

Implement a rough sketch of *Lexicon Experimental* based on the new
[DocileExperimental](https://github.com/MichaelHatherly/Docile.jl/tree/master/src/Experimental) for:

* single or triple quoted docstrings
* format markdown
* julia 0.4-

#### Implement the new features from the Docile/Lexicon issues.

* Make a new *Configuration* system a central feature of the *Lexicon Experimental* markdown format.

    * For configuration make use of the Docile new feature: [Extensible Metadata Syntax](https://github.com/MichaelHatherly/Lexicon.jl/issues/105)
    * see also [.docile config file](https://github.com/MichaelHatherly/Docile.jl/pull/96#issuecomment-100010167)
    * see also: [optional .docile file](https://github.com/MichaelHatherly/Docile.jl/issues/89#issuecomment-100179496)


* Add a seamless integration to document multiple packages.

    * Extract for ALL Pkg documentation: https://github.com/MichaelHatherly/Lexicon.jl/issues/71


* Implement a new *Section* system as a central feature of the *Lexicon Experimental* markdown format.

  This will solve most of the issues and ideas below.

  * Respect the :section metadata:  https://github.com/MichaelHatherly/Lexicon.jl/issues/8:
  * Propose new `section` meta: https://github.com/MichaelHatherly/Lexicon.jl/issues/103
  * Group section by Category only https://github.com/MichaelHatherly/Lexicon.jl/issues/99
  * placement of "[Exported]" https://github.com/MichaelHatherly/Lexicon.jl/issues/93
  * save index in the same order as the modules: https://github.com/MichaelHatherly/Lexicon.jl/issues/90
  * shortcomings of new reference anchors: https://github.com/MichaelHatherly/Lexicon.jl/issues/95


* Implement an improved output of object definition header

  This will solve most of the issues and ideas below.

    * Show keyword arguments in generated output: https://github.com/MichaelHatherly/Lexicon.jl/issues/19
    * Duplicate entries generated for methods with default arguments. https://github.com/MichaelHatherly/Lexicon.jl/issues/17


* Improved Anchor and hyperlink options

    * Add Anchor to groups like Exported/Internal : https://github.com/MichaelHatherly/Lexicon.jl/issues/92
    * Permalink only to display when hoover over it (Speculative): https://github.com/MichaelHatherly/Lexicon.jl/issues/102


* Ease integration with 3rd party [MkDocs](https://github.com/mkdocs/mkdocs/)

    * Add page order option: https://github.com/MichaelHatherly/Lexicon.jl/issues/106

    * Auto generate MkDocs `mkdocs.yml` file

    * Auto generate a MkDocs `index.md` file.


* Add improved source reference.

    * Better github code reference (Speculative): https://github.com/MichaelHatherly/Docile.jl/issues/90
    * Line number to point to docstring start.: https://github.com/MichaelHatherly/Docile.jl/issues/86

* On the fly renaming of meta !!section: path (speculative): https://github.com/peter1000/Lexicon.jl/issues


---

Review *Lexicon Experimental* features and decide which should go into the *New Lexicon*

Finalise and polish the features for

* single or triple quoted docstrings
* format markdown
* julia 0.4-

Decide which remaining features of the current Lexicon should be readded in case such where left out
in the rough sketch of *Lexicon Experimental*. Add them.

Backport to julia 3 if necessary.

Add suport for @doc related macros.

Implement the plain format and REPL integration.

Implement other formats (example html).

Replace `Lexicon` with `LexiconExperimental`.

