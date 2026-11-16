import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion, assertBool)
import IC.Exact ((-->))

import Data.List (sort, sortOn)

import DecisionTrees

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the test data in the template (fishingData, fishingData', fig1,
-- fig2, outlookPartition). Where the spec says the order of a result is
-- unimportant, it is sorted before comparison. Doubles are compared to
-- within 1e-9.

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "decision-trees"
  [ testGroup "allSame" (numberedTests allSameTests)
  , testGroup "remove" (numberedTests removeTests)
  , testGroup "lookUpAtt" (numberedTests lookUpAttTests)
  , testGroup "removeAtt" (numberedTests removeAttTests)
  , testGroup "addToMapping" (numberedTests addToMappingTests)
  , testGroup "buildFrequencyTable" (numberedTests buildFrequencyTableTests)
  , testGroup "nodes" (numberedTests nodesTests)
  , testGroup "evalTree" (numberedTests evalTreeTests)
  , testGroup "partitionData" (numberedTests partitionDataTests)
  , testGroup "buildTree" (numberedTests buildTreeTests)
  , testGroup "entropy" (numberedTests entropyTests)
  , testGroup "gain" (numberedTests gainTests)
  , testGroup "bestGainAtt" (numberedTests bestGainAttTests)
  ]

allSameTests :: [Assertion]
allSameTests = [ allSame ([] :: [Int]) --> True
               , allSame [9,9,9 :: Int] --> True
               , allSame "abc" --> False
               ]

removeTests :: [Assertion]
removeTests = [ remove 1 [(3,'a'),(1,'b'),(7,'a') :: (Int, Char)] --> [(3,'a'),(7,'a')]
              , remove 6 ([] :: [(Int, Char)]) --> []
              ]

lookUpAttTests :: [Assertion]
lookUpAttTests = [ lookUpAtt "temp" header (table !! 0) --> "hot" ]

removeAttTests :: [Assertion]
removeAttTests = [ removeAtt "temp" header (table !! 0) --> ["sunny","high","calm","bad"] ]

addToMappingTests :: [Assertion]
addToMappingTests = [ sortOn fst (addToMapping (1,'a') [(2,"b") :: (Int, String)]) --> [(1,"a"),(2,"b")]
                    , sortOn fst (addToMapping (5,'a') [(2,"b"),(5,"bcd") :: (Int, String)]) --> [(2,"b"),(5,"abcd")]
                    ]

buildFrequencyTableTests :: [Assertion]
buildFrequencyTableTests
  = [ sort (buildFrequencyTable result fishingData) --> sort [("good",9),("bad",5)]
    , sort (buildFrequencyTable outlook fishingData) --> sort [("sunny",5),("overcast",4),("rainy",5)]
    , sort (buildFrequencyTable outlook ([],[])) --> sort [("sunny",0),("overcast",0),("rainy",0)]
    ]

nodesTests :: [Assertion]
nodesTests = [ nodes fig1 --> 18
             , nodes fig2 --> 8
             ]

evalTreeTests :: [Assertion]
evalTreeTests = [ evalTree fig1 header (table !! 5) --> "bad"
                , evalTree fig2 header (table !! 4) --> "good"
                ]

partitionDataTests :: [Assertion]
partitionDataTests
  = [ partitionData fishingData outlook --> outlookPartition
    , fst (snd (partitionData fishingData outlook !! 1))
        --> [("temp",["hot","mild","cool"]),("humidity",["high","normal"]),
             ("wind",["windy","calm"]),("result",["good","bad"])]
    , snd (snd (partitionData fishingData outlook !! 1))
        --> [["hot","high","calm","good"],["cool","normal","windy","good"],
             ["mild","high","windy","good"],["hot","normal","calm","good"]]
    ]

buildTreeTests :: [Assertion]
buildTreeTests = [ buildTree fishingData result nextAtt --> fig1
                 -- fishingData' is the same table with the result in the second column
                 , buildTree fishingData' result nextAtt --> fig1
                 ]

entropyTests :: [Assertion]
entropyTests = [ entropy fishingData result ~= 0.9402859586706309
               , entropy fishingData temp ~= 1.5566567074628228
               , entropy (header, []) result ~= 0.0
               ]

gainTests :: [Assertion]
gainTests = [ gain fishingData outlook result ~= 0.2467498197744391
            , gain fishingData temp result ~= 2.9222565658954647e-2
            , gain fishingData humidity result ~= 0.15183550136234136
            , gain fishingData wind result ~= 4.812703040826927e-2
            ]

bestGainAttTests :: [Assertion]
bestGainAttTests = [ bestGainAtt fishingData result --> ("outlook",["sunny","overcast","rainy"])
                   , buildTree fishingData result bestGainAtt --> fig2
                   , buildTree fishingData' result bestGainAtt --> fig2
                   ]

-- Test helpers

infix 1 ~=
(~=) :: Double -> Double -> Assertion
actual ~= expected
  = assertBool ("expected: " ++ show expected ++ "\n but got: " ++ show actual)
               (abs (actual - expected) < 1e-9)

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
