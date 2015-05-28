const HEADERS   = ["#", "##", "###", "####", "#####", "######"]
const EMPHASIS  = ["*", "**"]

const CATEGORIES = [:module,    :function, :method, :macro, :type,
                    :typealias, :global,   :symbol, :tuple, :aside]


## Config Nodes
abstract ConfigN

type Config <: ConfigN
    objfilter               :: Any
    style_obj               :: ASCIIString

    const defaults = Dict{Symbol, Any}(
        :objfilter                  => CATEGORIES,
        :style_obj                  => "####",
        )

    Config(; args...) = update_config!(new(), merge(defaults, Dict(args)))
end
config(; cargs...) = PreConfig(; cargs...)

type PreConfig <: ConfigN
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
abstract NodeT

immutable Document  <: NodeT end
immutable Section   <: NodeT end
immutable Page      <: NodeT end

typealias NodeName Union(Symbol, AbstractString)

type Node{T <: NodeT}
   name     :: NodeName
   config   :: ConfigN
   meta     :: Dict{Symbol, Any}
   parent                           # Children are type checked so no need here
   children :: Vector               # type checked in the constructors
end

# Document
document(name::NodeName, children...) = document(name, PreConfig(), children...)
document(name::NodeName, conf::PreConfig, children...) =
    document(name, conf, Dict(), Node{Section}[children...])

function document(name::NodeName, conf::PreConfig, meta::Dict, children::Vector)
    this = isempty(conf.cargs)                                     ?
        Node{Document}(name, Config(), meta, Document(), children) :
        Node{Document}(name, update_config!(Config(), deepcopy(conf.cargs)), meta, Document(), children)
    this.parent = this
    isempty(children) || postprocess!(this, children)
    return this
end

# Section
section(name::NodeName, children...) = section(name, PreConfig(), children...)
section(name::NodeName, conf::PreConfig, children...) =
    Node{Section}(name, conf, Dict(:autogenerate => (false, nothing)), Section(), Node{Page}[children...])

# Page
page(name::NodeName, children...) = page(name, PreConfig(), children...)
page(name::NodeName, conf::PreConfig, children...) =
    page(name, conf, Dict(:autogenerate => (false, nothing)), [children...])

function page(name::NodeName, conf::PreConfig, meta::Dict, children::Vector)
    contentchildren = Vector{Content}()
    for child in children
        if isa(child, Tuple)
            childconf = child[end]
            isa(childconf, ConfigN) ||
                    throw(ArgumentError("`page` content `Tuple`: Last item must be a `config`."))
            [push!(contentchildren, content(child[i], childconf)) for i in 1:length(child)-1]
        else
            push!(contentchildren, content(child, PreConfig()))
        end
    end
    this = isempty(conf.cargs)                                              ?
            Node{Page}(name, PreConfig(), meta, Section(), contentchildren) :
            Node{Page}(name, conf, meta, Section(), contentchildren)
    return this
end


## Content nodes
type Content
    typename    :: Symbol
    config      :: ConfigN
    parent      :: Union(Node{Page}, Page)
    data        :: Any
end

function content(child::AbstractString, conf::ConfigN)
    headertype = getheadertype(child)
    if headertype == :none
        filename = abspath(child)
        Content(:text, conf, Page(), isfile(filename) ? readall(filename) : child)
    else
        Content(headertype, conf, Page(), child)
    end
end
content(child::Module, conf::ConfigN) = Content(:module, conf, Page(), child)

## Related functions
# sets: parents, final configuration
function postprocess!(parent, children::Vector)
    for child in children
        child.parent = parent
        child.config = isempty(child.config.cargs)  ?
                            deepcopy(parent.config) :
                            update_config!(deepcopy(parent.config), deepcopy(child.config.cargs))
        if isa(child, Union(Node{Section}, Node{Page}))
            isempty(child.children) || postprocess!(child, child.children)
        # these have no field children: but valid so just skip them
        elseif !isa(child, Content)
            throw(ArgumentError("`$(typeof(child))` is not a valid node structure type."))
        end
    end
end

# get the method name for a node structure object
getnodename(::Document)  = "document"
getnodename(::Section)   = "section"
getnodename(::Page)      = "page"

function getheadertype(s::AbstractString)
    for i in 1:min(length(s), 7)
        s[i] != '#' && return i < 2 ? :none : symbol("header$(i-1)")
    end
    return :none
end
