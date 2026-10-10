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
-- \(Y < Y_K\)
-- > Error: pre-req above 

-- data UnderUtilization: Output -> Capacity -> Type
-- data UltilizationRate: Output -> Capacity -> Num Type

||| --------------------- DUAL ------------------------------------

-- data Cost: Type
-- data VariableCost: Output -> Capacity -> Cost


-- This considers transformations like average cost, marginal, average total, etc
-- data CostForPricing: Cost -> Cost

-- data FixedCost: Cost
-- Any \(\theta_{m}\) where \(\theta_{m}\) is *proved* to have causal effect on markups \(m\)

data Parameter: Type
data MarkUp: Type

-- Cause: Parameter -> MarkUp -> MarkUp

-- > Error: Return type of Kalecky_types.MarkUpParameter must be Type. 
-- data MarkUpParameter : Parameter -> MarkUp where
--      Cause: Parameter Markup 

-- data Price: MarkUp -> CostForPricing -> Num Type

||| -----------------------STATE ---------------------------------

-- data State: FixedCost -> ProductionFactors -> Vect

||| -----------------------------------OTHERS------------------------------------------

-- WageLed, ProfitLed is a property of AggregateDemand AND EconomicGrowth

data AggregateDemand: Type

data EconomicGrowth: Type

-- > Error: While processing constructor ProfitLed. with application not implemented yet  
-- data WageLed: AggregateDemand | EconomicGrowth -> Bool
-- data ProfitLed: AggregateDemand | EconomicGrowth -> Bool
