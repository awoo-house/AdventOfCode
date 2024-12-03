module Day3 (day3) where

import Data.Void (Void)

import Text.Megaparsec (Parsec, anySingle, some, try, choice, parseMaybe)
import Text.Megaparsec.Char (string)
import qualified Text.Megaparsec.Char.Lexer as L
import Control.Applicative ((<|>))
import Data.Functor (($>))

----- EXPRESSIONS --------------------------------------------------------------

data Op =
  Mul Int Int
  | Do | DoNot
  | Nop
  deriving (Eq, Ord, Show)

----- PARSER -------------------------------------------------------------------

type Parser = Parsec Void String

isNop :: Op -> Bool
isNop Nop = True
isNop _   = False

lParen :: Parser ()
lParen = string "(" $> ()

rParen :: Parser ()
rParen = string ")" $> ()

comma :: Parser ()
comma = string "," $> ()

mulInstr :: Parser Op
mulInstr = do
  string "mul" $> ()
  lParen
  a <- L.decimal
  comma
  b <- L.decimal
  rParen
  return $ Mul a b

dontInstr :: Parser Op
dontInstr = do
  string "don't" $> ()
  lParen
  rParen
  return DoNot

doInstr :: Parser Op
doInstr = do
  string "do" $> ()
  lParen
  rParen
  return Do

opInstr :: Parser Op
opInstr = choice [
    try mulInstr
    , try dontInstr
    , try doInstr
    , anySingle $> Nop
  ]

noisyOps :: Parser [Op]
noisyOps = some opInstr

----- EVALUATOR ----------------------------------------------------------------

eval :: Bool -> [Op] -> [Int]
eval _ []               = [0]
eval _ (Do:xs)          = eval True xs
eval _ (DoNot:xs)       = eval False xs
eval False (_:xs)       = eval False xs
eval True (Mul a b:xs)  = a * b : eval True xs
eval _ (Nop:_)          = error "Tried to evaluate a No-op!"

--------------------------------------------------------------------------------

day3 :: IO ()
day3 = do
  inp <- readFile "src/inputs/day3.txt"
  -- let instrs = filter (not . isNop) <$> parseMaybe noisyOps "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  let instrs = filter (not . isNop) <$> parseMaybe noisyOps inp
  print instrs
  print $ (sum . eval True) <$> instrs
