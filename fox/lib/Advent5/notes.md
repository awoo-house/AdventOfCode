
A: 52 50 48



B's:
39 0 15
   ---52 50 48---
0 15 37
   ---52 50 48---
37 52 2
   52 50 48

-----------------

IT'S A REDUCTION PROBLEM WHERE THE ACC
STARTS WITH A!


Since there is no overlap with the first two entries,
they simply get copied over (since each ID just passes
through the lookup, if it's unmapped):
  39 0 15
  0 15 37

However, we *do* have overlap here, so we *rewrite* the
B entry we're looking at in terms of A. But then we
need to change the range and start of A so that it doesn't
overlap the freshly generated whatever
  37 50 2
  54 52 46

We can stop reduction if the acc's range <= 0.

-----------------

   98 99
   50 51




Cases:

      1) -------
                -----

      2) -------
            -----

      3) -------
           -----

      4)   -------
         -----