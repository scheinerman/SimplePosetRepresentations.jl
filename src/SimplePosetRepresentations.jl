module SimplePosetRepresentations

# Nothing here yet. We'll do IntervalOrder, SemiOrder, CircleOrder

using SimplePosets, ClosedIntervals

import Base.show
export IntervalOrder, SemiOrder
export Circle, inside, CircleOrder

export poset_builder


### GENERAL MACHINERY

function poset_builder(Xdict::Dict{S,T}, comparator::Function) where {S,T}
  P = SimplePoset{S}()
  for v in keys(Xdict)
    add!(P,v)
  end
  elts = collect(keys(Xdict))
  n = length(elts)
  for i=1:n
    a = elts[i]
    u = Xdict[a]
    for j=1:n
      b = elts[j]
      v = Xdict[b]
      if i!=j && comparator(u,v)
        add!(P,a,b)
      end
    end
  end
  return P
end

function poset_builder(Xlist::Vector{S}, comparator::Function) where S
  d = Dict{Int,S}()
  n = length(Xlist)
  for i=1:n
    d[i] = Xlist[i]
  end
  return poset_builder(d,comparator)
end

function poset_builder(Xset::Set{S}, comparator::Function) where S
  d = Dict{S,S}()
  for s in Xset
    d[s] = s
  end
  return poset_builder(d,comparator)
end


### INTERVAL ORDERS

_interval_compare(I::ClosedInterval{S}, J::ClosedInterval{S}) where S = I << J

"""
`IntervalOrder(Jmap)` creates an interval order from a dictionary
mapping elements to closed intervals.
"""
function IntervalOrder(Jmap::Dict{S,ClosedInterval{T}}) where {S,T}
  return poset_builder(Jmap,_interval_compare)
end

"""
`IntervalOrder(Jlist)` creates an interval order from a list of
intervals. The elements of the poset are named `1:n` where `n`
is the length of the `Jlist`.
"""
function IntervalOrder(Jlist::Vector{ClosedInterval{T}}) where T
  return poset_builder(Jlist,_interval_compare)
end

"""
`IntervalOrder(Jset)` creates an interval order from a set of
closed intervals. The elements of the poset are the intervals.
"""
function IntervalOrder(Jset::Set{ClosedInterval{T}}) where T
  return poset_builder(Jset,_interval_compare)
end


### SEMIORDERS

_unit_compare(x::Real,y::Real) = x+1 < y

"""
`SemiOrder(Xmap)` creates a semiorder whose elements are the
keys in the dictionary `Xmap`. We have `a<b` provided
`Xmap[a]+1 < Xmap[b]`.
"""
function SemiOrder(Xmap::Dict{S,T}) where {S,T<:Real}
  return poset_builder(Xmap, _unit_compare)
end

"""
`SemiOrder(Xlist)` creates a semiorder from a list of real numbers.
The elements are `1:n` and we have `a<b` provided `Xlist[a]+1 < Xlist[b]`.
"""
function SemiOrder(Xlist::Vector{T}) where {T<:Real}
  return poset_builder(Xlist, _unit_compare)
end

"""
`SemiOrder(Xset)` creates a semiorder from a set of real numbers.
The elements of the poset are the elements of `Xset`. For two elements
`a` and `b` we have `a<b` in the poset iff `a+1 < b` as real numbers.
"""
function SemiOrder(Xset::Set{T}) where {T<:Real}
  return poset_builder(Xset,_unit_compare)
end

SemiOrder(Xset::BitSet) = SemiOrder(Set(Xset))


### CIRCLE ORDERS
"""
The `Circle` datatype represents a circle in the
plane specified by a center and a radius like this:
`Circle(x,y,r)`.
"""
struct Circle{X<:Real, Y<:Real, R<:Real}
  x::X     # x-coordinate of center
  y::Y     # y-coordinate of center
  r::R     # radius
end

function show(io::IO, C::Circle)
  print(io, "Circle($(C.x), $(C.y), $(C.r))")
end

"""
`inside(C,D)` returns `true` provided circle `C`
is entirely contained inside circle `D`.
"""
function inside(C::Circle, D::Circle)
  dx = C.x - D.x
  dy = C.y - D.y
  dr = C.r - D.r
  return (dr<=0)&&(dx*dx + dy*dy <= dr*dr)
end

function CircleOrder(Cmap::Dict{S,Circle}) where S
  return poset_builder(Cmap,inside)
end

function CircleOrder(Clist::Vector{Circle})
  return poset_builder(Clist,inside)
end

function CircleOrder(Cset::Set{Circle})
  return poset_builder(Cset,inside)
end



end  # end of module
