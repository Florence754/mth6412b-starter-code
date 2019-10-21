here = @__DIR__
include(joinpath(here, "..", "phase1", "node.jl"))
include(joinpath(here, "..", "phase1", "node.jl"))
include(joinpath(here, "..", "phase1", "edge.jl"))
include(joinpath(here, "..", "phase1", "graph.jl"))

"""Renvoie la racine du  noeud `node`
Calcule recursivement la racine de `node, selon la relation de parents donnée
par le dictionnaire `dict`.
"""
function root(node::Node{T},dict::Dict{String,String}) where T
    p = name(node)
    #Tant que le parent du noeud p est différent de lui-même,
    #on remplace ce noeud par son parent
    while p != dict[p]
        p = dict[p]
    end
    return(p)
end

"""Renvoie un booléen true si les deux noeuds de l'arête
 edge sont dans le même ensemble connexe et false autrement
"""
function connex(node1::Node{T}, node2::Node{T},dict::Dict{String,String}) where T
     #Si ces deux noeuds ont la même racine, ils sont dans le
        #même ensemble connexe, sinon non
    return(root(node1,dict) == root(node2,dict))
end

"""Réalise l'union de deux arborescences, par les racines des noeuds,
 et dans la forêt représentée par le dictionaire dict
 """
function union_1!(node1::Node{T}, node2::Node{T}, dict::Dict{String,String}) where T
    #On récupère dans n1 et n2 les racines des deux noeuds
    n1 = root(node1, dict)
    n2 = root(node2, dict)
    dict[n1]=n2
end

"""Renvoie un arbre de recouvrement de coût minimal associé au
 graphe G, en utilisant l'algorithme de Kruskal
"""
function kruskal(G::Graph{T}) where T
    #copie des arêtes du graphe
     E = copy(edges(G))
     #Tri des arêtes par poids
     sort!(E, by = x -> weight(x))
     parents = Dict(name(node) => name(node) for node in nodes(G))

     #Graphe contenant les noeuds de G, initialement sans arêtes
     G_construction = Graph("Arbre", nodes(G), Edge{T}[])
     for e in E
         #Si les deux noeuds de l'arête e ne sont pas dans le même ensemble connexe
        if !connex(data(e)[1], data(e)[2],parents)
            #On ajoute cette arête au graphe de construction
            add_edge!(G_construction,e)
            #On ajoute cette arête à la forêt d'arborescence
            union_1!(data(e)[1], data(e)[2],parents)
        end
    end
    #Le graphe de construction obtenu est un arbre de recouvrement de G
    return G_construction
end
