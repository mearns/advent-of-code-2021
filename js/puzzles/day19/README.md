There are 30 scanners, something like 26 points per scanner. There are 435 unordered
pairs of scanners. For each pair of scanners, there are 26*26 = 676 joint-wise pairs of
points that we can try as an alignment point. For each of these alignment points, there are
6 possible relative orientations to try. So far we're up to 435 * 676 * 6 = 1764360
possibilities to try.

No, there are 6 possible directions for the X-axis, and for each of those, there are 4 possible
rotations, and 2 possible flips, making 6 * 4 * 2 = 48 possible orientations (assuming we aren't
limited to the right-hand rule). UPDATE: The instructions specifically say 24 different orientations,
so we'll restricted to the right-hand rule.

For each possibility, we can iterate over each point in the first scanner and check each
against every point in the second scanner, and count the number of matches. If there are
at least 12, it's a match.

Once we know a pair of scanners are a match in a particular orientation, they act like a
super-scanner.

Ok, but we can cut way down on the possible pairs of scanners. If look at every scanner
and for each scanner find every triangle of points, uniquely identify that triangle by
the lengths of its legs, and add them to a multimap using that triangle ID as a key, then
any scanners that have share a key are a possible pair.

We could cut down pairs even more because we know that any overlapping points must be one
of the points in one of the shared triangles.