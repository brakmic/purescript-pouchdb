module API.PouchDB
          (
              PouchDBM
            , PouchDB
            , PouchDBEff
            , Adapter(..)
            , StorageType(..)
            , AndroidDBImplementation(..)
            , PouchDBOptions(..)
            , PouchDBInfo(..)
            , PouchDBResponse(..)
            , PouchDBDocument(..)
            , logRaw
            , pouchDB
            , info
            , destroy
            , put
            , post
            , get
            , remove
            , removeDocRev
            , allDocs
            , bulkDocs
          ) where

import Prelude                       (Unit)
import Data.Maybe                    (Maybe)
import Control.Monad.Eff             (Eff)
import Control.Monad.Eff.Console     (CONSOLE())
import Control.Monad.Eff.Exception   (EXCEPTION)

-- | PouchDB Effects & Types
foreign import data PouchDBM :: !
foreign import data PouchDB  :: *

type PouchDBEff a = forall e. Eff(pouchDBM :: PouchDBM | e) a

data Adapter = IDB | LevelDB | WebSQL | Http
data StorageType = Persistent | Temporary
data AndroidDBImplementation = SQLite4Java | NativeAPI

data PouchDBResponse a = PouchDBResponse a |
          SimpleResponse {
            "ok" :: Boolean
          }

data PouchDBOptions a =
            DefaultDBOptions {
              "name" :: String
            }
          | LocalDBOptions {
              "auto_compaction" :: Boolean,
              "adapter"         :: Adapter,
              "revs_limit"      :: Int
            }
          | RemoteDBOptions {
              "ajax.cache"           :: Boolean,
              "ajax.headers"         :: Array String,
              "auth.username"        :: String,
              "auth.password"        :: String,
              "ajax.withCredentials" :: Boolean
            }
          | IndexedDBOptions {
              "storage" :: StorageType
            }
          | WebSQLOptions {
              "size" :: Int
            }
          | OtherDBOptions a

data PouchDBDocument a = PouchDBDocument {
                          "_id"   :: Maybe String,
                          "_rev"  :: Maybe String
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
foreign import pouchDB      :: forall a e. Maybe String -> Maybe (PouchDBOptions a) -> Eff (err :: EXCEPTION | e) PouchDB
foreign import info         :: forall a e f. Maybe (a -> Eff e Unit) -> PouchDB -> Eff (err :: EXCEPTION | f) Unit
foreign import destroy      :: forall a b c e. Maybe (PouchDBOptions a) -> Maybe (b -> Eff c Unit) -> PouchDB -> Eff (err :: EXCEPTION | e) Unit
foreign import put          :: forall a b c d e. PouchDBDocument a -> Maybe String -> Maybe String -> Maybe (PouchDBOptions b) -> Maybe (c -> Eff d Unit) -> PouchDB -> Eff (err :: EXCEPTION | e) Unit
foreign import post         :: forall a b c d e. PouchDBDocument a -> Maybe (PouchDBOptions b) -> Maybe (c -> Eff d Unit) -> PouchDB -> Eff (err :: EXCEPTION | e) Unit
foreign import get          :: forall a b c e. String -> Maybe (PouchDBOptions a) -> Maybe (b -> Eff c Unit) -> PouchDB -> Eff (err :: EXCEPTION | e) Unit
foreign import remove       :: forall a b c d e. PouchDBDocument a -> Maybe (PouchDBOptions b) -> Maybe (c -> Eff d Unit) -> PouchDB -> Eff (err :: EXCEPTION | e) Unit
foreign import removeDocRev :: forall a b c d e. PouchDBDocument a -> Maybe (PouchDBOptions b) -> Maybe (c -> Eff d Unit) -> PouchDB -> Eff (err :: EXCEPTION | e) Unit
foreign import bulkDocs     :: forall a b c d e. Array (PouchDBDocument a) -> Maybe (PouchDBOptions b) -> Maybe (c -> Eff d Unit) -> PouchDB -> Eff (err :: EXCEPTION | e) Unit
foreign import allDocs      :: forall a b c e. Maybe (PouchDBOptions a) -> Maybe(b -> Eff c Unit) -> PouchDB -> Eff (err :: EXCEPTION | e) Unit
