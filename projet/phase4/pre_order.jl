"""Parcours des noeuds d'un arbre en préordre
"""
function pre_order(root::Node{T}, children::Dict, parents::Dict, tree_nodes::Vector{Node{T}}) where T
    parent = root
    NodesTree = Node{T}[]
    nodes_vector = copy(tree_nodes)

    while length(nodes_vector) != 0
        while length(children[parent]) != 0
            parent = popfirst!( children[parent] )
            push!(NodesTree, parent)
            popfirst!(nodes_vector)
        end
        parent = parents[parent]
        while children[parent] == [] && length(nodes_vector) != 0
            parent = parents[parent]
        end
    end
    return NodesTree
end
