## This test file does not try to keep 100 char lines

facts("Config.") do

    context("Config init validation.") do

        @fact_throws ErrorException Config(category_order=[:module, :function, :method, :type, :comment])
        @fact_throws ErrorException Config(category_order=[:type, :module, :function, :method, :type]) "category_order can not have double entries of same symbol"

        @fact_throws ErrorException Config(metadata_order=[:date, :author, :date]) "metadata_order can not have double entries of same symbol"

        @fact_throws ErrorException Config(mdstyle_module="***")
        @fact_throws MethodError Config(mdstyle_module=:wrongtype)

        @fact_throws ErrorException Config(mdstyle_obj_name="##")  "mdstyle_obj_name can only use Emphasis tags"

        @fact_throws ErrorException Config(mdstyle_module="") "mdstyle_module is a required item"
        @fact_throws ErrorException Config(mdstyle_obj="") "mdstyle_obj is a required item"

        @fact_throws MethodError Config(md_permalink_char="¶") "md_permalink_char wrong type"

    end

    context("Tests update_config! using unicode.") do

        # test with unicode
        user_config1 = Dict([
                        (:category_order       , [:type, :function, :method]),
                        (:metadata_order       , [:date, :日期]),
                        (:include_internal     , false),
                        #
                        (:mdstyle_module       , "#"),
                        (:mdstyle_section      , "###"),
                        (:mdstyle_category     , "####"),
                        (:mdstyle_index_ref    , "##"),
                        #
                        (:mdstyle_meta         , ""),         # test allow empty style if not required
                        (:mdstyle_obj          , " "),
                        (:mdstyle_obj_name     , "**"),
                        (:mdstyle_obj_sig      , "*"),
                        #
                        (:md_permalink         , true),
                        (:md_permalink_header  , false),
                        (:md_permalink_char    , '§'),
                        #
                        (:md_textsource        , "文本"),
                        (:md_codesource        , "代码"),
                        #
                        (:md_module_prefix     , "谷歌翻译"),
                        (:md_obj_signature     , :normal),
                        ])

        # test with unicode
        user_config2 = Dict([
                        (:category_order       , [:aside, :global, :module, :function, :method, :macro, :type, :typealias]),
                        (:metadata_order       , [:ਮਿਤੀ, :日期]),
                        (:include_internal     , true),
                        #
                        (:mdstyle_module       , "###"),
                        (:mdstyle_section      , ""),
                        (:mdstyle_category     , "##"),
                        (:mdstyle_index_ref    , ""),
                        #
                        (:mdstyle_meta         , "*"),
                        (:mdstyle_obj          , "###"),
                        (:mdstyle_obj_name     , "*"),
                        (:mdstyle_obj_sig      , ""),
                        #
                        (:md_permalink         , false),
                        (:md_permalink_header  , true),
                        (:md_permalink_char    , '-'),
                        #
                        (:md_textsource        , "исходный текст"),
                        (:md_codesource        , "código fonte"),
                        #
                        (:md_module_prefix     , "МОДУЛ"),
                        (:md_obj_signature     , :remove),
                        ])

        config1 = Config(user_config1)
        for (k, v) in user_config1
            @fact getfield(config1, k)  => v    "Expceted config1 item: config-item `$k -> $(getfield(config1, k))`."
        end
        config2 = Config(user_config2)
        for (k, v) in user_config2
            @fact getfield(config2, k)  => v    "Expceted config2 item: config-item `$k -> $(getfield(config2, k))`."
        end

        # Replace / update_config! two kwargs item of config1
        config3 = Lexicon.update_config!(config1; md_obj_signature=:remove2, md_codesource="ソース")
        @fact config3.md_obj_signature  => :remove2    "Expceted config3.md_obj_signature: `remove2`."
        @fact config1.md_obj_signature  => :remove2    "Expceted now config1.md_obj_signature: `remove2`."

        @fact config3.md_codesource  => "ソース"     "Expceted config3.md_codesource: `ソース`."
        @fact config1.md_codesource  => "ソース"     "Expceted now config1.md_codesource: `ソース`."

        # Replace / update_config! ALL of config1
        config4 = Lexicon.update_config!(config1, user_config2)
        for (k, v) in user_config2
            @fact getfield(config4, k)  => v    "Expceted config4 item: config-item `$k -> $(getfield(config4, k))`."
        end
        # check config1 was really modified
        for (k, v) in user_config2
            @fact getfield(config1, k)  => v    "Expceted config1 item: config-item `$k -> $(getfield(config1, k))`."
        end

    end
end
