["Helper functions."]

"""
Find the final configuration fo node ``n``.

Search begins with the node ``n`` itself followed by any parent node configuration setting.
"""
function findconfig(n::Node)
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
Adds a new key ``k`` with value ``v`` to the node's data dictionary .
Throws an ``ArgumentError`` if the key exists.
"""
function addconfig{T}(n::Node{T}, k::Symbol, v)
    haskey(n.data, k) && throw(ArgumentError("'$(rename(T))' has already a key ':$k'."))
    n.data[k] = v
end
