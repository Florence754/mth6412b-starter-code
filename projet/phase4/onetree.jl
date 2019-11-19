here = @__DIR__
  #include("prim_New.jl")
  include(joinpath(here,"..","phase3","kruskal.jl"))

  """Construit un 1_arbre de noeud racine 'root' en utilisant l'algorithme de Prim  """
  function onetree(G::Graph{T}, root::Node{T}) where T
          edges_vector = copy(edges(G))
          nodes_vector = copy(nodes(G))
          graph = Graph("",nodes_vector,edges_vector)
          delete_node!(graph,root)
          #Création d'un arbre de coût minmal avec tous les noeuds sauf root
          onetree, parents, tree_root = prim(graph)
          weights = weight_graph(G)
          #Recherche des deux arêtes de poids minimal partant de root
          #Première arête
          minweight1 = Inf
          n1 = root
          for node in nodes(onetree)
                  if weights[(name(node),name(root))] < minweight1
                      minweight1 = weights[(name(node),name(root))]
                      n1 = node
                  end
          end
          edge1 = Edge((n1,root),minweight1) #Création de la première arête de poids minimal reliant root à onetree
          #Deuxième arête
          minweight2 = Inf
          n2 = root
          for node in nodes(onetree)
                  if weights[(name(node),name(root))] < minweight2 && node != n1
                      minweight2 = weights[(name(node),name(root))]
                      n2 = node
                  end
          end
          edge2 = Edge((n2,root),minweight2) #Création de la deuxième arête de poids minimal reliant root à onetree

          #Ajout de root au 1-arbre
          add_node!(onetree,root)
          add_edge!(onetree,edge1)
          add_edge!(onetree,edge2)
          return onetree, parents, tree_root
  end
