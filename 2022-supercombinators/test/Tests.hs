import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion)
import IC.Exact ((-->))

import Data.List (sort, sortOn)

import Types
import Examples
import SC

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the test expressions in Examples.hs ("eN' is the lambda-lifted
-- version of eN"; e1'' is e1 after modifyFunctions). Where the spec says
-- order is unimportant, results are sorted before comparison. The order of
-- the lifted supercombinators in the topmost let is not specified, so the
-- topmost bindings are sorted by name before lifted programs are compared.

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "supercombinators"
  [ testGroup "isFun" (numberedTests isFunTests)
  , testGroup "splitDefs" (numberedTests splitDefsTests)
  , testGroup "topLevelFunctions" (numberedTests topLevelFunctionsTests)
  , testGroup "unionAll" (numberedTests unionAllTests)
  , testGroup "freeVars" (numberedTests freeVarsTests)
  , testGroup "buildFVMap" (numberedTests buildFVMapTests)
  , testGroup "modifyFunctions" (numberedTests modifyFunctionsTests)
  , testGroup "lambdaLift" (numberedTests lambdaLiftTests)
  ]

isFunTests :: [Assertion]
isFunTests = [ isFun e2 --> False
             , isFun e5 --> True
             ]

splitDefsTests :: [Assertion]
splitDefsTests = [ splitDefs bs --> ([("g",Fun ["y"] (App (Var "+") [Var "y",Var "x"]))],[("x",Const 3)]) ]
  where
    Let bs _ = e4

topLevelFunctionsTests :: [Assertion]
topLevelFunctionsTests = [ topLevelFunctions e4 --> 1
                         , topLevelFunctions e12 --> 2
                         , topLevelFunctions e20 --> 0
                         , topLevelFunctions e1 --> 1
                         , topLevelFunctions (lambdaLift e1) --> 2
                         ]

unionAllTests :: [Assertion]
unionAllTests = [ sort (unionAll [[2, 5], [4, 2], [5, 1 :: Int]]) --> sort [2,5,4,1] ]

freeVarsTests :: [Assertion]
freeVarsTests = [ sort (freeVars e7) --> ["z"]
                , sort (freeVars e8) --> ["y","z"]
                , sort (freeVars e9) --> ["x"]
                ]

buildFVMapTests :: [Assertion]
buildFVMapTests = [ sort (buildFVMap e1) --> [("f",[]),("g",["x"])]
                  , sort (buildFVMap e2) --> [("succ",[])]
                  , sort (buildFVMap e19) --> [("f",["y","z"]),("g",["y","z"])]
                  ]

modifyFunctionsTests :: [Assertion]
modifyFunctionsTests = [ modifyFunctions (buildFVMap e1) e1 --> e1'' ]

lambdaLiftTests :: [Assertion]
lambdaLiftTests = [ canonTop (lambdaLift e) --> canonTop e'
                  | (e, e') <- [ (e1, e1'), (e2, e2'), (e4, e4'), (e12, e12'), (e13, e13')
                               , (e14, e14'), (e15, e15'), (e16, e16'), (e18, e18'), (e19, e19') ] ]

-- Test helpers

canonTop :: Exp -> Exp
canonTop (Let bs e) = Let (sortOn fst bs) e
canonTop e          = e

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
