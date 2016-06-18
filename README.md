# Simple Poset Representations

Interval orders, and the like.

## Interval orders

An *interval order* is a partially ordered set whose vertices
correspond to closed intervals. We have the relation `a<b` exactly when
the interval assigned to `a` is entirely to the left of the interval
assigned to `b`.

The `IntervalOrder` function creates a new interval order given
a collection of closed intervals in one of the following ways:
+ As a dictionary mapping element names to intervals.
+ As a list (one-dimensional array) of intervals. In this case,
the elements are named `1:n` where `n` is the length of the list.
+ As a set of intervals. In this case the intervals themselves
are the elements.

## Semiorders

## Circle orders
