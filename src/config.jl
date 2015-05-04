const MDSYLE_HEADER = ["#", "##", "###", "####", "#####", "######"]
const MDSYLE_EMPHASIS = [" ", "*", "**"]

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
        (:metadata_order       , Symbol[]),
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
    config = Config(md_permalink = false, mathjax = true)

    ```
    """
    function Config(; args...)
        return update_config!(new(), merge(defaults, Dict(args)))
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
    # Header plus Emphasis or Empty
    for k in [:mdstyle_module, :mdstyle_section, :mdstyle_category,
              :mdstyle_index_ref,:mdstyle_meta, :mdstyle_obj]
        getfield(config, k) in vcat(MDSYLE_HEADER, MDSYLE_EMPHASIS) ||
                error("""Invalid mdstyle : config-item `$k -> $(getfield(config, k))`.
                      Valid values: [$(join(vcat(MDSYLE_HEADER, MDSYLE_EMPHASIS, [""]), ", "))].""")
    end
    # Only Emphasis
    for k in [:mdstyle_obj_name, :mdstyle_obj_sig]
        getfield(config, k) in vcat(MDSYLE_EMPHASIS) ||
                error("""Invalid mdstyle : config-item `$k -> $(getfield(config, k))`.
                      Valid values: [$(join(MDSYLE_EMPHASIS, ", "))].""")
    end
    # Required
    for k in [:mdstyle_module, :mdstyle_obj]
        isempty(getfield(config, k)) &&
                error("""Invalid mdstyle : config-item is required: `$k -> $(getfield(config, k))`.
                      Valid values: [$(join(vcat(MDSYLE_HEADER, MDSYLE_EMPHASIS), ", "))].""")
    end
    return config
end
