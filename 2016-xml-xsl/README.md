# XML and XSL Transformations (2016)

Imperial College Haskell January Test, 2016, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/xml/>

**Difficulty:** \*\*\* (out of three stars)

## About this test (from the website)

There is somewhat less hand-holding in this test than previous tests, particularly in Part III (the hard part), which offers no hints as to how to break the problem down.  A common problem in Parts I and II was using inappropriate functions for decomposing strings, e.g. takeWhile and dropWhile, rather than break/span, resulting in multiple passes over the source string.

Part III takes quite a while to get your head round and the best attempts at Part III were from students who had finished Parts I and II within the first hour. One student completed Part III right on the three-hour deadline, passing all the test cases that we used for marking. Several others came very close. The highest mark was 29/30, which was achieved by two students. The class average was around 70%.

This is quite a tricky test, although it’s not that hard to get Part III to work in the time available. I’ve rated the difficulty *** largely because of the time constraints involved.

The original specification made use of a Null value in the XML data type, but I have removed this here in favour of Text "". Other than this the specification is precisely the one used in the test. An earlier draft of the exercise built in some basic syntax checking in the form of a small library of parsing utility functions. In the end, I opted to assume that all XML input is well formed in order to simplify the problem. This means that you can apply several shortcuts to the parser, e.g. skipping over ‘=‘ symbols in attributes because they will always be there. This isn’t entirely satisfactory, so if you’re going to try this out I would suggest putting the checks back, e.g. by defining utility functions for reading/skipping over specified terminal symbols, throwing an error if the symbols aren’t found. Your test cases should then include some syntactically broken XML strings.

### More information

Full details of XML and XSLT can be found on the World-Wide Web Consortium’s (W3C) [web pages](https://www.w3.org/).  In particular, details of XSL, including XSL transformations and XPaths can be found [here](https://www.w3.org/Style/XSL/).  The [W3Schools web pages](http://www.w3schools.com/xsl/xsl_languages.asp) provide an excellent test-bed for experimenting with XML syntax and XSL semantics and proved incredibly useful when preparing the exercise.

## Files

| Original download | Saved as |
|---|---|
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/xml/spec.pdf) | `spec/spec.pdf` |
| [Template File](http://www.doc.ic.ac.uk/~ajf/haskelltests/xml/template.hs) | `src/Exam.hs` |
| [filmTable.html](http://www.doc.ic.ac.uk/~ajf/haskelltests/xml/filmTable.html) | `test/golden/filmTable.html` |
| [composerList.html](http://www.doc.ic.ac.uk/~ajf/haskelltests/xml/composerList.html) | `test/golden/composerList.html` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples, the template's test data (`s1..s3`, `x1..x3`, `casablanca`, `films`, `xsl1..xsl9` and their parsed versions) and the two downloaded expected-output files. Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- The template already declares `module Exam`, so it's saved as `src/Exam.hs`. The given `showXML` got a `Null` case so it builds without warnings.
- The expected outputs `filmTable.html` and `composerList.html` are in `test/golden/` and are read by the tests, which must be run from the package folder (`cabal test` does this).
