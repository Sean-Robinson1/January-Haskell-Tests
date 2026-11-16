import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion)
import IC.Exact ((-->))

import Data.List (sort)

import Types
import Clues
import Examples
import Solver hiding (split2M, split3M)

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the data in Examples.hs (figParses, trees, parses, enumerations,
-- strings). Where the spec says order is unimportant, results are sorted
-- before comparison.
--
-- NOTE: WordData reads "thesaurus.txt" from the current directory, so the
-- tests must be run from the package folder (cabal test does this).

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "cluesolving"
  [ testGroup "cleanUp" (numberedTests cleanUpTests)
  , testGroup "split2" (numberedTests split2Tests)
  , testGroup "split3" (numberedTests split3Tests)
  , testGroup "uninsert" (numberedTests uninsertTests)
  , testGroup "split2M/split3M" (numberedTests mirrorTests)
  , testGroup "matches" (numberedTests matchesTests)
  , testGroup "evaluate" (numberedTests evaluateTests)
  , testGroup "parseSynonym" (numberedTests parseSynonymTests)
  , testGroup "parseAnagram" (numberedTests parseAnagramTests)
  , testGroup "parseReversal" (numberedTests parseReversalTests)
  , testGroup "parseInsertion" (numberedTests parseInsertionTests)
  , testGroup "parseCharade" (numberedTests parseCharadeTests)
  , testGroup "parseClue" (numberedTests parseClueTests)
  , testGroup "solve" (numberedTests solveTests)
  , testGroup "hidden words (Part IV)" (numberedTests hiddenWordTests)
  ]

cleanUpTests :: [Assertion]
cleanUpTests = [ cleanUp "half-baked" --> "halfbaked"
               , cleanUp "Haskell - everyone's favourite language!" --> "haskell everyones favourite language"
               ]

split2Tests :: [Assertion]
split2Tests = [ split2 "" --> []
              , sort (split2 [1,2,3,4 :: Int]) --> sort [([1],[2,3,4]),([1,2],[3,4]),([1,2,3],[4])]
              ]

split3Tests :: [Assertion]
split3Tests = [ sort (split3 (words "a sample word play"))
                  --> sort [(["a"],["sample"],["word","play"]),
                            (["a"],["sample","word"],["play"]),
                            (["a","sample"],["word"],["play"]),
                            (["a"],[],["sample","word","play"]),
                            (["a","sample"],[],["word","play"]),
                            (["a","sample","word"],[],["play"])]
              ]

uninsertTests :: [Assertion]
uninsertTests = [ sort (uninsert "abcde") --> sort [("b","acde"),("bc","ade"),("bcd","ae"),("c","abde"),("cd","abe"),("d","abce")]
                , uninsert [1,2 :: Int] --> []
                ]

-- split2M/split3M are the (commented-out) boilerplate definitions from the
-- template, reproduced below in terms of split2/split3.
mirrorTests :: [Assertion]
mirrorTests = [ sort (split2M [1,2,3 :: Int]) --> sort [([1],[2,3]),([1,2],[3]),([2,3],[1]),([3],[1,2])]
              , sort (split3M "abcd")
                  --> sort [("a","b","cd"),("a","bc","d"),("ab","c","d"),("a","","bcd"),
                            ("ab","","cd"),("abc","","d"),("cd","b","a"),("d","bc","a"),
                            ("d","c","ab"),("bcd","","a"),("cd","","ab"),("d","","abc")]
              ]

matchesTests :: [Assertion]
matchesTests = [ matches "road" (Synonym "street") --> True
               , matches "road" (Synonym "apricot") --> False
               ] ++
               -- "For the first 19 clues the first element should match the
               -- corresponding tree in trees above; the second should not."
               zipWith (\s t -> matches s t --> True) (map fst strings) trees ++
               zipWith (\s t -> matches s t --> False) (map snd strings) trees

evaluateTests :: [Assertion]
evaluateTests = [ evaluate (figParses !! 0) 7 --> []
                , evaluate (figParses !! 2) 7 --> ["rotates"]
                , map (flip evaluate 7) figParses --> [[],[],["rotates"],[]]
                , map sort (zipWith evaluate parses enumerations) --> solutions19
                ]

parseSynonymTests :: [Assertion]
parseSynonymTests = [ parseSynonym (words "great") --> [Synonym "great"]
                    , parseSynonym (words "at home") --> [Synonym "at home"]
                    , parseSynonym (words "triangular mollusc") --> []
                    ]

parseAnagramTests :: [Assertion]
parseAnagramTests = [ parseAnagram (words "mixed bag") --> [Anagram ["mixed"] "bag"]
                    , parseAnagram (words "bag mixed") --> [Anagram ["mixed"] "bag"]
                    , parseAnagram (words "changed the car") --> [Anagram ["changed"] "thecar"]
                    , parseAnagram (words "fruit cake") --> []
                    ]

parseReversalTests :: [Assertion]
parseReversalTests
  = [ parseReversal (words "go backwards") --> [Reversal ["backwards"] (Synonym "go")]
    , parseReversal (words "backwards go") --> [Reversal ["backwards"] (Synonym "go")]
    , parseReversal (words "mixed bag") --> []
    , sort (parseReversal (words "back at home"))
        --> sort [Reversal ["back"] (Synonym "at home"),
                  Reversal ["back"] (Charade [] (Synonym "at") (Synonym "home"))]
    ]

parseInsertionTests :: [Assertion]
parseInsertionTests
  = [ parseInsertion (words "back in business") --> [Insertion ["in"] (Synonym "back") (Synonym "business")]
    , parseInsertion (words "work around town") --> [Insertion ["around"] (Synonym "town") (Synonym "work")]
    , parseInsertion (words "back pain") --> []
    , sort (parseInsertion (words "was back in time"))
        --> sort [Insertion ["in"] (Reversal ["back"] (Synonym "was")) (Synonym "time"),
                  Insertion ["in"] (Charade [] (Synonym "was") (Synonym "back")) (Synonym "time")]
    ]

parseCharadeTests :: [Assertion]
parseCharadeTests
  = [ parseCharade (words "stop go") --> [Charade [] (Synonym "stop") (Synonym "go")]
    , sort (parseCharade (words "stop and go"))
        --> sort [Charade ["and"] (Synonym "stop") (Synonym "go"),
                  Charade [] (Synonym "stop") (Charade [] (Synonym "and") (Synonym "go")),
                  Charade [] (Charade [] (Synonym "stop") (Synonym "and")) (Synonym "go")]
    , sort (parseCharade (words "go after stop"))
        --> sort [Charade [] (Synonym "go") (Charade [] (Synonym "after") (Synonym "stop")),
                  Charade [] (Charade [] (Synonym "go") (Synonym "after")) (Synonym "stop"),
                  Charade ["after"] (Synonym "stop") (Synonym "go")]
    ]

parseClueTests :: [Assertion]
parseClueTests
  = [ sort (parseClue (clues !! 0)) --> sort [(["business"],[],Synonym "worry"),(["worry"],[],Synonym "business")]
    , sort (parseClue (clues !! 1)) --> sort figParses
    , length (parseClue (clues !! 16)) --> 72
    ]

solveTests :: [Assertion]
solveTests
  = [ solve (clues !! 1) --> [(("New toaster revolves",7),(["revolves"],[],Anagram ["new"] "toaster"),"rotates")]
    , sort [ p | (_, p, _) <- solve (clues !! 16) ]
        --> sort [ (["palace"],["for"],Insertion ["in"] (Synonym "carol") (Charade [] (Synonym "county") (Synonym "working")))
                 , (["palace"],["for"],Charade [] (Insertion ["in"] (Synonym "carol") (Synonym "county")) (Synonym "working")) ]
    , map getSol (solve (clues !! 16)) --> ["kensington","kensington"]
    , map sort (solveAll 19) --> solutions19
    ]

hiddenWordTests :: [Assertion]
hiddenWordTests
  = [ solve (clues !! 19) --> [(("Fish from Gillingham",4),(["fish"],[],HiddenWord ["from"] "gillingham"),"ling")]
    , solve (clues !! 20) --> [(("Boy hiding in fitted wardrobe",6),(["boy"],[],HiddenWord ["hiding","in"] "fitted wardrobe"),"edward")]
    ]

-- Test helpers

solutions19 :: [[String]]
solutions19
  = [["concern","problem"],["rotates"],["redshank"],["master"],["edam"],
     ["repaid"],["amnesty"],["remainder"],["sustain"],["loire"],["cabin"],
     ["snappy"],["fremantle"],["nasty"],["rotate"],["inapt"],
     ["kensington"],["defiant"],["speed"]]

split2M :: [a] -> [([a], [a])]
split2M xs
  = sxs ++ [(y, x) | (x, y) <- sxs]
  where
    sxs = split2 xs

split3M :: [a] -> [([a], [a], [a])]
split3M xs
  = sxs ++ [(z, y, x) | (x, y, z) <- sxs]
  where
    sxs = split3 xs

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
