include("queue.jl")
function prim(G::Graph{T}, root = nodes(G)[1]::Node{T}) where T
     tree = Graph("Arbre", [root], Edge{T}[])
     file = PriorityQueue(PriorityItem[]) #File de priorité contenant tous les noeuds restants à ajouter à l'arbre tree
     list_nodes = nodes(G)
     list_edges = edges(G)
     #Remplissage de file
     for node in list_nodes
         if node != root
             push!(file, PriorityItem(Inf, node)) #Tous les noeuds de la file sont initialement à distance infinie de la racine
         end
     end

     #Création d'un dictionaire associant à chaque couple de noeuds reliés par une arête le poids de cette arête
     weights=Dict{Tuple{String, String},Real}()
     for edge in list_edges
         data_edge = data(edge)
         n1 = name(data_edge[1])
         n2 = name(data_edge[2])
         weight_edge = weight(edge)
         weights[(n1, n2)] = weight_edge
         weights[(n2,n1)] = weight_edge
     end
     parents = Dict(node => node for node in list_nodes)
     node1 = root
     vect_file = items(file)
     while !is_empty(file)
         n1 = name(node1)
         for i in 1 : length(file)
             node2 = data(vect_file[i])
             n2 = name(node2)
             if ((n1, n2) in keys(weights)) && (weights[(n1, n2)] < priority(vect_file[i]))
                     set_priority!(vect_file[i], weights[(n1,n2)])
                     parents[node2] = node1
             end
         end
         item = popfirst!(file)
         node = data(item)
         add_node!(tree, node)
         add_edge!(tree, Edge((node, parents[node]), priority(item)))
         node1 = node
     end
     return tree
 end
