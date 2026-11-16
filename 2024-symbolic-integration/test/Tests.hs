import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion)
import IC.Exact ((-->))

import Types
import Utilities
import Examples
import Int

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the polynomials/expressions in Examples.hs (p1..p5, e1..e16).
-- The spec shows most results via prettyPrint, so results are compared as
-- pretty-printed strings (polynomials are printed like prettyPrint does,
-- i.e. with zero terms removed). As the spec notes, simplify does not
-- give a unique normal form, so a mathematically correct answer may
-- occasionally print differently.

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "integration"
  [ testGroup "addP/mulP" (numberedTests addMulTests)
  , testGroup "sumP/prodP" (numberedTests sumProdTests)
  , testGroup "diffT/intT" (numberedTests termTests)
  , testGroup "diffP/intP" (numberedTests polyTests)
  , testGroup "diffE" (numberedTests diffETests)
  , testGroup "intE" (numberedTests intETests)
  ]

addMulTests :: [Assertion]
addMulTests = [ ppP (addP p2 p2) --> "[2x]"
              , ppP (addP p3 p4) --> "[2x^2 + x - 2]"
              , ppP (addP p5 [(0,0)]) --> "[2x^3 - 2x + 2]"
              , ppP (mulP p3 p4) --> "[8x^3 - 18x^2 + 13x - 3]"
              ]

sumProdTests :: [Assertion]
sumProdTests = [ ppP (sumP [[(0,0)]]) --> "[0]"
               , ppP (sumP [p1,p2,p3,p4,p5]) --> "[2x^3 + 2x^2 + 5]"
               , ppP (prodP [p3,p5]) --> "[4x^5 - 6x^4 - 2x^3 + 10x^2 - 8x + 2]"
               ]

termTests :: [Assertion]
termTests = [ diffT (1,0) --> (0,0)
            , diffT (2,3) --> (6,2)
            , intT (1,0) --> (1,1)
            , intT (2,3) --> (1/2,4)
            ]

polyTests :: [Assertion]
polyTests = [ ppP (diffP p3) --> "[4x - 3]"
            , ppP (intP p3) --> "[(2/3)x^3 + (-3/2)x^2 + x]"
            ]

diffETests :: [Assertion]
diffETests = [ pretty (simplifiedDiff e3) --> "[4x - 3]"
             , pretty (simplifiedDiff e10) --> "[24x^2 - 36x + 13]"
             , pretty (simplifiedDiff e11) --> "[-1] . [x]^-2 . log[x] + [x]^-2"
             ]

intETests :: [Assertion]
intETests = [ fmap pretty (simplifiedInt e3) --> Just "[(1/6)] . [4x^3 - 9x^2 + 6x]"
            , fmap pretty (simplifiedInt e6) --> Just "[(1/6)] . [3x^4 + 4x^3 - 15x^2 + 18x]"
            , fmap pretty (simplifiedInt e8) --> Just "[x] . ([-1] + log[x])"
            , fmap pretty (simplifiedInt e9) --> Just "log[x]"
            , fmap pretty (simplifiedInt e10) --> Just "[(1/2)] . [4x^4 - 12x^3 + 13x^2 - 6x + 1]"
            , fmap pretty (simplifiedInt e11) --> Just "[(1/2)] . (log[x])^2"
            , fmap pretty (simplifiedInt e12) --> Just "[2x^2 - 3x + 1] . ([-1] + log[2x^2 - 3x + 1])"
            , fmap pretty (simplifiedInt e13) --> Just "[(2/5)] . ([2x^2 - 3x + 1])^(5/2)"
            , fmap pretty (simplifiedInt e14) --> Just "[(2/25)] . ([5] . [2x^2 - 3x + 1])^(5/2)"
            , fmap pretty (simplifiedInt e15) --> Just "[(1/3)] . [x^3 - 3x] . ([-1] + log[x^3 - 3x])"
            , fmap pretty (simplifiedInt e16) --> Nothing
            ]

-- Test helpers

-- Pretty-prints a polynomial the way prettyPrint does (zero terms removed,
-- "[0]" if nothing is left).
ppP :: Polynomial -> String
ppP p
  | null p'   = "[0]"
  | otherwise = pretty p'
  where
    p' = filter ((/= 0) . fst) p

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
