include("kruskal.jl")
include("prim.jl")

using Test
#Initialisation du graphe test G
node1 = Node("1", [-1.0,0.0])
node2 = Node("2", [0.0,1.0])
node3 = Node("3", [1.0,0.0])
node4 = Node("4", [0.0,-1.0])
arete1 = Edge((node1, node2), 1)
arete2 = Edge((node2, node4), 2)
arete3 = Edge((node2, node3), 3)
arete4 = Edge((node1, node4), 4)
arete5 = Edge((node3, node4), 5)
G = Graph("Test graph", [node1, node2, node3, node4], [arete1, arete2, arete3, arete4, arete5])

parents=Dict(name(node) => name(node) for node in nodes(G))

#Vérification du fonctionnement de la fonction Kruskal
K=kruskal(G)
typeof(K) == typeof(G)

total_weight = sum([weight(e) for e in edges(K)])

@test total_weight == 6 #On vérifie que l'arbre obtenu est bien de coût minimal

#On vérifie que K ne contient pas les aretes 4 et 5
@test !(arete4 in edges(K))
@test !(arete5 in edges(K))


#Vérification du fonctionnement de la fonction prim
L = prim(G)
typeof(L)==typeof(G)

total_weight = sum([weight(e) for e in edges(L)])

@test total_weight == 6 #On vérifie que l'arbre obtenu est bien de coût minimal

#On vérifie que K ne contient pas les aretes 4 et 5
@test !(arete4 in edges(L))
@test !(arete5 in edges(L))
