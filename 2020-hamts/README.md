# Hash Array Mapped Tries (2020)

Imperial College Haskell January Test, 2020, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/hamts/>

**Difficulty:** \* (out of three stars)

## About this test (from the website)

This exercise was about building an implementation of Hash Array Mapped Tries (HAMTs) in Haskell. I wanted to ensure that the resulting code mirrored that of a highly tuned implementation in your language of choice. Thus, students had to implement bitmaps and hash indexing using via bit twiddling, using Data.Bits. My original solution also used arrays to perform constant-time subtree indexing, and to implement clash sets, but I decided to resort to lists in the end, as I don’t cover arrays in the lectures. It’s trivial to change data types and replace !! with !, for example, if you want to use arrays instead.

The key design decision revolves around what to do when you get a clash in the leaves of the trie. I contemplated a version that extends the trie using a separate hashing function, but that gets quite messy and isn’t guaranteed to solve the problem anyway. So I elected to stick with clashes, here using lists.

Students were given a crib sheet on how to use Data.Bits the day before the test, which is included here with the spec. The test is similar in nature to an interim test that was sat before the Christmas break. Therefore, I felt that students were especially well prepared for this test, which is why I’ve rated it one-star.

The exercise was generally well done: 17 students out of 188 scored full marks, with the average being around 73%. Lots of students (around 40) scored 90%+, so the distribution was lumped quite significantly to the right compared with past tests. The hardest part seemed to revolve around having to re-hash when you need to re-insert an item into the tree.

The version here, including the marking scheme, is exactly as was sat, with the exception of a small fix to one of the diagrams.

### More information

HAMTs are a relatively recent ‘discovery’, although the main ideas are essentially elaborations on established textbook algorithms and data structures. There are lots of on-line resources describing HAMTs and their variants, which can easily be found using a search engine. In preparing the exercise I found the [Youtube video](https://www.youtube.com/watch?v=WT9kmIE3Uis) of Phil Nash’s talk at C++ Now, 2017, particularly useful. Thank you, Phil!

## Files

| Original download | Saved as |
|---|---|
| [Background reading (Data.Bits)](http://www.doc.ic.ac.uk/~ajf/haskelltests/hamts/bits.pdf) | `spec/bits.pdf` |
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/hamts/spec.pdf) | `spec/spec.pdf` |
| [Template](http://www.doc.ic.ac.uk/~ajf/haskelltests/hamts/template.hs) | `src/Tries.hs` |
| [Types module](http://www.doc.ic.ac.uk/~ajf/haskelltests/hamts/Types.hs) | `src/Types.hs` |
| [HashFunctions module](http://www.doc.ic.ac.uk/~ajf/haskelltests/hamts/HashFunctions.hs) | `src/HashFunctions.hs` |
| [Test Data module](http://www.doc.ic.ac.uk/~ajf/haskelltests/hamts/Examples.hs) | `src/Examples.hs` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples and `Examples.hs` (`figure`, `figureHashed`, `insT1..insT4`, `buildT1`, `buildT2`). The elements of each `Leaf` are sorted before comparison, because their order is unimportant. Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- The template already declares `module Tries`. `Types.hs` got one type signature (`showT''`) so it builds without warnings. The background reading `bits.pdf` is in `spec/`.
- The template's commented-out `trieSize`, `binCount` and `meanBinSize` are copied into the test file, so the spec's examples for them can be tested without editing the template.
