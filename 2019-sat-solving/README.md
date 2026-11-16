# SAT Solving (2019)

Imperial College Haskell January Test, 2019, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/sat/>

**Difficulty:** \* (out of three stars)

## About this test (from the website)

The focus of this exercise was the Davis–Putnam (DP) algorithm for SAT solving. This is an extremely simple but extraordinarily effective algorithm for turning the NP-complete boolean satisfiability problem into a computationally tractable problem for many practical examples. The exercise is quite closely aligned to the earlier exercise on Binary Decision Diagrams (2009), but the approach is very different. The structure of the DP algorithm also has some similarity to that covered in the constant folding exercise (2018). Students were advised to revise for the test using these two exercises in particular and I think this prepared them well.

The solution to the DP algorithms falls out *beautifully* in Haskell. The final parts of the exercise, in particular, have a number of extremely elegant solutions using list comprehensions and Haskell’s higher-order list processing functions. Some of the more delightful solutions involve multiple passes over the formula in question, but I was not concerned here with efficiency, other that ensuring that the solution has the right asymptotic complexity.

When marking the submissions I decided to revise the original marking scheme, as it was clear that relatively few students had made it through to the end in the time available. I therefore turned the final question, which is essentially a pretty-printer for DP solutions, into a bonus question and moved some marks around to shrink the total from its original 30 to 25. The specification here reflects the revised marking scheme and I think it worked well: the average mark was around 71% and eight students out of 204 achieved the maximum mark of 25. The only other changes I have made are to function names and the name of the DP algorithm itself, which I originally presented as a sub-algorithm of DPLL (see below).

The main problem was the enormous number of submissions that made use of length to check for null and singleton lists. Students are constantly reminded *never* to use length in this way, yet the vast majority did so here. The lecturer clearly has some work to do! If you are reading this and are at all tempted to write, e.g. filter ((==1) . length) to extract unit clauses, please don’t!  A surprising number of students also forgot to invoke toCNF, or rather its helper function, in the arguments to Or.

I was very pleased with Parts III and IV. Students seemed to understand the algorithm, even though some struggled to express it correctly in Haskell in the time available. The last three questions spread the class nicely and yielded some extremely beautiful solutions, in some cases every bit as good as the specimen solution that I had prepared for marking.

Many thanks to Qianyi Shu, who provided me with a Haskell implementation of DPLL. This convinced me that the problem was doable in the time available.

### More information

The exercise focuses on the unit clause elimination algorithm presented in the original paper [1] on the subject. A more detailed treatment of the subject would almost certainly address memory efficiency (not a priority here) and hence also the algorithm presented in [2]. SAT solving, and more recently, SAT Modulo Theories (SMT) solving has been the subject of an enormous amount of subsequent research and it remains a ‘hot’ topic to this day. SMT would make an interesting lab exercise, but it is not well suited to a beginners class.

The presentation in the original papers (below) is somewhat archaic and there are much more succinct explanations of the algorithm in more recent lecture notes and on-line articles. Some of the best of these are actually in relation to DPLL (the core DP algorithm with space optimisation).

[1]  M. Davis, H. Putnam (1960). “A Computing Procedure for Quantification Theory”. Journal of the ACM. 7 (3): 201–215.

[2]  M. Davis, G. Logemann, D. Loveland (1962). “A Machine Program for Theorem Proving”. Communications of the ACM. 5 (7): 394–397.

## Files

| Original download | Saved as |
|---|---|
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/sat/spec.pdf) | `spec/spec.pdf` |
| [Template File](http://www.doc.ic.ac.uk/~ajf/haskelltests/sat/template.hs) | `src/SOL.hs` |
| [Types module](http://www.doc.ic.ac.uk/~ajf/haskelltests/sat/Types.hs) | `src/Types.hs` |
| [Test Data module](http://www.doc.ic.ac.uk/~ajf/haskelltests/sat/TestData.hs) | `src/TestData.hs` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples and `TestData.hs` (`f1..f9` and their CNFs `c1..c9`, `cnf0..cnf4` and their flattened forms). Clause and literal order is ignored where the spec says it's unimportant. Includes the 92-solution 8-queens check. Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- The template declares `module SOL`, so it's saved as `src/SOL.hs`. `TestData.hs` got one type signature (`cnf0Rep`) so it builds without warnings.
