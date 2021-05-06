{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module KaTeX.KaTeXIPC
    ( kaTeXifyIO
    ) where

import Control.Monad
import System.ZMQ4.Monadic
import qualified Data.ByteString.Char8 as BS (putStr, putStrLn)
import Data.ByteString (ByteString)
import Data.ByteString.Lazy (toStrict)
import GHC.Generics
import Data.Text
import Data.Text.Encoding (decodeUtf8)
-- Pandoc
import Text.Pandoc.Definition (MathType(..), Inline(Math, RawInline), Pandoc, Format(..))
import Text.Pandoc.Readers.HTML (readHtml)
import Text.Pandoc.Options (def)
import Text.Pandoc.Walk (walkM)
import Text.Pandoc.Class (PandocPure, runPure)
-- Aeson
import Data.Aeson hiding (Options)

--------------------------------------------------------------------------------
-- DataTypes
--------------------------------------------------------------------------------
newtype Options = Options
  { displayMode :: Bool
  } deriving (Generic, Show)

data TeXMath = TeXMath
  { latex :: Text
  , options :: Options
  } deriving (Generic, Show)

--------------------------------------------------------------------------------
-- Instances
--------------------------------------------------------------------------------
instance ToJSON Options where
  -- No need to provide implementation (Generic)
instance FromJSON Options where
  -- No need to provide implementation (Generic)
instance ToJSON TeXMath where
  -- No need to provide implementation (Generic)
instance FromJSON TeXMath where
  -- No need to provide implementation (Generic)

--------------------------------------------------------------------------------
-- Convert Inline
--------------------------------------------------------------------------------
toTeXMath :: MathType -> Text -> TeXMath
toTeXMath mt inner =
  TeXMath
  { latex = inner
  , options = toOptions mt
  }
  where
    toOptions DisplayMath = Options { displayMode = True }
    toOptions _ = Options { displayMode = False }


toKaTeX :: TeXMath -> IO ByteString
toKaTeX tex = runZMQ $ do
  requester <- socket Req
  connect requester "ipc:///tmp/katex"
  send requester [] (toStrict $ encode tex)
  receive requester

parseKaTeX :: Text -> Maybe Inline
parseKaTeX txt =
  -- Ensure txt is parsable HTML
  case runPure $ readHtml def txt of
    Right _   -> Just (RawInline (Format "html") txt)
    otherwise -> Nothing

kaTeXify :: Inline -> IO Inline
kaTeXify orig@(Math mt str) =
  do
    bs <- toKaTeX (toTeXMath mt str)
    case (parseKaTeX $ decodeUtf8 bs) of
      Just inl -> return inl
      Nothing  -> return orig
kaTeXify x = return x

--------------------------------------------------------------------------------
-- Convert Pandoc
--------------------------------------------------------------------------------
kaTeXifyIO :: Pandoc -> IO Pandoc
kaTeXifyIO p = do
  walkM kaTeXify p