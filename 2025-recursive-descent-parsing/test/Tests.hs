import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, Assertion, assertBool)
import IC.Exact ((-->))

import Types
import Examples
import Parser

-- Tests derived from the examples in the specification (spec/spec.pdf)
-- and the token lists / program strings in Examples.hs. Where the spec
-- accepts either of two errors, both are accepted.

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "parsing"
  [ testGroup "checkTok" (numberedTests checkTokTests)
  , testGroup "parseAtom" (numberedTests parseAtomTests)
  , testGroup "parseStmt" (numberedTests parseStmtTests)
  , testGroup "parseTerm" (numberedTests parseTermTests)
  , testGroup "parseBlock" (numberedTests parseBlockTests)
  , testGroup "parse" (numberedTests parseTests)
  , testGroup "parentheses (Part III)" (numberedTests parenTests)
  , testGroup "while loops (Part III)" (numberedTests whileTests)
  ]

checkTokTests :: [Assertion]
checkTokTests = [ checkTok Plus [Plus,Nat 4,RBrace] --> Right [Nat 4,RBrace]
                , checkTok Plus [Minus,Nat 4,RBrace] --> Left (Unexpected (Just Minus) Plus)
                , checkTok Plus [] --> Left (Unexpected Nothing Plus)
                ]

parseAtomTests :: [Assertion]
parseAtomTests = [ parseAtom atomToks1 --> Right ([Plus,Ident "y",RBrace],Var "x")
                 , parseAtom atomToks2 --> Right ([Plus,Ident "y",RBrace],Val 2)
                 , parseAtom atomToks3 --> Right ([Plus,Ident "y",RBrace],Val (-2))
                 , parseAtom atomToks4 --> Left (ExprNotFound (Just Plus))
                 ]

parseStmtTests :: [Assertion]
parseStmtTests = [ parseStmt asgnToks1 --> Right ([RBrace],Asgn "x" (Val 1))
                 , parseStmt asgnToks2 --> Right ([],Asgn "x" (Var "y"))
                 , parseStmt asgnToks3 --> Left (StmtNotFound (Just (Nat 4)))
                 , parseStmt asgnToks4 --> Left (ExprNotFound (Just RBrace))
                 , parseStmt asgnToks5 `oneOf` [ Left (Unexpected (Just Times) Eq)
                                               , Left (StmtNotFound (Just (Ident "x"))) ]
                 ]

parseTermTests :: [Assertion]
parseTermTests = [ parseTerm termToks1 --> Right ([RBrace],Mul (Var "x") (Val 3))
                 , parseTerm termToks2 --> Right ([],Mul (Mul (Var "x") (Var "y")) (Val 2))
                 , parseTerm termToks3 --> Left (ExprNotFound (Just Semi))
                 , parseTerm termToks4 --> Left (ExprNotFound Nothing)
                 ]

parseBlockTests :: [Assertion]
parseBlockTests = [ parseBlock blockToks1 --> Right ([],[Asgn "y" (Var "x")])
                  , parseBlock blockToks2 --> Right ([],[Asgn "x" (Val 4),Asgn "y" (Var "x")])
                  , parseBlock blockToks3 --> Left (ExprNotFound (Just RParen))
                  , parseBlock blockToks4 `oneOf` [ Left (StmtNotFound (Just (Ident "x")))
                                                  , Left (Unexpected (Just Times) Eq) ]
                  , parseBlock blockToks5 --> Left (StmtNotFound Nothing)
                  ]

parseTests :: [Assertion]
parseTests = [ parse progStr1 --> Right [Asgn "res1" (Val 0)]
             , parse progStr2 --> Right [Asgn "v1" (Val 1),Asgn "v2" (Val 2),
                                         Asgn "res1" (Add (Var "v1") (Mul (Var "v2") (Val 3)))]
             , parse progStr3 --> Left (BadChar '?')
             , parse progStr4 --> Left (StmtNotFound (Just (Nat 4)))
             , parse progStr5 --> Left (ExprNotFound (Just LBrace))
             , parse progStr6 --> Left (UnparsedInput [Ident "res1",Eq,Nat 2])
             ]

parenTests :: [Assertion]
parenTests = [ parseAtom parenToks1 --> Right ([],Var "x")
             , parseAtom parenToks2 --> Right ([],Mul (Var "x") (Var "y"))
             , parseExpr parenToks3 --> Right ([],Mul (Var "x") (Add (Val 2) (Var "y")))
             , parseExpr parenToks4 --> Left (ExprNotFound (Just RParen))
             , parseExpr parenToks5 --> Left (Unexpected Nothing RParen)
             ]

whileTests :: [Assertion]
whileTests = [ parse fact --> factParse
             , parse badFact1 --> Left (Unexpected (Just LParen) LBrace)
             , parse badFact2 --> Left (StmtNotFound (Just RBrace))
             , parse badFact3 --> Left (Unexpected (Just (Ident "acc")) RBrace)
             ]

-- Test helpers

oneOf :: (Eq a, Show a) => a -> [a] -> Assertion
oneOf actual allowed
  = assertBool ("expected one of: " ++ show allowed ++ "\n but got: " ++ show actual)
               (actual `elem` allowed)

numberedTests :: [Assertion] -> [TestTree]
numberedTests = zipWith (\n -> testCase ("#" ++ show n)) ([1..] :: [Integer])
