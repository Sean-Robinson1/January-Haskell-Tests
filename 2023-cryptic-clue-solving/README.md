# Cryptic Clue Solving (2023)

Imperial College Haskell January Test, 2023, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/cluesolving/>

**Difficulty:** \* (out of three stars)

## About this test (from the website)

This problem was very familiar to me, having spent several years developing a sophisticated crossword clue solver called Morse, which focuses on the problem of explaining cryptic wordplays. Computationally, it’s a very demanding problem, but all the complexities of making the solver really fast have been excluded from the problem presented here. Nonetheless, if you complete the exercise as specified you’ll get a pretty good idea of how Morse works.

The spec here is exactly the one originally set. Although there was a fairly good spread of marks across the class most of the stronger students did exceptionally well, with many scoring full marks. Unusually for these tests, the marks were heavily lumped toward the top end, the average being around 73%. In hindsight, it would have been good to award credit for Part IV, so as the spread the top end of the class. The difficulty rating reflects this.

There are quite a lot of files associated with the exercise, which comes with the territory. To make the problem tractable in three hours, the problem of computing the synonyms of words/phrases is delegated to a manually-constructed thesaurus, and for an indicator to be recognised it has to appear verbatim in a given indicator set. The corresponding data sets were manually constructed in advance, with knowledge of the test clues.

### More information

There is precious little published work in this area, so this is pretty much self-contained. Apart from Morse, the only other viable solver is the commercial CrosswordGenius app [3], wich is very powerful, but closed-source. There is growing interest in the problem, however, and a large corpus of clues has fairly recently been assembled for evaluation of clue solvers and other NLP-related algorithms [2].

The tiny solver developed here can be extended in numerous directions. From an NLP perspective the key challenge is to automate the “reverse dictionary” problem [1], e.g. by fine-tuning pre-trained language models such as T5 [4] using dictionary definitions. Making the solver scale to accommodate longer clues is also non-trivial, as the number of readings of a clue grows exponentially with its length.

[1] Felix Hill, Kyunghyun Cho, Anna Korhonen and Yoshua Bengio, “Learning to Understand Phrases by Embedding the Dictionary, Transactions of the Association for Computational Linguistics, Vol. 4, pp.17-30, Feb. 2016.

[2] Avia Efrat, Uri Shaham, Dan Kilman and Omer Levy, “Cryptonite: A Cryptic Crossword Benchmark for Extreme Ambiguity in Language”, Proc. 2021 Conference on Empirical Methods in Natural Language Processing, https://aclanthology.org/2021.emnlp-main.344, pp.4186-4192, Nov. 2021.

[3] Crossword Genius (unlikely.ai), *https://www.crosswordgenius.com/*.

[4] Colin Raffel, Noam Shazeer, Adam Roberts, Katherine Lee, Sharan Narang, Michael Matena, Yanqi Zhou, Wei Li, and Peter J. Liu. “Exploring the limits of transfer learning with a unified text-to-text transformer.” *The Journal of Machine Learning Research* 21, no. 1 (2020): 5485-5551.

## Files

| Original download | Saved as |
|---|---|
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/cluesolving/spec.pdf) | `spec/spec.pdf` |
| [Template File](http://www.doc.ic.ac.uk/~ajf/haskelltests/cluesolving/Solver.hs) | `src/Solver.hs` |
| [Types module](http://www.doc.ic.ac.uk/~ajf/haskelltests/cluesolving/Types.hs) | `src/Types.hs` |
| [Examples](http://www.doc.ic.ac.uk/~ajf/haskelltests/cluesolving/Examples.hs) | `src/Examples.hs` |
| [Sample clues](http://www.doc.ic.ac.uk/~ajf/haskelltests/cluesolving/Clues.hs) | `src/Clues.hs` |
| [Word data](http://www.doc.ic.ac.uk/~ajf/haskelltests/cluesolving/WordData.hs) | `src/WordData.hs` |
| [Thesaurus](http://www.doc.ic.ac.uk/~ajf/haskelltests/cluesolving/thesaurus.txt) | `thesaurus.txt` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples and `Examples.hs` (`figParses`, `trees`, `parses`, `enumerations`, `strings`). Part IV (hidden words, no marks) is tested with the spec's two worked clues. Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- `Solver.hs` and `WordData.hs` got type signatures (`showAll` and the indicator word lists) so they build without warnings. `WordData.hs` needs the `text` package and reads `thesaurus.txt` from the current directory, so the thesaurus is at the package root, and the tests must be run from the package folder (`cabal test` does this).
- The template's commented-out `split2M`/`split3M` are copied into the test file.
- With the unmodified template, the four tests whose expected result is `[]` (`triangular mollusc`, `fruit cake`, `mixed bag`, `back pain`) already pass, because the parsing rules default to `const []`.
