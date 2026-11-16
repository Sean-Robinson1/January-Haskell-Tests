import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion)
import IC.Exact ((-->))

import Data.List (sort, sortOn)

import Memoisation

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the predefined states, expressions, functions and executors in the
-- template. Where the spec says the order of elements is unimportant,
-- lists are sorted before comparison.

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "memoisation"
  [ testGroup "getValue" (numberedTests getValueTests)
  , testGroup "getLocals/getGlobals" (numberedTests localsGlobalsTests)
  , testGroup "assignArray" (numberedTests assignArrayTests)
  , testGroup "updateVar" (numberedTests updateVarTests)
  , testGroup "applyOp" (numberedTests applyOpTests)
  , testGroup "bindArgs" (numberedTests bindArgsTests)
  , testGroup "eval" (numberedTests evalTests)
  , testGroup "executeBlock" (numberedTests executeBlockTests)
  , testGroup "translate" (numberedTests translateTests)
  ]

getValueTests :: [Assertion]
getValueTests = [ getValue "x" sampleState --> I 5 ]

localsGlobalsTests :: [Assertion]
localsGlobalsTests = [ getLocals sampleState --> [("x",(Local,I 5))]
                     , getGlobals sampleState --> [("y",(Global,I 2)),("a",(Global,A [(0,4),(1,2),(2,7)]))]
                     ]

assignArrayTests :: [Assertion]
assignArrayTests = [ sortArray (assignArray (getValue "a" sampleState) (I 2) (I 1)) --> sortArray (A [(2,1),(0,4),(1,2)]) ]

updateVarTests :: [Assertion]
updateVarTests = [ updateVar ("x", I 6) sampleState
                     --> [("x",(Local,I 6)),("y",(Global,I 2)),("a",(Global,A [(0,4),(1,2),(2,7)]))]
                 , sortOn fst (updateVar ("z", I 3) [("g", (Global, I 8))])
                     --> [("g",(Global,I 8)),("z",(Local,I 3))]
                 ]

applyOpTests :: [Assertion]
applyOpTests = [ applyOp Add (I 6) (I (-2)) --> I 4
               , applyOp Mul (I 3) (I 4) --> I 12
               , applyOp Less (I 7) (I 0) --> I 0
               , applyOp Equal (I 2) (I 2) --> I 1
               , applyOp Index (A [(1,1),(0,3)]) (I 0) --> I 3
               , applyOp Index (A [(1,1),(0,3)]) (I 2) --> I 0
               ]

bindArgsTests :: [Assertion]
bindArgsTests = [ bindArgs ["x", "a"] [I 6, A [(1,1),(0,3)]] --> [("x",(Local,I 6)),("a",(Local,A [(1,1),(0,3)]))] ]

evalTests :: [Assertion]
evalTests = [ eval e1 [] sampleState --> I 1
            , eval e2 [] sampleState --> I 2
            , eval e3 [] sampleState --> I 7
            , eval e4 [] sampleState --> I 5
            , eval e5 [fib] sampleState --> I 8
            ]

executeBlockTests :: [Assertion]
executeBlockTests
  = [ executeBlock [Call "s" "sumA'" [sampleArray, intToExp 3]] [] [sumA'] [] --> [("s",(Local,I 22))]
    , execSumA' [9,5,7,1] 3 --> [("s",(Local,I 22))]
    , executeBlock [Call "s" "sumA'" [sampleArray, intToExp 3]] [] [sumA'] [("s", (Global, I 0))]
        --> [("s",(Global,I 22))]
    , execGlobalSumA' [9,5,7,1] 3 --> [("s",(Global,I 22))]
    -- execFibM 35 (Section 5.3.2): f is bound to fib 35 and the memo tables are filled
    , lookup "f" (execFibM 35) --> Just (Local, I 9227465)
    , fmap sortTagged (lookup "fibTab" (execFibM 35)) --> Just (Global, A [ (n, fibH n) | n <- [1..34] ])
    , fmap sortTagged (lookup "fibPres" (execFibM 35)) --> Just (Global, A [ (n, 1) | n <- [1..34] ])
    ]

-- The generated variable names may differ from those in fibM, so the
-- translated procedure is checked by running it in place of fibM.
translateTests :: [Assertion]
translateTests
  = [ lookup "f" (executeBlock [Call "f" "fibM" [intToExp 35]] [] [fibMGenerator, fibManager] fibState)
        --> Just (Local, I 9227465)
    ]

-- Test helpers

sortArray :: Value -> Value
sortArray (A xs) = A (sort xs)
sortArray v      = v

sortTagged :: (Scope, Value) -> (Scope, Value)
sortTagged (s, v) = (s, sortArray v)

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
