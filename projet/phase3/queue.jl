import Base.length, Base.push!, Base.popfirst!
import Base.show

"""Type abstrait dont d'autres types de files dériveront."""
abstract type AbstractQueue{T} end

"""Type représentant une file avec des éléments de type T."""
mutable struct Queue{T} <: AbstractQueue{T}
    items::Vector{T}
end

Queue{T}() where T = Queue(T[])

"""Ajoute `item` à la fin de la file `s`."""
function push!(q::AbstractQueue{T}, item::T) where T
    push!(q.items, item)
    q
end

"""Retire et renvoie l'objet du début de la file."""
popfirst!(q::AbstractQueue) = popfirst!(q.items)

"""Indique si la file est vide."""
is_empty(q::AbstractQueue) = length(q.items) == 0

"""Donne le nombre d'éléments sur la file."""
length(q::AbstractQueue) = length(q.items)

"""Affiche une file."""
show(q::AbstractQueue) = show(q.items)


"""Éléments de files de priorité"""
abstract type AbstractPriorityItem{T} end

mutable struct PriorityItem{T} <: AbstractPriorityItem{T}
    priority::Real
    data::T
end

function PriorityItem(priority::Real, data::T) where T
    PriorityItem{T}(max(0, priority), data)
end

priority(p::PriorityItem) = p.priority

data(p::PriorityItem) = p.data

function priority!(p::PriorityItem, priority::Real)
    p.priority = max(0, priority)
    p
end

import Base.isless, Base.==

isless(p::PriorityItem, q::PriorityItem) = priority(p) < priority(q)

==(p::PriorityItem, q::PriorityItem) = priority(p) == priority(q)


"""File de priorité."""
mutable struct PriorityQueue{T <: AbstractPriorityItem} <: AbstractQueue{T}
    items::Vector{T}
end

PriorityQueue{T}() where T = PriorityQueue(T[])

"""Retire et renvoie l'élément ayant la plus haute priorité."""
function popfirst!(q::PriorityQueue)
    lowest = q.items[1]
    for item in q.items[2:end]
        if item < lowest
            lowest = item
        end
    end
    idx = findall(x -> x == lowest, q.items)[1]
    deleteat!(q.items, idx)
    lowest
end

import Base.maximum

maximum(q::AbstractQueue) = maximum(q.items)
