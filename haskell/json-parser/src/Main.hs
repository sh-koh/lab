module Main where

import Data.Char
import System.Environment

data JSON
  = JNull
  | JInt Int
  | JFloat Double
  | JString String
  | JBool Bool
  | JObject [(String, JSON)]
  | JArray [JSON]
  deriving (Show, Eq)

newtype Parser a = Parser 
  { runParser :: String -> Maybe (String, a)
  }

jsonNull :: Parser JSON
jsonNull = undefined

charP :: Char -> Parser Char
charP x = Parser $ f
  where
    f (y:ys)
      | y == x    = Just (ys, x)
      | otherwise = Nothing
    f [] = Nothing

json :: Parser JSON
json = undefined

main :: IO ()
main = undefined
