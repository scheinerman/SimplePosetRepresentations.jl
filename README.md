# Simple Poset Representations

Interval orders, and the like.

## Interval orders

An *interval order* is a partially ordered set whose elements
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

A *semiorder* is a type of interval order in which
all of the intervals have length 1. Thus, the representation
may be specified by giving only the left end points of
the intervals.

In other words, if `a` and `b` are elements of the poset
with assigned values `x` and `y`, respectively, we have
`a<b` exactly when `x+1 < y`.

The `SemiOrder` function creates a new semiorder given
a collection of real numbers as follows:
+ As a dictionary mapping element names to real numbers.
+ As a list (one-dimensional array) of real numbers.
+ As a set of real numbers.






## Circle orders
