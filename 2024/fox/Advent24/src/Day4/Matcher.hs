module Day4.Matcher (
    MatchState(..)
  , mkMatcher
  , isMatch
  , (+>)
) where

data MatchState =
  MatchFail | Step String | Match String
  deriving (Show, Eq)

mkMatcher :: String -> MatchState
mkMatcher = Step

isMatch :: MatchState -> Bool
isMatch (Match _) = True
isMatch _         = False

(+>) :: MatchState -> Char -> MatchState
Step []     +> _ = MatchFail
MatchFail     +> _ = MatchFail
Step [c] +> chr
  | c == chr  = Match [c]
  | otherwise = MatchFail
Step (c:cs) +> chr
  | c == chr  = Step cs
  | otherwise = MatchFail
Match _     +> _ = MatchFail

-- Ideal syntax: mkMatcher "XMAS" +> 'X' +> 'M' +> 'A' +> 'S' == Match 'S'
--               mkMatcher "XMAS" +> 'X'                      == Step "MAS"
--               mkMatcher "XMAS" +> 'X' +> 'A'               == MatchFail
--               mkMatcher "XMAS" +> 'A'                      == MatchFail