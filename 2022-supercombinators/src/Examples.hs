module Examples where

import Types

-- Some useful predefined names...

f :: Exp
f   = Var "f"
g :: Exp
g   = Var "g"
h :: Exp
h   = Var "h"
w :: Exp
w   = Var "w"
x :: Exp
x   = Var "x"
y :: Exp
y   = Var "y"
z :: Exp
z   = Var "z"

add :: Exp
add = Var "+"
sub :: Exp
sub = Var "-"
mul :: Exp
mul = Var "*"
leq :: Exp
leq = Var "<="
ite :: Exp
ite = Var "ite"

-- A Num instance makes it easier to define test cases...

instance Num Exp where
  x + y = App (Var "+") [x, y]
  x - y = App (Var "-") [x, y]
  x * y = App (Var "*") [x, y]
  abs = undefined
  signum = undefined
  fromInteger = Const . fromInteger

-------------------------------------------------------------
-- Test expressions
-- eN' is the lambda-lifted version of eN

e1 :: Exp
e1 = Let [("f", Fun ["x"] (Let [("g", Fun ["y"] (y + x))] g))]
         (App f [3, 8])

e1' :: Exp
e1' = Let [("$f",Fun ["x"] (App (Var "$g") [Var "x"])),
           ("$g",Fun ["x","y"] (App (Var "+") [Var "y",Var "x"]))]
          (App (Var "$f") [Const 3,Const 8])

-- Version of e1 after calling modifyFunctions...
e1'' :: Exp
e1''
  = Let [("$f",Fun ["x"] (Let [("$g",Fun ["x","y"] (App (Var "+") [Var "y",Var "x"]))] 
                              (App (Var "$g") [Var "x"])))] 
        (App (Var "$f") [Const 3,Const 8])

e2 :: Exp
e2 = Let [("succ", Fun ["x"] (x + 1))]
         (App (Var "succ") [5])

e2' :: Exp
e2' = Let [("$succ",Fun ["x"] (App (Var "+") [Var "x",Const 1]))] 
          (App (Var "$succ") [Const 5])


e3 :: Exp
e3 = Let [("f", Fun ["x"] (App ite [App leq [x, 1],
                                    1,
                                    x * App f [x - 1]]))]
         (App f [6])

e4 :: Exp
e4 = Let [("x", 3),
          ("g", Fun ["y"] (y + x))]
          (App g [8])

e4' :: Exp
e4' = Let [("$g", Fun ["x", "y"] (App (Var "+") [Var "y",Var "x"]))] 
          (Let [("x",Const 3)] 
               (App (App (Var "$g") [Var "x"]) [Const 8]))

e5 :: Exp
e5 = Fun ["x", "y"] x

e6 :: Exp
e6 = x 

e7 :: Exp
e7 = App add [z]

e8 :: Exp
e8 = Fun ["x"] (x + y - z)

e9 :: Exp
e9 = Let [("g", Fun ["y"] (y + x))] (App g [1])

e10 :: Exp
e10 = Let [("x", y), ("g", Fun ["y"] (y + x))] z

e11 :: Exp
e11 = Let [("g", Fun ["y"] (y + x))] (App g [z])

e12 :: Exp
e12 = Let [("f", g),
           ("g", Fun ["x"] (App h [2 * x])),
           ("h", Fun ["x", "y"] (x * y + 1))]
          (Var "f")

e12' :: Exp
e12' = Let [("$g",Fun ["x"] (App (Var "$h") [App (Var "*") [Const 2,Var "x"]])),
            ("$h",Fun ["x","y"] (App (Var "+") [App (Var "*") [Var "x",Var "y"],Const 1]))] 
           (Let [("f",Var "$g")] (Var "f"))

e13 :: Exp
e13 = Let [("f1", e12)] (App (Var "f1") [7])

e13' :: Exp
e13' = Let [("$g",Fun ["x"] (App (Var "$h") [App (Var "*") [Const 2,Var "x"]])),
            ("$h",Fun ["x","y"] (App (Var "+") [App (Var "*") [Var "x",Var "y"],Const 1]))] 
           (Let [("f1",Let [("f",Var "$g")] (Var "f"))] 
                (App (Var "f1") [Const 7]))

e14 :: Exp
e14 = Let [("x", 1)] e12

e14' :: Exp
e14' = Let [("$g",Fun ["x"] (App (Var "$h") [App (Var "*") [Const 2,Var "x"]])),
            ("$h",Fun ["x","y"] (App (Var "+") [App (Var "*") [Var "x",Var "y"],Const 1]))] 
           (Let [("x",Const 1)] 
                (Let [("f",Var "$g")] (Var "f")))

e15 :: Exp
e15 = App e12 [1]

e15' :: Exp
e15' = Let [("$g",Fun ["x"] (App (Var "$h") [App (Var "*") [Const 2,Var "x"]])),
            ("$h",Fun ["x","y"] (App (Var "+") [App (Var "*") [Var "x",Var "y"],Const 1]))] 
           (App (Let [("f",Var "$g")] (Var "f")) [Const 1])

e16 :: Exp
e16 = Let [("f1", Fun ["x"] (App e12 [x]))] 2

e16' :: Exp
e16' = Let [("$f1",Fun ["x"] (App (Let [("f",Var "$g")] (Var "f")) [Var "x"])),
            ("$g",Fun ["x"] (App (Var "$h") [App (Var "*") [Const 2,Var "x"]])),
            ("$h",Fun ["x","y"] (App (Var "+") [App (Var "*") [Var "x",Var "y"],Const 1]))] 
           (Const 2)

e18 :: Exp
e18 = Let [("y", 1), ("z", 1)]
          (Let [("f", Fun ["x"] (App ite [App leq [x, y],
                                          Var "y",
                                          App g [x]])),
                ("g", Fun ["x"] (x * App f [x - Var "z"]))]
               (App f [6]))

e18' :: Exp
e18' = Let [("$f",Fun ["y","z","x"] 
                      (App (Var "ite") 
                           [App (Var "<=") [Var "x",Var "y"],
                            Var "y",
                            App (App (Var "$g") [Var "y",Var "z"]) [Var "x"]])),
            ("$g",Fun ["y","z","x"]
                      (App (Var "*") [Var "x",
                                      App (App (Var "$f") [Var "y",Var "z"]) 
                                          [App (Var "-") [Var "x",Var "z"]]]))] 
           (Let [("y",Const 1),("z",Const 1)] 
                (App (App (Var "$f") [Var "y",Var "z"]) [Const 6]))

e19 :: Exp
e19 = Let [("y", 1)]
          (Let [("z", 1),
                ("f", Fun ["x"] (App ite [App leq [x, y],
                                          Var "y",
                                          App g [x]])),
                ("g", Fun ["x"] (x * App f [x - Var "z"]))]
               (App f [6]))

e19' :: Exp
e19' = Let [("$f",Fun ["y","z","x"] 
                      (App (Var "ite") [App (Var "<=") [Var "x",Var "y"],
                                        Var "y",
                                        App (App (Var "$g") [Var "y",Var "z"]) 
                                            [Var "x"]])),(
             "$g",Fun ["y","z","x"] 
                      (App (Var "*") [Var "x",
                                      App (App (Var "$f") [Var "y",Var "z"]) 
                                          [App (Var "-") [Var "x",Var "z"]]]))] 
           (Let [("y",Const 1)] 
                (Let [("z",Const 1)] (App (App (Var "$f") [Var "y",Var "z"]) [Const 6])))

e20 :: Exp
e20 = Let [("x", z),
           ("y", x),
           ("z", 1)] 
          y

e21 :: Exp
e21 = Let [("z", 1)]
          (Let [("x", z),
                ("y", x)]
               y)


