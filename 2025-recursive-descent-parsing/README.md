# Recursive-Descent Parsing (2025)

Imperial College Haskell January Test, 2025, by Tony Field. Original page: <https://wp.doc.ic.ac.uk/ajf/parsing/>

**Difficulty:** \*\*\* (out of three stars)

## About this test (from the website)

This was the first exercise that required students to exploit functors and monads in order to score full marks. The sticking point seemed to be an understanding of the fact that Eithers are monads, and therefore that:

Left e >>= _ = Left e
Right x >>= f = f x

and hence, for example, that

do (toks', e) <- parseExpr toks ...

yields Left err if parseExpr returns Left err.

Many students therefore resorted to inspecting the result of every parser call using pattern matching, which missed the point. The marking scheme was generous in this respect – in hindsight pattern matching was deemed acceptable for Parts I and II. Despite this, the results were (very) mixed: many students struggled to get going, due largely, I suspect, due to the lack of past exercises of a similar nature. The mark variance was much higher than normal, with the original average being only 60%. To compensate for this, four marks were added to each total, with the maximum being capped at 30, which raised the average to 71% whilst helping students at the lower end of the distribution. Despite the unusual distribution it could be done: out of 235 students,16 scored the maximum of 30 and 62 scored 80% or more before the adjustment. One student even had time to sketch a variation exploiting the State monad!

Because of the above I’ve rated the difficulty ***. Without the above issues, I suspect ** would be about right.

### More information

Not much is written any more about recursive-descent parsing but, as the specification says, it’s useful to see at least one example as it helps explain the basic parsing problem and how some automated parsing tools work under the hood. 

At Imperial, students write a complete compiler in their second year, using their own choice of language and and parsing tools. For students who elect to use Haskell or Scala, parser combinators (see, for example, [1]) turn out to be a popular choice.

[1] Hutton, G., & Meijer, E. (1998). *Monadic Parser Combinators.* Journal of Functional Programming, **8**(4), 437-444.

## Files

| Original download | Saved as |
|---|---|
| [Types module](http://www.doc.ic.ac.uk/~ajf/haskelltests/parsing/Types.hs) | `src/Types.hs` |
| [Skeleton](http://www.doc.ic.ac.uk/~ajf/haskelltests/parsing/Parser.hs) | `src/Parser.hs` |
| [Specification](http://www.doc.ic.ac.uk/~ajf/haskelltests/parsing/spec.pdf) | `spec/spec.pdf` |
| [Examples](http://www.doc.ic.ac.uk/~ajf/haskelltests/parsing/Examples.hs) | `src/Examples.hs` |
| [Lexer](http://www.doc.ic.ac.uk/~ajf/haskelltests/parsing/Lexer.hs) | `src/Lexer.hs` |
| (written for this repo) | `test/Tests.hs`, `test/IC/Exact.hs` |

## How to run

From this folder:

```sh
cabal build
cabal test
```

Before you implement anything, the tests fail (mostly with `Prelude.undefined`). Fill in the functions in `src/` until they pass.

## Tests

No test files were published for this test, so `test/Tests.hs` was written from the spec. Derived from the spec examples and the token lists and program strings in `Examples.hs`. Where the spec accepts either of two errors, both are accepted. Each spec example becomes one test case, and no extra cases were made up.

## Notes on the packaging

- The skeleton is `Parser.hs`. `Examples.hs` got one type signature (`asgnToks5`) so it builds without warnings.
