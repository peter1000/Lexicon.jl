## General markdown rendering  –––––––––––––––––––––––––––––––––––––
function save(file::AbstractString, mime::MIME"text/md", doc::Metadata, config::Config)
    ents = Entries(abspath(file), modulename(doc), config)
    # Write the main file.
    isfile(file) || mkpath(dirname(file))
    open(file, "w") do f
        info("writing documentation to $(file)")
        writemd_module_header(f, doc, config)
        ents = mainsetup(f, mime, doc, ents)
    end
    return ents
end

# used for all headers: except objects
function writemd_anchor_permalink(io::IO, mdstyle::Symbol, name::AbstractString,
                                        anchor_tmpname::AbstractString, config::Config)
    anchorname = generate_html_id(anchor_tmpname)
    println(io, """\n<a id="$anchorname" class="lexicon_definition"></a>""")
    item = string(name, config.md_permalink            ?
        " [$(config.md_permalink_char)](#$anchorname)" :
        "")
    mdstyle_val = getfield(config, mdstyle)
    println(io, string(mdstyle_val, mdstyle_val in MDSYLE_HEADER ? " $(item)" : " $(item)$(mdstyle_val)"))
    return anchorname
end

# used for object headers: this prepares for the TODO
#   TODO: implement `mdstyle_obj_name` and `mdstyle_obj_sig`
function writemd_anchor_permalink(io::IO, objname::AbstractString, anchorname::AbstractString, config::Config)
    mdstyle_val = config.mdstyle_obj
    println(io, """\n<a id="$anchorname" class="lexicon_definition"></a>""")
    item = string(objname, config.md_permalink            ?
        " [$(config.md_permalink_char)](#$anchorname)" :
        "")
    println(io, string(mdstyle_val, mdstyle_val in MDSYLE_HEADER ? " $(item)" : "$(item)$(mdstyle_val)"))
    return anchorname
end

## NOTE: This is used by both: documentation and API-Index (isindex=true)
#function grp_categorynames_md(io::IO, ents::Entries, category::Symbol, grpname::AbstractString,
#                                                                 config::Config, isindex::Bool)
#    category_str = string(category, category == :typealias ? "es" : "s")
#    final_categoryname = ucfirst(category_str)
#    if isindex
#        tmp_id_tag = string("index_", ents.modulename, "__", category_str)
#        mdstyle_subheader = config.mdstyle_subheader
#        md_grp_permalink = config.md_grp_permalink
#    else
#        tmp_id_tag = string(ents.modulename, "__", category_str)
#        mdstyle_subheader = ents.savedconfig.mdstyle_subheader
#        md_grp_permalink = ents.savedconfig.md_grp_permalink
#    end
#    if !ents.isjoined
#        final_categoryname =  string(ents.savedconfig.md_split_category_prefixed   ?
#                                    "$(grpname) $(final_categoryname)" :
#                                    "$(final_categoryname) [$(grpname)]")
#        tmp_id_tag = string(tmp_id_tag, "_", grpname)
#    end
#    writemd_anchor_permalink(io, :mdstyle_subheader, grpname, tmp_id_tag, config)
#    isindex || push!(ents.grp_anchors, final_categoryname, grp_anchorname)
#end

# format specific document process inner loop 
function processmd_entries_items(io::IO, ents::Entries, entries::Dict, grpname::AbstractString)
    savedconfig = ents.savedconfig
    for k in savedconfig.category_order
        if length(entries[k]) > 0
#            if (savedconfig.md_subheader == :category || savedconfig.md_subheader == :split_category)
#                grp_categorynames_md(io, ents, k, grpname, savedconfig, false)
#            end
            for (obj, ent, anchorname) in entries[k]
                writemd(io, obj, ent, anchorname, savedconfig)
            end
        end
    end
end

# Processes joined entries
function process_entries(io::IO, mime::MIME"text/md", ents::Entries)
    ents.savedconfig.md_section && throw(ArgumentError(string("This `process_entries` method needs ",
                                                              "`config.md_section = false`")))
    processmd_entries_items(io, ents, ents.joined, "")
end

# Processes separate entries: 'exported' and 'internal'
function process_entries(io::IO, mime::MIME"text/md", ents::Entries, section::AbstractString)
    entries = section == "Exported" ? ents.exported : ents.internal
    grp_anchors = ents.grp_anchors
    savedconfig = ents.savedconfig
    if savedconfig.md_subheader == :simple
        grp_anchorname = writemd_anchor_permalink(io, :mdstyle_subheader, section,
                                            "$(string(ents.modulename))__$(section)", ents.savedconfig)
        push!(ents.grp_anchors, section, grp_anchorname)
    end
    processmd_entries_items(io, ents, entries, section)
end

#function writemime(io::IO, mime::MIME"text/md", manual::AbstractString)
#    println(io, manual)
#end

function writemd{category}(io::IO, obj, ent::Entry{category},
                           anchorname::AbstractString, config::Config)
    objname = writeobj(obj, ent)
    println(io, "---\n")
    writemd_anchor_permalink(io, objname, anchorname, config)
    #writemd(io, docs(ent))
    println(io)
#    for k in sort(collect(keys(ent.data)))
#        mdstyle = config.mdstyle_meta
#        println(io, string(mdstyle, mdstyle in MDSYLE_HEADER ? " $(k):" : "$($(k):$(mdstyle)"))

#        writemd(io, Meta{k}(ent.data[k]))
#        println(io)
#    end
end

#function writemd(io::IO, md::Meta)
#    println(io, md.content)
#end

#function writemd(io::IO, m::Meta{:source})
#    path = last(split(m.content[2], r"v[\d\.]+(/|\\)"))
#    println(io, "[$(path):$(m.content[1])]($(url(m)))")
#end

function writemd_module_header(io::IO, doc::Metadata, config::Config)
    writemd_anchor_permalink(io, :mdstyle_module, string(doc.modname), string("api_", doc.modname), config)
end

### Docs-specific rendering

#function writemd(io::IO, docs::Docile.Interface.Docs{:md})
#    println(io, docs.data)
#end


#### API-Index ----------------------------------------------------------------------------

#function save(file::AbstractString, mime::MIME"text/md", index::Index, config::Config)
#    # Write the API-Index file.
#    indexfiledir = dirname(abspath(file))
#    isfile(file) || mkpath(indexfiledir)
#    open(file, "w") do f
#        info("writing API-Index to $(file)")
#        writemd_anchor_permalink(f, :mdstyle_header, "API-INDEX", "index__api-index", config)
#        for ents in index.entries
#            if ents.has_items
#                ents.index_relpath = relpath(ents.sourcepath, indexfiledir)
#                namemod = string(config.md_index_modprefix, ents.modulename)
#                writemd_anchor_permalink(f, :mdstyle_header, namemod, string("index_api_", namemod), config)
#                if config.md_index_grpsection && !isempty(ents.grp_anchors)
#                    println(f, "---\n")
#                    writemd_anchor_permalink(f, :mdstyle_subheader, "Sections",
#                                           string("index_$(ents.modulename)__sections"), config)
#                    for (final_grpname, grp_anchorname) in ents.grp_anchors
#                        println(f, "[$(final_grpname)]($(ents.index_relpath)#$(grp_anchorname))\n")
#                    end
#                end
#                if ents.isjoined && has_items(ents.joined)
#                    process_api_index_items_md(f, ents, ents.joined, "", config)
#                elseif (has_items(ents.exported) || has_items(ents.internal))
#                    process_api_index_md(f, ents, "Exported", config)
#                    process_api_index_md(f, ents, "Internal", config)
#                end
#            end
#        end
#    end
#end

## Processes API-Index separate entries: 'exported' and 'internal'
#function process_api_index_md(io::IO, ents::Entries, grpname::AbstractString, config::Config)
#    entries = grpname == "Exported" ? ents.exported : ents.internal
#    grp_anchors = ents.grp_anchors
#    savedconfig = ents.savedconfig
#    savedconfig.md_subheader == :simple && writemd_anchor_permalink(io, :mdstyle_subheader, grpname,
#                                            "index_$(string(ents.modulename))__$(grpname)", config)
#    process_api_index_items_md(io, ents, entries, grpname, config)
#end

## The API-Index inner loop
#function process_api_index_items_md(io::IO, ents::Entries, entries::Dict,
#                                    grpname::AbstractString, config::Config)
#    savedconfig = ents.savedconfig
#    for k in savedconfig.category_order
#        if length(entries[k]) > 0
#            if (savedconfig.md_subheader == :category || savedconfig.md_subheader == :split_category)
#                grp_categorynames_md(io, ents, k, grpname, config, true)
#            end
#            for (obj, ent, anchorname) in entries[k]
#                description = split(data(docs(ent)), '\n')[1]
#                println(io, "[$(writeobj(obj, ent))]($(ents.index_relpath)#$(anchorname))  $(description)\n")
#            end
#        end
#    end
#end
