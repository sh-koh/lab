module Main where

import Data.List (intercalate)
import Data.Word (Word8)

data IPv4 = IPv4
  { a :: Word8,
    b :: Word8,
    c :: Word8,
    d :: Word8
  }
  deriving (Eq)

instance Show IPv4 where
  show (IPv4 a b c d) = intercalate "." $ map show [a, b, c, d]

newtype NetAddr = NetAddr IPv4 deriving (Eq)

instance Show NetAddr where
  show (NetAddr ip) = show ip

newtype NetMask = NetMask IPv4 deriving (Eq)

instance Show NetMask where
  show (NetMask ip) = show ip

ipInit :: String -> String -> (NetAddr, NetMask)
ipInit ip msk =
  (ip', msk')
  where
    ipL = map (\x -> read x :: Word8) $ words [if c == '.' then ' ' else c | c <- ip]
    mskL = map (\x -> read x :: Word8) $ words [if c == '.' then ' ' else c | c <- msk]
    mkIPv4 (a : b : c : d : _) = IPv4 a b c d
    ip' = NetAddr (mkIPv4 ipL)
    msk' = NetMask (mkIPv4 mskL)

main :: IO ()
main = do
  putStr "IP: "
  netaddr <- getLine
  putStr "Mask: "
  netmask <- getLine

  print $ ipInit netaddr netmask
