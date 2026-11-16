import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion)
import IC.Exact ((-->))

import Data.List (sort)

import BDD

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the example expressions/BDDs (b1..b8, bdd1..bdd8) in the template.

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "bdd"
  [ testGroup "lookUp" (numberedTests lookUpTests)
  , testGroup "checkSat" (numberedTests checkSatTests)
  , testGroup "sat" (numberedTests satTests)
  , testGroup "simplify" (numberedTests simplifyTests)
  , testGroup "restrict" (numberedTests restrictTests)
  , testGroup "buildBDD" (numberedTests buildBDDTests)
  , testGroup "buildROBDD" (numberedTests buildROBDDTests)
  ]

lookUpTests :: [Assertion]
lookUpTests = [ lookUp 5 [(4,1),(5,2),(9,9)] --> (2 :: Int)
              , lookUp (2,1) [((1,2),True),((2,1),False)] --> False
              ]

checkSatTests :: [Assertion]
checkSatTests = [ checkSat bdd2 [(1,True),(2,False)] --> True
                , checkSat bdd7 [(3,True),(2,False),(9,True)] --> False
                ]

-- The spec does not fix the order of the satisfying assignments, so they
-- are compared after sorting.
satTests :: [Assertion]
satTests = [ sort (sat bdd1) --> []
           , sort (sat bdd2) --> [[(1,False),(2,False)],[(1,False),(2,True)],[(1,True),(2,False)]]
           , sort (sat bdd8) --> [[(1,False)],[(1,True)]]
           ]

simplifyTests :: [Assertion]
simplifyTests = [ simplify (Not (Prim False)) --> Prim True
                , simplify (Or (Prim False) (Prim False)) --> Prim False
                , simplify (And (IdRef 3) (Prim True)) --> And (IdRef 3) (Prim True)
                ]

restrictTests :: [Assertion]
restrictTests = [ restrict b7 2 True --> Or (Not (IdRef 3)) (Or (Prim True) (Not (IdRef 9)))
                , restrict (restrict b7 2 True) 9 False --> Or (Not (IdRef 3)) (Prim True)
                , restrict (restrict (restrict b7 2 True) 9 False) 3 True --> Prim True
                ]

-- Node identifiers are arbitrary, so a built BDD is checked against the
-- template's valid BDD (bdd1..bdd8, built with indices in ascending order)
-- by evaluating both under every possible variable assignment.
examples :: [(BExp, [Index], BDD)]
examples = [ (b1, [],        bdd1)
           , (b2, [1,2],     bdd2)
           , (b3, [1],       bdd3)
           , (b4, [2,3,7],   bdd4)
           , (b5, [2,3,7],   bdd5)
           , (b6, [1,2,3,4], bdd6)
           , (b7, [2,3,9],   bdd7)
           , (b8, [1],       bdd8)
           ]

buildBDDTests :: [Assertion]
buildBDDTests = [ sameFunction xs (buildBDD e xs) expected
                | (e, xs, expected) <- examples ]

buildROBDDTests :: [Assertion]
buildROBDDTests
  = [ sameFunction xs (buildROBDD e xs) expected
    | (e, xs, expected) <- examples ] ++
    -- Figure 6 (right): the ROBDD for b6 with order [1,2,3,4] has 4 internal nodes
    [ length (snd (buildROBDD b6 [1,2,3,4])) --> 4 ]

-- Test helpers (independent of the code under test)

sameFunction :: [Index] -> BDD -> BDD -> Assertion
sameFunction xs actual expected
  = [ evalBDD actual env | env <- envs xs ] --> [ evalBDD expected env | env <- envs xs ]

envs :: [Index] -> [Env]
envs = mapM (\x -> [(x, False), (x, True)])

evalBDD :: BDD -> Env -> Bool
evalBDD (root, nodes) env = go root
  where
    go :: NodeId -> Bool
    go 0 = False
    go 1 = True
    go n = case Prelude.lookup n nodes of
             Just (i, l, r) -> case Prelude.lookup i env of
                                 Just True  -> go r
                                 Just False -> go l
                                 Nothing    -> error ("evalBDD: unbound variable " ++ show i)
             Nothing        -> error ("evalBDD: missing node " ++ show n)

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
