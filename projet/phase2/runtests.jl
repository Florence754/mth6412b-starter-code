include(joinpath( @__DIR__,"kruskal.jl"))

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

parents=Dict(name(node) => name(node) for node in nodes(G)) #Création d'une forêt d'arborescences
                                                            #avec les noeuds de G, et dont chaque noeud est son propre parent

for node in nodes(G) #Vérification du contenu de parents
    @test parents[name(node)] == name(node)
end

for edge in edges(G) #On vérifie qu'aucun couple de sommets n'est dans le même ensemble connexe, dans parents
    @test !connex(data(edge)[1], data(edge)[2], parents)
end

union_1!(node1, node2, parents) #On ajoute l'arête 1 à parents
@test connex(node1, node2, parents)  #on vérifie le fonctionnement de la fonction connex
@test !connex(node2, node4, parents)
@test !connex(node2, node3, parents)
@test !connex(node1, node4, parents)
@test !connex(node3, node4, parents)

union_1!(node2, node4,parents)
@test connex(node1, node2, parents)
@test connex(node2, node4, parents)
@test !connex(node2, node3, parents)
@test connex(node1, node4, parents)
@test !connex(node3, node4, parents)


union_1!(node2, node3, parents) #Ajout de la dernière arête possible

for edge in edges(G) #On vérifie que tous les couples de sommets sont dans le même ensemble connexe
    @test connex(data(edge)[1], data(edge)[2], parents)
end


#Vérification du fonctionnement de la fonction Kruskal
K=kruskal(G)
typeof(K)==typeof(G)

total_weight = sum([weight(e) for e in edges(K)])

for e in edges(K)
@test connex(data(e)[1], data(e)[2],parents) #On vérifie que l'ensemble obtenu est connexe

end

@test total_weight==6 #On vérifie que l'arbre obtenu est bien de coût minimal

#On vérifie que K ne contient pas les aretes 4 et 5
@test !(arete4 in edges(K))
@test !(arete5 in edges(K))
