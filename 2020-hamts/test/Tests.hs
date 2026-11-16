import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion)
import IC.Exact ((-->))

import Data.List (sort)

import Types
import HashFunctions
import Examples
import Tries hiding (trieSize, binCount, meanBinSize)

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the example tries in Examples.hs (figure, figureHashed, insT1..insT4,
-- buildT1, buildT2). The order of elements within a Leaf is unimportant,
-- so leaves are sorted before tries are compared.

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "hamts"
  [ testGroup "countOnes" (numberedTests countOnesTests)
  , testGroup "countOnesFrom" (numberedTests countOnesFromTests)
  , testGroup "getIndex" (numberedTests getIndexTests)
  , testGroup "replace" (numberedTests replaceTests)
  , testGroup "insertAt" (numberedTests insertAtTests)
  , testGroup "sumTrie" (numberedTests sumTrieTests)
  , testGroup "member" (numberedTests memberTests)
  , testGroup "insert" (numberedTests insertTests)
  , testGroup "buildTrie" (numberedTests buildTrieTests)
  ]

countOnesTests :: [Assertion]
countOnesTests = [ countOnes 0 --> 0
                 , countOnes 65219 --> 11
                 ]

countOnesFromTests :: [Assertion]
countOnesFromTests = [ countOnesFrom 0 88 --> 0
                     , countOnesFrom 3 15 --> 3
                     ]

getIndexTests :: [Assertion]
getIndexTests = [ getIndex 53767 0 4 --> 7
                , getIndex 53767 3 4 --> 13
                , getIndex 53767 1 8 --> 210
                ]

replaceTests :: [Assertion]
replaceTests = [ replace 0 "trie" 'b' --> "brie"
               , replace 3 "trie" 'p' --> "trip"
               ]

insertAtTests :: [Assertion]
insertAtTests = [ insertAt 3 'p' "trie" --> "tripe"
                , insertAt 4 's' "trie" --> "tries"
                ]

-- trieSize/binCount/meanBinSize are the (commented-out) definitions from
-- the template, reproduced here in terms of sumTrie.
sumTrieTests :: [Assertion]
sumTrieTests = [ sumTrie (const 1) length empty --> 0
               , trieSize empty --> 0
               , sumTrie (const 1) (const 1) figure --> 4
               , binCount figure --> 4
               , meanBinSize figure --> 1.25
               , meanBinSize figureHashed --> 1.0
               ]

memberTests :: [Assertion]
memberTests = [ member 12 12 figure 4 --> False
              , member 73 73 figure 4 --> True
              , member 206 (hash 206) figureHashed 4 --> True
              ]

insertTests :: [Assertion]
insertTests = [ canon t1 --> canon insT1
              , canon t2 --> canon insT2
              , canon t3 --> canon insT3
              , canon t6 --> canon insT4
              ]
  where
    t1 = insert id 3 4 2521 empty
    t2 = insert id 3 4 1830 t1
    t3 = insert id 3 4 729 t2
    t4 = insert hash 3 4 729 empty
    t5 = insert hash 3 4 2521 t4
    t6 = insert hash 3 4 206 t5

buildTrieTests :: [Assertion]
buildTrieTests = [ canon (buildTrie id 3 4 [1..3]) --> canon buildT1
                 , canon (buildTrie id 3 4 [n * 256 | n <- [1..5]]) --> canon buildT2
                 , canon (buildTrie id 3 4 [73,206,729,1830,2521]) --> canon figure
                 , canon (buildTrie hash 3 4 [73,206,729,1830,2521]) --> canon figureHashed
                 ]

-- Test helpers

canon :: Trie -> Trie
canon (Leaf vs)    = Leaf (sort vs)
canon (Node bv ns) = Node bv (map canonSub ns)
  where
    canonSub (SubTrie t) = SubTrie (canon t)
    canonSub term        = term

trieSize :: Trie -> Int
trieSize t = sumTrie (const 1) length t

binCount :: Trie -> Int
binCount t = sumTrie (const 1) (const 1) t

meanBinSize :: Trie -> Double
meanBinSize t = fromIntegral (trieSize t) / fromIntegral (binCount t)

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
