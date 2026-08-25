-- \[ P : G \times T \to V \]
-- \[ \operatorname{dom}(P) = G \times T \]
module Kalecky.Types.Panel.Panel
  ( Panel
  , panel
  , window
  , cell
  , row
  , column
  , groups
  , periods
  ) where

import Data.List (nub)
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map

data Panel g t v = Panel [t] (Map (g, t) v)
  deriving (Eq, Show)

panel :: (Bounded g, Enum g, Ord g, Ord t) => [t] -> (g -> t -> v) -> Panel g t v
panel = undefined

window :: (Bounded g, Enum g, Ord g, Ord t) => [t] -> [(g, t, v)] -> Maybe (Panel g t v)
window = undefined

cell :: (Ord g, Ord t) => g -> t -> Panel g t v -> Maybe v
cell = undefined

row :: (Ord g, Ord t) => g -> Panel g t v -> [(t, v)]
row = undefined

column :: (Bounded g, Enum g, Ord g, Ord t) => t -> Panel g t v -> Maybe (g -> v)
column = undefined

groups :: (Bounded g, Enum g) => Panel g t v -> [g]
groups = undefined

periods :: Panel g t v -> [t]
periods = undefined
