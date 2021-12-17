# Day 15

** SPOILERS **

## Part 1

We're going from point `(0, 0)` to point `(C, R)`. The most direct a path can be (because we can't go
diaganolly) is to always move forward in one of the two dimensions. There are many such paths,
but they all involve `R + C` moves. So the cheapest possible path is a direct path where every cell
is a 1, which has a cost of `R + C`. The most expensive a direct path could possibly be is if every
cell along the way is a 9, which would have a total cost of `9 * (R + C)`.

Note we can _always_ make a longer more expensive path, but we also know that we _can_ make the trip
without spending more than `9 * (R + C)`: this is the _worst case cheapest path_. We also know that we
can't possibly make the trip for less than `R + C`: this is the _best case cheapest path_.

It's important to note that the cheapest path isn't necessarily a direct path. E.g.:

```
S1155
99155
11199
19999
1111E
```

Here, the that is all `1's` is the cheapest with a cost of 11, but it is not direct: it moves backward.

So a totally brute force approach would enumerate every possible path and find the cheapest. But there are
an inifinite number of paths. We can start by elliminating any paths that revisit the same cell twice, because
that means there's a loop in the path that doesn't do anything but add cost. That gives us a finite, but still
very large number of possible paths.

For a grid W columns by H rows, we know the worst case cost will be `9 * (W + H)`, so we can elliminate any
path as soon as it costs more than that.

For any given partial path, it will have a _concrete_ cost `K`, and it will lead us from start to a certain point
`(W - X, H - Y)`. From that point, there are a number of possible descendant paths that will complete a path to the end. This set of descendant paths will have a worst case cost of `9 * (Y + X)`, and a best case cost of `Y + X`. Adding in
the concrete cost we know for the partial path, we know that the best case cost for completing this path is
`K + Y + X`, and the worst case is `K + 9(Y + X)`.

When considering a set of partial paths, we can consider the best case and worst case cost for the entire set.
The best case cost for the entire set is the minimum best case cost of any path in the set, and the worst case
cost is _also the minimum_ of the worst case cost of any path in the set (note that it isn't necessarily the same
path that has the best case and worst case cost for the set). Any path in the set whose individual best case cost
is greater than the worst case cost for the set can be elliminated because there's no way it will give us the 
cheapest full path.

A partial path can be extended by stepping to any of its neighbors (at most 4 neighbors, depending on the location
in the grid). As we do this, we're necessarily increasing the concrete cost compared to the parent path, but we will,
in general be narrowing down the cost window compared to the parent path. Specifically, the best case cost will
increase monotonically (either increase or stay the same) and the worst case cost will decrease monotonically
(either descrease or stay the same).

More to the point, extending a partial path refines our knowledge of the possible costs of following that part.
If we consider the set of all child paths, the best case cost of that set may be greater than that of the parent
path, but that does not imply that it may still be possible to find the lower cost path from the parent path as
that scenario was based on incomplete knowledge which we have now refined. In other words, the exhaustive set of
child paths from a partial path _replace_ the parent path in terms of our options.

So...we are building a set of partial paths to get us from start to end. We start this set with a partial path
beginning at `(0,0)` (the start). It has a concrete cost of 0, a best case cost of `W + H` and a worse case cost
of `9(W + H)`. 

We can define the following operations on this set:

- `prune()` - Remove any paths whose best case cost is greater than the set's worst case cost.
- `add(P)` Adds path `P` to the set. Recompute the best case and worst case cost of the entire set, then prune it.

But there's a short cut here for computing the new costs: the new best case cost of the set is the minimum of
the current best case cost of the set and the best case cost of `P`. Likewise, the new worst case cost of the
set is the minimum of the current worst case cost and the worst case cost of `P`. Since the pruning operation
is only removing paths whose costs are all higher than the worst case cost of the set, removing
them will not impact the costs of the set, so it does not need to be recomputed.

An additional optimization for `add` is to check `P` before adding it to the set: if it's best case is greater than
the set's current worst case, you can just skip the remainder of the operation, which would otherwise add and then
prune the path `P`.

We extend the set by taking each partial path in the set and _replacing it_ with the partial paths we get by
extending it to each neighbor of its last cell, less any partial paths which intersect themselves. It's important
to note that we can't simply add the new paths then prune the set, because what we're saying
is that the old best and worst case costs of the set were based on limited knowledge, and we're now improving
that knowledge. In particular, since the new extended paths will typically have a more narrow window than the parent
path they're replacing, we want to recompute the window for the set based on that, not using the same arithematic
as a simple addition.

However, it should be sufficient to remove the old path from the set, and add the new paths using the `add` operation.

So that's what we do. We start with a set containing only the partial path that sits at the starting point and we repeat:
for every partial path `P` in the set, remove `P` from the set, and create up to four new partial paths by extending
`P` to each of it's neighbors. Remove any of these new paths that intersects itself, then add them to the set.

A partial path is a completed path when it reaches the end position. At this point, it's best case and worst case costs
are moot, the only thing that matters is its concrete cost, which is the actual cost of following that path from beginning
to end (to maintain the interface, we say that the best case cost and worst case cost of a completed path are identical to
its concrete cost). There's no need to extend a completed path, and we stop repeating when the set contains only completed paths.
Note that the prune operation does in fact remove completed paths if there concrete cost (and therefore there best case cost) are
greater than the set's worst case cost.

Once the set is thus filled, the selected path is the one with the lowest concrete cost.