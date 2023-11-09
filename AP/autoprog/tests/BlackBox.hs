-- Sample black-box test suite. Feel free to adapt, or start from scratch.

-- Do NOT import from your ModImpl files here. These tests should work with
-- any implementation of the AutoProg APIs. Put any white-box tests in
-- suite1/WhiteBox.hs.
import Defs
import Parser
import Resolver
import Coder

import Test.Tasty
import Test.Tasty.HUnit

errorTest :: String -> IO ()
errorTest s = case parseStringType s of
      Left e -> return ()  -- any message is OK
      Right p -> assertFailure $ "Unexpected parse: " ++ show p

main :: IO ()
main = defaultMain $ localOption (mkTimeout 1000000) tests

tests = testGroup "All tests" [testGroup "Minimal tests" [
  testGroup "Parser" [
    testCase "...Type" $
      parseStringType "a -> a" @?= Right pt0,
    testCase "...TDeclz" $
      parseStringTDeclz "type T a = a -> a" @?= Right [td0]
  ],
  testGroup "Resolver" [
    testCase "resolve" $
      resolve tce0 (\x -> return $ STVar (x++"'")) pt0 @?= Right st0,
    testCase "declare" $
      do tce <- declare [td0]
         tf <- case lookup "T" tce of Just tf -> return tf; _ -> Left "no T"
         tf [STVar "a'"]
      @?= Right st0
  ],
  testGroup "Coder" [
    testCase "pick" $
      do n <- pick [0,3]
         if n > 0 then return n
         else do m <- pick [4,0]
                 if m > 0 then return m else pick []
      @?= tr0,
    testCase "solutions" $
      solutions tr0 10 Nothing @?= [3,4],
    testCase "produce" $
      do e <- dfs (produce [] st0)
         return $ case e of
                    Lam x (Var x') | x' == x -> e0
                    _ -> e
      @?= [e0]
    ]],
  testGroup "My Parser Tests" [
    testCase "Type Combination 1" $
      parseStringType "(a -> a, F a)" @?= Right pt1,
    testCase "Type Combination 2" $
      parseStringType "(F a) -> (a)" @?= Right pt2,
    testCase "Right associativity of (->)" $
      parseStringType "x->y->z" @?= Right pt3,
    testCase "Reserved Keyword Variabel Name" $
      errorTest "(type, a)",
    testCase "Reserved Keyword Constructor Name" $
      parseStringType "(Type, a)" @?= Right pt4,
    testCase "Reserved Haskell Keyword Variable Name" $
      parseStringType "(let, a)" @?= Right pt5,
    testCase "Type Precedence" $
      parseStringType "F a -> a" @?= Right pt6,
    testCase "Type Comments" $
      parseStringType "F {-Comment here-} a" @?= Right pt7,
    testCase "Type Empty Comment" $
      parseStringType "F{--}a" @?= Right pt8,
    testCase "Type Newline and Special Chars Comment" $
      parseStringType "F{-comment\n   hejæøå'`^~ _,- }.\n-}a" @?= Right pt8,
    testCase "Type Comment with '->'" $
      parseStringType "F {-> comment -} a" @?= Right pt8,
    testCase "Type Comment Counts as Space" $
      errorTest "F -{- comment -}> a",
    testCase "Type Multiple Comment and Whitespaces" $
      parseStringType "F{--}{--}\n {--}   a  " @?= Right pt8,
    testCase "Type Multiple End Comments" $
      errorTest "F{-comment-} -} a",
    testCase "Type Nested Comments" $
      errorTest "F{- {- comment -} -}",
    testCase "String Starting with Comments and Whitespaces" $
      parseStringType "{-cmt @ the start-}  F a" @?= Right pt8,
    testCase "Type - A bit of Everything 1" $
      parseStringType "{- hej -} Data ((a_,data'))\n\n b-> ({-xD-}b,b)\t" @?= Right pt9,
    testCase "Type - A bit of Everything 2" $
      parseStringType "F (xD->Dx) ({-hmm-}t'_,\nb->F u->ck)" @?= Right pt10,
    testCase "Type - A bit of Everything 3" $
      errorTest "\r ((F a),F (a ->b)) ->{-Should fail right here at _a :O -}_a",
    testCase "Empty String" $
      errorTest "",
    testCase "Nonsense String" $
      errorTest "a b c 1 2 3 _-'*'-_",
    testCase "From the Exam Description" $
      parseStringType "F x -> (y, A)"  @?= Right pt11,
    testCase "Type Constructor grouping (previously failing)" $
      parseStringType "F G x" @?= Right fpt0

  ],
  testGroup "My Resolver Tests" [
{----- resolve -----}
    testCase "Resolve (,) (with illegal variable name)" $
      resolve tce0 (\x -> return $ STVar (x++"'")) pt5 @?= Right st1,
{----- declare -----}
    testCase "Declare empty list given (,)" $
      do tce <- declare []
         tf <- case lookup "(,)" tce of Just tf -> return tf; _ -> Left "no T"
         tf [STVar "let'", STVar "a'"]
      @?= Right st1,
    testCase "Declare empty list given (->)" $
      do tce <- declare []
         tf <- case lookup "(->)" tce of Just tf -> return tf; _ -> Left "no T"
         tf [STVar "a'", STVar "a'"]
      @?= Right st0
  ],
  -- testGroup "My Parser Failing Tests" [
  -- ],
  testGroup "My Resolver Failing Tests" [-- Negative tests
    -- testCase "Resolve ..." $
    --   parseStringType "F G x" @?= Right fpt0,
    testCase "Declare non empty list (copy of handed out declare test)" $
      do tce <- declare [td0]----- CHANGE
         tf <- case lookup "T" tce of Just tf -> return tf; _ -> Left "no T"
         tf [STVar "a'"]
      @?= Right st0
  ]]
 where pt0 = PTApp "(->)" [PTVar "a", PTVar "a"]
       pt1 = (PTApp "(,)" [PTApp "(->)" [PTVar "a",PTVar "a"],PTApp "F" [PTVar "a"]])
       pt2 = (PTApp "(->)" [PTApp "F" [PTVar "a"],PTVar "a"])
       pt3 = (PTApp "(->)" [PTVar "x",PTApp "(->)" [PTVar "y",PTVar "z"]])
       pt4 = (PTApp "(,)" [PTApp "Type" [],PTVar "a"])
       pt5 = (PTApp "(,)" [PTVar "let",PTVar "a"])
       pt6 = (PTApp "(->)" [PTApp "F" [PTVar "a"],PTVar "a"])
       pt7 = (PTApp "F" [PTVar "a"])
       pt8 = (PTApp "F" [PTVar "a"])
       pt9 = (PTApp "(->)" [PTApp "Data" [PTApp "(,)" [PTVar "a_",PTVar "data'"],PTVar "b"],PTApp "(,)" [PTVar "b",PTVar "b"]])
       pt10 = (PTApp "F" [PTApp "(->)" [PTVar "xD",PTApp "Dx" []],PTApp "(,)" [PTVar "t'_",PTApp "(->)" [PTVar "b",PTApp "(->)" [PTApp "F" [PTVar "u"],PTVar "ck"]]]])
       pt11 = (PTApp "(->)" [PTApp "F" [PTVar "x"],PTApp "(,)" [PTVar "y",PTApp "A" []]])
       fpt0 = (PTApp "F" [PTApp "G" [],PTVar "x"])
       td0 = TDSyn ("T", ["a"]) pt0
       st0 = STArrow (STVar "a'") (STVar "a'")
       st1 = STProd (STVar "let'") (STVar "a'")
       tr0 = Choice [Choice [Found 4, Choice []], Found 3]
       dfs (Found a) = [a]
       dfs (Choice ts) = concatMap dfs ts
       e0 = Lam "X" (Var "X")


-- resolve [] (return . STVar) (PTApp "(,)" [PTVar "a",PTVar "b",PTVar "c"])
-- parseStringType "a{- hej"
-- parseStringType "a{- hej {--}"
-- solutions (Choice [Choice [Found 1,Found 2,Found 3],Choice [Choice [Found 4,Found 5], Choice[Found 6,Choice []]]]) 12 (Just 0)
-- [1,2,3,4,5,6]
-- solutions (Choice [Choice [Found 1,Found 2,Found 3],Choice [Choice [Found 4,Found 5], Choice[Found 6,Choice []]]]) 4 (Just 0)
-- [1,0]
-- solutions (Choice [Choice [Found 1,Found 2,Found 3],Choice [Choice [Found 4,Found 5], Choice[Found 6,Choice []]]]) 11 (Just 0)
-- [1,2,3,4,5,6,0]
-- solutions (Choice [Choice [Found 1,Found 2,Found 3],Choice [Choice [Found 4,Found 5], Choice[Found 6,Choice []]]]) 11 Nothing
-- [1,2,3,4,5,6]

-- atleast one test case for every part not implemented, so they can see I know how to use all the cases.
-- resolve [] (return . STVar) (PTApp "(,)" [PTVar "a",PTVar "b",PTVar "c"])
-- "Integration testing"? test parseStringType > resolve, og solutions > driver?
-- solutions (pick [0..]) 100 Nothing
-- [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98]
-- White Box bfs()?
