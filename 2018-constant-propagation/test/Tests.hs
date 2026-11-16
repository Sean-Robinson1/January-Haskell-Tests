import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion)
import IC.Exact ((-->))

import Data.List (sort)

import SSA

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the example functions in the template, which follow the naming
-- convention fun / funSSA / funSSAPropagated / funOptimised.
-- States are sorted before comparison as their order is unimportant.

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "ssa"
  [ testGroup "update" (numberedTests updateTests)
  , testGroup "apply" (numberedTests applyTests)
  , testGroup "eval" (numberedTests evalTests)
  , testGroup "execStatement/execBlock" (numberedTests execTests)
  , testGroup "foldConst" (numberedTests foldConstTests)
  , testGroup "sub" (numberedTests subTests)
  , testGroup "propagateConstants" (numberedTests propagateTests)
  , testGroup "unPhi" (numberedTests unPhiTests)
  , testGroup "optimise" (numberedTests optimiseTests)
  ]

updateTests :: [Assertion]
updateTests = [ sort (update ("x", 3) s1) --> sort [("x",3),("y",8)]
              , sort (update ("z", 0) s1) --> sort [("z",0),("x",7),("y",8)]
              ]

applyTests :: [Assertion]
applyTests = [ apply Add 7 5 --> 12
             , apply Gtr 4 9 --> 0
             ]

evalTests :: [Assertion]
evalTests = [ eval e1 s1 --> 7
            , eval e2 s1 --> 64
            ]

execTests :: [Assertion]
execTests
  = [ sort (execFun fact [5]) --> sort [("$return",120),("i",0),("prod",120),("n",5)]
    , sort (execFun loop [4]) --> sort [("$return",40),("i",0),("sum",40),("k",0),("n",4)]
    , sort (execFun loopOptimised [4])
        --> sort [("$return",40),("i1",0),("sum1",40),("i2",0),("sum2",40),
                  ("m0",2),("b1",2),("a0",1),("i0",4),("n",4)]
    ]

foldConstTests :: [Assertion]
foldConstTests = [ foldConst e3 --> Const 2
                 , foldConst e4 --> Var "x"
                 ]

subTests :: [Assertion]
subTests = [ sub "a" 0 e5 --> Var "x" ]

propagateTests :: [Assertion]
propagateTests = [ applyPropagate exampleSSA --> exampleSSAPropagated
                 , applyPropagate loopSSA --> loopSSAPropagated
                 , applyPropagate basicBlockSSA --> basicBlockSSAPropagated
                 , applyPropagate max2SSA --> max2SSAPropagated
                 ]

unPhiTests :: [Assertion]
unPhiTests = [ applyUnPhi max2SSAPropagated --> max2Optimised
             , applyUnPhi loopSSAPropagated --> loopOptimised
             , applyUnPhi exampleSSAPropagated --> exampleOptimised
             , applyUnPhi basicBlockSSAPropagated --> basicBlockOptimised
             ]

optimiseTests :: [Assertion]
optimiseTests = [ optimise loopSSA --> loopOptimised
                , optimise exampleSSA --> exampleOptimised
                , optimise basicBlockSSA --> basicBlockOptimised
                , optimise max2SSA --> max2Optimised
                , sort (execFun (optimise loopSSA) [4])
                    --> sort [("$return",40),("i1",0),("sum1",40),("i2",0),("sum2",40),
                              ("m0",2),("b1",2),("a0",1),("i0",4),("n",4)]
                ]

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
