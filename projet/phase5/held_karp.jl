"""Renvoie un cycle hamiltonien de coût faible dans le graphe G, d'une longueur inférieure
(si possible) à length_lim, en un nombre d'itérations maximal itermax
"""
   function held_karp(G::Graph{T}, length_lim = 0.0::Float64, itermax = 1000::Int, coef=100000::Int, exponent=0.3::Float64, gap_lim = 1000.0::Float64) where T
       G2 = deepcopy(G) #graphe initialement identique à G, et dans lequel on modifiera le poids de chaque arête
       correction_stsp!(G2)
       node_weights = Dict(name(node) => 0.0 for node in nodes(G2)) #Poids pi de tous les noeuds
       weights = weight_graph(G2) #Poids des arêtes associées à chaque paire de noeuds
       weights_sum = sum(weight(edge) for edge in edges(G2))

       root=root_choice(G2,weights) #On choisit une racine au centre du graphe
       one_tree, parents, tree_root = onetree(G2, root) #Calcul d'un 1-arbre minimal
       N = 0
       i=0
       gap = Inf
       length_cycle = Inf
       length_min = Inf
       cycle_min = Graph("cycle_min", Node{T}[], Edge{T}[])
       alpha = weights_sum/coef #alpha dépend donc du nombre d'arêtes et de leur poids, pour chaque graphe
       while N < itermax && length_cycle > length_lim
           #Modification du poids des noeuds
           for node in nodes(G2)
               node_weights[name(node)] += alpha*(degree(edges(one_tree), node)-2)
           end
           #Modification du poids des arêtes dans G2
           for edge in edges(G2)
               edge.weight =  weights[(name(data(edge)[1]), name(data(edge)[2]))]+node_weights[name(data(edge)[1])]+node_weights[name(data(edge)[2])]
           end
           #Calcul d'un nouvel 1-arbre minimal dans G2
           one_tree, parents, tree_root = onetree(G2, root)

           #Recherche d'un cycle à partir du 1-arbre :
           i += 1
           N += 1
           if gap < gap_lim #A chaque fois que le gap est inférieur à une certaine valeur
               cycle = create_cycle3(one_tree, root, tree_root, weights, parents)
               gap, length_cycle = eval_gap(cycle, one_tree, node_weights, weights)
               #On garde en mémoire le cycle si son coût est inférieur au record conservé jusque là
               if  length_cycle < length_min
                   cycle_min = cycle
                   length_min = length_cycle
               end

           else
               if i == 10 #Sinon toutes les 10 itérations
                   cycle = create_cycle3(one_tree, root, tree_root, weights, parents)
                   gap, length_cycle = eval_gap(cycle, one_tree, node_weights, weights)
                   #On garde en mémoire le cycle si son coût est inférieur au record conservé jusque là
                   if  length_cycle < length_min
                       cycle_min = cycle
                       length_min = length_cycle
                   end
                   i=0
               end
           end
           # Modification de alpha selon une fonction 1/sqrt(x)
           alpha = (weights_sum/coef) / ((N+1)^exponent)

       end

        cycle = cycle_min

        #Réaffectation des poids initiaux aux arêtes
        for edge in edges(cycle)
           edge.weight = weights[(name(data(edge)[1]), name(data(edge)[2]))]
        end

        return cycle
   end
