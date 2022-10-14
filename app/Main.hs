{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import           Foreign.C                      ( CChar(..)
                                                , CInt(..)
                                                , throwErrnoIfMinus1
                                                )
import           Foreign.C.String               ( castCharToCChar )
import           Prelude                 hiding ( sin )
import           System.Posix                   ( closeFd )
import           System.Posix.Types             ( Fd )

foreign import ccall "init_tun" c_init_tun :: IO CInt

initTun :: IO Fd
initTun = do
    fd <- throwErrnoIfMinus1 "initTun" c_init_tun
    pure $ fromIntegral fd

main :: IO ()
main = do
    fd <- initTun
    putStrLn $ "Got utun! " ++ show fd

    putStrLn "Hit newline to finish"
    _ <- getLine

    closeFd fd
    putStrLn "Closed fd!"
