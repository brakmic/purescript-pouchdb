module Test.Main where

import Prelude                     (Unit, unit, return, bind)
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
                                    , remove
                                    , removeDocRev
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

showDeletedDocument :: forall a e. a -> Eff(console :: CONSOLE | e) Unit
showDeletedDocument = \document -> do
                                     logRaw document
                                     log "Document retrieved."

main :: forall e. Eff(err :: EXCEPTION | e) Unit
main = do
      traceA "\r\n[TEST 1] create new PouchDB"
      pdb <- pouchDB (Just "dummyDB") Nothing
      traceA "\r\n[TEST 2] get info from PouchDB"
      info (Just showDBCreateInfo) pdb

      traceA "\r\n[TEST 3] destroy PouchDB instance"
      destroy Nothing (Just showDBDestroyInfo) pdb

      traceA "\r\n[TEST 4] put Document into PouchDB"
      let doc = PouchDBDocument {
                                  "_id" : Just "hbr12345",
                                  "_rev" : Nothing,
                                  name : "Harris",
                                  occupation: "Procrastinator",
                                  city: "Troisdorf"
                                }
      pdb2 <- pouchDB (Just "dummyDB2") Nothing
      put doc (Just "myDummyId2") Nothing Nothing (Just showDBPutInfo) pdb2

      traceA "\r\n[TEST 5] post Document into PouchDB"
      let doc2 = PouchDBDocument {
                                  "_id" : Just "hbr56789",
                                  "_rev" : Nothing,
                                  name : "John",
                                  occupation : "Coder",
                                  city : "New York"
                                }
      post doc2 Nothing (Just showDBPostInfo) pdb2

      traceA "\r\n[TEST 6] get Document from PouchDB"
      pdb3 <- pouchDB (Just "dummyDB3") Nothing
      put doc2 (Just "myDummyId3") Nothing Nothing (Just showDBPutInfo) pdb3
      get "myDummyId" Nothing (Just showRetrievedDocument) pdb3

      traceA "\r\n[TEST] delete document from PouchDB"
      let doc4 = PouchDBDocument {
                                  "_id" : Just "hbr789",
                                  "_rev" : Just "0000000000000003333333",
                                  name : "John",
                                  occupation : "Coder",
                                  city : "New York"
                                }
      let doc4x = PouchDBDocument {
                                  "_id" : Just "hbr789",
                                  "_rev" : Just "0000000000000003333333",
                                  name : "John",
                                  occupation : "Coder",
                                  city : "New York"
                                }
      pdb4 <- pouchDB (Just "dummyDB4") Nothing
      post doc4 Nothing (Just showDBPostInfo) pdb4
      put doc4x (Just "myDummy4x") Nothing Nothing (Just showDBPutInfo) pdb3
      get "myDummy4x" Nothing (Just (\mydoc -> do
                                             removeDocRev mydoc Nothing Nothing pdb4
                                             return unit)) pdb4
      remove doc4 Nothing (Just showDeletedDocument) pdb4


      traceA "[CLEANUP] Removing databases"
      destroy Nothing (Just showDBDestroyInfo) pdb2
      destroy Nothing (Just showDBDestroyInfo) pdb3
      destroy Nothing (Just showDBDestroyInfo) pdb4

