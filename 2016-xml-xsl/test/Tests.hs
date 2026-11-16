import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion)
import IC.Exact ((-->))

import Exam

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the test data in the template (s1..s3, x1..x3, casablanca, films,
-- xsl1..xsl9 and their parsed versions, filmsXSL, composersXSL).
-- The expected outputs filmTable.html and composerList.html were
-- downloaded with the test and live in test/golden/.

main :: IO ()
main = do
  filmTable    <- readFile "test/golden/filmTable.html"
  composerList <- readFile "test/golden/composerList.html"
  defaultMain (tests filmTable composerList)

tests :: String -> String -> TestTree
tests filmTable composerList = testGroup "xml"
  [ testGroup "skipSpace" (numberedTests skipSpaceTests)
  , testGroup "getAttribute" (numberedTests getAttributeTests)
  , testGroup "getChildren" (numberedTests getChildrenTests)
  , testGroup "getChild" (numberedTests getChildTests)
  , testGroup "addChild" (numberedTests addChildTests)
  , testGroup "getValue" (numberedTests getValueTests)
  , testGroup "addText" (numberedTests addTextTests)
  , testGroup "popAndAdd" (numberedTests popAndAddTests)
  , testGroup "parseAttributes" (numberedTests parseAttributesTests)
  , testGroup "parse" (numberedTests parseTests)
  , testGroup "expandXSL" (numberedTests (expandXSLTests filmTable composerList))
  ]

skipSpaceTests :: [Assertion]
skipSpaceTests = [ skipSpace "\n \n\nsome \n \n text" --> "some \n \n text" ]

getAttributeTests :: [Assertion]
getAttributeTests = [ getAttribute "x" x2 --> "1"
                    , getAttribute "x" (Text "t") --> ""
                    ]

getChildrenTests :: [Assertion]
getChildrenTests = [ getChildren "b" x2 --> [Element "b" [] [Text "A"],Element "b" [] [Text "B"]]
                   , getChildren "c" x2 --> []
                   ]

getChildTests :: [Assertion]
getChildTests = [ getChild "b" x2 --> Element "b" [] [Text "A"]
                , getChild "c" x2 --> Text ""
                ]

addChildTests :: [Assertion]
addChildTests = [ addChild (Text "B") (Element "a" [] [Text "A"]) --> Element "a" [] [Text "A",Text "B"] ]

getValueTests :: [Assertion]
getValueTests = [ getValue x1 --> Text "A"
                , getValue x2 --> Text "AB"
                ]

-- Section 3.3 worked example (rule 2c steps)
addTextTests :: [Assertion]
addTextTests
  = [ addText "\n  " [Element "film" [("title","Casablanca")] [], sentinel]
        --> [Element "film" [("title","Casablanca")] [Text "\n  "], sentinel]
    , addText "Michael Curtiz" [Element "director" [] [], Element "film" [("title","Casablanca")] [Text "\n  "], sentinel]
        --> [Element "director" [] [Text "Michael Curtiz"], Element "film" [("title","Casablanca")] [Text "\n  "], sentinel]
    ]

popAndAddTests :: [Assertion]
popAndAddTests = [ popAndAdd [x1, Element "ab" [("a","1")] [], sentinel]
                     --> [Element "ab" [("a","1")] [Element "a" [] [Text "A"]],Element "" [] []] ]

parseAttributesTests :: [Assertion]
parseAttributesTests = [ parseAttributes "x=\"7\">rest of text" --> ([("x","7")],"rest of text")
                       , parseAttributes "a = \"0\" b = \"1\" >rest of text" --> ([("a","0"),("b","1")],"rest of text")
                       ]

parseTests :: [Assertion]
parseTests = [ parse s1 --> Element "a" [] [Text "A"]
             , showXML (parse s2) --> "<a x=\"1\"><b>A</b><b>B</b></a>"
             , parse s1 --> x1
             , parse s2 --> x2
             , parse s3 --> x3
             , parse casablanca --> casablancaParsed
             , parse films --> filmsParsed
             ] ++
             [ parse s --> x
             | (s, x) <- [ (xsl1, xsl1Parsed), (xsl2, xsl2Parsed), (xsl3, xsl3Parsed)
                         , (xsl4, xsl4Parsed), (xsl5, xsl5Parsed), (xsl6, xsl6Parsed)
                         , (xsl7, xsl7Parsed), (xsl8, xsl8Parsed), (xsl9, xsl9Parsed) ] ]

expandXSLTests :: String -> String -> [Assertion]
expandXSLTests filmTable composerList
  = [ expandXSL xsl1Parsed x1 --> [Text ""]
    , expandXSL xsl1Parsed x3 --> [Text "text1"]
    , expandXSL xsl2Parsed x3 --> [Text "text1text2"]
    , expandXSL xsl4Parsed x3 --> [Text "att1"]
    , expandXSL xsl5Parsed x3 --> [Text "text1"]
    , showXMLs (expandXSL xsl6Parsed x3) --> "<t1><t2>Preamble</t2><t3>text1</t3></t1>"
    , expandXSL xsl7Parsed x3 --> [Text "att1",Text "att2",Text "att3"]
    , showXMLs (expandXSL xsl8Parsed x3) --> "<t>text1</t><t>text3</t>"
    , showXMLs (expandXSL xsl9Parsed x3) --> "<t1></t1><t1></t1>"
    -- Section 4.1 examples
    , expandXSL (Element "value-of" [("select","filmlist/film/year")] []) filmsParsed --> [Text "1954"]
    , expandXSL (Element "value-of" [("select","filmlist/film/duration")] []) filmsParsed --> [Text "228"]
    -- Expected output files (filmTable.html, composerList.html)
    , showXMLs (expandXSL (parse filmsXSL) filmsParsed) --> filmTable
    , showXMLs (expandXSL (parse composersXSL) filmsParsed) --> composerList
    ]

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
