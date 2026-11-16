# Functions, Procedures and Memoisation (2015)

Imperial College Haskell January Test, 2015, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/functions-procedures-and-memoisation/>

**Difficulty:** \*\*\* (out of three stars)

## About this test (from the website)

The specification for this exercise is quite long, so we gave the students a short document to read in advance on the topic of memoisation.  Part I was rather more difficult than previous ‘Part I’s – in particular the updateVar function takes some time to get right as it doesn’t lend itself to an obvious beautiful solution.  Part II was generally very well answered, as the specification was fairly precise.  Part III spread the class somewhat, as the students had to work out some of the details of procedure interpretation themselves.  Many students got the While and Call cases wrong.  Very few students had time to attempt Part IV and nobody scored 100%.  I don’t think Parts I-III are overly hard compared with previous tests; the main problem here was students running out of time.

Because of the timing problem I capped the maximum mark at 28 and to use any marks gained from Part IV as bonus marks.  The class average was then just over 75%. Nine students out of 163 scored 100% with the capped scheme. The highest gross mark out of 30 was 29, which was achieved by two students.

I have made very few modifications to the original text.  I’ve rated the difficulty as *** because of the scale of the exercise and the fact that Part IV is **very** hard to get right under pressure.

**Remark**: In this type of exercise one has to make several assumptions about the well-formedness and well-typedness of the programs being interpreted/memoised.  Some of these problems can be solved by appealing to Haskell’s GADTs, but these are only covered in the Advanced Programming lectures that accompanies the course, so I couldn’t build them in to the exercise.  There are thus a fair number of assumptions that materialise as either explicit or implicit preconditions, which isn’t entirely satisfactory.  Appropriate semantic analysis would ensure that none of these would be violated, of course.

### More information

There are countless books on compilers and interpreters which cover the sort of issues that arise in this exercise.  A good starting point is Gerald Sussman and Hal Abelson’s [Structure and Interpretation of Computer Programs](https://mitpress.mit.edu/sicp/full-text/book/book.html). The variable binding rules in our little ‘language’ are not a million miles away from those in scripting languages like [Python](https://www.python.org/).

## Files

| Original download | Saved as |
|---|---|
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/memoisation/spec.pdf) | `spec/spec.pdf` |
| [Template File](http://www.doc.ic.ac.uk/~ajf/haskelltests/memoisation/template.hs) | `src/Memoisation.hs` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples and the template's predefined states, functions and executors (`execSumA'`, `execGlobalSumA'`, `execFibM`). `translate` is checked by running `fibMGenerator` in place of `fibM` (fresh variable names may differ, as the spec allows). Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- Added a `module Memoisation where` header (the original template has none) so it can be built as a library module. The only other change is `_` for an unused binding in `translate`, so the given code builds without warnings.
- The spec calls the table manager `fibTableManager`; the template names it `fibManager`. The tests follow the template.
