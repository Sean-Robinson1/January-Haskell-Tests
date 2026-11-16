import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion)
import IC.Exact ((-->))

import Data.List (sortOn, nub)

import TypeInference

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the test cases in the template (Tables 1, 2 and 3: ex1..ex14,
-- u1a..u6b, sub1..sub6, type1..type14).

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "type-inference"
  [ testGroup "lookUp" (numberedTests lookUpTests)
  , testGroup "tryToLookUp" (numberedTests tryToLookUpTests)
  , testGroup "reverseLookUp" (numberedTests reverseLookUpTests)
  , testGroup "occurs" (numberedTests occursTests)
  , testGroup "inferType" (numberedTests inferTypeTests)
  , testGroup "applySub" (numberedTests applySubTests)
  , testGroup "unify" (numberedTests unifyTests)
  , testGroup "inferPolyType" (numberedTests inferPolyTypeTests)
  ]

lookUpTests :: [Assertion]
lookUpTests = [ lookUp "x" [("hello",1),("x",9),("dolly",1)] --> (9 :: Int)
              , lookUp "not" primTypes --> TFun TBool TBool
              ]

tryToLookUpTests :: [Assertion]
tryToLookUpTests = [ tryToLookUp "k" 0 [("hello",1),("x",9),("dolly",1)] --> (0 :: Int) ]

reverseLookUpTests :: [Assertion]
reverseLookUpTests = [ reverseLookUp (1 :: Int) [("hello",1),("x",9),("dolly",1)] --> ["hello","dolly"]
                     , reverseLookUp (TFun TInt (TFun TInt TBool)) primTypes --> [">","=="]
                     ]

occursTests :: [Assertion]
occursTests = [ occurs "x" (TVar "y") --> False
              , occurs "x" TBool --> False
              , occurs "x" (TFun TBool (TVar "x")) --> True
              ]

inferTypeTests :: [Assertion]
inferTypeTests = [ inferType e env --> t
    | (e, t) <- [ (ex1, type1), (ex2, type2), (ex3, type3), (ex4, type4)
                , (ex5, type5), (ex6, type6), (ex7, type7), (ex8, type8) ] ] ++
    -- Section 2.1 / Figure 1 worked example, with env [("x",TInt),("y",TInt)]
    [ inferType (App (App (Prim "+") (Id "y")) (Number 1)) xyEnv --> TInt
    , inferType (App (Prim "+") (Id "y")) xyEnv --> TFun TInt TInt
    , inferType sec21 xyEnv --> TInt
    ]
  where
    xyEnv = [("x", TInt), ("y", TInt)]
    sec21 = Cond (App (Prim "not") (App (App (Prim ">") (Id "x")) (Id "y")))
                 (Id "x")
                 (App (App (Prim "+") (Id "y")) (Number 1))

applySubTests :: [Assertion]
applySubTests = [ applySub s TInt --> TInt
                , applySub s (TFun TBool (TVar "a")) --> TFun TBool TBool
                , applySub s (TVar "c") --> TVar "c"
                ]
  where
    s = [("a",TBool),("b",TFun TBool TInt)]

-- The spec says the order of the substitution is unimportant for
-- correctness, so substitutions are compared after sorting by variable.
unifyTests :: [Assertion]
unifyTests = [ fmap (sortOn fst) (unify a b) --> fmap (sortOn fst) s
             | (a, b, s) <- [ (u1a, u1b, sub1), (u2a, u2b, sub2), (u3a, u3b, sub3)
                            , (u4a, u4b, sub4), (u5a, u5b, sub5), (u6a, u6b, sub6) ] ]

-- Type variable names are arbitrary ("the results agree up to an arbitrary
-- consistent renaming"), so types are compared after renaming variables
-- in order of first appearance.
inferPolyTypeTests :: [Assertion]
inferPolyTypeTests = [ rename (inferPolyType e) --> rename t
                     | (e, t) <- [ (ex9, type9), (ex10, type10), (ex11, type11)
                                 , (ex12, type12), (ex13, type13), (ex14, type14) ] ]

-- Test helpers

rename :: Type -> Type
rename t = go t
  where
    vs = nub (tvars t)
    go :: Type -> Type
    go (TVar v)    = TVar ("v" ++ show (length (takeWhile (/= v) vs)))
    go (TFun a b)  = TFun (go a) (go b)
    go other       = other
    tvars :: Type -> [String]
    tvars (TVar v)   = [v]
    tvars (TFun a b) = tvars a ++ tvars b
    tvars _          = []

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
