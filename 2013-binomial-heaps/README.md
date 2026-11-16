# Binomial Heaps (2013)

Imperial College Haskell January Test, 2013, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/binomial-heaps/>

**Difficulty:** \* (out of three stars)

## About this test (from the website)

My impression is that this is the easiest of the tests so far.  The majority of students completed Parts I and II and so picked up most of the marks.  The average mark was around 78%.  The final question is rather unsatisfactory for a number of reasons; I was aware of this at time, but had no time to fix it and am not sure even now how to make it more interesting!  It did, however, succeed in spreading the marks.

### More information

Chapter 19 of the [MIT Algorithms Book](http://books.google.co.uk/books/about/Introduction_To_Algorithms.html?id=NLngYyWFl_YC&redir_esc=y) provides a comprehensive coverage of Binomial Heaps.  Chris Osaki’s PhD thesis, [Purely Functional Data Structures](http://www.google.co.uk/url?sa=t&rct=j&q=&esrc=s&source=web&cd=3&cad=rja&ved=0CD0QFjAC&url=http%3A%2F%2Fwww.cs.cmu.edu%2F~rwh%2Ftheses%2Fokasaki.pdf&ei=xY73Us6TLuPH7Abiq4CQCA&usg=AFQjCNGXKQqKJho73FE372EjGzUoeSJm1w&sig2=NNu_k8rOJUeI9AIZTr29TQ&bvm=bv.60983673,d.ZGU), includes a chapter on binomial heaps that is similar to what you see here.  Another implementation can be found in the Haskell library [Data.Heap.Binomial](http://hackage.haskell.org/package/TreeStructures-0.0.2/docs/src/Data-Heap-Binomial.html) by Brendan Hickey.

## Files

| Original download | Saved as |
|---|---|
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/binheaps/spec.pdf) | `spec/spec.pdf` |
| [Template File](http://www.doc.ic.ac.uk/~ajf/haskelltests/binheaps/template.hs) | `src/BinomialHeaps.hs` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples and the template's sample trees and heaps (`t1..t8`, `h1..h7`). Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- Added a `module BinomialHeaps where` header (the original template has none) so it can be built as a library module; the rest of the file is unchanged.
- The spec calls the first accessor `value`, but the template names it `key` (the template also declares `remove` and `removeMin`, which the spec doesn't mention). The tests follow the template.
