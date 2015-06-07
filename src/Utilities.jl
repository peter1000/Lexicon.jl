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
nameof(m::Module, obj::Symbol)            = obj
nameof(m::Module, obj::Module)            = module_name(obj)
nameof(m::Module, obj::Method)            = obj.func.code.name
nameof(m::Module, obj::DataType)          = obj.name.name
nameof(m::Module, obj::QualifiedSymbol)   = obj.sym

function nameof(x::Expr)
    isa(x.args[1], Bool)    && return nameof(x.args[2])
    isexpr(x.args[1], :(.)) && return x.args[1]
    nameof(x.args[1])
end

function nameof(m::Module, obj::Aside)
    linenumber, path = Cache.getmeta(m, obj)[:textsource]
    return symbol("aside_$(first(splitext(basename(path))))_L$(linenumber)")
end

function nameof(m::Module, obj::Function)
    meta = Cache.getmeta(m, obj)
    meta[:category] == :function ? obj.env.name : symbol(string("@", nameof(meta[:code])))
end

"""
Is the documented object ``obj`` exported from the given module ``m``?
"""
isexported(m::Module, obj) = nameof(m, obj) in Cache.getmeta(Cache.getmodule(m))[:exports]

"""
Is the object ``obj`` from module ``m`` a Docile category ``cat`` or one of the categories ``cats``.
"""
:iscategory

iscategory(m::Module, obj, cat::Symbol)          = Cache.getmeta(m, obj)[:category] == cat
iscategory(m::Module, obj, cats::Vector{Symbol}) = Cache.getmeta(m, obj)[:category] in cats

"""
Is the docstring location of object ``obj`` from module ``m``` in one of the files ``files``.
"""
function isinfile(m::Module, obj, files::Vector)
    textsource = Cache.getmeta(m, obj)[:textsource][2]
    for f in files
        endswith(textsource, f) && return true
    end
    false
end

end
