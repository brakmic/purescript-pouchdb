module API.PouchDB
          (
              PouchDBM
            , PouchDB
            , PouchDBEff
            , AjaxOptions
            , AuthOptions
            , LocalDBOptions
            , RemoteDBOptions
            , PouchDBOptions(..)
            , PouchDBInfo(..)
            , PouchDBResponse(..)
            , PouchDBDocument(..)
            , IndexedDBOptions
            , WebSQLOptions
            , SQLiteOptions
            , logRaw
            , pouchDB
            , info
            , destroy
            , put
            , post
            , get
            , remove
            , removeDocRev
          ) where

import Control.Monad.Eff (Eff, kind Effect)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Maybe (Maybe)
import Prelude (Unit)

-- | PouchDB Effects & Types
foreign import data PouchDBM :: Effect 
foreign import data PouchDB  :: Type

type PouchDBEff a = Eff (pouchdbm :: PouchDBM) a

data PouchDBResponse a = PouchDBResponse a |
          SimpleResponse {
            "ok" :: Boolean
          }

type DefaultDBOptions = {
  "name" :: String
}
type LocalDBOptions = {
  "auto_compaction" :: Boolean,
  "adapter"         :: Maybe String,
  "revs_limit"      :: Int
}

type RemoteDBOptions a = {
  "ajax"                 :: Maybe AjaxOptions,
  "auth"                 :: Maybe AuthOptions,
  "skip_setup"           :: Maybe Boolean
  | a
}

type AjaxOptions = {
  "withCredentials" :: Boolean,
  "cache"           :: Boolean,
  "headers"         :: Array String
}

type AuthOptions = {
  "username" :: String,
  "password" :: String
}

type IndexedDBOptions = {
  "storage" :: String
}
type WebSQLOptions = {
  "size" :: Int
}

type SQLiteOptions = {
  "location"                     :: String,
  "createFromLocation"           :: Boolean,
  "adroidDatabaseImplementation" :: Int
}

data OtherDBOptions a = OtherDBOptions a

data PouchDBOptions a = PouchDBOptions {
              "name"    :: Maybe String,
              "local"   :: Maybe LocalDBOptions,
              "remote"  :: Maybe (RemoteDBOptions a),
              "indexdb" :: Maybe IndexedDBOptions,
              "websql"  :: Maybe WebSQLOptions,
              "sqlite"  :: Maybe SQLiteOptions
            }

data PouchDBDocument a = PouchDBDocument {
                "id"   :: String,
                "rev"  :: String
                | a
            }


data PouchDBInfo = PouchDBInfo {
  "db_name"    :: String,
  "doc_count"  :: Number,
  "update_seq" :: Number
}

-- | Logging helper
foreign import logRaw :: forall a e. a -> Eff (console :: CONSOLE | e) Unit

-- | PouchDB API
foreign import pouchDB      :: forall a e.     Maybe String -> Maybe (PouchDBOptions a) -> Eff (err :: EXCEPTION | e) PouchDB
foreign import info         :: forall a b c.   Maybe (a -> Eff b Unit) -> PouchDB -> Eff (err :: EXCEPTION | c) Unit
foreign import destroy      :: forall a b c d.   Maybe (PouchDBOptions a) -> Maybe (b -> Eff c Unit) -> PouchDB -> Eff (err :: EXCEPTION | d) Unit
foreign import put          :: forall a b c d e. PouchDBDocument a -> Maybe String -> Maybe String -> Maybe (PouchDBOptions b) -> Maybe (c -> Eff d Unit) -> PouchDB -> Eff (err :: EXCEPTION | e) Unit
foreign import post         :: forall a b c d e. PouchDBDocument a -> Maybe (PouchDBOptions b) -> Maybe (c -> Eff d Unit) -> PouchDB -> Eff (err :: EXCEPTION | e) Unit
foreign import get          :: forall a b c d.   String -> Maybe (PouchDBOptions a) -> Maybe (b -> Eff c Unit) -> PouchDB -> Eff (err :: EXCEPTION | d) Unit
foreign import remove       :: forall a b c d e. PouchDBDocument a -> Maybe (PouchDBOptions b) -> Maybe (c -> Eff d Unit) -> PouchDB -> Eff (err :: EXCEPTION | e) Unit
foreign import removeDocRev :: forall a b c d e. PouchDBDocument a -> Maybe (PouchDBOptions b) -> Maybe (c -> Eff d Unit) -> PouchDB -> Eff (err :: EXCEPTION | e) Unit
