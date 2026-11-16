import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion)
import IC.Exact ((-->))

import Data.List (sort, sortOn)

import RegExp

-- Tests derived from the examples in the specification (spec/spec.pdf):
-- Table 1 (matching / non-matching strings), Tables 2-4 (re1..re5,
-- nda1..nda5, da1..da5 in the template) and the inline examples.

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "regex"
  [ testGroup "simplify" (numberedTests simplifyTests)
  , testGroup "startState/terminalStates/transitions" (numberedTests indexTests)
  , testGroup "isTerminal" (numberedTests isTerminalTests)
  , testGroup "transitionsFrom" (numberedTests transitionsFromTests)
  , testGroup "labels" (numberedTests labelsTests)
  , testGroup "accepts" (numberedTests acceptsTests)
  , testGroup "makeNDA" (numberedTests makeNDATests)
  , testGroup "getFrontier" (numberedTests getFrontierTests)
  , testGroup "groupTransitions" (numberedTests groupTransitionsTests)
  , testGroup "makeDA" (numberedTests makeDATests)
  ]

simplifyTests :: [Assertion]
simplifyTests = [ showRE (simplify re5) --> "(ab|)dd*" ]

indexTests :: [Assertion]
indexTests = [ terminalStates nda1 --> [2]
             , startState nda1 --> 1
             , transitions nda2 --> [(1,3,C 'x'),(3,4,Eps),(4,2,Eps),(4,5,Eps),(5,6,C '\''),(6,2,Eps),(6,5,Eps)]
             ]

isTerminalTests :: [Assertion]
isTerminalTests = [ isTerminal 2 nda1 --> True
                  , isTerminal 3 da4 --> True
                  , isTerminal 5 nda2 --> False
                  ]

transitionsFromTests :: [Assertion]
transitionsFromTests = [ sort (transitionsFrom 5 ndaFigure) --> [(5,7,Eps),(5,9,Eps)]
                       , transitionsFrom 10 nda3 --> [(10,6,C 'b')]
                       ]

labelsTests :: [Assertion]
labelsTests = [ labels [(1,2,Eps)] --> []
              , sort (labels (transitions nda3)) --> sort [C 'a',C 'c',C 'b']
              ]

-- Table 1: (regex automaton, matching strings, non-matching strings).
-- Both the NDA and the DA of each expression should give the same answers.
table1 :: [(Automaton, Automaton, [String], [String])]
table1 = [ (nda1, da1, ["x2","y1"], ["x","x3"])
         , (nda2, da2, ["x","x'","x'''"], ["y","'","x'x"])
         , (nda3, da3, ["","c","abababccab"], ["d","ac","cccb"])
         , (nda4, da4, ["a","aa"], ["b","aaa"])
         , (nda5, da5, ["d","abd","abddd"], ["ab","bd","ababd"])
         ]

acceptsTests :: [Assertion]
acceptsTests
  = [ accepts a s --> True  | (n, d, yes, _) <- table1, a <- [n, d], s <- yes ] ++
    [ accepts a s --> False | (n, d, _, no) <- table1, a <- [n, d], s <- no ] ++
    -- Section 3 examples on the NDA for (a|b)*c
    [ accepts ndaFigure "ac" --> True
    , accepts ndaFigure "bc" --> True
    , accepts ndaFigure "aac" --> True
    , accepts ndaFigure "cc" --> False
    , accepts ndaFigure "ad" --> False
    ]

makeNDATests :: [Assertion]
makeNDATests = [ makeNDA (Term 'x') --> (1,[2],[(1,2,C 'x')])
               , makeNDA reFigure --> ndaFigure
               , makeNDA re1 --> nda1
               , makeNDA re2 --> nda2
               , makeNDA re3 --> nda3
               , makeNDA re4 --> nda4
               , makeNDA re5 --> nda5
               ]

getFrontierTests :: [Assertion]
getFrontierTests = [ sort (getFrontier 1 nda3) --> [(2,2,Eps),(5,9,C 'a'),(7,8,C 'c')] ]

groupTransitionsTests :: [Assertion]
groupTransitionsTests
  = [ sortOn fst (groupTransitions [(2,2,Eps),(5,9,C 'a'),(7,8,C 'c')]) --> [(C 'a',[9]),(C 'c',[8])]
    , map (fmap sort) (groupTransitions [(3,7,C 'a'),(5,9,C 'a')]) --> [(C 'a',[7,9])]
    ]

-- DA state numbers are arbitrary, so DAs are compared up to a renaming
-- of states (the start state and terminal states are renamed too).
makeDATests :: [Assertion]
makeDATests = [ canon (makeDA n) --> canon d
              | (n, d) <- [ (ndaFigure, daFigure), (nda1, da1), (nda2, da2)
                          , (nda3, da3), (nda4, da4), (nda5, da5) ] ]

-- Test helpers

-- Renumbers the states of a deterministic automaton in breadth-first
-- order from the start state, following transitions in label order.
canon :: Automaton -> Automaton
canon (start, terms, ts) = (ren start, sort (map ren terms), sort [ (ren s, ren t, l) | (s, t, l) <- ts ])
  where
    order = bfs [start] []
    ren s = maybe (-1) id (Prelude.lookup s (zip order [0..]))
    bfs :: [State] -> [State] -> [State]
    bfs [] seen = reverse seen
    bfs (s : rest) seen
      | s `elem` seen = bfs rest seen
      | otherwise     = bfs (rest ++ [ t | (_, t, _) <- out s ]) (s : seen)
    out s = sortOn (\(_, _, l) -> l) [ tr | tr@(s', _, _) <- ts, s' == s ]

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
