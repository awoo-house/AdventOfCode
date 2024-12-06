{-# LANGUAGE InstanceSigs #-}
module Day4 (day4) where

import Data.List (foldl')
import Text.Printf

import Day4.Matcher (MatchState(..), mkMatcher, isMatch, (+>))

----- DIRECTIONAL MATCHING -----------------------------------------------------

data Direction = Above | Left | Diagonal

instance Show Direction where
  show Above    = "↓"
  show Left     = "→"
  show Diagonal = "↘"


newtype CellMatch = CellMatch (Direction, MatchState)
newtype CellMatches = CellMatches [CellMatch]

(-+>) :: CellMatches -> Char -> CellMatches
CellMatches cs -+> chr = undefined

----- DYNAMIC PROGRAMMING ------------------------------------------------------

-- TODO:
-- newtype DynamicTable = DynamicTable [[Cell]]
-- instance Show DynamicTable where ...

data Cell = Cell { matchCount :: Int, matchState :: MatchState }
  deriving (Eq)

instance Show Cell where
  show (Cell mc ms) = "[" ++ show mc ++ "|" ++ show ms ++ "]"

-- d u
-- l .
computeCell :: Char -> Cell -> Cell -> Cell -> Cell
computeCell c (Cell u us) (Cell d ds) (Cell l ls) =
  let
    un = nextMatch us c
    dn = nextMatch ds c
    ln = nextMatch ls c
    nextState = mconcat [un, dn, ln]
    inc = if isMatch nextState then 1 else 0
  in Cell (inc + u + l - d) nextState

-- ..X...
-- .SAMX.
-- .A..A.
-- XMAS.S
-- .X....
mkRow :: Int -> String -> [Cell] -> [Cell]
mkRow 0 row _ = reverse $ foldl' firstRowFn [] row
  where
    firstRowFn :: [Cell] -> Char -> [Cell]
    firstRowFn [] chr = [Cell 0 $ nextMatch None chr]
    firstRowFn (left@(Cell lc ls):cs) chr =
      let
        ln = nextMatch ls chr
        inc = if isMatch ln then 1 else 0
      in Cell (lc + inc) ln:left:cs
mkRow _ row prevRow = reverse $ map snd $ foldl' nextRowFn [] (zip row prevRow)
  where
    -- (next-diag, current-output)
    nextRowFn :: [(Cell, Cell)] -> (Char, Cell) -> [(Cell, Cell)]
    nextRowFn [] (chr, up) = [(up, computeCell chr up (Cell 0 None) (Cell 0 None))]
    nextRowFn (c@(diag, left):cs) (chr, up) = (up, computeCell chr up diag left) : c : cs

mkTable :: [String] -> [[Cell]]
mkTable lns = reverse $ foldl' nxtLine [] (zip lns [0..])
  where
    nxtLine :: [[Cell]] -> (String, Int) -> [[Cell]]
    nxtLine [] (row, _) = [mkRow 0 row []]
    nxtLine (prev:acc) (row, n) = mkRow n row prev : prev : acc

----- VISUALIZATION ------------------------------------------------------------

showRow :: [Cell] -> String
showRow cs = "| " ++ line1 ++ "\n| " ++ line2
  where
    line1 = concatMap (printf "% 7d | " . matchCount) cs
    line2 = concatMap ((++" | ") . show . matchState) cs

--------------------------------------------------------------------------------

day4 :: IO ()
day4 = do
  src <- readFile "src/inputs/day4.example.txt"
  let rows = lines src
  let table = mkTable rows
  mapM_ (putStrLn . showRow) table

  let ans = last $ last table
  print $ matchCount ans