Variable OutputPrice;
Variable Cost;
Variable MarkUpMultiplier;

Positive Variable OutputPrice;
Positive Variable Cost;
Positive Variable MarkUpMultiplier;

* TODO: This parameter comes from production
Parameter LaborProductivity;
* TODO: This parameter comes from some wages module
Parameter NominalWage;

Equations FeasiblePricing, PriceWageProductivityLevel;
FeasiblePricing.. OutputPrice =g= MarkUpMultiplier*Cost.m; 
PriceWageProductivityLevel.. OutputPrice =e= MarkUpMultiplier*NominalWage*LaborProductivity; 