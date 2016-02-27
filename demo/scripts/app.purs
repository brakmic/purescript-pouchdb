module DemoApp.PouchDB where

import Prelude
import Data.Maybe                (Maybe(Nothing, Just), fromMaybe)
import Control.Monad.Eff         (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import API.PouchDB
import Control.Monad.Eff.Random  (RANDOM, random)

showDBInfo :: forall a e. a -> Eff(console :: CONSOLE | e) Unit
showDBInfo = \anyData -> do
                         logRaw anyData

main :: forall e. Eff(console :: CONSOLE, pouchDBM :: PouchDBM | e) Unit
main = do
      pdb <- pouchDB (Just "dummyDB") Nothing
      info showDBInfo pdb
      log "PouchDB database created!"