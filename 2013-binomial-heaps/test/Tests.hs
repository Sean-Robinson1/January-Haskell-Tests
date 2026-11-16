import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion)
import IC.Exact ((-->))

import BinomialHeaps

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the sample trees/heaps (t1..t8, h1..h7) in the template.
-- Note: the spec calls the first accessor 'value'; the template names it 'key'.

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "binomial-heaps"
  [ testGroup "key/rank/children" (numberedTests accessorTests)
  , testGroup "combineTrees" (numberedTests combineTreesTests)
  , testGroup "extractMin" (numberedTests extractMinTests)
  , testGroup "mergeHeaps" (numberedTests mergeHeapsTests)
  , testGroup "insert" (numberedTests insertTests)
  , testGroup "deleteMin" (numberedTests deleteMinTests)
  , testGroup "binSort" (numberedTests binSortTests)
  , testGroup "toBinary" (numberedTests toBinaryTests)
  , testGroup "binarySum" (numberedTests binarySumTests)
  ]

accessorTests :: [Assertion]
accessorTests = [ key t4 --> 2
                , rank t7 --> 3
                , children t2 --> [Node 5 0 []]
                ]

combineTreesTests :: [Assertion]
combineTreesTests = [ combineTrees t5 t6 --> t7 ]

extractMinTests :: [Assertion]
extractMinTests = [ extractMin h3 --> 1 ]

mergeHeapsTests :: [Assertion]
mergeHeapsTests = [ mergeHeaps h4 h5 --> h6 ]

insertTests :: [Assertion]
insertTests = [ insert 7 [Node 4 0 []] --> [Node 4 1 [Node 7 0 []]]
              , insert 7 [t1] --> [Node 4 1 [Node 7 0 []]]
              ]

deleteMinTests :: [Assertion]
deleteMinTests = [ deleteMin h6 --> h7 ]

binSortTests :: [Assertion]
binSortTests = [ binSort "BinomialHeap" --> "BHaaeiilmnop" ]

toBinaryTests :: [Assertion]
toBinaryTests = [ toBinary h2 --> [1,1,0,0] ]

binarySumTests :: [Assertion]
binarySumTests = [ binarySum (toBinary h4) (toBinary h5) --> [1,0,0,1] ]

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
