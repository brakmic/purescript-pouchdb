module DemoApp.PouchDB where

import Prelude
import Data.Maybe                (Maybe(Nothing, Just))
import Control.Monad.Eff         (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import API.PouchDB
import Control.Monad.Eff.Random  (RANDOM, random)

showDBCreateInfo :: forall a e. a -> Eff(console :: CONSOLE | e) Unit
showDBCreateInfo = \anyData -> do
                               logRaw anyData
                               log "PouchDB database created!"

showDBDestroyInfo :: forall a e. a -> Eff(console :: CONSOLE | e) Unit
showDBDestroyInfo = \anyData -> do
                                logRaw anyData
                                log "PouchDB database deleted!"

main :: forall e. Eff(console :: CONSOLE, pouchDBM :: PouchDBM | e) Unit
main = do
      pdb <- pouchDB (Just "dummyDB") Nothing
      info (Just showDBCreateInfo) pdb
      destroy Nothing (Just showDBDestroyInfo) pdb
      return unit