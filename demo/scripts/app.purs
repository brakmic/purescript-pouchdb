module DemoApp.PouchDB where

import Prelude
import Data.Maybe                (Maybe(Nothing, Just))
import Data.Either
import Control.Monad.Eff
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Random  (RANDOM, random)
import Control.Monad.Eff.Exception
import API.PouchDB

showDBCreateInfo :: forall a e. a -> Eff(console :: CONSOLE | e) Unit
showDBCreateInfo = \anyData -> do
                               logRaw anyData
                               log "PouchDB database created!"

showDBDestroyInfo :: forall a e. a -> Eff(console :: CONSOLE | e) Unit
showDBDestroyInfo = \anyData -> do
                                logRaw anyData
                                log "PouchDB database deleted!"

showDBPutInfo :: forall a e. a -> Eff(console :: CONSOLE | e) Unit
showDBPutInfo = \anyData -> do
                            logRaw anyData
                            log "New document created!"

main :: forall e. Eff(console :: CONSOLE, pouchDBM :: PouchDBM, err :: EXCEPTION | e) Unit
main = do
      let doc = PouchDBDocument { name : "Harris", occupation: "Procrastinator", city: "Troisdorf" }
      pdb <- pouchDB (Just "dummyDB") Nothing
      info (Just showDBCreateInfo) pdb
      put doc (Just "myDummyId") Nothing Nothing (Just showDBPutInfo) pdb
      -- destroy Nothing (Just showDBDestroyInfo) pdb
      return unit