here = @__DIR__
include("new_function.jl")
include("rsl.jl")
include("prim_New.jl")
include(joinpath(here,"..","phase3","read_graph.jl"))
include("onetree.jl")
include("held_karp.jl")

using Statistics
using Printf
using Test

# List of stsp instances
const STSP_DIR = joinpath(@__DIR__,"..","..","instances", "stsp")
const STSP = readdir(STSP_DIR)
const GRAPHS = [read_graph_stsp(joinpath(STSP_DIR, finst)) for finst in STSP
               if read_header(joinpath(STSP_DIR, finst))["DISPLAY_DATA_TYPE"]!="None"]

list_resultat = []
for i in [2]
    G = held_karp(GRAPHS[i], nodes(GRAPHS[i])[1], 2, 10000)
    push!(list_resultat, G)
    plot_graph(G)
end
