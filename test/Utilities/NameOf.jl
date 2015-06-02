module NameOf

"""
module string
"""
NameOf

"G_M_1"
G_M_1 = 1

"G_C_1"
const G_C_1 = 1

"T_A_1"
abstract T_A_1

"T_TA_1"
typealias T_TA_1 T_A_1

"T_M_1"
type T_M_1 end

"T_I_1"
immutable T_I_1 end

"m_1"
macro m_1(x) end

"f_1"
function f_1 end

"f_10"
f_10{N}(dest::Array, src::Array, I::NTuple{N,Union(Int,AbstractVector)}...) = ()

end
