here = @__DIR__
include(joinpath(here,"..","phase3","kruskal.jl"))
include("new_function.jl")
include("read_graph1.jl")
include("prim_New.jl")
include("gap.jl")
include("onetree.jl")
include("held_karp.jl")
include("pre_order.jl")
include("rsl.jl")
include(joinpath(here,"..","..","shredder","shredder-julia","bin","tools.jl"))

# List of stsp instances
const STSP_DIR = joinpath(@__DIR__,"..","..","shredder","shredder-julia","tsp","instances")
const STSP = readdir(STSP_DIR)
const GRAPHS = [read_graph_stsp(joinpath(STSP_DIR, finst)) for finst in STSP]
const SHUFFLED_DIR  = joinpath(@__DIR__,"..","..","shredder","shredder-julia","images","shuffled")
const SHUFFLED = readdir(SHUFFLED_DIR)
const TOUR = joinpath(@__DIR__,"..","..","shredder","shredder-julia","tsp","tours")
const IMAGES_DIR  = joinpath(@__DIR__,"..","..","shredder","shredder-julia","images","original")
const IMAGES = readdir(IMAGES_DIR)

# # # # # # # # # # # # # # #
#  abstract-light-painting  #
# # # # # # # # # # # # # # #

Shuffled_ALP = joinpath(@__DIR__,"..","..","shredder","shredder-julia","images","shuffled",SHUFFLED[1])

H_ALP = held_karp(GRAPHS[1],0.0,10,1000000000,0.9)
weigh = cost_graph(H_ALP)
tour_ALP = data(nodes(H_ALP))
filen_ALP =joinpath(@__DIR__,"tour","tour_ALP.tour")
write_tour(filen_ALP, tour_ALP, weigh)
L1 = joinpath(@__DIR__, "images_reconstruted","abstract-light-painting.png")
reconstruct_picture(filen_ALP, Shuffled_ALP, L1; view=true)


# # # # # # # # # # # # # # #
#  alaska-railroad          #
# # # # # # # # # # # # # # #

Shuffled_AR = joinpath(@__DIR__,"..","..","shredder","shredder-julia","images","shuffled",SHUFFLED[2])
H_AR = held_karp(GRAPHS[2],0.0,10,100000000,0.9)
weigh_AR = cost_graph(H_AR)
tour_AR = data(nodes(H_AR))
filen_AR =joinpath(@__DIR__,"tour","tour_AR.tour")
write_tour(filen_AR, tour_AR, weigh_AR)
L2 = joinpath(@__DIR__, "images_reconstruted","alaska-railroad.png")
reconstruct_picture(filen_AR, Shuffled_AR, L2; view=true)

# # # # # # # # # # # # # # #
#  blue-hour-paris          #
# # # # # # # # # # # # # # #

Shuffled_BHP = joinpath(@__DIR__,"..","..","shredder","shredder-julia","images","shuffled",SHUFFLED[3])
H_BHP = held_karp(GRAPHS[3],0.0,10,100000000,0.9)
weigh_BHP = cost_graph(H_BHP)
tour_BHP = data(nodes(H_BHP))
filen_BHP =joinpath(@__DIR__,"tour","tour_BHP.tour")
write_tour(filen_BHP, tour_BHP, weigh_BHP)
L3 = joinpath(@__DIR__, "images_reconstruted","blue-hour-paris.png")
reconstruct_picture(filen_BHP, Shuffled_BHP, L3; view=true)

# # # # # # # # # # # # # # #
# lower-kananaskis-lake     #
# # # # # # # # # # # # # # #

Shuffled_LKL = joinpath(@__DIR__,"..","..","shredder","shredder-julia","images","shuffled",SHUFFLED[4])
H_LKL = held_karp(GRAPHS[4],0.0,10,100000000,0.9)
weigh_LKL = cost_graph(H_LKL)
tour_LKL = data(nodes(H_LKL))
filen_LKL =joinpath(@__DIR__,"tour","tour_LKL.tour")
write_tour(filen_LKL, tour_LKL, weigh_LKL)
L4 = joinpath(@__DIR__, "images_reconstruted","lower-kananaskis-lake.png")
reconstruct_picture(filen_LKL, Shuffled_LKL, L4; view=true)


# # # # # # # # # # # # # # #
# marlet2-radio-board       #
# # # # # # # # # # # # # # #

Shuffled_MRB = joinpath(@__DIR__,"..","..","shredder","shredder-julia","images","shuffled",SHUFFLED[5])
H_MRB = held_karp(GRAPHS[5],0.0,10,100000000,0.9)
weigh_MRB = cost_graph(H_MRB)
tour_MRB = data(nodes(H_MRB))
filen_MRB =joinpath(@__DIR__,"tour","tour_MRB.tour")
write_tour(filen_MRB, tour_MRB, weigh_MRB)
L5 = joinpath(@__DIR__, "images_reconstruted","marlet2-radio-board.png")
reconstruct_picture(filen_MRB, Shuffled_MRB, L5; view=true)

# # # # # # # # # # # # # # #
# nikos-cat                 #
# # # # # # # # # # # # # # #

Shuffled_NC = joinpath(@__DIR__,"..","..","shredder","shredder-julia","images","shuffled",SHUFFLED[6])
H_NC = held_karp(GRAPHS[6],0.0,10,100000000,0.9)
weigh_NC = cost_graph(H_NC)
tour_NC = data(nodes(H_NC))
filen_NC =joinpath(@__DIR__,"tour","tour_NC.tour")
write_tour(filen_NC, tour_NC, weigh_NC)
L6 = joinpath(@__DIR__, "images_reconstruted","nikos-cat.png")
reconstruct_picture(filen_NC, Shuffled_NC, L6; view=true)


# # # # # # # # # # # # # # #
# pizza-food-wallpaper      #
# # # # # # # # # # # # # # #

Shuffled_PFW = joinpath(@__DIR__,"..","..","shredder","shredder-julia","images","shuffled",SHUFFLED[7])
H_PFW = held_karp(GRAPHS[7],0.0,10,100000000,0.9)
weigh_PFW = cost_graph(H_PFW)
tour_PFW = data(nodes(H_PFW))
filen_PFW =joinpath(@__DIR__,"tour","tour_PFW.tour")
write_tour(filen_PFW, tour_PFW, weigh_PFW)
L7 = joinpath(@__DIR__, "images_reconstruted","pizza-food-wallpaper.png")
reconstruct_picture(filen_PFW, Shuffled_PFW, L7; view=true)


# # # # # # # # # # # # # # #
# the-enchanted-garden      #
# # # # # # # # # # # # # # #

Shuffled_TEG = joinpath(@__DIR__,"..","..","shredder","shredder-julia","images","shuffled",SHUFFLED[8])
H_TEG = held_karp(GRAPHS[8],0.0,10,100000000,0.9)
weigh_TEG = cost_graph(H_TEG)
tour_TEG = data(nodes(H_TEG))
filen_TEG =joinpath(@__DIR__,"tour","tour_TEG.tour")
write_tour(filen_TEG, tour_TEG, weigh_TEG)
L8 = joinpath(@__DIR__, "images_reconstruted","the-enchanted-garden.png")
reconstruct_picture(filen_TEG, Shuffled_TEG, L8; view=true)


# # # # # # # # # # # # # # #
# tokyo-skytree-aerial      #
# # # # # # # # # # # # # # #


Shuffled_TSA = joinpath(@__DIR__,"..","..","shredder","shredder-julia","images","shuffled",SHUFFLED[9])
H_TSA = held_karp(GRAPHS[9],0.0,10,1000000000,0.9)
weigh_TSA = cost_graph(H_TSA)
tour_TSA = data(nodes(H_TSA))
filen_TSA =joinpath(@__DIR__,"tour","tour_TSA.tour")
write_tour(filen_TSA, tour_TSA, weigh_TSA)
L9 = joinpath(@__DIR__, "images_reconstruted","tokyo-skytree-aerial.png")
reconstruct_picture(filen_TSA, Shuffled_TSA, L9; view=true)
