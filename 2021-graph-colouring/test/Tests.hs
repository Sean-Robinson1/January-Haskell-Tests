import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion)
import IC.Exact ((-->))

import Data.List (sort)

import Types
import Examples
import Alloc

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the examples in Examples.hs (fig1Left, fig1Middle, fact and fig3
-- with their IGs, colourings, IdMaps, transformed versions, live variable
-- sets and CFGs). Where the spec says order is unimportant, results are
-- sorted (or sortGraph/sortCFG from Types is used) before comparison.

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "colouring"
  [ testGroup "count" (numberedTests countTests)
  , testGroup "degrees" (numberedTests degreesTests)
  , testGroup "neighbours" (numberedTests neighboursTests)
  , testGroup "removeNode" (numberedTests removeNodeTests)
  , testGroup "colourGraph" (numberedTests colourGraphTests)
  , testGroup "buildIdMap" (numberedTests buildIdMapTests)
  , testGroup "buildArgAssignments" (numberedTests buildArgAssignmentsTests)
  , testGroup "renameExp" (numberedTests renameExpTests)
  , testGroup "renameBlock/renameFun" (numberedTests renameTests)
  , testGroup "buildIG" (numberedTests buildIGTests)
  , testGroup "liveVars (Part V)" (numberedTests liveVarsTests)
  , testGroup "buildCFG (Part V)" (numberedTests buildCFGTests)
  ]

countTests :: [Assertion]
countTests = [ count 'a' "b" --> 0
             , count 3 [2,4,1,3,2,3,3 :: Int] --> 3
             ]

degreesTests :: [Assertion]
degreesTests = [ sort (degrees ([1], [] :: [Edge Int])) --> [(1,0)]
               , sort (degrees fig1Left) --> [(1,2),(2,2),(3,2),(4,2)]
               ]

neighboursTests :: [Assertion]
neighboursTests = [ sort (neighbours 1 ([1], [] :: [Edge Int])) --> []
                  , sort (neighbours 2 fig1Left) --> [1,4]
                  ]

removeNodeTests :: [Assertion]
removeNodeTests = [ sortGraph (removeNode "i" factIG) --> (["n","prod"],[("n","prod")])
                  , sortGraph (removeNode "prod" factIG) --> (["i","n"],[])
                  ]

colourGraphTests :: [Assertion]
colourGraphTests = [ sort (colourGraph 2 fig1Middle) --> sort [(2,2),(1,0),(3,2),(4,1)]
                   , sort (colourGraph 2 fig3IG) --> [("a",0),("b",0),("c",0),("d",2),("n",1)]
                   , sort (colourGraph 3 fig3IG) --> [("a",3),("b",0),("c",3),("d",2),("n",1)]
                   , sort (colourGraph 3 fig3IG) --> sort fig3Colouring
                   ]

buildIdMapTests :: [Assertion]
buildIdMapTests = [ sort (buildIdMap factColouring) --> sort [("return","return"),("i","R2"),("n","R2"),("prod","R1")]
                  , sort (buildIdMap fig3Colouring)
                      --> sort [("return","return"),("a","R3"),("b","b"),("c","R3"),("d","R2"),("n","R1")]
                  ]

buildArgAssignmentsTests :: [Assertion]
buildArgAssignmentsTests = [ buildArgAssignments ["x","y"] idMap1 --> [Assign "R6" (Var "x"),Assign "R1" (Var "y")] ]

renameExpTests :: [Assertion]
renameExpTests = [ renameExp e1 idMap1 --> Apply Add (Var "a") (Var "R1")
                 , renameExp e2 idMap1 --> Apply Mul (Apply Add (Var "R6") (Const 2)) (Var "R1")
                 ]

renameTests :: [Assertion]
renameTests = [ renameBlock factB factIdMap --> let (_, _, b) = factTransformed in drop 1 b
              , renameFun fact factIdMap --> factTransformed
              , renameFun fig3 fig3IdMap --> fig3Transformed
              ]

buildIGTests :: [Assertion]
buildIGTests = [ sortGraph (buildIG factLiveVars) --> sortGraph (["n","prod","i"],[("n","prod"),("prod","i")])
               , sortGraph (buildIG factLiveVars) --> factIG
               , sortGraph (buildIG fig3LiveVars) --> fig3IG
               ]

liveVarsTests :: [Assertion]
liveVarsTests = [ map sort (liveVars factCFG) --> factLiveVars
                , map sort (liveVars fig3CFG) --> fig3LiveVars
                ]

buildCFGTests :: [Assertion]
buildCFGTests = [ sortCFG (buildCFG fact) --> factCFG
                , sortCFG (buildCFG fig3) --> fig3CFG
                ]

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
