module API.PouchDB
          (
            PouchDBM,
            PouchDB,
            PouchDBEff,
            Adapter(),
            StorageType(),
            AndroidDBImplementation(),
            PouchDBOptions(),
            PouchDBInfo(),
            logRaw,
            pouchDB,
            info
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

data DefaultDBOptions = DefaultDBOptions {
  "name" :: String
}

data LocalDBOptions = LocalDBOptions {
  "auto_compaction" :: Boolean,
  "adapter"         :: Adapter,
  "revs_limit"      :: Int
}

data RemoteDBOptions = RemoteDBOptions {
  "ajax.cache"           :: Boolean,
  "ajax.headers"         :: List String,
  "auth.username"        :: String,
  "auth.password"        :: String,
  "ajax.withCredentials" :: Boolean
}

data IndexedDBOptions = IndexedDBOptions {
  "storage" :: StorageType
}

data WebSQLOptions = WebSQLOptions {
  "size" :: Int
}

data SQLiteOptions = SQLiteOptions {
  "location"                      :: String,
  "createFromLocation"            :: String,
  "androidDatabaseImplementation" :: AndroidDBImplementation
}

data OtherDBOptions a = OtherDBOptions a

data PouchDBOptions =
            DefaultDBOptions
          | LocalDBOptions
          | RemoteDBOptions
          | IndexedDBOptions
          | WebSQLOptions
          | OtherDBOptions

data PouchDBInfo = PouchDBInfo {
  "db_name"    :: String,
  "doc_count"  :: Number,
  "update_seq" :: Number
}

-- | Logging helper
foreign import logRaw :: forall a e. a -> Eff (console :: CONSOLE | e) Unit

-- | PouchDB API
foreign import pouchDB :: forall e. Maybe String -> Maybe PouchDBOptions -> PouchDBEff PouchDB
foreign import info    :: forall a e. (a -> Eff e Unit) -> PouchDB -> PouchDBEff Unit

