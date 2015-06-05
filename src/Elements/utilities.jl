["Helper functions."]

"""
Find the value for ``key`` associated with a node's ``n`` configuration.

Returns a ``Nullable{T}`` object. ``isnull`` must be called to determine whether
an object was actually found or not.

When the configuration of ``n`` does not contain the key ``key`` then all it's parents
are searched in turn.
"""
function findconfig(n::Node, key::Symbol, T)
    haskey(n.data, key) && return Nullable{T}(n.data[key])
    # Stage 2: Parent's config.
    while isdefined(n, :parent)
        n = n.parent
        haskey(n.data, key) && return Nullable{T}(n.data[key])
    end
    Nullable{T}()
end

"""
Adds a new key ``k`` with value ``v`` to the node's data dictionary .
Throws an ``ArgumentError`` if the key exists.
"""
function addconfig{T}(n::Node{T}, k::Symbol, v)
    haskey(n.data, k) && throw(ArgumentError("'$(rename(T))' has already a key ':$k'."))
    n.data[k] = v
end
