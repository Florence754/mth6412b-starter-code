"""Renvoie une tournée en utilisant l'algorithme de RSL"""

function rsl(G::Graph{T},root=nodes(G)[1]::Node{T}) where T
    tree = prim(G, root)
    cycle = Graph("cycle", [root], Edge{T}[])
    #Création d'un dictionaire associant à chaque couple de noeuds reliés par une arête le poids de cette arête
    weights = weight_graph(G)
    n = length(nodes(tree))
    nodesTree_copy = copy(nodes(tree))
    node1 = popfirst!(nodesTree_copy)
    while !isempty(nodesTree_copy)
        node2 = popfirst!(nodesTree_copy)
        add_node!(cycle, node2)
        add_edge!(cycle, Edge((node1, node2), weights[(name(node1),name(node2))]))
        node1 = node2
    end
    add_edge!(cycle, Edge((nodes(tree)[n], nodes(tree)[1]), weights[(name(nodes(tree)[n]),name(nodes(tree)[1]))] ))
    return cycle

 end
