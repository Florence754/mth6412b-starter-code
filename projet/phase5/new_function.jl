here = @__DIR__
  include(joinpath(here,"..","phase1","node.jl"))
  include(joinpath(here,"..","phase1","edge.jl"))
  include(joinpath(here,"..","phase1","graph.jl"))
  include(joinpath(here,"..","phase1","read_stsp.jl"))
  """Egalité de deux arêtes"""
  function egal_edges(edge1::Edge{T},edge2::Edge{T}) where T
    if  (name(data(edge1)[1]) == name(data(edge2)[1]) &&
         name(data(edge1)[2]) == name(data(edge2)[2]))

      return true
    elseif  (name(data(edge1)[1]) == name(data(edge2)[2]) &&
         name(data(edge1)[2]) == name(data(edge2)[1]))

      return true
    else
      return false
    end
  end


  """Appartenance d'une arêtes"""
  function in_edges(E::Vector{Edge{T}}, edge::Edge{T}) where T
    for e in E
      if egal_edges(e, edge)
        return true
      end
    end
    return false
  end


  """Renvoie l'indice d'une arête"""

  function index_edges(Vect_edges::Vector{Edge{T}}, edge::Edge{T}) where T
    n = length(Vect_edges)
    ind = [i for i in 1:n if egal_edges(Vect_edges[i], edge)]
    if !isempty(ind)
      return ind[1]
    else
      return 0
    end
  end

  """Trouve l'indice d'un noeud"""
  function index_node(Vect_nodes::Vector{Node{T}}, node::Node{T}) where T
    n = length(Vect_nodes)
    ind = [i for i in 1:n if name(Vect_nodes[i]) == name(node)]
    if !isempty(ind)
      return ind[1]
    else
      return 0
    end
  end

  """Enlever un noeud au graphe."""
  function delete_node!(graph::Graph{T}, node::Node{T}) where T
    for node2 in nodes(graph)
      delete_edge!(graph,Edge((node,node2),1))
      delete_edge!(graph,Edge((node2,node),1))
    end
    index=index_node(nodes(graph), node)
    if index!=0
      deleteat!(nodes(graph), index)
    end
  end




  """Enlever une arête au graphe."""
  function delete_edge!(graph::Graph{T}, edge::Edge{T}) where T
    if index_edges(edges(graph), edge) == 0
      return graph
    end
      deleteat!(edges(graph), index_edges(edges(graph), edge))
      return graph
  end

  """Donne la liste des voisins d'un noeud"""
  function neighbord_node(G::Graph{T}, node::Node{T}) where T
      weights = Dict{Tuple{String,String},Real}()
      for edge in edges(G)
          weights[(name(data(edge)[1]), name(data(edge)[2]))]= weight(edge)
          weights[(name(data(edge)[2]), name(data(edge)[1]))]= weight(edge)
      end

      succ = [ parse(Int,name(nod)) for nod in nodes(G)
        if (name(nod), name(node)) in keys(weights)
            && in_edges(edges(G), Edge((node, nod), weights[(name(node), name(nod))]))]
      succ
  end

  """Renvoie un dictionnaire de poids dont la clé est un tuple de noms des noueds de l'arête"""
  function weight_graph(G::Graph)
    n = nb_nodes(G)
    weights = Dict{Tuple{String,String},Real}()
    for edge in edges(G)
        weights[(name(data(edge)[1]), name(data(edge)[2]))] = weight(edge)
        weights[(name(data(edge)[2]), name(data(edge)[1]))] = weight(edge)
    end
    return weights
  end


  """Affiche un graph étant donnée un objet de type Graph."""
  function plot_graph(G::Graph{T}) where T
    graph_nodes = Dict{Int}{Vector{Float64}}()
    graph_edges = Dict{Int}{Vector{}}()
    for node in nodes(G)
       graph_nodes[parse(Int, name(node))] = data(node)
       graph_edges[parse(Int, name(node))] = neighbord_node(G,node)
     end
    plot_graph(graph_nodes, graph_edges)
  end


   """Correction de stsp"""
   function correction_stsp!(G::Graph)
       for edge in edges(G)
           for node in nodes(G)
               if name(data(edge)[1])==name(node)
                   edge=Edge((node,data(edge)[2]),weight(edge))
               end
               if name(data(edge)[2])==name(node)
                   edge=Edge((data(edge)[1],node),weight(edge))
               end
               if data(edge)[1]==data(edge)[2]
                   delete_edge!(G,edge)
               end
           end
       end
   end

   """Trouve le degrée d'un noeud"""
   function degree(edges::Array{Edge{T}}, node::Node{T}) where T
       degree=0
       for edge in edges
           if name(data(edge)[1])==name(node)||name(data(edge)[2])==name(node)
               degree+=1
           end
       end
       return degree
   end


   """Trouve les noeuds de degrée """
   function find_onedegree_node(graph::Graph, travelnode::String, tracenode::String,node_names::Dict)
       neighbours = neighbourhood(graph)
       while degree(edges(graph),node_names[travelnode])!=1
           found=false
           i=1
           while found==false
               if neighbours[travelnode][i] == tracenode
                   i += 1
               else
                   found=true
               end
           end
           tracenode = travelnode
           travelnode = neighbours[travelnode][i]
       end
       return(travelnode)
   end

   """Renvoie un dictionnaire avec un noeud(clés) et ses voisins"""
   function neighbourhood(graph::Graph{T}) where T
       neighbours = Dict(name(node) => String[] for node in nodes(graph))
       for edge in edges(graph)
           node1 = name(data(edge)[1])
           node2 = name(data(edge)[2])
           if !(node2 in neighbours[node1])
               push!(neighbours[node1],node2)
           end
           if !(node1 in neighbours[node2])
               push!(neighbours[node2],node1)
           end
       end
       return(neighbours)
   end

   """Créee un cycle apartir d'un 1-arbre de racine 'root' et d'un dictionnaire
   de poids des aretes 'weights'. """
   function create_cycle(onetree::Graph{T}, root::Node{T}, tree_root::Node{T}, weights::Dict{Tuple{String,String},Real}, parents::Dict) where T
       cycle = Graph("cycle", [root], Edge{T}[]) #le cycle ne contient qu départ que le noeud root
       tree = Graph("tree", copy(nodes(onetree)), copy(edges(onetree)))
       delete_node!(tree,root) #On retrouve ici l'arbre avec lequel le 1-arbre a été construit
       children = Dict(node => Node{T}[] for node in nodes(tree))

         for (child,parent) in parents
             push!(children[parent],child)
         end

         #On relie root à l'arbre par l'intermédiaire de node1
         nodesTree_copy = pre_order(tree_root, children, parents,nodes(G))
         node1 = popfirst!(nodesTree_copy)

       #On relie root à l'arbre par l'intermédiaire de node1
       add_node!(cycle, node1)
       add_edge!(cycle, Edge((root, node1), weights[(name(root),name(node1))] ))
       while !isempty(nodesTree_copy)
           node2 = popfirst!(nodesTree_copy)
           add_node!(cycle, node2)
           add_edge!(cycle, Edge((node1, node2), weights[(name(node1),name(node2))]))
           node1 = node2
       end
       #Bouclage du cycle
       add_edge!(cycle, Edge((node1, root), weights[(name(node1),name(root))]))
       return cycle

   end

   """Créee un cycle apartir d'un 1-arbre de racine 'root' et d'un dictionnaire
   de poids des aretes 'weights', en utilisant l'arête de poids minimal partant de root """
   function create_cycle_min(tree::Graph{T}, root::Node{T}, weights::Dict{Tuple{String,String},Real}) where T
       cycle = Graph("cycle", [root], Edge{T}[])#le cycle ne contient qu départ que le noeud root
       delete_node!(tree,root) #On retrouve ici l'arbre avec lequel le 1-arbre a été construit
       nodesTree_copy = copy(nodes(tree))
       #Recherche d'une arête de poids minimal partant de root
       minweight1 = Inf
       root_neighbour = root
       for node in nodesTree_copy
           if weights[(name(node),name(root))] < minweight1
               minweight1 = weights[(name(node),name(root))]
               root_neighbour = node
           end
       end
       add_edge!(cycle, Edge((root, root_neighbour), weights[(name(root),name(root_neighbour))]))

       node0 = popfirst!(nodesTree_copy)
       node1=node0
       node2=node1
       add_node!(cycle,node1)

       while !isempty(nodesTree_copy)
           node2 = popfirst!(nodesTree_copy)
           println(node1)
           if name(node1)==name(root_neighbour)
               add_node!(cycle, node2)
               add_edge!(cycle, Edge((root, node2), weights[(name(root),name(node2))]))
           else
               add_node!(cycle, node2)
               add_edge!(cycle, Edge((node1, node2), weights[(name(node1),name(node2))]))
           end
           node1 = node2
       end
       add_edge!(cycle, Edge((node2, node0), weights[(name(node2),name(node0))]))
       return cycle
   end

   """Créee un cycle apartir d'un 1-arbre de racine 'root' et d'un dictionnaire
   de poids des aretes 'weights', en utilisant l'arête de poids minimal partant de root """
   function create_cycle2(onetree::Graph{T}, root::Node{T}, weights::Dict{Tuple{String,String},Real}) where T
       cycle = Graph("cycle", [root], Edge{T}[])#le cycle ne contient qu départ que le noeud root
       #Recherche d'une arête du 1-arbre partant de root
       tree = Graph("tree", copy(nodes(onetree)), copy(edges(onetree)))
       root_neighbour = root
       found=false
       k=1
       while found==false
           edge=edges(tree)[k]
           if name(data(edge)[1]) == name(root)
               root_neighbour = data(edge)[2]
               found=true
           elseif name(data(edge)[2]) == name(root)
               root_neighbour = data(edge)[1]
               found=true
           end
           k+=1
       end
       add_edge!(cycle, Edge((root, root_neighbour), weights[(name(root),name(root_neighbour))]))

       delete_node!(tree,root) #On retrouve ici l'arbre avec lequel le 1-arbre a été construit
       nodesTree_copy = copy(nodes(tree))

       node0 = popfirst!(nodesTree_copy)
       node1=node0
       node2=node0
       add_node!(cycle,node1)
       while !isempty(nodesTree_copy)
           node2 = popfirst!(nodesTree_copy)
           if name(node1)==name(root_neighbour)
               add_node!(cycle, node2)
               add_edge!(cycle, Edge((root, node2), weights[(name(root),name(node2))]))
           else
               add_node!(cycle, node2)
               add_edge!(cycle, Edge((node1, node2), weights[(name(node1),name(node2))]))
           end
           node1 = node2
       end
       if name(node2)==name(root_neighbour)
           add_edge!(cycle, Edge((root, node0), weights[(name(root),name(node0))]))
       else
           add_edge!(cycle, Edge((node2, node0), weights[(name(node2),name(node0))]))
       end
       return cycle
   end

   """Créee un cycle apartir d'un 1-arbre de racine 'root' et d'un dictionnaire
   de poids des aretes 'weights', en utilisant l'arête de poids minimal partant de root """
   function create_cycle3(onetree::Graph{T}, root::Node{T}, tree_root::Node{T}, weights::Dict{Tuple{String,String},Real}, parents:: Dict) where T
       cycle = Graph("cycle", [root], Edge{T}[])#le cycle ne contient qu départ que le noeud root
       #Recherche d'une arête du 1-arbre partant de root
       tree = Graph("tree", copy(nodes(onetree)), copy(edges(onetree)))


       root_neighbour = root
       found=false
       k=1
       while found==false
           edge=edges(tree)[k]
           if name(data(edge)[1]) == name(root)
               root_neighbour = data(edge)[2]
               found=true
           elseif name(data(edge)[2]) == name(root)
               root_neighbour = data(edge)[1]
               found=true
           end
           k+=1
       end
       add_edge!(cycle, Edge((root, root_neighbour), weights[(name(root),name(root_neighbour))]))

       delete_node!(tree,root) #On retrouve ici l'arbre avec lequel le 1-arbre a été construit

       children = Dict(node => Node{T}[] for node in nodes(tree))
       for child in nodes(tree)
             push!(children[parents[child]],child)
         end


         nodesTree_copy = pre_order(tree_root, children, parents, nodes(tree))

       node0 = popfirst!(nodesTree_copy)
       node1=node0
       node2=node0
       add_node!(cycle,node1)
       while !isempty(nodesTree_copy)
           node2 = popfirst!(nodesTree_copy)
           if name(node1)==name(root_neighbour)
               add_node!(cycle, node2)
               add_edge!(cycle, Edge((root, node2), weights[(name(root),name(node2))]))
           else
               add_node!(cycle, node2)
               add_edge!(cycle, Edge((node1, node2), weights[(name(node1),name(node2))]))
           end
           node1 = node2
       end
       if name(node2)==name(root_neighbour)
           add_edge!(cycle, Edge((root, node0), weights[(name(root),name(node0))]))
       else
           add_edge!(cycle, Edge((node2, node0), weights[(name(node2),name(node0))]))
       end
       return cycle
   end



   """Verifie si un 1-arbre possède des degrés différents de 2"""
   function iscycle(G::Graph{T}) where T
       list_node = nodes(G)
       list_edge = edges(G)
       for node in list_node
            if degree(list_edge, node)!=2
                return false
            end
        end
        return true
    end

 function cost_graph(cycle::Graph)
     length=0.0
     for edge in edges(cycle)
         length+=weight(edge)
     end
     return length
 end

"""Choisi un noeud pour Held_karp"""
 function root_choice(G::Graph, weights::Dict{Tuple{String,String},Real})
    minweight=Inf
    min_node=nodes(G)[1]
    for node1 in nodes(G)
        weight=0.0
        for node2 in nodes(G)
            if node2!=node1
                weight+=(weights[(name(node1),name(node2))])^2
            end
        end
        if weight<minweight
            minweight=weight
            min_node=node1
        end
    end
    return min_node
end

"""Renvoie les données d'un vecteur de noeuds"""
data(node::Vector{Node{T}}) where T = [data(nod) for nod in node]
