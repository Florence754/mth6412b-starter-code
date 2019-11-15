here = @__DIR__
include("prim_New.jl")
include(joinpath(here,"..","phase3","kruskal.jl"))

"""Construit un 1_arbre de noeud racine 'root' en utilisant la methode Kruskal ou prim
 'method' = 1 pour kruskal et 'method' = 2 pour prim  """
function onetree(G::Graph{T}, root::Node{T}, method = 1::Set([1,2])) where T
        edges_vector = copy(edges(G))
        nodes_vector = copy(nodes(G))
        graph=Graph("",nodes_vector,edges_vector)
        delete_node!(graph,root)
        #Création d'un arbre de coût minmal avec tous les noeuds sauf root
        if method == 1
                onetree = kruskal(graph)
        elseif method == 2
                onetree = prim(G)
        end

        weights = weight_graph(G)
        minweight1 = Inf
        n1 = root
        n2 = root
        for node in nodes(onetree)
            if in_edges(edges(G),Edge((root,node),0)) == true
                if weights[(name(node),name(root))] < minweight1
                    minweight1 = weights[(name(node),name(root))]
                    n1 = node
                end
        end
        end

        edge1 = Edge((n1,root),minweight1)

        minweight2 = Inf
        for node in nodes(onetree)
            if in_edges(edges(G),Edge((root,node),0)) == true
                if weights[(name(node),name(root))] < minweight2 && node != n1
                    minweight2 = weights[(name(node),name(root))]
                    n2 = node
                end
        end
        end
        edge2 = Edge((n2,root),minweight2)

        add_node!(onetree,root)
        add_edge!(onetree,edge1)
        add_edge!(onetree,edge2)
        return onetree
end
