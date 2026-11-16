# Graph Colouring and Register Allocation (2021)

Imperial College Haskell January Test, 2021, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/colouring/>

**Difficulty:** \*\* (out of three stars)

## About this test (from the website)

A complete treatment of the graph colouring approach to register allocation involves a pipeline of analysis and code transformations that goes well beyond what can routinely be achieved in a three-hour test. After much deliberation I decided to focus on the core problems of interference graph construction, graph colouring and variable renaming, but sidestepping the issue of register spilling altogether in order to simplify the problem. The last two elements of the pipeline, construction of the control flow graph (CFG) of a program and live variable analysis of the CFG, were left as extensions. As it happens this worked really well, as the core problems were completely doable in the time available. Out of  around 240 submissions the vast majority of students attempted all the questions, with around 20 trying out the extensions. One student produced a solution to both extension questions in the 3 hours, even catching quite a few of the messy edge cases in CFG construction.

The test seemed rather easier than I was expecting, but this is likely due to the similarity of the core data structures with those used in the constant propagation exercise (2018), which I picked out as a revision exercise; so there were lots of hints. The specification here is exactly the one published for the test, with the exception of two explicit preconditions that were (mostly) assumed by students, but which were missing from the original. The average mark was around 71%.

Note: The CFG construction question turns out to be ripe fodder for ‘knot tying’, which facilitates a one-pass solution to the instruction labelling problem using lazy evaluation when two would normally be required. If you have time on your hands you might to try coding this up.

### More information

The graph colouring approach to register allocation was first proposed in [1] and this includes a very elegant recursive formulation of the core colouring algorithm. The colouring algorithm, with and without spilling, falls out beautifully when formulated recursively, so it is perhaps rather surprising that most lecture notes on the topic choose to describe its operation with an explicit recursion stack, some even with redundant testing of the register (colour) count. A mess!

For further reading, there are many excellent notes available online. I particularly recommend those produced by Tim Jones: https://www.cl.cam.ac.uk/teaching/1718/OptComp/.

[1] G.J. Chaitin, M.A. Auslander, A.K. Chandra, J. Cocke, M.E. Hopkins, , P.W.  Markstein (1981). “Register allocation via coloring”. Computer Languages. 6 (1): 47–57.

## Files

| Original download | Saved as |
|---|---|
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/colouring/spec.pdf) | `spec/spec.pdf` |
| [Template File](http://www.doc.ic.ac.uk/~ajf/haskelltests/colouring/Alloc.hs) | `src/Alloc.hs` |
| [Types module](http://www.doc.ic.ac.uk/~ajf/haskelltests/colouring/Types.hs) | `src/Types.hs` |
| [Examples module](http://www.doc.ic.ac.uk/~ajf/haskelltests/colouring/Examples.hs) | `src/Examples.hs` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples and `Examples.hs` (`fact` and `fig3` with their IGs, colourings, IdMaps, transformed versions, live variable sets and CFGs). `sortGraph` and `sortCFG` from `Types` are used where order is unimportant. Part V (no marks) is tested via the spec's `liveVars`/`buildCFG` properties. Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- `Types.hs` and `Examples.hs` got type signatures for the given helpers and example data, so they build without warnings.
