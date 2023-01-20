1) True or False: we can prevent the heap being erased during upgrades by using a stable heap.
- False

2) A.call() -> B.call() -> C How much time (or rounds of consensus) do we need to wait for an answer?
- Depends, if A is on a different subnet than b the call will take 2 consensus rounds, otherwise 1. Same for B and C. So best case 2 rounds, worst case 4 rounds otherwise 3 rounds.

3) Is possible to realize an intercanister call in query mode?
- No, at the moment only update calls can be intercanister with query calls planned at a later date