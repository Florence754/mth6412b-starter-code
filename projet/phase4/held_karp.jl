"""Renvoie un cycle hamiltonien de coût faible dans le graphe G
    method 1 pour Kruskal et 2 pour Prim"""
 function held_karp(G::Graph{T}, root = nodes(G)[1]::Node{T}, method = 2::Set([1,2]),
                     itermax = 1000::Int, alpha = 0.1::Real) where T
     n = length(nodes(G))
     G2 = deepcopy(G) #graphe initialement identique à G, et dans lequel on modifiera le poids de chaque arête
     node_weights = Dict(name(node) => 0.0 for node in nodes(G2))
     weights = weight_graph(G2)
     cycle = onetree(G2, root, method)
     N = 0
     while N < itermax
         for node in nodes(G2)
             node_weights[name(node)] += alpha*(degree(edges(cycle), node)-2)
         end
         for edge in edges(G2)
             edge.weight =  weights[(name(data(edge)[1]), name(data(edge)[2]))]+node_weights[name(data(edge)[1])]+node_weights[name(data(edge)[2])]
         end
         cycle = onetree(G2, root, method)
         N += 1
     end

      if !iscycle(cycle)
          cycle = creat_cycle(cycle, root, weights, method)
     end

      for edge in edges(cycle)
         edge.weight = weights[(name(data(edge)[1]), name(data(edge)[2]))]
      end
     return(cycle)
 end
