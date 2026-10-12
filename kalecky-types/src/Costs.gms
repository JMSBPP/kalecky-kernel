
* Import only Labor, Technology, CapitalStock
* TODO: This needs to be replaced to be coming from Production

Set Labor, Technology, CapitalStock;

Parameter FixedCosts(Labor, Technology, CapitalStock);
Variable Cost;

Positive Variable Cost;

Equation CostStructure;
CostStructure.. Cost =g= sum((Labor, Technology, CapitalStock), FixedCosts(Labor, Technology, CapitalStock));