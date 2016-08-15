module DemoApp.PouchDB where

import Prelude                     (Unit, unit, pure, bind)
import Data.Maybe                  (Maybe(Nothing, Just))
-- import Data.Either
import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Console   (CONSOLE, log)
-- import Control.Monad.Eff.Random  (RANDOM, random)
import Control.Monad.Eff.Exception (EXCEPTION)
import API.PouchDB                 (  PouchDBM
                                    , PouchDB
                                    , PouchDBDocument(..)
                                    , PouchDBOptions(..)
                                    , post
                                    , put
                                    , get
                                    , info
                                    , pouchDB
                                    , destroy
                                    , remove
                                    , removeDocRev
                                    , logRaw)

callback :: forall a e. a -> Eff(console :: CONSOLE| e) Unit
callback = \anyData -> do
                       logRaw anyData

main :: forall e. Eff(console :: CONSOLE, pouchDBM :: PouchDBM, err :: EXCEPTION | e) Unit
main = do
      let doc = PouchDBDocument {
                                  "id" : "hbr123",
                                  "rev" : "2-9AF304BE281790604D1D8A4B0F4C9ADB",
                                  "name" : "Harris",
                                  "occupation": "Procrastinator",
                                  "city": "Troisdorf"
                                }
      let options = PouchDBOptions {
              "name"    : Just "myDummyDB",
              "local"   : Just {
                    "auto_compaction" : true,
                    "adapter"         : Nothing,
                    "revs_limit"      : 3
              },
              "remote"  : Just  {
                      "ajax" :  Just
                                {
                                  "cache"           : true,
                                  "headers"         : ["header1", "header2"],
                                  "withCredentials" : false
                                },
                      "auth" : Just
                                {
                                  "username"        : "harris",
                                  "password"        : "unbreakable_pwd"
                                },
                      "skip_setup" : Just false
              },
              "indexdb" : Nothing,
              "websql"  : Nothing,
              "sqlite"  : Nothing
      }
      -- pdb <- pouchDB (Just "dummyDB") Nothing
      pdb <- pouchDB Nothing (Just options)
      info (Just callback) pdb
      --put doc Nothing Nothing Nothing (Just callback) pdb
      post doc Nothing (Just callback) pdb
      --get doc."_id" Nothing (Just callback) pdb
      --remove doc Nothing (Just callback) pdb
      --removeDocRev doc Nothing (Just callback) pdb
      --destroy Nothing (Just callback) pdb
      pure unit