module DemoApp.PouchDB where

import Prelude                     (Unit, unit, return, bind)
import Data.Maybe                  (Maybe(Nothing, Just))
-- import Data.Either
import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Console   (CONSOLE, log)
-- import Control.Monad.Eff.Random  (RANDOM, random)
import Control.Monad.Eff.Exception (EXCEPTION)
import API.PouchDB                 (PouchDBM
                                    , PouchDB
                                    , PouchDBDocument(PouchDBDocument)
                                    , post
                                    , put
                                    , get
                                    , info
                                    , pouchDB
                                    , destroy
                                    , remove
                                    , removeDocRev
                                    , bulkDocs
                                    , logRaw)

callback :: forall a e. a -> Eff(console :: CONSOLE| e) Unit
callback = \anyData -> do
                       logRaw anyData

main :: forall e. Eff(console :: CONSOLE, pouchDBM :: PouchDBM, err :: EXCEPTION | e) Unit
main = do
      let doc = PouchDBDocument {
                                  "_id" : Just "hbr123",
                                  "_rev" : Just "2-9AF304BE281790604D1D8A4B0F4C9ADB",
                                  name : "Harris",
                                  occupation: "Procrastinator",
                                  city: "Troisdorf"
                                }
      pdb <- pouchDB (Just "dummyDB") Nothing
      info (Just callback) pdb
      --put doc Nothing Nothing Nothing (Just callback) pdb
      post doc Nothing (Just callback) pdb
      --get doc."_id" Nothing (Just callback) pdb
      --remove doc Nothing (Just callback) pdb
      --removeDocRev doc Nothing (Just callback) pdb
      --destroy Nothing (Just callback) pdb
      return unit