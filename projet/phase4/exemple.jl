here = @__DIR__
include("new_function.jl")
include("rsl.jl")
include("prim_New.jl")
include(joinpath(here,"..","phase3","read_graph.jl"))
include("onetree.jl")
include("held_karp.jl")
include("gap.jl")
include("pre_order.jl")


using Statistics
using Printf
using Test

# List of stsp instances
const STSP_DIR = joinpath(@__DIR__,"..","..","instances", "stsp")
const STSP = readdir(STSP_DIR)
const GRAPHS = [read_graph_stsp(joinpath(STSP_DIR, finst)) for finst in STSP]

# bayg29.tsp

G1 = held_karp(GRAPHS[1], 0.0, 1000, 10000, 0.5)
G1_rsl =rsl(GRAPHS[1])
cost_graph(G1)
cost_graph(G1_rsl[1])
plot_graph(G1)


# brazil58.tsp
G2 = held_karp(GRAPHS[3], 0.0, 1000, 10000, 0.5)
cost_graph(G2)
G2_rsl =rsl(GRAPHS[3])
cost_graph(G2_rsl[3])

# gr21.tsp
G3 = held_karp(GRAPHS[8], 0.0, 1000, 10000, 0.7)
cost_graph(G3)
G3_rsl =rsl(GRAPHS[1])
cost_graph(G3_rsl[1])
