# MARKDOWN ONLY
const MDSTYLE_HEADER = ["#", "##", "###", "####", "#####", "######"]
const MDSTYLE_EMPHASIS = [" ", "*", "**"]

"docs/config.md"
type Config

    category_order       :: Vector{Symbol}
    metadata_order       :: Vector{Symbol}
    include_internal     :: Bool
    #
    mdstyle_module       :: ASCIIString
    mdstyle_section      :: ASCIIString
    mdstyle_category     :: ASCIIString
    mdstyle_index_ref    :: ASCIIString
    #
    mdstyle_meta         :: ASCIIString
    mdstyle_obj          :: ASCIIString
    mdstyle_obj_name     :: ASCIIString
    mdstyle_obj_sig      :: ASCIIString
    #
    md_permalink         :: Bool
    md_permalink_header  :: Bool
    md_permalink_char    :: Char
    #
    md_textsource        :: UTF8String
    md_codesource        :: UTF8String
    #
    md_module_prefix     :: UTF8String
    md_obj_signature     :: Symbol

    const defaults = Dict{Symbol, Any}([

        (:category_order       , [:module, :function, :method, :type, :typealias, :macro, :global, :aside]),
        (:metadata_order       , []),
        (:include_internal     , true),
        #
        (:mdstyle_module       , "#"),
        (:mdstyle_section      , "##"),
        (:mdstyle_category     , "####"),
        (:mdstyle_index_ref    , "####"),
        #
        (:mdstyle_meta         , "*"),
        (:mdstyle_obj          , "#####"),
        (:mdstyle_obj_name     , "**"),
        (:mdstyle_obj_sig      , "*"),
        #
        (:md_permalink         , true),
        (:md_permalink_header  , true),
        (:md_permalink_char    , '¶'),
        #
        (:md_textsource        , "txt"),
        (:md_codesource        , "code"),
        #
        (:md_module_prefix     , ""),
        (:md_obj_signature     , :normal),
        ])

    """
    Returns a default Config. If any args... are given these will overwrite the defaults.

    ```
    using Lexicon
    config = Config(md_permalink=false, md_obj_signature=:normal)

    ```
    """
    Config(; args...) = update_config!(new(), merge(defaults, Dict(args)))

    """
    Returns a default Config. If any args... are given these will overwrite the defaults.

    ```
    using Lexicon
    mydict = Dict([(:category_order    , [:type, :function, :method]),
                   (:metadata_order    , [:date, :日期]),
                   (:include_internal  , false)])
    config=Config(mydict)

    ```
    """
    Config(args::Dict) =  update_config!(new(), merge(defaults, args))
end

## MDStyle validations: does allow empty values
function mdstyle_validation(symbols::Vector, mdstyles::Vector, config::Config)
    for k in symbols
        value = getfield(config, k)
        isempty(value) && continue  # no requirement check: empty is a valid option
        value in mdstyles || error("""Invalid mdstyle : config-item `$k -> $(getfield(config, k))`.
                                   Valid values: [$(join(vcat(mdstyles, [""]), ", "))].""")
    end
end

function update_config!(config::Config, args::Dict)
    for (k, v) in args
        if k in fieldnames(Config)
            setfield!(config, k, convert(fieldtype(Config, k), v))
        else
            warn("Invalid setting: '$(k) = $(v)'.")
         end
    end

    # Some of this might be moved to file top f needed outside of this function
    const CATEGORIES =     [:module, :function, :method, :type, :typealias, :macro, :global, :aside]
    const OBJ_SIGNATURES = [:normal, :remove,   :remove2]

    const MDSTYLE_SYM_HEADER_AND_EMPHASIS = [:mdstyle_module,   :mdstyle_section, :mdstyle_category,
                                             :mdstyle_index_ref,:mdstyle_meta,    :mdstyle_obj]
    const MDSTYLE_SYM_ONLY_EMPHASIS       = [:mdstyle_obj_name, :mdstyle_obj_sig]
    const MDSTYLE_SYM_HEADER_REQUIRED     = [:mdstyle_module, :mdstyle_obj]

    # Required MDSTYLE
    for k in MDSTYLE_SYM_HEADER_REQUIRED
        isempty(getfield(config, k)) &&
                error("""Invalid mdstyle : config-item is required: `$k -> $(getfield(config, k))`.
                      Valid values: [$(join(vcat(MDSTYLE_HEADER, MDSTYLE_EMPHASIS), ", "))].""")
    end
    # Header plus Emphasis or Empty
    mdstyle_validation(MDSTYLE_SYM_HEADER_AND_EMPHASIS, vcat(MDSTYLE_HEADER, MDSTYLE_EMPHASIS), config)
    # Only Emphasis
    mdstyle_validation(MDSTYLE_SYM_ONLY_EMPHASIS, MDSTYLE_EMPHASIS, config)

    ## Other validations
    for cat in config.category_order
        cat in CATEGORIES || error("""Invalid category_order item:  `$cat)`.
                        Valid values: $(CATEGORIES).""")
    end
    config.md_obj_signature in OBJ_SIGNATURES ||
                error("""Invalid md_obj_signature item:  `$(config.md_obj_signature))`.
                      Valid values: $(OBJ_SIGNATURES).""")
    # mistaken double entries in Vectors
    length(Set(config.category_order)) == length(config.category_order) ||
              error("Seems there a double entries in category_order:  `$(config.category_order))`.")
    length(Set(config.metadata_order)) == length(config.metadata_order) ||
              error("Seems there a double entries in metadata_order:  `$(config.metadata_order))`.")

    return config
end
update_config!(config::Config; args...) = update_config!(config, Dict(args))
