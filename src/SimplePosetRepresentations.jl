module SimplePosetRepresentations

# Nothing here yet. We'll do IntervalOrder, SemiOrder, CircleOrder

using SimplePosets, ClosedIntervals

import Base.show
export IntervalOrder, SemiOrder, Circle, inside

export poset_builder


### GENERAL MACHINERY

function poset_builder{S,T}(Xdict::Dict{S,T}, comparator::Function)
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

function poset_builder{S}(Xlist::Vector{S}, comparator::Function)
  d = Dict{Int,S}()
  n = length(Xlist)
  for i=1:n
    d[i] = Xlist[i]
  end
  return poset_builder(d,comparator)
end

function poset_builder{S}(Xset::Set{S}, comparator::Function)
  d = Dict{S,S}()
  for s in Xset
    d[s] = s
  end
  return poset_builder(d,comparator)
end


### INTERVAL ORDERS

_interval_compare{S}(I::ClosedInterval{S}, J::ClosedInterval{S}) = I << J

"""
`IntervalOrder(Jmap)` creates an interval order from a dictionary
mapping elements to closed intervals.
"""
function IntervalOrder{S,T}(Jmap::Dict{S,ClosedInterval{T}})
  return poset_builder(Jmap,_interval_compare)
end

"""
`IntervalOrder(Jlist)` creates an interval order from a list of
intervals. The elements of the poset are named `1:n` where `n`
is the length of the `Jlist`.
"""
function IntervalOrder{T}(Jlist::Vector{ClosedInterval{T}})
  return poset_builder(Jlist,_interval_compare)
end

"""
`IntervalOrder(Jset)` creates an interval order from a set of
closed intervals. The elements of the poset are the intervals.
"""
function IntervalOrder{T}(Jset::Set{ClosedInterval{T}})
  return poset_builder(Jset,_interval_compare)
end


### SEMIORDERS

"""
`SemiOrder(Xmap)` creates a semiorder whose elements are the
keys in the dictionary `Xmap`. We have `a<b` provided
`Xmap[a]+1 < Xmap[b]`.
"""
function SemiOrder{S,T<:Real}(Xmap::Dict{S,T})
  xvals = collect(keys(Xmap))
  n = length(xvals)
  P = SimplePoset{S}()

  for x in xvals
    add!(P,x)
  end

  for i=1:n
    a = xvals[i]
    x = Xmap[a]
    for j=1:n
      if i==j
        continue
      end
      b = xvals[j]
      y = Xmap[b]
      if x+1 < y
        add!(P,a,b)
      end
    end
  end
  return P
end

"""
`SemiOrder(Xlist)` creates a semiorder from a list of real numbers.
The elements are `1:n` and we have `a<b` provided `Xlist[a]+1 < Xlist[b]`.
"""
function SemiOrder{T<:Real}(Xlist::Vector{T})
  n = length(Xlist)
  d = Dict{Int,T}()
  for k=1:n
    d[k] = Xlist[k]
  end
  return SemiOrder(d)
end

"""
`SemiOrder(Xset)` creates a semiorder from a set of real numbers.
The elements of the poset are the elements of `Xset`. For two elements
`a` and `b` we have `a<b` in the poset iff `a+1 < b` as real numbers.
"""
function SemiOrder{T<:Real}(Xset::Set{T})
  d = Dict{T,T}()
  for x in Xset
    d[x] = x
  end
  return SemiOrder(d)
end

SemiOrder(Xset::IntSet) = SemiOrder(Set(Xset))


### CIRCLE ORDERS
"""
The `Circle` datatype represents a circle in the
plane specified by a center and a radius like this:
`Circle(x,y,r)`.
"""
immutable Circle{X<:Real, Y<:Real, R<:Real}
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




end  # end of module
