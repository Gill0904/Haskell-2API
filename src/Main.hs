{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

module Main where

import           Network.HTTP.Simple            ( parseRequest, getResponseBody, httpBS )       
import Control.Lens ( preview, (^..) )          
import Data.Aeson ( Value(String, Array, Object), eitherDecodeStrict') 
import Data.Aeson.Lens ( key, members, values, _String, _Array,_Integer )
import qualified Data.ByteString.Char8         as BS
import           Data.Text                     (Text,toUpper)
import qualified Data.Text.Lazy as T (toStrict)
import qualified Data.Text.Lazy.Builder as B
import qualified Data.Text.Lazy.Builder.Int as B
import qualified Data.Text.IO                  as TIO
import Data.Vector as V ( Vector, forM , generate)
import qualified Data.HashMap.Strict as HashMap
import Foreign ()
import Data.List ( intercalate ,intersperse)

fetchJSONVuelos :: String -> IO BS.ByteString 
fetchJSONVuelos  codigoIATA = do
  let api = "YourAPI"++codigoIATA
  request <- parseRequest api
  res <- httpBS request
  return (getResponseBody res)


fetchJSONClima :: String -> IO BS.ByteString 
fetchJSONClima  ciudad = do
  let api = "YourAPI" ++ciudad
  request <- parseRequest api
  res <- httpBS request
  return (getResponseBody res)

getClima :: BS.ByteString -> Maybe Integer
getClima = preview (key "current" . key "temperature" . _Integer)

intToText :: Integral a => a -> Text
intToText = T.toStrict . B.toLazyText . B.decimal

main :: IO ()
main = do
  
  putStrLn "Bienvenido "
  putStrLn "¿De que ciudad desea conocer el clima? "
  ciudad <- getLine
  jsonClima <- fetchJSONClima ciudad
  case getClima jsonClima of
    Nothing   -> TIO.putStrLn "No se pudo encontrar la temperatura :("
    Just temperature -> TIO.putStrLn $ "El clima es de: " <> intToText temperature <> " grados" 
  putStrLn "¿Desea conocer los vuelos de salida mediante código iata? \n [S/N]"
  putStrLn "Si desea consultar los códigos iata consulte: \n http://api.aviationstack.com/v1/cities?access_key=YourKEY"
  confirmacion <- getLine
  if confirmacion == "S"
    then do
      putStrLn "Ingrese su código iata "
      codigoIATA <- getLine
      jsonVuelos <- fetchJSONVuelos codigoIATA
      putStrLn $ "Los vuelos disponible que salen desde la ciudad:" ++codigoIATA++" \ntienen como destino los aereopuertos:"
      print $ jsonVuelos^..key "data".values.key "arrival".key "airport"._String
    else
      putStrLn "Buen día, hasta la proxima."
