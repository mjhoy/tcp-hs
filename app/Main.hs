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

newtype UTun = UTun { fd :: Fd } deriving (Show)

foreign import ccall "init_tun" c_init_tun :: IO CInt

initTun :: IO UTun
initTun = do
    fd <- throwErrnoIfMinus1 "initTun" c_init_tun
    pure $ UTun $ fromIntegral fd

closeTun :: UTun -> IO ()
closeTun (UTun fd) = closeFd $ fromIntegral fd

main :: IO ()
main = do
    utun <- initTun
    putStrLn $ "Got utun! " ++ show utun

    putStrLn "Hit newline to finish"
    _ <- getLine

    closeTun utun
    putStrLn "Closed fd!"
