# Binary Decision Diagrams (2009)

Imperial College Haskell January Test, 2009, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/binary-decision-diagrams-bdds-in-haskell/>

**Difficulty:** \*\* (out of three stars)

## About this test (from the website)

This was one of our first attempts to produce an extended three-hour test with the now traditional ‘sting in the tail’.  The original version started out with an interpreter for boolean expressions, which then led to functions for implementing negation and satisfiability on BDDs.  The last two parts were concerned with the construction of BDDs and ROBDDs.  The average mark was around 72%, with most students reaching Part III at least within the three hours.  Quite a few students completed all four parts; the sticking point for many was the ‘inverse lookup’ required for the ROBDD construction.

In hindsight, I have come to the conclusion that negation of BDDs was uninteresting, as it involves nothing more than flipping the $False$ and $True$ terminal nodes.  I  also think that it is more useful to learn about the notion of *restriction* of boolean expressions, as it facilitates the Shannon expansion:

$E \equiv x \rightarrow E [True/x], \,E[False/x]$

Restriction also leads to a more efficient algorithm for constructing BDDs.

The version you see here is thus a slightly re-worked version of the original test, with boolean expression evaluation being replaced by restriction.  The last two parts are unaltered versions of the original, bar the use of restriction to construct the (RO)BDDs.

If you want something else to practice on, try writing the original eval function, which has type

 eval :: BExp -> Env -> Bool and rewrite the two make functions in terms of eval.

### More information

An excellent introduction to BDDs and their construction and use can be found in Henrik Anderson’s lecture notes: [An Introduction to Binary Decision Diagrams](http://www.google.co.uk/url?sa=t&rct=j&q=&esrc=s&source=web&cd=16&ved=0CGIQFjAP&url=http%3A%2F%2Fwww.cs.aau.dk%2F~srba%2Fcourses%2FSV-08%2Fmaterial%2F09.pdf&ei=wmD3Uq3cFpGjhgf2t4GQCQ&usg=AFQjCNErshC0BEfJ0342K7U5a0q0yarLpA&sig2=yyGw0ycjpnuyGiIDLLT5Tg&bvm=bv.60983673,d.ZGU&cad=rja).  An alternative Haskell implementation of ROBDDs can be found [here](http://citeseerx.ist.psu.edu/viewdoc/download;jsessionid=68F37CFEE0A54D6E8C5FB209DC4F2446?doi=10.1.1.98.7725&rep=rep1&type=pdf).

## Files

| Original download | Saved as |
|---|---|
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/bdd/spec.pdf) | `spec/spec.pdf` |
| [Template File](http://www.doc.ic.ac.uk/~ajf/haskelltests/bdd/template.hs) | `src/BDD.hs` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples and the template's `b1..b8` / `bdd1..bdd8`. Built BDDs are checked by evaluating them under every variable assignment against the template's BDD for the same expression (node ids are arbitrary). The `buildROBDD` node-count test uses Figure 6 (right): 4 internal nodes for `b6` with order `[1,2,3,4]`. Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- Added a `module BDD where` header (the original template has none) so it can be built as a library module; the rest of the file is unchanged.
