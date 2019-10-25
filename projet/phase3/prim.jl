include("queue.jl")
function prim(G::Graph{T},root=nodes(G)[1]::Node{T}) where T
     tree=Graph("Arbre",[root],Edge{T}[])
     file=PriorityQueue(PriorityItem[]) #File de priorité contenant tous les noeuds restants à ajouter à l'arbre tree
     #Remplissage de file
     for node in nodes(G)
         if node!=root
             push!(file,PriorityItem(Inf,node)) #Tous les noeuds de la file sont initialement à distance infinie de la racine
         end
     end

     #Création d'un dictionaire associant à chaque couple de noeuds reliés par une arête le poids de cette arête
     weights=Dict{Array{String,1},Real}()
     for edge in edges(G)
         merge!(weights,Dict([name(data(edge)[1]),name(data(edge)[2])]=>weight(edge)))
         merge!(weights,Dict([name(data(edge)[2]),name(data(edge)[1])]=>weight(edge)))
     end


      parents = Dict(node => node for node in nodes(G))

      while !is_empty(file)
          for node1 in nodes(tree)
              for i in 1 : length(file)
                  node2 = data(items(file)[i])
                  weight2=priority(items(file)[i])
                  if [name(node1), name(node2)] in keys(weights)
                      if weights[[name(node1),name(node2)]] < weight2
                          priority!(items(file)[i],weights[[name(node1),name(node2)]])
                          parents[node2] = node1
                      end
                  end

              end
          end
          item=popfirst!(file)
          node=data(item)
          add_node!(tree, node)
          add_edge!(tree, Edge((node, parents[node]), priority(item)))
      end
     tree
end
