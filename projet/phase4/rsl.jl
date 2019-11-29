#include("primNew.jl")
 """Renvoie une tournée en utilisant l'algorithme de RSL"""

 function rsl(G::Graph{T}, root=nodes(G)[1]::Node{T}) where T
     n = nb_nodes(G)
     tree, parents = prim(G, root)
     children = Dict(node => Node{T}[] for node in nodes(G))

     for (child,parent) in parents
         push!(children[parent], child)
     end
     nodesTree_copy = pre_order(root, children, parents, nodes(G))

     cycle = Graph("cycle", [root], Edge{T}[])

     #Création d'un dictionaire associant à chaque couple de noeuds reliés par une arête le poids de cette arête
     weights = weight_graph(G)
     n = length(tree)

     node1 = popfirst!(nodesTree_copy)
     while !isempty(nodesTree_copy)
         node2 = popfirst!(nodesTree_copy)
         add_node!(cycle, node2)
         add_edge!(cycle, Edge((node1, node2), weights[(name(node1),name(node2))]))
         node1 = node2
     end
     add_edge!(cycle, Edge((nodes(tree)[n], nodes(tree)[1]), weights[(name(nodes(tree)[n]),name(nodes(tree)[1]))] ))
     return cycle, tree

  end
