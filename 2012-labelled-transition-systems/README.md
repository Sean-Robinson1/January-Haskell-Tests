# Labelled Transition Systems (2012)

Imperial College Haskell January Test, 2012, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/labelled-transition-systems/>

**Difficulty:** \*\*\* (out of three stars)

## About this test (from the website)

The specification for this test may look frighteningly long, but the students were given a short introductory document the night before the test.  This definitely helped.  A substantial number of students got most of the way through Part IV, with nine out of 139 student scoring full marks.  I decided to allocate 32 marks, capped down to 30, because I was worried that the test was too long.  In hindsight there was no need for this, as the average mark was around 78%.

You will notice the ‘mystery’ Part V, which I decided to include because we had had so much fun working it out ourselves when designing the test!  We had no expectation that any student was going to get that far, but one did come perilously close to completing it within the three hours.

I have made only one significant modification to the original version of the test, in order to fix an edge case in the construction of the cartesian product required in Part IV.

### More information

There really is only one useful source of additional information, which is the text book upon which the test was based: *[Concurrency – state models and Java programs (2. ed.)](http://www.doc.ic.ac.uk/~jnm/book/).*, 2006, by Jeff Magee and Jeff Kramer, published by Wiley, ISBN:978-0-470-09355-9.

## Files

| Original download | Saved as |
|---|---|
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/lts/spec.pdf) | `spec/spec.pdf` |
| [Template File](http://www.doc.ic.ac.uk/~ajf/haskelltests/lts/template.hs) | `src/LTS.hs` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples and the template's sample processes and LTSs (by convention, `pLTS` is the LTS of `p`). Composed and built LTSs are compared up to a renumbering of states that keeps state 0. `buildLTS` (Part V, no marks) is only tested on processes whose template LTS is minimal; `switch` is skipped because the spec accepts non-minimal LTSs for it. Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- Added a `module LTS where` header (the original template has none) so it can be built as a library module; the rest of the file is unchanged apart from layout.
