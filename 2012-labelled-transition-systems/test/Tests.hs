import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion)
import IC.Exact ((-->))

import Data.List (sort, sortOn, nub)

import LTS

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the sample processes/LTSs in the template ("By convention, the LTS
-- for the FSP process represented in Haskell by p is named pLTS").
-- Where the spec says order is unimportant, lists are sorted before
-- comparison. Composed/built LTSs may number their states differently, so
-- they are compared up to a renaming of states that keeps state 0.

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "lts"
  [ testGroup "lookUp" (numberedTests lookUpTests)
  , testGroup "states" (numberedTests statesTests)
  , testGroup "transitions" (numberedTests transitionsTests)
  , testGroup "alphabet" (numberedTests alphabetTests)
  , testGroup "actions" (numberedTests actionsTests)
  , testGroup "accepts" (numberedTests acceptsTests)
  , testGroup "composeTransitions" (numberedTests composeTransitionsTests)
  , testGroup "pruneTransitions" (numberedTests pruneTransitionsTests)
  , testGroup "compose" (numberedTests composeTests)
  , testGroup "buildLTS (Part V)" (numberedTests buildLTSTests)
  ]

lookUpTests :: [Assertion]
lookUpTests = [ lookUp (1,0) [((0,0),0),((0,1),1),((1,0),2),((1,1),3)] --> (2 :: Int) ]

statesTests :: [Assertion]
statesTests = [ sort (states vendorLTS) --> [0,1,2,3] ]

transitionsTests :: [Assertion]
transitionsTests = [ sort (transitions 0 vendorLTS) --> sort [((0,1),"off"),((0,2),"blue"),((0,3),"red")] ]

alphabetTests :: [Assertion]
alphabetTests = [ sort (alphabet playLTS) --> ["end","move","think"] ]

processLTSs :: [(ProcessDef, LTS)]
processLTSs = [ (vendor, vendorLTS), (clock, clockLTS), (play, playLTS)
              , (maker, makerLTS), (user, userLTS), (p, pLTS), (q, qLTS) ]

actionsTests :: [Assertion]
actionsTests = [ sort (actions (snd maker)) --> ["make","ready"] ] ++
               -- "a testable axiom is that actions p should contain the same
               -- elements as alphabet pLTS"
               [ sort (actions (snd d)) --> sort (nub (map snd lts)) | (d, lts) <- processLTSs ]

acceptsTests :: [Assertion]
acceptsTests = [ accepts ["on","off","on"] [switch,on,off] --> True
               , accepts ["use","use"] [user] --> False
               , accepts [] [user] --> True
               ]

composeTransitionsTests :: [Assertion]
composeTransitionsTests
  = [ sort (composeTransitions ((0,1),"a") ((0,1),"c") ["a"] ["b","c"] m) --> [((0,1),"c"),((0,2),"a")]
    , sort (composeTransitions ((1,1),"a") ((1,0),"c") ["a"] ["a","c"] m) --> [((3,2),"c")]
    , sort (composeTransitions ((0,1),"a") ((1,1),"c") ["a","c"] ["a","c"] m) --> ([] :: [Transition])
    ]
  where
    m = [((0,0),0),((0,1),1),((1,0),2),((1,1),3)]

pruneTransitionsTests :: [Assertion]
pruneTransitionsTests
  = [ sort (pruneTransitions [((0,1),"d"),((1,4),"a"),((2,5),"a")]) --> [((0,1),"d"),((1,4),"a")] ]

composeTests :: [Assertion]
composeTests = [ canon (compose clockLTS playLTS) --> canon clockPlayLTS
               , canon (compose makerLTS userLTS) --> canon makerUserLTS
               , canon (compose pLTS qLTS) --> canon pqLTS
               ]

buildLTSTests :: [Assertion]
buildLTSTests
  = [ canon (buildLTS [vendor])
        --> canon [((0,3),"red"),((3,0),"coffee"),((0,2),"blue"),((2,0),"tea"),((0,1),"off")] ] ++
    [ canon (buildLTS [d]) --> canon lts | (d, lts) <- processLTSs ]

-- Test helpers

-- Renumbers the states of a (deterministic) LTS in breadth-first order
-- from state 0, following transitions in label order, then sorts the
-- transitions. Two such LTSs are equal up to state renaming iff their
-- canonical forms are equal.
canon :: LTS -> LTS
canon lts = sort [ ((ren s, ren t), a) | ((s, t), a) <- lts ]
  where
    order = bfs [0] []
    ren s = maybe (-1) id (Prelude.lookup s (zip order [0..]))
    bfs :: [State] -> [State] -> [State]
    bfs [] seen = reverse seen
    bfs (s : rest) seen
      | s `elem` seen = bfs rest seen
      | otherwise     = bfs (rest ++ [ t | ((_, t), _) <- out s ]) (s : seen)
    out s = sortOn snd [ tr | tr@((s', _), _) <- lts, s' == s ]

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
