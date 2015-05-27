const HEADERS   = ["#", "##", "###", "####", "#####", "######"]
const EMPHASIS  = ["*", "**"]

const CATEGORIES = [:module,    :function, :method, :macro, :type,
                    :typealias, :global,   :symbol, :tuple, :aside]


## Config Nodes
abstract ConfigNode

type Config <: ConfigNode
    objfilter               :: Any
    style_obj               :: ASCIIString

    const defaults = Dict{Symbol, Any}(
        :objfilter                  => CATEGORIES,
        :style_obj                  => "####",
        )

    Config(; args...) = update_config!(new(), merge(defaults, Dict(args)))
end
config(; cargs...) = PreConfig(; cargs...)

type PreConfig <: ConfigNode
    cargs :: Dict{Symbol, Any}

    PreConfig(; cargs...) = new(Dict(cargs))
end

function update_config!(config::Config, args::Dict)
    const fields = fieldnames(Config)
    for (k, v) in args
        k in fields                                                ?
            setfield!(config, k, convert(fieldtype(Config, k), v)) :
            throw(ArgumentError("'Config'. Invalid setting: '$(k) = $(v)'."))
    end

    for k in [:style_obj]
        getfield(config, k) in HEADERS ||
                error("""Invalid style : config-item `$k -> $(getfield(config, k))`.
                      Valid values: [$(join(MDSTYLETAGS, ", "))].""")
    end
    return config
end
update_config!(config::Config, args...) = update_config!(config, Dict(args))


## Main structure nodes
abstract SectionNode
abstract PageNode
abstract ContentNode

immutable NullSection <: SectionNode end
immutable NullPage    <: PageNode    end

# Document
type Document
    name        :: AbstractString
    config      :: ConfigNode
    meta        :: Dict{Symbol, Any}
    children    :: Vector{SectionNode}
end
document(name::AbstractString, conf::PreConfig, children...) =
        document(name, conf, Dict(), [children...])
document(name::AbstractString, children...) = document(name, PreConfig(), children...)

function document(name::AbstractString, conf::PreConfig, meta::Dict, children::Vector)
    this = isempty(conf.cargs)                       ?
            Document(name, Config(), meta, children) :
            Document(name, update_config!(Config(), deepcopy(conf.cargs)), meta, children)
    isempty(children) || postprocess!(this, children)
    return this
end

# Section
type Section <: SectionNode
    name            :: AbstractString
    config          :: ConfigNode
    meta            :: Dict{Symbol, Any}
    parent          :: Union(Document, SectionNode)
    children        :: Vector{Union(SectionNode, PageNode)}
end
section(name::AbstractString, conf::PreConfig, children...) =
        Section(name, conf, Dict(:autogenerate => (false, nothing)), NullSection(), [children...])
section(name::AbstractString, children...) = section(name, PreConfig(), children...)

# Page
type Page <: PageNode
    name            :: AbstractString
    config          :: ConfigNode
    meta            :: Dict{Symbol, Any}
    parent          :: SectionNode
    children        :: Vector{ContentNode}
end
page(name::AbstractString, conf::PreConfig, children...) =
        page(name, conf, Dict(), [children...])
page(name::AbstractString, children...) = 
        page(name, PreConfig(), Dict(:autogenerate => (false, nothing)), [children...])

function page(name::AbstractString, conf::PreConfig, meta::Dict, children::Vector)
    contentchildren = []
    for child in children
        if isa(child, Tuple)
            childconf = child[end]
            isa(childconf, ConfigNode) ||
                    throw(ArgumentError("`page` content `Tuple`: Last item must be a `config`."))
            [push!(contentchildren, content(child[i], childconf)) for i in 1:length(child)-1]
        else
            push!(contentchildren, content(child, PreConfig()))
        end
    end
    this = isempty(conf.cargs)                                                              ?
            Page(name, PreConfig(), meta, NullSection(), contentchildren) :
            Page(name, conf, meta, NullSection(), contentchildren)
    return this
end


## Content nodes
type Content <: ContentNode
    typename    :: Symbol
    config      :: ConfigNode
    parent      :: PageNode
    data        :: Any
end

function content(child, conf::ConfigNode)
    if isa(child, AbstractString)
        headertype = getheadertype(child)
        if headertype == :none
            filename = abspath(child)
            Content(:text, conf, NullPage(), isfile(filename) ? readall(filename) : child)
        else
            Content(headertype, conf, NullPage(), child)
        end
    elseif isa(child, Module)
        Content(:module, conf, NullPage(), child)
    else
        throw(ArgumentError("`$(typeof(child))` is not a valid `content` type."))
    end
end


## Related functions
# sets: parents, final configuration
function postprocess!(parent, children::Vector)
    for child in children
        child.parent = parent
        child.config = isempty(child.config.cargs)  ?
                            deepcopy(parent.config) :
                            update_config!(deepcopy(parent.config), deepcopy(child.config.cargs))
        if isa(child, Union(Section, Page))
            isempty(child.children) || postprocess!(child, child.children)
        # these have no field children: but valid just skip them
        elseif !isa(child, ContentNode)
            throw(ArgumentError("`$(typeof(child))` is not a valid node structure type."))
        end
    end
end

# get the method name for a node structure object
function getnodename(nodeobj)
    isa(nodeobj, Document)  && return "document"
    isa(nodeobj, Section)   && return "section"
    isa(nodeobj, Page)      && return "page"
    throw(ArgumentError("`$(typeof(nodeobj))` is not a valid node structure type."))
end

function getheadertype(s::AbstractString)
    headertype = :none
    if s[1] == '#'
        startswith(s, "# ")         && (headertype = :header1)
        startswith(s, "## ")        && (headertype = :header2)
        startswith(s, "### ")       && (headertype = :header3)
        startswith(s, "#### ")      && (headertype = :header4)
        startswith(s, "##### ")     && (headertype = :header5)
        startswith(s, "###### ")    && (headertype = :header6)
    end
    return headertype
end
