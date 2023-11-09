-- Put your Coder implementation in this file
module CoderImpl where

import Defs
import Control.Monad (ap, liftM, join)

-- no need to touch these
instance Functor Tree where fmap = liftM
instance Applicative Tree where pure = return; (<*>) = ap

instance Monad Tree where
  return a = Found a
  (>>=) m f = (case m of Choice as -> Choice $ map (\a -> a >>= f) as
                         Found  a  -> f a)

pick :: [a] -> Tree a
pick [] = Choice []
pick [a] = return a
pick as  = Choice $ map return as

-- Should be able to make the length restriction in the last case simpler
solutions :: Tree a -> Int -> Maybe a -> [a]
solutions tr 0 d = case d of Just a -> [a]; Nothing -> []--Test
solutions (Found a) n _d = [a]--Test
solutions tr n Nothing = join $ map (\m -> case m of Found a -> [a]; Choice _as -> []) (take n (bfs [tr]))
solutions tr n (Just d) = let res = (take (n+1) (bfs [tr])) in
                            if length res > n then (join $ map (\m -> case m of Found a -> [a]; Choice _as -> []) (take n res))<>[d]
                            else (join $ map (\m -> case m of Found a -> [a]; Choice _as -> []) (take n res))

-- Breadth first search, while decreasing n. Then check d.
bfs :: [Tree a] -> [Tree a]
bfs [] = []
bfs q = case head q of Found a -> [Found a] <> (bfs $ tail q)
                       Choice as -> [Choice as] <> (bfs $ (tail q)<>as)
-- bfs [Found a]:qs = [Found a] <> bfs qs
-- bfs [(Choice [as])]:qs = [Choice [as]] <> bfs (qs <> as)

produce :: [(String,SType)] -> SType -> Tree Exp
produce = undefined

-- recommended, but not mandated, helper function:
extract :: [(String,SType)] -> SType -> SType -> Tree (Exp -> Exp)
extract = undefined
