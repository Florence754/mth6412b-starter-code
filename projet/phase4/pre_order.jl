function pre_order(root::Node{T}, children::Dict, parents::Dict, tree_nodes::Vector{Node{T}}) where T
    parent = root
    NodesTree = Node{T}[]
    nodes_vector = copy(tree_nodes)

    while nodes_vector != []
        while children[parent] !=[]
            parent = popfirst!( children[parent] )
            push!(NodesTree, parent)
            popfirst!(nodes_vector)
        end
        parent = parents[parent]
        while children[parent] == [] && nodes_vector != []
            parent = parents[parent]
        end


    end
    return NodesTree
end
