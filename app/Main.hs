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
import           System.Posix.IO.ByteString     ( fdRead )
import           Network.Socket
import           Network.Socket.ByteString      ( recv, sendAll )

import qualified Data.ByteString as B
import Numeric (showHex)

foreign import ccall "init_tun" c_init_tun :: IO CInt

prettyPrint :: B.ByteString -> String
prettyPrint = concatMap (`showHex` "") . B.unpack

initTun :: IO Fd
initTun = do
    fd <- throwErrnoIfMinus1 "initTun" c_init_tun
    pure $ fromIntegral fd

main :: IO ()
main = do
    fd <- initTun
    putStrLn $ "Got utun! " ++ show fd

    sock <- mkSocket $ fromIntegral fd
    msg <- recv sock 1024

    putStrLn "Got some data!"
    putStrLn $ prettyPrint msg

    putStrLn "Hit newline to finish"
    _ <- getLine

    closeFd fd
    putStrLn "Closed fd!"
