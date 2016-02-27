module API.PouchDB
          (
            PouchDBM,
            PouchDB,
            PouchDBEff,
            Adapter(..),
            StorageType(..),
            AndroidDBImplementation(..),
            PouchDBOptions(..),
            PouchDBInfo(..),
            PouchDBResponse(..),
            logRaw,
            pouchDB,
            info,
            destroy
          ) where

import Prelude
import Data.Maybe
import Data.List
import Control.Monad.Eff             (Eff)
import Control.Monad.Eff.Console     (CONSOLE())

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
              "ajax.headers"         :: List String,
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

data PouchDBInfo = PouchDBInfo {
  "db_name"    :: String,
  "doc_count"  :: Number,
  "update_seq" :: Number
}

-- | Logging helper
foreign import logRaw :: forall a e. a -> Eff (console :: CONSOLE | e) Unit

-- | PouchDB API
foreign import pouchDB :: forall a e. Maybe String -> Maybe (PouchDBOptions a) -> PouchDBEff PouchDB
foreign import info    :: forall a e. Maybe (a -> Eff e Unit) -> PouchDB -> PouchDBEff Unit
foreign import destroy :: forall a b c e. Maybe (PouchDBOptions a) -> Maybe (b -> Eff e Unit) -> PouchDB -> PouchDBEff (PouchDBResponse c)

