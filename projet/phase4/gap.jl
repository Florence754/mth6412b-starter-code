"""Calcul du gap entre la solution actuelle (le cycle) et la borne inférieure définie par le 1-arbre
"""
function eval_gap(cycle::Graph{T}, onetree::Graph{T}, node_weights::Dict, weights::Dict) where T
     cycle_cost = 0.0
     for edge in edges(cycle)
         cycle_cost += weights[(name(data(edge)[1]), name(data(edge)[2]))]
     end
     onetree_cost = cost_graph(onetree)
     sum=0.0

     for node in nodes(onetree)
         sum += 2*node_weights[name(node)]
     end

     gap = cycle_cost - (onetree_cost - sum)
     return gap, cycle_cost
 end
