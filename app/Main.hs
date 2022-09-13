{-# LANGUAGE ForeignFunctionInterface #-}

module Main where

import           Foreign.C                      ( CChar(..)
                                                , CInt(..)
                                                )
import           Foreign.C.String               ( castCharToCChar )
import           Prelude                 hiding ( sin )

-- testing!
foreign import ccall "take_a_char" c_take_a_char :: CChar -> CInt
takeAChar :: Char -> Int
takeAChar c = fromIntegral $ c_take_a_char $ castCharToCChar c

main :: IO ()
main = do
    let char = 'x'
    print $ takeAChar char
