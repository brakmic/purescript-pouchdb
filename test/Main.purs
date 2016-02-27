module Test.Main where

import Prelude                     (Unit, bind)
import Data.Maybe                  (Maybe(Just, Nothing))
-- import Test.QuickCheck
-- import Unsafe.Coerce               (unsafeCoerce)
import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Eff.Console   (CONSOLE, log)
-- import Control.Monad.Eff.Random    (RANDOM)
import Debug.Trace (traceA)
import API.PouchDB                 (PouchDBDocument(PouchDBDocument), put, pouchDB, destroy, info, logRaw)

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

main :: forall e. Eff(err :: EXCEPTION | e) Unit
main = do
      traceA "\r\n[TEST] create new PouchDB"
      pdb <- pouchDB (Just "dummyDB") Nothing
      traceA "\r\n[TEST] get info from PouchDB"
      info (Just showDBCreateInfo) pdb
      traceA "\r\n[TEST] destroy PouchDB instance"
      destroy Nothing (Just showDBDestroyInfo) pdb
      traceA "\r\n[TEST] put Document into PouchDB"
      let doc = PouchDBDocument { name : "Harris", occupation: "Procrastinator", city: "Troisdorf" }
      pdb2 <- pouchDB (Just "dummyDB") Nothing
      put doc (Just "myDummyId") Nothing Nothing (Just showDBPutInfo) pdb2

