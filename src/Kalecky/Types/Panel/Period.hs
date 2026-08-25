-- \[ t = (g, n), \qquad g \in \{\text{Hour}, \text{Month}\}, \; n \in \mathbb{N} \]
-- \[ \operatorname{next}(g, n) = (g, n + 1) \]
-- \[ (g, n) \prec (g, m) \iff n < m ; \qquad (g, n) \not\sim (g', m) \text{ for } g \neq g' \]
module Kalecky.Types.Panel.Period
  ( Period
  , period
  , granularity
  , ordinal
  , next
  , compareP
  ) where

import Numeric.Natural (Natural)

import Kalecky.Types.Units.TimeUnit (TimeBasis)

data Period = Period TimeBasis Natural
  deriving (Eq, Ord, Show)

period :: TimeBasis -> Natural -> Period
period = undefined

granularity :: Period -> TimeBasis
granularity = undefined

ordinal :: Period -> Natural
ordinal = undefined

next :: Period -> Period
next = undefined

compareP :: Period -> Period -> Maybe Ordering
compareP = undefined
