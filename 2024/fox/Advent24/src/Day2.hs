module Day2 (day2) where

import Data.Bifunctor (bimap)
import Data.List (sort, group, length, lookup, elemIndex, splitAt)

getDists :: [Int] -> [Int]
getDists xs = zipWith (-) (tail xs) xs

isSafe :: [Int] -> Bool
isSafe dists = (all (<0) dists || all (>0) dists) && all ((<4) . abs) dists

withoutNth :: [a] -> Int -> [a]
withoutNth [] _ = []
withoutNth xs n =
  let (l, r) = splitAt (n-1) xs
  in l ++ tail r

withoutOne :: [a] -> [[a]]
withoutOne xs = map (withoutNth xs) [0..length xs]

damperSafe :: [Int] -> Bool
damperSafe report =
  isSafe (getDists report) ||
    any (isSafe . getDists) (withoutOne report)

day2 :: IO ()
day2 = do
  putStrLn "Day2"
  file <- readFile "src/inputs/day2.txt"
  let reports = map (map read . words) $ lines file
  -- mapM_ (print . damperSafe) reports
  print $ length $ filter id $ map damperSafe reports