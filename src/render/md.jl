## markdown rendering  –––––––––––––––––––––––––––––––––––––
immutable MarkdownFormatter <: Docile.Formats.AbstractFormatter end

Docile.Formats.parsedocs(::Docile.Formats.Format{MarkdownFormatter}, raw) = Markdown.parse(raw)

#=
"""

""" =#


"""
Returns the meta symbol and associated text.
"""
function parse!!(rawtext::AbstractString, i::Int)
    tmpbuf = IOBuffer()
    local name::Symbol, text::AbstractString
    while !done(rawtext, i)
        c, i = next(rawtext, i)
        if c == '('
            name = takebuf_string(tmpbuf)
            continue
        elseif c == ')'
            text = takebuf_string(tmpbuf)
            break
        end
        write(tmpbuf, c)
    end
    try
        return name, text, i
    catch
        error("Could not parse meta. ")  # QUESTION: add module/obj info or no error at all? see: https://github.com/MichaelHatherly/Docile.jl/issues/89#issuecomment-99664243
    end
end

# meta_order_dict is a mapping from the config
#       (:metadata_order       , [ (:author    , "笔者 : "),
#                                  (:license   , "许可证: "),
#                                  (:args      , "参数: "),
#                                  (:page      , "输出部分: ")]),
function extractmeta(rawtext::AbstractString, obj, mod::Module, meta_order_dict::Dict)
    check_char = '!'
    outbuf = IOBuffer()
    i = start(rawtext)
#    if done(rawtext,i)  # QUESTION: is an empty docstring allowed? see: https://github.com/MichaelHatherly/Docile.jl/issues/89#issuecomment-99664243
#        return 0
#    end
    while !done(rawtext, i)
        c, i = next(rawtext, i)
        if c == check_char
            # Check the next one too
            if rawtext[i] == check_char
                meta_i = i + 1
                if !done(rawtext, meta_i)
                    name, text, i = parse!!(rawtext, meta_i)
                    write(outbuf, extractmeta(name, text, obj, mod, meta_order_dict))
                    continue
                else
                    break
                end
            end
        end
        write(outbuf, c)
    end
    #parsedocs(outbuf, obj, mod)   QUESTION: do we really parsedocs here or return the outbuf
    return takebuf_string(outbuf)
end

function extractmeta(meta_name::Symbol, text::AbstractString, obj, mod::Module, meta_order_dict::Dict)
    Docile.Cache.getmeta(mod, obj)[meta_name] = text                   # add to the object's metadata
    if haskey(meta_order_dict, meta_name)
        return string(meta_order_dict[meta_name], text)                # rewrite the displayed output
    else
        return "$(ucfirst(string(meta_name))): $(text)"                # rewrite the displayed output
    end
end

function save(file::AbstractString, mime::MIME"text/md", mod::Module, config::Config)
    #ents = Entries(abspath(file), config)
    raw_ = Docile.Cache.getraw(mod)
    # do it once
    meta_order_dict = Dict(config.metadata_order)
    for (obj, rawtext) in raw_
        final_rawtext = extractmeta(rawtext, obj, mod, meta_order_dict)
        println("\nfinal_rawtext: \n", final_rawtext)
        println("\ngetmeta(mod, obj): ", Docile.Cache.getmeta(mod, obj))
    end

    # Write the main file.
    isfile(file) || mkpath(dirname(file))
    open(file, "w") do f
        info("writing documentation to $(file)")
    end
    #return ents
end
