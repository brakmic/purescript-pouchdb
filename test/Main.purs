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
import API.PouchDB                 (PouchDBM
                                    , PouchDBDocument(PouchDBDocument)
                                    , post
                                    , put
                                    , info
                                    , pouchDB
                                    , destroy
                                    , get
                                    , logRaw)

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
                            log "New document created (via PUT)!"

showDBPostInfo :: forall a e. a -> Eff(console :: CONSOLE | e) Unit
showDBPostInfo = \anyData -> do
                            logRaw anyData
                            log "New document created (via POST)!"

showRetrievedDocument :: forall a e. a -> Eff(console :: CONSOLE | e) Unit
showRetrievedDocument = \document -> do
                                     logRaw document
                                     log "Document retrieved."

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
      pdb2 <- pouchDB (Just "dummyDB2") Nothing
      put doc (Just "myDummyId") Nothing Nothing (Just showDBPutInfo) pdb2

      traceA "\r\n[TEST] post Docfument into PouchDB"
      let doc2 = PouchDBDocument { name : "John", occupation : "Coder", city : "New York" }
      post doc2 Nothing (Just showDBPostInfo) pdb2

      traceA "\r\n[TEST] get Document from PouchDB"
      pdb3 <- pouchDB (Just "dummyDB3") Nothing
      put doc (Just "myDummyId") Nothing Nothing (Just showDBPutInfo) pdb3
      get "myDummyId" Nothing (Just showRetrievedDocument) pdb3

      traceA "[CLEANUP] Removing databases"
      destroy Nothing (Just showDBDestroyInfo) pdb2
      destroy Nothing (Just showDBDestroyInfo) pdb3

