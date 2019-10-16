
include(joinpath(@__DIR__,"..","phase1","read_stsp.jl"))
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
