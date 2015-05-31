module Utilities

"""

"""
Utilities

using Compat

convert(::Type{UTF8String}, sym::Symbol)    = utf8(string(sym))
convert(::Type{UTF8String}, s::ASCIIString) = utf8(s)

utf8checked!(d::Dict, k) = isa(d[k], UTF8String) || (d[k] = convert(UTF8String, d[k]))

end
