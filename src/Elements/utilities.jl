["Helper functions."]

"""
Find the final configuration fo node `n`.

Search begins with the node `n` itself followed by any parent `Node` configuration setting.
"""
function findconfig(n::Node)
    local config
    # Stage 1: nodes's config.
    config = n.data

    # Stage 2: Parent's config.
    while isdefined(n, :parent)
        n = n.parent
        update!(config, n.data)
    end
    config
end

function update!(d::Dict, other::Dict)
    for (k,v) in other
        haskey(d, k) || (d[k] = v)
    end
    d
end

"""
Returns the value for key ``k``of the node's final configuration (inclusive parent configuration).
"""
getconfig(n::Node, k::Symbol) = findconfig(n)[k]

"""
Adds a new key ``k`` with value ``v`` to the ``node`` data dictionary .
Throws an ArgumentError if the key exists.
"""
function addconfig{T}(n::Node{T}, k::Symbol, v)
    haskey(n.data, k) && throw(ArgumentError("'$(rename(T))' has already a key ':$k'."))
    n.data[k] = v
end
