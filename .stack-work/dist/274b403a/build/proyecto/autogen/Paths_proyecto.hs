{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_proyecto (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\luisi\\proyecto\\.stack-work\\install\\d1517fd0\\bin"
libdir     = "C:\\Users\\luisi\\proyecto\\.stack-work\\install\\d1517fd0\\lib\\x86_64-windows-ghc-8.10.4\\proyecto-0.1.0.0-CioVlaIcFMeIk4p0surHmS-proyecto"
dynlibdir  = "C:\\Users\\luisi\\proyecto\\.stack-work\\install\\d1517fd0\\lib\\x86_64-windows-ghc-8.10.4"
datadir    = "C:\\Users\\luisi\\proyecto\\.stack-work\\install\\d1517fd0\\share\\x86_64-windows-ghc-8.10.4\\proyecto-0.1.0.0"
libexecdir = "C:\\Users\\luisi\\proyecto\\.stack-work\\install\\d1517fd0\\libexec\\x86_64-windows-ghc-8.10.4\\proyecto-0.1.0.0"
sysconfdir = "C:\\Users\\luisi\\proyecto\\.stack-work\\install\\d1517fd0\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "proyecto_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "proyecto_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "proyecto_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "proyecto_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "proyecto_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "proyecto_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
