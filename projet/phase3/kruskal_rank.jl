here = @__DIR__
include(joinpath(here,"..","phase1","node.jl"))
include(joinpath(here,"..","phase1","node.jl"))
include(joinpath(here,"..","phase1","edge.jl"))
include(joinpath(here,"..","phase1","graph.jl"))

"""Renvoie la racine du  noeud `node`
Calcule recursivement la racine de `node, selon la relation de parents donnée
par le dictionnaire `dict`.
"""
function root(node::Node{T},dict::Dict{String,String}) where T
    p = name(node)
    #Tant que le parent du noeud p est différent de lui-même, on remplace ce noeud par son parent
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

"""Réalise l'union de deux arborescences, en utilisant le rang,
 et dans la forêt représentée par le dictionaire dict
"""
function union_rank!(node1::Node{T}, node2::Node{T}, dict::Dict{String,String}, rank::Dict{String,Int}) where T
    # racine des noeuds
    root1 = root(node1,dict)
    root2 = root(node2,dict)
    # rang des racines
    rank1 = rank[root1]
    rank2 = rank[root2]
    if rank1 == rank2
        dict[root2] = root1
        rank[root1] += 1
    elseif rank1 > rank2
        dict[root2] = root1
    else
        dict[root1] = root2
    end
end


"""Renvoie un arbre de recouvrement de coût minimal associé au
 graphe G, en utilisant l'algorithme de Kruskal et l'union par le rang.
"""
function kruskal_rank(G::Graph)
     E = edges(G)
     #Tri des arêtes par poids
     sort!(E, by = x -> weight(x))

     parents=Dict(name(node) => name(node) for node in nodes(G))
     rank=Dict(name(node) => 0 for node in nodes(G))
     #Graphe contenant les noeuds de G, initialement sans arêtes
     G_construction=Graph("Arbre", nodes(G), Edge{Vector{Float64}}[])
     for e in E
         #Si les deux noeuds de l'arête e ne sont pas dans le même ensemble connexe
        if connex(data(e)[1], data(e)[2], parents) == false
            #On ajoute cette arête au graphe de construction
            add_edge!(G_construction,e)
            #On ajoute cette arête à la forêt d'arborescence
            union_rank!(data(e)[1], data(e)[2], parents, rank)
        end
    end
    #Le graphe de construction obtenu est un arbre de recouvrement de G
    return G_construction
end
