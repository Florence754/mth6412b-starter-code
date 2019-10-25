include(joinpath(@__DIR__, "..", "phase2", "kruskal.jl"))
include(joinpath(@__DIR__,"kruskal_rank.jl"))
include(joinpath(@__DIR__,"kruskal_compression.jl"))
include(joinpath(@__DIR__,"prim.jl"))
include(joinpath(@__DIR__,"read_graph.jl"))


using Statistics
using Printf

#include(joinpath(@__DIR__,"projet", "phase2", "main.jl"))

# List of stsp instances
const STSP_DIR = joinpath(@__DIR__,"..","..","instances", "stsp")
const STSP = readdir(STSP_DIR)
const GRAPHS = [read_graph_stsp(joinpath(STSP_DIR, finst)) for finst in STSP]

"""
    run_kruskal(graphs)

Run Kruskal's algorithm on each graph `g ∈ graphs`.
"""
function run_kruskal(graphs)
    for g in graphs
        mst = kruskal(g)
    end
    return nothing
end

"""
    run_kruskal(graphs)

Run Kruskal's algorithm on each graph `g ∈ graphs`.
"""
function run_kruskalRank(graphs)
    for g in graphs
        mst = kruskal_rank(g)
    end
    return nothing
end

"""
    run_kruskal(graphs)

Run Kruskal's algorithm on each graph `g ∈ graphs`.
"""
function run_kruskalComp(graphs)
    for g in graphs
        mst = kruskal_compression(g)
    end
    return nothing
end

"""
    run_Prim(graphs)

Run Prim's algorithm on each graph `g ∈ graphs`.
"""
function run_Prim(graphs)
    for g in graphs
        mst = prim(g)
    end
    return nothing
end

# Kruskal
run_kruskal(GRAPHS)

# Second round
# Here we record times
N = 16  # Number of runs. Higher yields more accurate results
T = Float64[]
for i in 1:N
    t = @elapsed run_kruskal(GRAPHS)
    push!(T, t)
end

μ = mean(T)  # mean
σ = std(T)   # standard deviation

println("Resultat Kruskal:")
# Print results
@printf "Total time: %8.4f\n" sum(T)
@printf "Min   time: %8.4f\n" minimum(T)
@printf "CI-lo time: %8.4f\n" μ - (2.0 / sqrt(N)) * σ
@printf "Mean  time: %8.4f\n" μ
@printf "CI-up time: %8.4f\n" μ + (2.0 / sqrt(N)) * σ
@printf "Max   time: %8.4f\n" maximum(T)

#Kruskal rank
run_kruskalRank(GRAPHS)

# Second round
# Here we record times
N = 16  # Number of runs. Higher yields more accurate results
T = Float64[]
for i in 1:N
    t = @elapsed run_kruskalRank(GRAPHS)
    push!(T, t)
end

μ = mean(T)  # mean
σ = std(T)   # standard deviation

println("Resultat Kruskal avec rank union:")
# Print results
@printf "Total time: %8.4f\n" sum(T)
@printf "Min   time: %8.4f\n" minimum(T)
@printf "CI-lo time: %8.4f\n" μ - (2.0 / sqrt(N)) * σ
@printf "Mean  time: %8.4f\n" μ
@printf "CI-up time: %8.4f\n" μ + (2.0 / sqrt(N)) * σ
@printf "Max   time: %8.4f\n" maximum(T)


# Kruskal compression

run_kruskalComp(GRAPHS)

# Second round
# Here we record times
N = 16  # Number of runs. Higher yields more accurate results
T = Float64[]
for i in 1:N
    t = @elapsed run_kruskalComp(GRAPHS)
    push!(T, t)
end

μ = mean(T)  # mean
σ = std(T)   # standard deviation

println( "Resultat Kruskal avec compression union:")
# Print results
@printf "Total time: %8.4f\n" sum(T)
@printf "Min   time: %8.4f\n" minimum(T)
@printf "CI-lo time: %8.4f\n" μ - (2.0 / sqrt(N)) * σ
@printf "Mean  time: %8.4f\n" μ
@printf "CI-up time: %8.4f\n" μ + (2.0 / sqrt(N)) * σ
@printf "Max   time: %8.4f\n" maximum(T)

# Prim
run_Prim(GRAPHS)

# Second round
# Here we record times
N = 16  # Number of runs. Higher yields more accurate results
T = Float64[]
for i in 1:N
    t = @elapsed run_Prim(GRAPHS)
    push!(T, t)
end

μ = mean(T)  # mean
σ = std(T)   # standard deviation

println( "Resultat Prim:")
# Print results
@printf "Total time: %8.4f\n" sum(T)
@printf "Min   time: %8.4f\n" minimum(T)
@printf "CI-lo time: %8.4f\n" μ - (2.0 / sqrt(N)) * σ
@printf "Mean  time: %8.4f\n" μ
@printf "CI-up time: %8.4f\n" μ + (2.0 / sqrt(N)) * σ
@printf "Max   time: %8.4f\n" maximum(T)
