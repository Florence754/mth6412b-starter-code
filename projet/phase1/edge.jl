import Base.show
# ajout d'une ligne
"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{T} end

"""Type représentant les arêtes d'un graphe.

Exemple:

        arete1 = Edge((node1, node2), 12)
        arete2 = Edge((node1, node3), 24)
        arete3 = Edge((node1, node3), 3)

"""
mutable struct Edge{T} <: AbstractEdge{T}
  data::Tuple{Node{T},Node{T}}
  weight::Real
end


 #on présume que tous les arêtes dérivant d'AbstractEdge
 # posséderont des champs `data` et `weight`.

"""Renvoie les sommets reliés par l'arête."""
data(edge::AbstractEdge) = edge.data


"""Renvoie le poids de l'arête."""
weight(edge::AbstractEdge) = edge.weight

"""Affiche une arête."""
function show(edge::AbstractEdge)
  println("data : ", data(edge)[1].name, " et ",data(edge)[2].name , ", weight : ", weight(edge))
end
