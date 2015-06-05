["Helper functions."]

function findconfig(n::Node, key::Symbol, default = :notfound)
    haskey(n.data, key) && return n.data[key]
    # Stage 2: Parent's config.
    while isdefined(n, :parent)
        n = n.parent
        haskey(n.data, key) && return n.data[key]
    end
    default
end

"""
Adds a new key ``k`` with value ``v`` to the node's data dictionary .
Throws an ``ArgumentError`` if the key exists.
"""
function addconfig{T}(n::Node{T}, k::Symbol, v)
    haskey(n.data, k) && throw(ArgumentError("'$(rename(T))' has already a key ':$k'."))
    n.data[k] = v
end
