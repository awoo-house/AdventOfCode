import Test.Tasty
import Test.Tasty.HUnit

import Day4.Matcher (MatchState (..), (+>), mkMatcher, isMatch)

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "Foxy Advent of Code" [day4Tests]


day4Tests :: TestTree
day4Tests = testGroup "Day 4" [
    testGroup "Matcher Tests" [
          testCase "Step 1" $ mkMatcher "XMAS" +> 'X'                      @?= Step "MAS"
        , testCase "Step 2" $ mkMatcher "XMAS" +> 'X' +> 'M'               @?= Step "AS"
        , testCase "Step 3" $ mkMatcher "XMAS" +> 'X' +> 'M' +> 'A'        @?= Step "S"
        , testCase "Match"  $ mkMatcher "XMAS" +> 'X' +> 'M' +> 'A' +> 'S' @?= Match "S"

        , testCase "Fail 1" $ mkMatcher "XMAS" +> 'Q'                      @?= MatchFail
        , testCase "Fail 2" $ mkMatcher "XMAS" +> 'X' +> 'Z'               @?= MatchFail
        , testCase "Fail 3" $ mkMatcher "XMAS" +> 'X' +> 'M' +> 'N'        @?= MatchFail
        , testCase "Fail 4" $ mkMatcher "XMAS" +> 'X' +> 'M' +> 'A' +> 'A' @?= MatchFail
      ]
  ]