-- \[
--   \operatorname{Intensity} : \text{StateVector} \to \text{StateVector}
-- \]
-- \[
--   \begin{bmatrix} \frac{K}{N} \\ \frac{E}{N} \\ \cdots \end{bmatrix}
-- \]
-- \[ d = \frac{X}{B}, \qquad d_i = \frac{X_i}{B}, \qquad \sum_i d_i = d \]
-- \[ \frac{B}{X} \; \text{is not derivable} \]
module Kalecky.Operators.Intensity
  ( Density
  , densityRatio
  , densityValue
  , Intensity
  , intensity
  , totalDensity
  , groupDensity
  , matchedDensity
  ) where

import Data.Ratio ((%))

import Kalecky.Types.Panel.Period (Period)
import Kalecky.Types.Stocks.StateVector (component, total)
import Kalecky.Types.Stocks.Stock (Role (..), Stock, at, totals)
import Kalecky.Types.Units.CompoundUnit (Per, denominator, numerator, per)
import Kalecky.Types.Units.Unit (value)

newtype Density b c = Density (Per b c)
  deriving (Eq, Show)

densityRatio :: Density b c -> Per b c
densityRatio = undefined

densityValue :: Density b c -> Rational
densityValue = undefined

data Intensity g h b c = Intensity (Stock Level g b) (Stock Base h c)

intensity :: Stock Level g b -> Stock Base h c -> Maybe (Intensity g h b c)
intensity = undefined

totalDensity :: Period -> Intensity g h b c -> Maybe (Density b c)
totalDensity = undefined

groupDensity :: Ord g => g -> Period -> Intensity g h b c -> Maybe (Density b c)
groupDensity = undefined

matchedDensity :: Ord g => g -> Period -> Intensity g g b c -> Maybe (Density b c)
matchedDensity = undefined
