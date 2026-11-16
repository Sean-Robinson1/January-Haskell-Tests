import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion)
import IC.Exact ((-->))

import Data.List (sort)

import SuffixTrees

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the example strings/trees (s1, s2, t1, t2) in the template.
-- Where the spec says the order of results is unimportant, results are
-- sorted before comparison.

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "suffix-trees"
  [ testGroup "isPrefix" (numberedTests isPrefixTests)
  , testGroup "removePrefix" (numberedTests removePrefixTests)
  , testGroup "suffixes" (numberedTests suffixesTests)
  , testGroup "isSubstring" (numberedTests isSubstringTests)
  , testGroup "findSubstrings" (numberedTests findSubstringsTests)
  , testGroup "getIndices" (numberedTests getIndicesTests)
  , testGroup "findSubstrings'" (numberedTests findSubstrings'Tests)
  , testGroup "partition (bonus)" (numberedTests partitionTests)
  , testGroup "insert/buildTree" (numberedTests buildTreeTests)
  , testGroup "longestRepeatedSubstring" (numberedTests lrsTests)
  ]

isPrefixTests :: [Assertion]
isPrefixTests = [ isPrefix "has" "haskell" --> True
                , isPrefix "" "haskell" --> True
                , isPrefix "haskell" "has" --> False
                , isPrefix "ask" "haskell" --> False
                ]

removePrefixTests :: [Assertion]
removePrefixTests = [ removePrefix "ja" "java" --> "va"
                    , removePrefix "" "java" --> "java"
                    ]

suffixesTests :: [Assertion]
suffixesTests = [ suffixes "perl" --> ["perl","erl","rl","l"] ]

isSubstringTests :: [Assertion]
isSubstringTests = [ isSubstring "ho" "python" --> True
                   , isSubstring "thong" "python" --> False
                   ]

findSubstringsTests :: [Assertion]
findSubstringsTests = [ sort (findSubstrings "an" "banana") --> [1,3]
                      , sort (findSubstrings "s" "mississippi") --> [2,3,5,6]
                      ]

getIndicesTests :: [Assertion]
getIndicesTests = [ sort (getIndices (Node [("",Leaf 4),("",Leaf 1)])) --> [1,4]
                  , sort (getIndices t1) --> [0,1,2,3,4,5]
                  ]

findSubstrings'Tests :: [Assertion]
findSubstrings'Tests = [ sort (findSubstrings' "an" t1) --> [1,3]
                       , sort (findSubstrings' "s" t2) --> [2,3,5,6]
                       -- Section 2 worked examples on "mississippi"
                       , sort (findSubstrings' "p" t2) --> [8,9]
                       , sort (findSubstrings' "iss" t2) --> [1,4]
                       , sort (findSubstrings' "ssify" t2) --> []
                       ]

partitionTests :: [Assertion]
partitionTests = [ partition "happy" "haskell" --> ("ha","ppy","skell") ]

-- The order of subtrees in a node is not significant, so trees are
-- compared after putting every node's subtrees into a canonical order.
buildTreeTests :: [Assertion]
buildTreeTests = [ canon (buildTree s1) --> canon t1
                 , canon (buildTree s2) --> canon t2
                 , sort (findSubstrings' "an" (buildTree s1)) --> sort (findSubstrings' "an" t1)
                 , sort (findSubstrings' "s" (buildTree s2)) --> sort (findSubstrings' "s" t2)
                 ]

lrsTests :: [Assertion]
lrsTests = [ longestRepeatedSubstring t2 --> "issi" ]

-- Test helpers

data Canon = CLeaf Int | CNode [(String, Canon)]
  deriving (Eq, Ord, Show)

canon :: SuffixTree -> Canon
canon (Leaf i)  = CLeaf i
canon (Node ts) = CNode (sort [ (a, canon t) | (a, t) <- ts ])

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
