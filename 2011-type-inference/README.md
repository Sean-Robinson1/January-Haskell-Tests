# Polymorphic Type Inference (2011)

Imperial College Haskell January Test, 2011, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/type-inference/>

**Difficulty:** \*\*\* (out of three stars)

## About this test (from the website)

This was a highly ambitious test, but arguably the most rewarding, because the students’ solutions were impressive.  Most of them were able to complete the monomorphic part of the algorithm before either getting stuck or running out of time implementing unification.  Around 10% of the class had a good stab at Part IV with three of the 139 students who sat the test scoring maximum marks.  The average mark was around 74%.

Remark: the solution is arguably more elegant when type substitutions are represented as functions, whereupon the composition of substitutions can be implemented using built-in function composition (.).  I decided to stick with substitution lists instead, as the idea of substitutions as functions would have been unfamiliar.

The test appears here almost exactly as it was originally set.  Nobody left early!

### More information

The [Wikipedia article](http://en.wikipedia.org/wiki/Algorithm_W#Algorithm_W) on type inference provides a useful digest on Hindley/Milner/Damas type inference and Algorithm W.  An implementation of Algorithm W in Haskell can be found in the article  [Algorithm W Step by Step](http://www.google.co.uk/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&ved=0CDsQFjAB&url=http%3A%2F%2Fciteseerx.ist.psu.edu%2Fviewdoc%2Fdownload%3Fdoi%3D10.1.1.65.7733%26rep%3Drep1%26type%3Dpdf&ei=KHz3UvijIsbH7AbJooCwBw&usg=AFQjCNEZd7yLYNia8S_uC0CF-s0v5PHQ7A&sig2=M9jLfV9dREPDn4-8LhOHzA&bvm=bv.60983673,d.ZGU&cad=rja).  I recently came across another Haskell implementation which turned out to be very close to the one developed for this test, but I cannot locate the source.  If anyone can point me to that I will update this page.

## Files

| Original download | Saved as |
|---|---|
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/typeinference/spec.pdf) | `spec/spec.pdf` |
| [Template File](http://www.doc.ic.ac.uk/~ajf/haskelltests/typeinference/template.hs) | `src/TypeInference.hs` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples and Tables 1-3 in the template (`ex1..ex14`, `u1a..u6b`, `sub1..sub6`, `type1..type14`). Substitutions are compared ignoring order. Polymorphic types are compared after renaming type variables consistently, as the spec allows. Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- Added a `module TypeInference where` header (the original template has none) so it can be built as a library module; the rest of the file is unchanged.
