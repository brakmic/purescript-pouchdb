module Test.Main where

import Prelude
import Data.Maybe
import Test.QuickCheck
import Unsafe.Coerce               (unsafeCoerce)
import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Eff.Console
import Control.Monad.Eff.Random    (RANDOM)
import Debug.Trace
import API.PouchDB

showDBCreateInfo :: forall a e. a -> Eff(console :: CONSOLE | e) Unit
showDBCreateInfo = \anyData -> do
                               logRaw anyData
                               log "PouchDB database created!"

showDBDestroyInfo :: forall a e. a -> Eff(console :: CONSOLE | e) Unit
showDBDestroyInfo = \anyData -> do
                                logRaw anyData
                                log "PouchDB database deleted!"

main = do
      traceA "\r\n[TEST] create new PouchDB"
      pdb <- pouchDB (Just "dummyDB") Nothing
      traceA "\r\n[TEST] get info from PouchDB"
      info (Just showDBCreateInfo) pdb
      traceA "\r\n[TEST] destroy PouchDB instance"
      destroy Nothing (Just showDBDestroyInfo) pdb

