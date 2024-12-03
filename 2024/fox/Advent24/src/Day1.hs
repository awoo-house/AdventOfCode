module Day1 (day1) where

import Data.Bifunctor (bimap)
import Data.List (sort, group, length, lookup)


mkLookup :: [Int] -> [(Int, Int)]
mkLookup = map (\xs -> (head xs, length xs)) . group . sort

importData :: String -> ([Int], [Int])
importData =  unzip . map (toInts . words) . lines
  where
    toInts :: [String] -> (Int, Int)
    toInts [a, b] = (read a, read b)
    toInts _      = error "Unexpected input!"

pt1 :: ([Int], [Int]) -> Int
pt1 = sum . map abs . uncurry (zipWith (-)) . bimap sort sort

getScore :: [(Int, Int)] -> Int -> Int
getScore dict n =
  case lookup n dict of
    Just count -> n * count
    Nothing    -> 0

day1 :: IO ()
day1 = do
  file <- readFile "src/inputs/day1.txt"
  let (l, r) = importData file
  let dict = mkLookup r
  print $ sum $ map (getScore dict) l