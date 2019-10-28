here = @__DIR__
include(joinpath(here,"..","phase1","node.jl"))
include(joinpath(here,"..","phase1","node.jl"))
include(joinpath(here,"..","phase1","edge.jl"))
include(joinpath(here,"..","phase1","graph.jl"))
include(joinpath(here,"..","phase1","read_stsp.jl"))
include("kruskal.jl")

filename = joinpath(here,"..","..","instances","stsp","bayg29.tsp")

"""read_graph_stsp(filename)

Construct a graph from given stsp file.
"""
function read_graph_stsp(filename::String)
    header = read_header(filename)
    nom = header["NAME"]
    graph_edges = read_edges(header,filename)
    G = Graph(nom, Node{Vector{Float64}}[], Edge{Vector{Float64}}[])

    # On ajoute les noueds un par un au graphe G
    if header["DISPLAY_DATA_TYPE"]=="None"
        graph_nodes = Dict(i => [NaN,NaN] for i = 1 : parse(Int,header["DIMENSION"]))
        for (i,nodes) in graph_nodes
        add_node!(G, Node(string(i), nodes))
        end
    else
        graph_nodes = read_nodes(header,filename)
        for (i,nodes) in graph_nodes
            add_node!(G, Node(string(i), nodes))
        end
    end
    # On ajoute les arêtes au graphe G
    for e in graph_edges
        add_edge!(G, Edge((Node(string(e[1]), graph_nodes[e[1]]), Node(string(e[2]), graph_nodes[e[2]])), e[3]))
    end
    return G
end

G = read_graph_stsp(filename)
arbre=kruskal(G)
show(arbre)
tree_weight = sum([weight(e) for e in edges(arbre)])
println("Le poids de l'arbre de recouvrement est de ",tree_weight)
#plot_graph(nodes(arbre),edges(arbre))
