# String Matching and Suffix Trees (2010)

Imperial College Haskell January Test, 2010, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/suffix-trees/>

**Difficulty:** \* (out of three stars)

## About this test (from the website)

This test is based on the simple, brute force, approach to suffix tree construction, using moderately straightforward list processing functions that students were required to define in the earlier parts of the test.

The test appears here almost exactly as it was originally set, with only minor adjustments made to the formatting.  Quite a few students completed the test in full within the three hours.  The impression was that the final part was actually relatively easy once you’d mastered the tree construction.  The average mark was around 75%.

### More information

The [Wikipedia article](http://en.wikipedia.org/wiki/Suffix_tree) on suffix trees provides a useful digest, including references to [Ukkonen’s original paper](http://www.cs.helsinki.fi/u/ukkonen/SuffixT1withFigs.pdf).  Of particular interest to Haskellers is the paper by Robert Giegerich and Stefan Kurtz, [A comparison of imperative and purely functional suffix tree constructions](http://www.google.co.uk/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&ved=0CC8QFjAA&url=http%3A%2F%2Fwww.zbh.uni-hamburg.de%2Fpubs%2Fpdf%2FGieKur1995a.pdf&ei=KWr3UqThOsWN7AbJioCIAQ&usg=AFQjCNFV9pqiy-BdyFpgrfQaJGQP6gqrOA&sig2=1CHjVmvuuRfEc40GIsN84A&bvm=bv.60983673,d.ZGU), which builds the tree lazily, top down, rather than by repeated insertion of suffixes, as here.  [Data.SuffixTree](http://hackage.haskell.org/package/suffixtree-0.2.2/docs/Data-SuffixTree.html), written by Bryan O’Sullivan, is based on an implementation of the lazy construction algorithm in Haskell.

## Files

| Original download | Saved as |
|---|---|
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/suffixtrees/spec.pdf) | `spec/spec.pdf` |
| [Template File](http://www.doc.ic.ac.uk/~ajf/haskelltests/suffixtrees/template.hs) | `src/SuffixTrees.hs` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples and the template's `s1`, `s2`, `t1`, `t2`. Results whose order the spec calls unimportant are sorted, and built trees are compared with `t1`/`t2` after sorting the subtrees of every node. Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- Added a `module SuffixTrees where` header (the original template has none) so it can be built as a library module; the rest of the file is unchanged.
