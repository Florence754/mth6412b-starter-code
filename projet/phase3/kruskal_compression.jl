here = @__DIR__
include(joinpath(here,"..","phase1","node.jl"))
include(joinpath(here,"..","phase1","node.jl"))
include(joinpath(here,"..","phase1","edge.jl"))
include(joinpath(here,"..","phase1","graph.jl"))

import Base.union!

"""
Fonction renvoyant un booléen true si les deux noeuds de l'arête
 edge sont dans le même ensemble connexe et false autrement

"""
function connex(edge::Edge{T},dict::Dict{String,String}) where T
        #On récupère dans node1 et node2 les deux noeuds contenus dans l'arête edge
    node1=name(data(edge)[1])
    node2=name(data(edge)[2])
        #Si ces deux noeuds ont la même racine, ils sont dans le même ensemble connexe, sinon non
    dict[node1]==dict[node2]
end

"""
Fonction réalisant l'union de deux arborescences, par l'arête edge,
 et dans la forêt représentée par le dictionaire dict
 """
function union_compression!(edge::Edge,dict::Dict{String,String})
    #On récupère dans node1 et node2 les deux noeuds contenus dans l'arête edge
    node1=data(edge)[1]
    node2=data(edge)[2]
    root1=dict[name(node1)]
    root2=dict[name(node2)]
    for (key,val) in dict
        if val==root2
            dict[key]=root1
        end
    end
end


"""
Fonction renvoyant un arbre de recouvrement de coût minimal associé au
 graphe G, en utilisant l'algorithme de Kruskal

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
        if connex(e,parents)==false
            #On ajoute cette arête au graphe de construction
            add_edge!(G_construction,e)
            #On ajoute cette arête à la forêt d'arborescence
            union_compression!(e,parents)
        end
    end
    #Le graphe de construction obtenu est un arbre de recouvrement de G
    return G_construction
end
