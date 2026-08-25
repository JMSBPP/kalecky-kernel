-- \[
--   FK =
--   \begin{bmatrix} K \\ L \\ E \\ A \end{bmatrix} =
--   \begin{bmatrix}
--     K_F \oplus K_K \oplus K_{MC} \\
--     L_I \oplus L_F \oplus L_{ML} \\
--     E_G \oplus E_{pr} \\
--     A
--   \end{bmatrix}
-- \]
-- \[ S : T \to \text{StateVector}, \qquad T = \{ (g, n), (g, n+1), \dots, (g, n+k) \} \]
module Kalecky.Types.Stocks.Stock
  ( Role (..)
  , Stock
  , stock
  , point
  , at
  , series
  , totals
  , toPanel
  ) where

import Data.List (sortOn)
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map

import Kalecky.Types.Panel.Panel (Panel, panel)
import Kalecky.Types.Panel.Period (Period, granularity, ordinal)
import Kalecky.Types.Stocks.StateVector (StateVector, component, total)
import Kalecky.Types.Units.Unit (Unit)

data Role = Base | Level
  deriving (Eq, Show)

data Stock (r :: Role) g b = Stock [Period] (Map Period (StateVector g b))
  deriving (Eq, Show)

stock :: [(Period, StateVector g b)] -> Maybe (Stock r g b)
stock = undefined

point :: Period -> StateVector g b -> Stock r g b
point = undefined

at :: Period -> Stock r g b -> Maybe (StateVector g b)
at = undefined

series :: Ord g => g -> Stock r g b -> [(Period, Unit b)]
series = undefined

totals :: Stock r g b -> [(Period, Unit b)]
totals = undefined

toPanel :: (Bounded g, Enum g, Ord g) => Stock r g b -> Panel g Period (Unit b)
toPanel = undefined
