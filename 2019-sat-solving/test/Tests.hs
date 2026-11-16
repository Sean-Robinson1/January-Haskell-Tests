import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion)
import IC.Exact ((-->))

import Data.List (sort)

import Types
import TestData
import SOL

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the test data in TestData.hs (f1..f9 with their CNF forms c1..c9,
-- cnf0..cnf4 with their flattened representations cnf0Rep..cnf4Rep).
-- Where the spec says the order of elements in lists/sublists is
-- unimportant, results are put in a canonical (sorted) order first.

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "sat"
  [ testGroup "lookUp" (numberedTests lookUpTests)
  , testGroup "vars" (numberedTests varsTests)
  , testGroup "idMap" (numberedTests idMapTests)
  , testGroup "toNNF" (numberedTests toNNFTests)
  , testGroup "toCNF" (numberedTests toCNFTests)
  , testGroup "flatten" (numberedTests flattenTests)
  , testGroup "propUnits" (numberedTests propUnitsTests)
  , testGroup "dp" (numberedTests dpTests)
  , testGroup "allSat (bonus)" (numberedTests allSatTests)
  ]

lookUpTests :: [Assertion]
lookUpTests = [ lookUp 3 [(2,1),(3,8)] --> (8 :: Int) ]

varsTests :: [Assertion]
varsTests = [ vars f1 --> ["a"]
            , vars cnf3 --> ["a","b","c","d","e","f","g"]
            ]

idMapTests :: [Assertion]
idMapTests = [ idMap cnf3 --> [("a",1),("b",2),("c",3),("d",4),("e",5),("f",6),("g",7)] ]

toNNFTests :: [Assertion]
toNNFTests = [ toNNF f1 --> Var "a"
             , toNNF f6 --> (Not b `And` (Not a `Or` c))
             , toNNF f8 --> ((a `And` (Not b `And` Not c)) `Or` Not d)
             ]

toCNFTests :: [Assertion]
toCNFTests = [ toCNF f4 --> (a `Or` b)
             , toCNF f6 --> (Not b `And` (Not a `Or` c))
             , toCNF f8 --> ((a `Or` Not d) `And` ((Not b `Or` Not d) `And` (Not c `Or` Not d)))
             ] ++
             [ toCNF fi --> ci
             | (fi, ci) <- [ (f1, c1), (f2, c2), (f3, c3), (f4, c4), (f5, c5)
                           , (f6, c6), (f7, c7), (f8, c8), (f9, c9) ] ]

flattenTests :: [Assertion]
flattenTests = [ canon (flatten c3) --> canon [[1],[2]]
               , canon (flatten c4) --> canon [[1,2]]
               , canon (flatten cnf3) --> canon [[-3,-7],[2,3,5],[1,-2],[1,-5],[-1,-4],[3,4,6],[-1,-6],[7]]
               -- Table 1 (flattened representations)
               , canon (flatten (toCNF f1)) --> canon [[1]]
               , canon (flatten (toCNF f6)) --> canon [[-2],[-1,3]]
               , canon (flatten (toCNF f8)) --> canon [[1,-4],[-2,-4],[-3,-4]]
               ] ++
               -- (cnf0Rep has no type signature in TestData, so it defaults to [[Integer]])
               [ canon (flatten cnf0) --> canon (map (map fromInteger) cnf0Rep) ] ++
               [ canon (flatten cnf) --> canon rep
               | (cnf, rep) <- [ (cnf1, cnf1Rep), (cnf2, cnf2Rep)
                               , (cnf3, cnf3Rep), (cnf4, cnf4Rep) ] ]

propUnitsTests :: [Assertion]
propUnitsTests
  = [ canonPair (propUnits []) --> ([], [])
    , canonPair (propUnits cnf1Rep) --> canonPair (cnf1Rep, [])
    , canonPair (propUnits cnf2Rep) --> canonPair ([[2,5],[3,-2],[3,-5],[-3,-7],[7,6],[-3,6]],[4,-1])
    ]

dpTests :: [Assertion]
dpTests = [ canon (dp cnf1Rep) --> canon [[1,2,3]]
          , canon (dp cnf2Rep) --> canon [[4,-1,2,3,-7,6],[4,-1,-2,5,3,-7,6]]
          , canon (dp cnf3Rep) --> []
          , length (dp (queensCNFRep 8)) --> 92
          ]

allSatTests :: [Assertion]
allSatTests
  = [ sort (allSat cnf1) --> [[("a",True),("b",True),("c",True)]]
    , sort (allSat cnf2)
        --> sort [[("a",False),("b",True),("c",True),("d",True),("e",False),("f",True),("g",False)],
                  [("a",False),("b",True),("c",True),("d",True),("e",True),("f",True),("g",False)],
                  [("a",False),("b",False),("c",True),("d",True),("e",True),("f",True),("g",False)]]
    , allSat cnf3 --> []
    , sort (allSat cnf4)
        --> sort [[("a",False),("b",True),("c",True),("d",False)],
                  [("a",True),("b",False),("c",False),("d",True)]]
    ]

-- Test helpers

canon :: [[Int]] -> [[Int]]
canon = sort . map sort

canonPair :: (CNFRep, [Int]) -> (CNFRep, [Int])
canonPair (cnf, us) = (canon cnf, sort us)

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
