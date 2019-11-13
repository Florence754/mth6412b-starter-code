include("queue.jl")
function prim(G::Graph{T}, root = nodes(G)[1]::Node{T}) where T
     tree = Graph("Arbre", [root], Edge{T}[])
     file = PriorityQueue(PriorityItem[]) #File de priorité contenant tous les noeuds restants à ajouter à l'arbre tree
     #Remplissage de file
     for node in nodes(G)
         if node != root
             push!(file, PriorityItem(Inf, node)) #Tous les noeuds de la file sont initialement à distance infinie de la racine
         end
     end

     #Création d'un dictionaire associant à chaque couple de noeuds reliés par une arête le poids de cette arête
     weights=Dict{Tuple{String, String},Real}()
     for edge in edges(G)
         weights[(name(data(edge)[1]),name(data(edge)[2]))] = weight(edge)
         weights[(name(data(edge)[2]),name(data(edge)[1]))] = weight(edge)
     end
     parents = Dict(node => node for node in nodes(G))
     node1 = root
     vect_file = items(file)
     while !is_empty(file)
         for i in 1 : length(file)
             node2 = data(vect_file[i])
             weight2 = priority(vect_file[i])
             if (name(node1), name(node2)) in keys(weights)
                 if weights[(name(node1), name(node2))] < weight2
                     set_priority!(vect_file[i], weights[(name(node1),name(node2))])
                     parents[node2] = node1
                 end
             end
         end
         item = popfirst!(file)
         node = data(item)
         add_node!(tree, node)
         add_edge!(tree, Edge((node, parents[node]), priority(item)))
         node1 = node
     end
     tree
 end
