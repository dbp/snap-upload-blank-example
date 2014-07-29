{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Control.Monad (void)
import           Control.Monad.Trans (liftIO)
import           Control.Applicative
import           Snap.Core
import           Snap.Util.FileUploads
import           Snap.Http.Server

main :: IO ()
main = quickHttpServe site

site :: Snap ()
site = method GET (writeBS "<html><body><form method='POST' enctype='multipart/form-data'><input type='file' name='f'/><input type='submit'/></form></body></html>") <|>
       method POST upload

upload :: Snap ()
upload = do
  void $ handleFileUploads "/tmp" defaultUploadPolicy (const $ allowWithMaximumSize 100000) $ mapM (\(info, _) -> liftIO $ print info)
