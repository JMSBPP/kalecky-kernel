module Kalecky_types

import Data.Vect
||| -------------------MICROFOUNDATIONS -----------------


||| ------------------------PRIMAL -----------------------------------
-- > Error: While processing constructor ProductionFactors. When unifying:
-- data Technology: Type
-- data CapitalStock: Type
-- data Labor: Type
-- data ProductionFactors: Technology -> CapitalStock -> Labor -> Vect


--> Error: pre-req of the error above
-- data Output: Type
-- data Capacity: ProductionFactors -> Output

-- Firms tend to prefer to produce under excess capacity. This is with UnderUtilization.
-- This is increasincg capacity due to parameters.

-- These parameters can be:
-- demand forecasts --> Building Ahead of demand
-- "incentives/regulation" to acquire excess factors of production -> Indivisibilities
-- Increasing capacity to increase output, more output, higher supply, lower price, if below entriers marginal cost, they leave --> BarriersToEntry [Oligopoly]

---  OTHERS

AggregateDemand: Type

EconomicGrowth: Type

WageLed: Either AggregateDemand  EconomicGrowth -> Bool
ProfitLed: Either AggregateDemand  EconomicGrowth -> Bool



