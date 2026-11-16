# Symbolic Integration (2024)

Imperial College Haskell January Test, 2024, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/integration/>

**Difficulty:** \* (out of three stars)

## About this test (from the website)

This exercise can be seen as a natural extension to one of the students’ weekly Haskell programming exercises, which focuses on symbolic differentiation. Symbolic integration is much harder, of course, because there is no equivalent of the chain rule, which results in a neat `compositional’ algorithm for differentiating arbitrary mathematical functions.

I had originally planned a more involved exercise involving pattern matching over pre-determined integration rules, the implementation of integration by parts, and so on. However, quite a lot of aparatus is needed to implement even a basic integration engine, so these more ambitious objectives, which quickly become messy, were eventually pruned out in order for the problem to fit the 3hr schedule.

Part II is little more than extension of one of the functions the students had seen in their lab exercise and most students scored full marks as a result. When grading the submissions I wanted to reduce the weighting of this question to better align the marks with previous years, but I was eventually persuaded not to in the interest of `fairness’.

It is relatively easy to write code that passes the basic tests for Part III, but it is rather harder to write *beautiful* code for so doing. The final sting in the tail is that the implementation of the inverse chain rule requires constant factors to be pulled out of the integral before applying the rule; determining the required factor for a given integral is non-trivial and this is where most students got stuck. Given the relatively easly nature of Parts I and II, the marking scheme was very strict for Part III and this made it very difficult to score more than 7/10. 

The specification here is the one originally set, modulo the correction of a couple of typos. The mark distribution was a perfect right-biased single `hump’, with a mean mark of around 75%. Nobody managed full marks, but there were six students who scored 29/30.

Overall, I’ve graded the difficulty 1-star, given the relative simplicity of Part I and the essentially `free’ marks allocated to Part II. The mark average also suggests that this was one of the easier problems so far.

### More information

Symbolic (automatic) differentiation in Haskell is the topic of Conal Elliott’s paper “Beautiful Differentiation” [1]. Students undertaking the weekly exercise on symbolic differentiation end up reproducing much of the material in that paper; the exercise also exploits Haskell’s type classes, which are an essential ingredient of the paper.

An algorithm for symbolic integration of elementary functions was first detailed in [2]. A mostly-complete implementation of Risch’s algorithm was produced by Manuel Bronstein and documented in [3].

[1] Conal M. Elliott (2009.) Beautiful differentiation. SIGPLAN Not. 44, 9 (September 2009), 191–202. https://doi.org/10.1145/1631687.1596579

[2] Risch, R. H. (1969). The Problem of Integration in Finite Terms. *Transactions of the American Mathematical Society*, *139*, 167–189. https://doi.org/10.2307/1995313

[3] Manuel Bronstein (1990). Integration of elementary functions. Journal of Symbolic Computation,
Volume 9, Issue 2, 117-173. https://doi.org/10.1016/S0747-7171(08)80027-2.

## Files

| Original download | Saved as |
|---|---|
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/integration/spec.pdf) | `spec/spec.pdf` |
| [Types module](http://www.doc.ic.ac.uk/~ajf/haskelltests/integration/Types.hs) | `src/Types.hs` |
| [Examples](http://www.doc.ic.ac.uk/~ajf/haskelltests/integration/Examples.hs) | `src/Examples.hs` |
| [Utilities](http://www.doc.ic.ac.uk/~ajf/haskelltests/integration/Utilities.hs) | `src/Utilities.hs` |
| Int.hs (not linked from the page; from the server folder) | `src/Int.hs` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples. Results are compared as pretty-printed strings, because that is how the spec shows them. As the spec warns, `simplify` doesn't produce a unique normal form, so a mathematically correct answer may occasionally print differently. Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- `Utilities.hs` got a type signature for `crs` and an unreachable `[]` case in `collapse`, so it builds without warnings.
- The template `src/Int.hs` is unchanged. The page doesn't link it, but it is in the test's folder on the server: <http://www.doc.ic.ac.uk/~ajf/haskelltests/integration/Int.hs>.
- The original test suite used in the exam (the spec mentions given tests) isn't published either.
