module Utilities

"""

"""
Utilities

export isexported, iscategory

import Docile.Collector: QualifiedSymbol, Aside

import Docile.Utilities: isexpr

import Docile: Cache

using Compat

convert(::Type{UTF8String}, sym::Symbol)    = utf8(string(sym))
convert(::Type{UTF8String}, s::ASCIIString) = utf8(s)

function utf8checked!(d::Dict{Symbol, Any}, k)
    isa(d[k], UTF8String) ? d[k] : (d[k] = convert(UTF8String, d[k]); d[k])
end

"""
Get the ``Symbol`` representing an object such as ``Function`` or ``Method``.
"""
nameof(s::Symbol) = s
nameof(mod::Module, obj::Symbol)            = obj
nameof(mod::Module, obj::Module)            = module_name(obj)
nameof(mod::Module, obj::Method)            = nameof(Cache.getmeta(mod, obj)[:code])
nameof(mod::Module, obj::DataType)          = obj.name.name
nameof(mod::Module, obj::QualifiedSymbol)   = symbol(last(split(string(obj), '.')))

function  nameof(x::Expr)
    isa(x.args[1], Bool)  ?
        nameof(x.args[2]) :
        isexpr(x.args[1], :(.)) ?
                      x.args[1] :
                      nameof(x.args[1])
end

function nameof(mod::Module, obj::Aside)
    linenumber, path = Cache.getmeta(mod, obj)[:textsource]
    return symbol("aside_$(first(splitext(basename(path))))_L$(linenumber)")
end

function nameof(mod::Module, obj::Function)
    meta = Cache.getmeta(mod, obj)
    if meta[:category] == :function
        obj.env.name
    elseif meta[:category] == :macro
        symbol(string("@", nameof(meta[:code])))
    else
        throw(ArgumentError("'$obj' wrong category: $(meta[:category])"))
    end
end

"""
Is the documented object ``obj`` been exported from the given module ``mod``?
"""
isexported(mod::Module, obj) = nameof(mod, obj) in names(mod)

"""
Is the object ``obj`` from module ``mod`` a Docile category ``cat`` or one of the categories ``cats``.
"""
iscategory(mod::Module, obj, cat::Symbol)          = Cache.getmeta(mod, obj)[:category] == cat
iscategory(mod::Module, obj, cats::Vector{Symbol}) = Cache.getmeta(mod, obj)[:category] in cats

end
