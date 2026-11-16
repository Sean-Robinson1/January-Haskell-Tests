# Decision Trees (2017)

Imperial College Haskell January Test, 2017, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/decision-trees/>

**Difficulty:** \*\* (out of three stars)

## About this test (from the website)

This is based on the data set from Ross Quinlan’s famous paper: *J. R. Quinlan. Induction **of decision trees. Mach. Learn., 1(1):81–106, March **1986* which is the archetypal example used by many articles on the subject. I spent some time trying to construct a ‘better’ data set that shows off the key principles of  decision trees without being over-long, and quickly gave up – the data set in the paper is very cleverly constructed! In the end I did nothing more than tweak some of the names.

The Haskell solution we develop here isn’t entirely satisfactory because the items in the source data set have to be of the same type – strings being the obvious choice. The only way round this would be to use heterogeneous lists, but this requires type-level reasoning which is not covered in this introductory course.

I have made very few modifications to the original text. When marking the scripts I decided to move two marks from later questions to the earlier ones and the version here reflects that scheme.

This exercise presents a nice opportunity for students to show off their ability to use Haskell’s higher-order list processing functions and list comprehensions and there were many beautiful solutions, including a one-liner for partitionData using nested comprehensions that I hadn’t spotted! Four students out of 172 scored full marks with many more in the high 20s. This is definitely ‘doable’ in three hours, so I’ve rated the difficulty **. The average mark was a little over 70%.

### More information

Aside from Quinlan’s excellent paper, there are countless articles and tutorials on decision trees, many of which, as here, use the original data set from the paper. A Google search will also reveal a number of Haskell implementations, some of which are similar in many respects to the version developed here.

## Files

| Original download | Saved as |
|---|---|
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/decisiontrees/spec.pdf) | `spec/spec.pdf` |
| [Template File](http://www.doc.ic.ac.uk/~ajf/haskelltests/decisiontrees/template.hs) | `src/DecisionTrees.hs` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples and the template's `fishingData`, `fishingData'`, `fig1`, `fig2` and `outlookPartition`. Doubles are compared to within 1e-9. Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- Added a `module DecisionTrees where` header (the original template has none) so it can be built as a library module; the rest of the file is unchanged apart from layout.
