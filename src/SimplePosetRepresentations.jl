module SimplePosetRepresentations

# Nothing here yet. We'll do IntervalOrder, SemiOrder, CircleOrder

using SimplePosets, ClosedIntervals

export IntervalOrder

"""
`IntervalOrder(Jmap)` creates an inteval order from a dictionary
mapping elements to closed intervals.
"""
function IntervalOrder{S,T}(Jmap::Dict{S,ClosedInterval{T}})
  P = SimplePoset{S}()
  for v in keys(Jmap)
    add!(P,v)
  end
  verts = elements(P)
  n = length(verts)
  for i=1:n-1
    u = verts[i]
    I = Jmap[u]
    for j=i+1:n
      v = verts[j]
      J = Jmap[v]
      if I << J
        add!(P,u,v)
      end
    end
  end
  return P
end


"""
`IntervalOrder(Jlist)` creates an interval order from a list of
intervals. The elements of the poset are named `1:n` where `n`
is the length of the `Jlist`.
"""
function IntervalOrder{T}(Jlist::Vector{ClosedInterval{T}})
  d = Dict{Int,ClosedInterval{T}}()
  n = length(Jlist)
  for k=1:n
    d[k] = Jlist[k]
  end
  return IntervalOrder(d)
end


"""
`IntervalOrder(Jset)` creates an interval order from a set of
closed intervals. The elements of the poset are the intervals.
"""
function IntervalOrder{T}(Jset::Set{ClosedInterval{T}})
  Jtype = ClosedInterval{T}
  d = Dict{Jtype,Jtype}()
  for J in Jset
    d[J] = J
  end
  return IntervalOrder(d)
end


end  # end of module
