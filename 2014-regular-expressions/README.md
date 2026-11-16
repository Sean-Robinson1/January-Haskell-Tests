# Regular Expressions and Finite Automata (2014)

Imperial College Haskell January Test, 2014, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/regular-expressions-and-finite-automata/>

**Difficulty:** \*\*\* (out of three stars)

## About this test (from the website)

The specification for this exercise is quite long, so we gave students a short introductory document to read the night before the test.  Most students did very well in Parts I and II, but were then slowed down by Part III.  Common errors were in the state labelling and/or the chaining of the state identifiers into and out of the make function.  Quite a number of students had a go at Part IV, which is hard to get your head around in the time available.  Amazingly, one student completed the entire exercise in just over two hours, scoring 100%, so it could be done.

I have made one small adjustment to the original structure by including the labels function in Part II.  A number of students who attempted Part IV made heavy weather of groupTransitions, which should be a one-liner.  The labels function, simple though it is, might help.

The acceptance testing algorithm used here is the simple backtracking version.  However, if you implement getFrontier correctly from Part IV then you’ll find that it’s relatively straightforward to use it to build the breadth-first version of acceptance testing which is substantially more efficient (see below).

**Remark**: Most treatments of NFA to DFA conversion are based on the calculation of the so-called $\epsilon$-closure of a set of states. The trouble with this is that it introduces superfluous states in the resulting DFA. These are avoided by using the $\epsilon$-frontier instead, as described in the specification. Does the use of frontiers yield the minimal DFA? Sadly not.

### More information

There are countless on-line sources of information on regular expressions and automata.  I would particular recommend [Chapter 10](http://www.google.co.uk/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0CC8QFjAA&url=http%3A%2F%2Finfolab.stanford.edu%2F~ullman%2Ffocs%2Fch10.pdf&ei=6l73UvLUL7Ou7AawkYGwAQ&usg=AFQjCNHZGvtUTk14KqBgDbIbAx2uGO83PA&sig2=YwcMhUSSrVQiR46Bp5wyTA&bvm=bv.60983673,d.ZGU&cad=rja) of Al Aho and Jeff Ullman’s on-line book on [Foundations of Computer Science](http://infolab.stanford.edu/~ullman/focs.html) (C version).  There is also an excellent [article ](http://swtch.com/~rsc/regexp/regexp1.html)by Russ Cox on the efficiency of regular expression matching which addresses, in particular, the advantages of breadth-first matching over backtracking.  It also includes further details of Ken Thompson’s [original paper](http://www.google.co.uk/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&ved=0CC8QFjAA&url=http%3A%2F%2Fwww.fing.edu.uy%2Finco%2Fcursos%2Fintropln%2Fmaterial%2Fp419-thompson.pdf&ei=55r3UqD5F-nY7Aavw4C4Cg&usg=AFQjCNHlYJuCgqpy2p7fJzns27CmwZ2OOQ&sig2=3njMnvPJKMjPYarhgfPSGg&bvm=bv.60983673,d.ZGU) on regular expression search algorithms. For a tutorial-style introduction to regular expressions and automata in Haskell, [this article](http://www.academia.edu/2720425/Regular_expressions_and_automata_using_Haskell) by Simon Thompson develops variations of several of the algorithms covered here and also addresses the issue of DFA minimisation.  A neat translator from NFAs to DFAs can also be found in Wouter Swierstra’s article on [Practical Graph Handling](http://www.haskell.org/haskellwiki/The_Monad.Reader/Issue5/Practical_Graph_Handling).

## Files

| Original download | Saved as |
|---|---|
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/regex/spec.pdf) | `spec/spec.pdf` |
| [Template File](http://www.doc.ic.ac.uk/~ajf/haskelltests/regex/template.hs) | `src/RegExp.hs` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples, Table 1 (matching and non-matching strings, checked against both the NDA and the DA of each expression) and Tables 2-4 (`re1..re5`, `nda1..nda5`, `da1..da5`). `makeNDA` is compared exactly, since the spec says to follow the numbering scheme exactly. `makeDA` is compared up to a renumbering of states. Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- Added a `module RegExp where` header (the original template has none) so it can be built as a library module. The only other changes are a type signature for `showRE'` and `_` for an unused binding in `makeNDA`, so the given code builds without warnings.
- The spec gives no example for `lookUp`, so it has no test. The spec's frontier example for `(a|)a` (`[(3,7,C 'a'),(5,9,C 'a')]`) doesn't match the template's `nda4`, so it's only used for the `groupTransitions` test.
- The template's `nd`, `nd'`, `da` and `re` aren't explained in the spec and aren't used by the tests.
