# Constant Propagation (SSA) (2018)

Imperial College Haskell January Test, 2018, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/ssa/>

**Difficulty:** \*\* (out of three stars)

## About this test (from the website)

I was keen on the idea of an exercise that was about building one program from another and settled on this, as the core algorithm (constant propagation) is succinct and elegant and is certainly doable in the time.

This test is quite similar in nature to the 2015 test, so students who did their homework had a leg-up, particularly in Part I. The first two questions in Part II are also quite straightforward, but then it gets harder and this is where most students got stuck. I originally thought that Part III might be a little simpler than Part II, but it’s actually very easy to forget a crucial call to unPhi among the various refactorings. Very few students got this right, so I came to the conclusion that both the order and balance of credit were about right.

Note that the substitution algorithm hinted at in Part II leads to a much more elegant solution than the traditional ‘worklist’ algorithm; you also only need one pass over a block for each new set of constant assignments uncovered. However, all but two students opted for the ‘textbook’ approach based on work lists.

I had originally considered including copy propagation, which involves a tiny change to the code and specification for Part II. However, it leads to some unpleasant edge cases when phi functions are removed in Part III. It’s all fixable, but I decided to keep it simple. I also contemplated conditional propagation, as you can then remove dead code, but I had to be mindful of the fact that this is a first-year Haskell programming exercise, and not an exercise on compiler technology, so I dropped that too – they will see this in due course.

Part IV is included only for completeness and I did not expect anyone to work out the details of how to plant phi functions. However, the variable renaming and expression simplification problems are actually quite doable at this level. Two students made a decent start before running out of time.

This was an easy test to pass, especially as we had covered the 2015 test as a revision exercise. However, Part II requires some quite careful thought in order to understand the logic required and arrive at a beautiful solution. I’ve rated it ** because it’s easy to get stuck in Part II and most students did!

The maximum mark was 30. There were lots of 29s and 28s and there were some beautiful solutions to individual questions, some of which inspired me to revisit my own specimen solution. However, nobody seemed to find a beautiful solution to all the questions, so no one got full marks. The average mark was around 70%.

### More information

There is an extremely extensive literature on SSA-based optimisation going back to the original paper: Rosen, B. K., Wegman, M. N. and Zadeck, F. K., Global Value Numbers and Redundant Computations, Proc. ACM POPL, 1988, pp. 12-27.

There are a great many online sources on SSA and related optimisations, many of them being lecture notes on compiler technology. Any search engine will do a good job of uncovering them.

## Files

| Original download | Saved as |
|---|---|
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/ssa/spec.pdf) | `spec/spec.pdf` |
| [Template File](http://www.doc.ic.ac.uk/~ajf/haskelltests/ssa/template.hs) | `src/SSA.hs` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples and the template's example functions, which follow the naming convention `fun` / `funSSA` / `funSSAPropagated` / `funOptimised`. States are compared ignoring order. Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- Added a `module SSA where` header (the original template has none) so it can be built as a library module. The only other change is type signatures for the given pretty-printing helpers, so they build without warnings.
- Part IV (`makeSSA`, no credit) has no tests, because the spec gives no expected output for it.
