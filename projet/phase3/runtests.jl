include("kruskal_rank.jl")
include("kruskal_compression.jl")

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

parents=Dict(name(node) => name(node) for node in nodes(G)) #Création d'une forêt d'arborescences avec les noeuds de G, et dont chaque noeud est son propre parent
rank=Dict(name(node) => 0 for node in nodes(G))

for node in nodes(G) #Vérification du contenu de parents
    @test parents[name(node)] == name(node)
    @test rank[name(node)] == 0
end


for edge in edges(G) #On vérifie qu'aucun couple de sommets n'est dans le même ensemble connexe, dans parents
    @test connex(edge,parents) == false
end

union_rank!(arete1,parents,rank) #On ajoute l'arête 1 à parents
@test parents[name(node2)]==name(node1) #On vérifie que le parent de node2 est bien devenu node1
@test parents[name(node1)]==name(node1)
@test connex(arete1,parents) == true #on vérifie le fonctionnement de la fonction connex
@test connex(arete2,parents) == false
@test connex(arete3,parents) == false
@test connex(arete4,parents) == false
@test connex(arete5,parents) == false

union_rank!(arete2,parents,rank)
@test parents[name(node4)]==name(node1)
@test parents[name(node2)]==name(node1)
@test parents[name(node1)]==name(node1)
@test connex(arete1,parents) == true
@test connex(arete2,parents) == true
@test connex(arete3,parents) == false
@test connex(arete4,parents) == true
@test connex(arete5,parents) == false

#Vérification des racines de chaque noeud, dans le nouveau "parents"
@test root(node4,parents)==name(node1)
@test root(node2,parents)==name(node1)
@test root(node1,parents)==name(node1)
@test root(node3,parents)==name(node3)

union_rank!(arete3,parents,rank) #Ajout de la dernière arête possible

#Vérification des racines de chaque noeud, dans le nouveau "parents"
@test root(node4,parents)==name(node1)
@test root(node2,parents)==name(node1)
@test root(node1,parents)==name(node1)
@test root(node3,parents)==name(node1)

for edge in edges(G) #On vérifie que tous les couples de sommets sont dans le même ensemble connexe
    @test connex(edge,parents) == true
end


#Vérification du fonctionnement de la fonction Kruskal
K=kruskal_rank(G)
typeof(K)==typeof(G)

total_weight = sum([weight(e) for e in edges(K)])

for e in edges(K)
@test connex(e,parents)==true #On vérifie que l'ensemble obtenu est connexe

end

@test total_weight==6 #On vérifie que l'arbre obtenu est bien de coût minimal

#On vérifie que K ne contient pas de cycles
@test !(arete4 in edges(K))
@test !(arete5 in edges(K))

#########################################################
#########################################################
#########################################################
#########################################################


parents=Dict(name(node) => name(node) for node in nodes(G)) #Création d'une forêt d'arborescences avec les noeuds de G, et dont chaque noeud est son propre parent

for node in nodes(G) #Vérification du contenu de parents
    @test parents[name(node)] == name(node)
end


for edge in edges(G) #On vérifie qu'aucun couple de sommets n'est dans le même ensemble connexe, dans parents
    @test connex(edge,parents) == false
end

union_compression!(arete1,parents) #On ajoute l'arête 1 à parents
@test parents[name(node2)]==name(node1) #On vérifie que le parent de node2 est bien devenu node1
@test parents[name(node1)]==name(node1)
@test connex(arete1,parents) == true #on vérifie le fonctionnement de la fonction connex
@test connex(arete2,parents) == false
@test connex(arete3,parents) == false
@test connex(arete4,parents) == false
@test connex(arete5,parents) == false

union_compression!(arete2,parents)
@test parents[name(node4)]==name(node1)
@test parents[name(node2)]==name(node1)
@test parents[name(node1)]==name(node1)
@test connex(arete1,parents) == true
@test connex(arete2,parents) == true
@test connex(arete3,parents) == false
@test connex(arete4,parents) == true
@test connex(arete5,parents) == false

union_compression!(arete3,parents) #Ajout de la dernière arête possible

for edge in edges(G) #On vérifie que tous les couples de sommets sont dans le même ensemble connexe
    @test connex(edge,parents) == true
end


#Vérification du fonctionnement de la fonction Kruskal
K=kruskal_compression(G)
typeof(K)==typeof(G)

total_weight = sum([weight(e) for e in edges(K)])

for e in edges(K)
@test connex(e,parents)==true #On vérifie que l'ensemble obtenu est connexe

end

@test total_weight==6 #On vérifie que l'arbre obtenu est bien de coût minimal

#On vérifie que K ne contient pas de cycles
@test !(arete4 in edges(K))
@test !(arete5 in edges(K))
