
include("read_stsp1.jl")
"""read_graph_stsp(filename)

Construct a graph from given stsp file.
"""
function read_graph_stsp(filename::String)
    header = read_header(filename)
    nom = header["NAME"]
    graph_edges = read_edges(header,filename)
    G = Graph(nom, Node{Int}[], Edge{Int}[])

    # On ajoute les noueds un par un au graphe G
    graph_nodes = read_nodes(header, filename)
    for (i, nodes) in graph_nodes
        add_node!(G, Node(string(i), nodes))
    end
    # On ajoute les arêtes au graphe G
    for e in graph_edges
        add_edge!(G, Edge((Node(string(e[1]), graph_nodes[e[1]]), Node(string(e[2]), graph_nodes[e[2]])), e[3]))
    end
    # sort!(nodes(G),by=data)
    return G
end
