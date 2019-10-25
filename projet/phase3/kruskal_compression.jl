here = @__DIR__
include(joinpath(here,"..","phase1","node.jl"))
include(joinpath(here,"..","phase1","node.jl"))
include(joinpath(here,"..","phase1","edge.jl"))
include(joinpath(here,"..","phase1","graph.jl"))

"""Renvoie un booléen true si les deux noeuds de l'arête
 edge sont dans le même ensemble connexe et false autrement
"""
function connex_compression(node1::Node{T}, node2::Node{T},dict::Dict{String,String}) where T
    dict[name(node1)]==dict[name(node2)]
end


"""Réalise l'union de deux arborescences dans la forêt
      représentée par le dictionaire dict
"""
function union_compression!(node1::Node{T}, node2::Node{T}, dict::Dict{String,String}) where T
    root1=dict[name(node1)]
    root2=dict[name(node2)]
    for (key,val) in dict
        if val==root2
            dict[key]=root1
        end
    end
end


"""Renvoie un arbre de recouvrement de coût minimal associé au
 graphe G, en utilisant l'algorithme de Kruskal et l'union par compression
"""
function kruskal_compression(G::Graph)
     E = edges(G)
     #Tri des arêtes par poids
     sort!(E, by = x -> weight(x))

     parents=Dict(name(node) => name(node) for node in nodes(G))
     #Graphe contenant les noeuds de G, initialement sans arêtes
     G_construction=Graph("Arbre", nodes(G), Edge{Vector{Float64}}[])
     for e in E
         #Si les deux noeuds de l'arête e ne sont pas dans le même ensemble connexe
        if connex_compression(data(e)[1],data(e)[2],parents)==false
            #On ajoute cette arête au graphe de construction
            add_edge!(G_construction,e)
            #On ajoute cette arête à la forêt d'arborescence
            union_compression!(data(e)[1],data(e)[2],parents)
        end
    end
    #Le graphe de construction obtenu est un arbre de recouvrement de G
    return G_construction
end
