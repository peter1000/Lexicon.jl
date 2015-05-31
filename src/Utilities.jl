module Utilities

"""

"""
Utilities

using Compat

convert(::Type{UTF8String}, sym::Symbol)    = utf8(string(sym))
convert(::Type{UTF8String}, s::ASCIIString) = utf8(s)

function utf8checked!(d::Dict{Symbol, Any}, k)
    isa(d[k], UTF8String) ? d[k] : (d[k] = convert(UTF8String, d[k]); d[k])
end

end
