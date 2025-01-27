module Main where

import System.Environment
import System.Exit 


exit  = exitWith ExitSuccess
exitF = exitWith (ExitFailure 1)

parse :: String -> String
parse arg
  | null arg   = "You need to provide at least one argument." 
  | arg == "0" = "255 evilge"
  | otherwise  = show ((read arg::Int) * 2) ++ " poggers"

main :: IO() 
main = do
  args <- getArgs
  mapM_ putStrLn (map parse args)
