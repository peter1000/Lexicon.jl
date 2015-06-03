["Helper functions."]

"""
Return the value stored for the given key, or the given default value if no mapping for the key is present.
Search begins with the node ``n`` itself followed by any parent node configuration setting.
"""
function getconfig(n::Node, key::Symbol, default::Any=:notfound)
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
