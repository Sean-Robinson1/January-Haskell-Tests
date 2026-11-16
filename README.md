# Haskell January Tests (cabalified)

Practice copies of the Imperial College first-year **Haskell January Tests** by Tony Field, from <https://wp.doc.ic.ac.uk/ajf/haskell-tests/>. Each test is its own cabal package with the original spec PDF, the skeleton or template in `src/`, and a `tasty` test suite in `test/` built from the examples in the spec.

> The January tests are online Haskell programming tests sat under examination conditions by first-year undergraduates at Imperial College at the end of a six-week introductory programming course. (From the website.)

## Tests

| Year | Test (folder) | Difficulty | Summary |
|---|---|---|---|
| 2009 | [Binary Decision Diagrams](2009-binary-decision-diagrams/) | \*\* | Boolean expressions, BDDs, restriction and (RO)BDD construction. |
| 2010 | [String Matching and Suffix Trees](2010-suffix-trees/) | \* | Naive substring search, then search and construction on suffix trees. |
| 2011 | [Polymorphic Type Inference](2011-type-inference/) | \*\*\* | Monomorphic inference, unification and Algorithm W style polymorphic inference. |
| 2012 | [Labelled Transition Systems](2012-labelled-transition-systems/) | \*\*\* | LTS utilities, FSP processes, trace acceptance and parallel composition. |
| 2013 | [Binomial Heaps](2013-binomial-heaps/) | \* | Binomial trees and heaps: combine, merge, insert, deleteMin, binSort, binary counting. |
| 2014 | [Regular Expressions and Finite Automata](2014-regular-expressions/) | \*\*\* | Regex simplification, NDA acceptance (backtracking), NDA construction and NDA to DA conversion. |
| 2015 | [Functions, Procedures and Memoisation](2015-memoisation/) | \*\*\* | An expression evaluator and a procedure interpreter, then translating pure functions into memoised procedures. |
| 2016 | [XML and XSL Transformations](2016-xml-xsl/) | \*\*\* | A stack-based XML parser and a small XSLT subset (value-of, for-each). |
| 2017 | [Decision Trees](2017-decision-trees/) | \*\* | Data-set utilities, decision tree evaluation and construction (first attribute, then information gain). |
| 2018 | [Constant Propagation (SSA)](2018-constant-propagation/) | \*\* | An interpreter, then constant propagation and folding on SSA form, and phi removal. |
| 2019 | [SAT Solving](2019-sat-solving/) | \* | NNF/CNF conversion, flattening and the Davis-Putnam algorithm (all solutions). |
| 2020 | [Hash Array Mapped Tries](2020-hamts/) | \* | Bit twiddling with Data.Bits, then membership, insertion and building of HAMTs. |
| 2021 | [Graph Colouring and Register Allocation](2021-graph-colouring/) | \*\* | Graph colouring, variable renaming, interference graphs and (unassessed) liveness and CFG construction. |
| 2022 | [Supercombinators (Lambda Lifting)](2022-supercombinators/) | \*\*\* | Free variables, then lambda lifting of let-bound functions into supercombinators. |
| 2023 | [Cryptic Clue Solving](2023-cryptic-clue-solving/) | \* | Parsing and evaluating cryptic crossword clue wordplay with a thesaurus. |
| 2024 | [Symbolic Integration](2024-symbolic-integration/) | \* | Polynomial arithmetic, symbolic differentiation and integration with the inverse chain rule. |
| 2025 | [Recursive-Descent Parsing](2025-recursive-descent-parsing/) | \*\*\* | A recursive-descent parser for a tiny imperative language using the Either monad. |

## Layout of each test

```
<year>-<name>/
  README.md          description from the website, how to run, packaging notes
  spec/spec.pdf      the original specification (plus any extra PDFs)
  <package>.cabal    library (src/) + test-suite (test/)
  src/               the skeleton/template (unimplemented)
  test/Tests.hs      tasty + HUnit tests derived from the spec examples
  test/IC/Exact.hs   small IC test helper providing (-->)
```

## Running a test

Go into the folder for the test you want and run the tests there:

```sh
cd 2019-sat-solving
cabal test
```

## Caveats

- No test files were published for any of these tests. All test suites were written from the examples in the specs and the example data in the templates, and the expected values are copied from the spec. Where the spec says an order is unimportant, results are put in a canonical order before they are compared. See each README for details.
- Templates without a `module` line got a one-line `module X where` header so they can be built as library modules. Given helper code (example data, pretty-printers, utilities) also got missing type signatures and a few small fixes so it builds without compiler warnings. Code the student has to write was left alone, so the stubs `applySub` (2011) and `composeTransitions` (2012) still warn about missing signatures.
- Equations were reformatted so the `=` sits on the same line as the definition (when that fits in 80 columns), with the `=` of consecutive clauses aligned. This is layout only and does not change the code.
- 2024 (Symbolic Integration): the page doesn't link the template `Int.hs`, but it is in the test's folder on the server, and `src/Int.hs` is that file (unchanged apart from layout).
- Specs and templates are (c) Imperial College London / Tony Field and are included here for personal practice only.
