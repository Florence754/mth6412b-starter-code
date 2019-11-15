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
  list_edges = edges(G)
  weights = Dict{Tuple{String,String},Real}()
  for edge in list_edges
      data_edge = data(edge)
      n1 = name(data_edge[1])
      n2 = name(data_edge[2])
      weight_edge = weight(edge)
      weights[(n1, n2)] = weight_edge
      weights[(n2,n1)] = weight_edge
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

"""To do"""
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

"""Renvoie le degré d'un noeud d'un gaphe.
 Prend en argument un vecteur d'aretes 'edges' et le noeud 'node'"""
function degree(edges::Array{Edge{T}}, node::Node{T}) where T
    degree=0
    for edge in edges
        if data(edge)[1]==node||data(edge)[2]==node
            degree+=1
        end
    end
    return degree
end

"""Trouve les degrés d'un noeud"""
function find_onedegree_node(graph::Graph, travelnode::String, tracenode::String)
    neighbours = neighbourhood(graph)
    node_names = Dict(name(node) => node for node in nodes(graph))
    while degree(edges(graph),node_names[travelnode])!=1
        i=1
        while neighbours[travelnode][i] == tracenode
            i += 1
        end
        tracenode = travelnode
        travelnode = neighbours[travelnode][i]
    end
    return(travelnode)
end

"""Renvoie un dictionaire des voisins d'un noeud"""
function neighbourhood(graph::Graph{T}) where T
    neighbours = Dict(name(node) => [] for node in nodes(graph))
    for edge in edges(graph)
        node1 = name(data(edge)[1])
        node2 = name(data(edge)[2])
        if !(node2 in neighbours[node1])
            append!(neighbours[node1],node2)
        end
        if !(node1 in neighbours[node2])
            append!(neighbours[node2],node1)
        end
    end
    return(neighbours)
end

"""Créee un cycle apartir d'un 1-arbre de racine 'root' et d'un dictionnaire
de poids des aretes 'weights'. """
function creat_cycle(tree::Graph{T}, root::Node{T}, weights::Dict{Tuple{String,String},Real},
     method=2::Set([1,2])) where T
    cycle = Graph("cycle", [root], Edge{T}[])
    delete_node!(tree,root)
    n = length(nodes(tree))
    nodesTree_copy = copy(nodes(tree))
    node1 = popfirst!(nodesTree_copy)
    add_node!(cycle, node1)
    add_edge!(cycle, Edge((root, node1), weights[(name(root),name(node1))] ))
    while !isempty(nodesTree_copy)
        node2 = popfirst!(nodesTree_copy)
        add_node!(cycle, node2)
        add_edge!(cycle, Edge((node1, node2), weights[(name(node1),name(node2))]))
        node1 = node2
    end
    if method == 1
        add_edge!(cycle, Edge((node1, root), weights[(name(node1),name(root))]))
    end
    return cycle
end

"""Verifie si  1-arbre est un cycle"""
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
