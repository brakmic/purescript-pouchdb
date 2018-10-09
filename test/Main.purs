module Test.Main where

import Prelude                     (Unit, unit, pure, bind, discard)
import Data.Maybe                  (Maybe(Just, Nothing))
import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Eff.Console   (CONSOLE, log)
import Debug.Trace (traceA)
import API.PouchDB                 (PouchDBDocument(PouchDBDocument)
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

showBulkInsertInfo :: forall a e. a -> Eff(console :: CONSOLE | e) Unit
showBulkInsertInfo = \docs -> do
                              logRaw docs
                              log "Multiple documents inserted."

showBatchFetchInfo :: forall a e. a -> Eff(console :: CONSOLE | e) Unit
showBatchFetchInfo = \docs -> do
                              logRaw docs
                              log "Multiple documents retrieved."

main :: forall e. Eff(err :: EXCEPTION | e) Unit
main = do
      traceA "\r\n[TEST 1] create PouchDB"
      pdb <- pouchDB (Just "dummyDB") Nothing
      traceA "\r\n[TEST 2] get info from PouchDB"
      info (Just showDBCreateInfo) pdb

      traceA "\r\n[TEST 3] destroy PouchDB"
      destroy Nothing (Just showDBDestroyInfo) pdb

      traceA "\r\n[TEST 4] put document"
      let doc = PouchDBDocument {
                                  "id" : "hbr12345",
                                  "rev" : "",
                                  name : "Harris",
                                  occupation: "Procrastinator",
                                  city: "Troisdorf"
                                }
      pdb2 <- pouchDB (Just "dummyDB2") Nothing
      put doc (Just "myDummyId2") Nothing Nothing (Just showDBPutInfo) pdb2

      traceA "\r\n[TEST 5] post document"
      let doc2 = PouchDBDocument {
                                  "id" : "hbr56789",
                                  "rev" : "",
                                  name : "John",
                                  occupation : "Coder",
                                  city : "New York"
                                }
      post doc2 Nothing (Just showDBPostInfo) pdb2

      traceA "\r\n[TEST 6] get Document from PouchDB"
      pdb3 <- pouchDB (Just "dummyDB3") Nothing
      put doc2 (Just "myDummyId3") Nothing Nothing (Just showDBPutInfo) pdb3
      get "myDummyId" Nothing (Just showRetrievedDocument) pdb3

      traceA "\r\n[TEST 7] delete document"
      let doc4 = PouchDBDocument {
                                  "id" : "hbr789",
                                  "rev" : "1-84abc2a942007bee7cf55007cba56198",
                                  name : "John",
                                  occupation : "Coder",
                                  city : "New York"
                                }
      let doc4x = PouchDBDocument {
                                  "id" : "hbr789",
                                  "rev" : "1-84abc2a942007bee7cf55007cba56122",
                                  name : "John",
                                  occupation : "Coder",
                                  city : "New York"
                                }
      pdb4 <- pouchDB (Just "dummyDB4") Nothing
      post doc4 Nothing (Just showDBPostInfo) pdb4
      put doc4x (Just "myDummy4x") Nothing Nothing (Just showDBPutInfo) pdb3
      get "myDummy4x" Nothing (Just (\mydoc -> do
                                             removeDocRev mydoc Nothing Nothing pdb4
                                             pure unit)) pdb4
      remove doc4 Nothing (Just showDeletedDocument) pdb4

      traceA "\r\n[TEST 8] insert multiple docs"
      pdb5 <- pouchDB (Just "coderDB") Nothing
      let doc_a = PouchDBDocument {
                                  "id" : "hbr_a",
                                  "rev" : "",
                                  name : "Emma",
                                  occupation : "Coder",
                                  city : "Menlo Park"
                                }
      let doc_b = PouchDBDocument {
                                  "id" : "hbr_b",
                                  "rev" : "",
                                  name : "Max",
                                  occupation : "Coder",
                                  city : "New York"
                                }
      let doc_c = PouchDBDocument {
                                  "id" : "hbr_c",
                                  "rev" : "",
                                  name : "Julia",
                                  occupation : "Coder",
                                  city : "New York"
                                }
      let doc_d = PouchDBDocument {
                                  "id" : "hbr_d",
                                  "rev" : "",
                                  name : "Lara",
                                  occupation : "Coder",
                                  city : "New York"
                                }

      traceA "[CLEANUP] Removing databases"
      destroy Nothing (Just showDBDestroyInfo) pdb2
      destroy Nothing (Just showDBDestroyInfo) pdb3
      destroy Nothing (Just showDBDestroyInfo) pdb4
      --destroy Nothing (Just showDBDestroyInfo) pdb5

