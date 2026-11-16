module Int where

-- NOTE: The original template for this test (Int.hs) is not published on
-- the website; only Types.hs, Utilities.hs and Examples.hs are. This file is
-- a RECONSTRUCTION from the specification (spec/spec.pdf): it contains the
-- type signatures of the functions you are asked to define (left as
-- undefined) and the helper functions the spec says are "defined in the
-- template" (toExpr, isConstant, simplifiedDiff, printDiff, simplifiedInt,
-- printInt).

import Data.Maybe

import Types
import Utilities
import Examples

--------------------------------------------------------------------
-- Given (as described in the specification)

toExpr :: Rational -> Expr
toExpr n = P [(n, 0)]

isConstant :: Expr -> Bool
isConstant (P [(_, 0)]) = True
isConstant _ = False

simplifiedDiff :: Expr -> Expr
simplifiedDiff = simplify . diffE

printDiff :: Expr -> IO ()
printDiff = prettyPrint . simplifiedDiff

simplifiedInt :: Expr -> Maybe Expr
simplifiedInt = fmap simplify . intE

printInt :: Expr -> IO ()
printInt e = maybe (putStrLn "Fail") prettyPrint (simplifiedInt e)

--------------------------------------------------------------------
-- Part I

addP :: Polynomial -> Polynomial -> Polynomial
addP
  = undefined

mulP :: Polynomial -> Polynomial -> Polynomial
mulP
  = undefined

sumP :: [Polynomial] -> Polynomial
sumP
  = undefined

prodP :: [Polynomial] -> Polynomial
prodP
  = undefined

diffT :: Term -> Term
diffT
  = undefined

intT :: Term -> Term
intT
  = undefined

diffP :: Polynomial -> Polynomial
diffP
  = undefined

intP :: Polynomial -> Polynomial
intP
  = undefined

--------------------------------------------------------------------
-- Part II

diffE :: Expr -> Expr
diffE
  = undefined

--------------------------------------------------------------------
-- Part III

intE :: Expr -> Maybe Expr
intE
  = undefined

-- Optional helper suggested by the specification.
applyICR :: Expr -> Expr -> Maybe Expr
applyICR
  = undefined
