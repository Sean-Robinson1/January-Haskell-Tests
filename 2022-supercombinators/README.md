# Supercombinators (Lambda Lifting) (2022)

Imperial College Haskell January Test, 2022, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/supercombinators/>

**Difficulty:** \*\*\* (out of three stars)

## About this test (from the website)

I’d contemplated setting this problem previously, but shied away from it, as it’s hard to understand why you need to do lambda lilfting in a compiler when you’ve not formally studied compilers and have not been exposed to the concepts of free and bound variables, lambda calculus etc. However, given how well students had coped with previous exercises in the language processing space I decided to try it out. I had originally planned to get the students to write an interepreter for the language, but that requires implementing partial application and that just got too messy.

The students were given a short refresher document on local functions, scope and partial application the day before the test, as these are key to understanding the transformation. I think that helped a lot, but students still found the test hard. Seven out of the 226 students scored full marks, which was amazing, but the average mark was around 66% (below the long-run average) and quite a few students didn’t get to Part III at all.

The specification here is exactly as set, with the exception of a couple of cosmetic changes to the wording.

Note: The problem of determining the optimal set of parameters to lifted functions is hard, so I opted for the dumb solution: if a function *might* need a free variable, then add it regardless before lifting it out. You can do better (see the references below).

### More information

The original paper on lambda lifting [1] details the idea and provides an $O(n^3)$ equation-based algorithm for finding the optimal set of parameters in lifted functions (finding the optimal set is not an issue in this exercise, as we adopt the naive approach). An $O(n^2)$ algorithm was later developed exploiting dominator trees [2].

[1] T. Johnsson (1985) “Lambda lifting: Transforming programs to recursive equations”,

proc. Functional Programming Languages and Computer Architecture, Nancy, 1985, pp. 190–203.

[2] M.T. Morazan & U.P. Schultz, “Optimal Lambda Lifting in Quadratic Time”, proc. 19th International Workshop on the Impementation and Application of Functional Languages (IFL), 2007, Freiburg, Germany, (Revised Selected Papers) pp. 37–56.

## Files

| Original download | Saved as |
|---|---|
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/supercombinators/spec.pdf) | `spec/spec.pdf` |
| [Template File](http://www.doc.ic.ac.uk/~ajf/haskelltests/supercombinators/SC.hs) | `src/SC.hs` |
| [Types module](http://www.doc.ic.ac.uk/~ajf/haskelltests/supercombinators/Types.hs) | `src/Types.hs` |
| [Examples module](http://www.doc.ic.ac.uk/~ajf/haskelltests/supercombinators/Examples.hs) | `src/Examples.hs` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples and `Examples.hs` ("`eN'` is the lambda-lifted version of `eN`"; `e1''` is `e1` after `modifyFunctions`). The spec doesn't fix the order of the lifted supercombinators, so the topmost let bindings are sorted by name before comparison. Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- `Types.hs` and `Examples.hs` got type signatures for the given helpers and example expressions, so they build without warnings.
