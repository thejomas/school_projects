-- Parallel Longest Satisfying Segment
--
-- ==
-- compiled input {
--    [1, -2, -2, 0, 0, 0, 0, 0, 3, 4, -6, 1]
-- }  
-- output { 
--    9
-- }
-- compiled input {
--    [1]
-- }
-- output {
--    1
-- }
-- compiled input {
--    empty([0]i32)
-- }
-- output {
--    0
-- }
-- compiled input {
--    [1, 2, 3, 4, 5, 5, 4, 3, 2, 1, -6, 1]
-- }
-- output {
--    6
-- }
-- compiled input {
--    [100, 99, 50, 42, 13, 12, 9, 5, 3, 2, 1, 0]
-- }
-- output {
--    1
-- }
-- compiled input {
--    [100, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
-- }
-- output {
--    9
-- }

import "lssp"
import "lssp-seq"

type int = i32

let main (xs: []int) : int =
  let pred1 _   = true
  let pred2 x y = (x <= y)
--  in  lssp_seq pred1 pred2 xs
  in  lssp pred1 pred2 xs
