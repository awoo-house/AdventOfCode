module Day1 (day1) where

import Data.Bifunctor (bimap)
import Data.List (sort)


importData :: String -> Int
importData = sum . map abs . uncurry (zipWith (-)) . bimap sort sort . unzip . map (toInts . words) . lines
  where
    toInts :: [String] -> (Int, Int)
    toInts [a, b] = (read a, read b)
    toInts _      = error "Unexpected input!"


day1 :: IO ()
day1 = do
  file <- readFile "src/inputs/day1.pt1.txt"
  print $ importData file