$onText
================================================
	-------> EQUATIONS <-----------------
================================================
$offText

$if not declared RealWage $include variables/Income.gms
$if not declared ProfitRate $include variables/Income.gms


$if not declared ProfitShare $include parameters/Profit.gms
$if not declared WageShare $include parameters/Wage.gms



$if not declared SetPriceFromMarkup $include equations/Pricing.gms

$include parameters/Production.gms



* Deferred to later models when \(\frac{\Pi}{K}\) is endogenous
Scalar TotalIncome /1/;
* \(1 \equiv \frac{\Pi}{Y} + \frac{W}{Y}\)
Equation IncomeCompositionId;
	 IncomeCompositionId.. TotalIncome =e= ProfitShare + WageShare;
* \( \frac{W}{Y} = \frac{W}{p}\frac{L}{Y} \)
Equation WageShareId;
	 WageShareId(Technology, Capital, Labor)..
	     WageShare =e= RealWage*unitLaborRequirement(Employment, Output);
* \( \frac{\Pi}{Y} = \frac{\Pi}{K}\frac{K}{Y_K} \)
Equation ProfitShareId;
	 ProfitShareId(Technology, Capital, Labor)..
	 			   ProfitShare =e= ProfitRate*unitCapitalRequirement(Stock,Capacity,Output);


* \( 1 = \frac{W}{p}\frac{L}{Y} + \frac{\Pi}{K}\frac{K}{Y} \)
Equations IncomeTotalityId;
	 IncomeTotalityId(Technology, Capital, Labor).. TotalIncome =e= incomeAt(RealWage, ProfitRate, Employment, Stock, Output, Capacity);

Model IncomeIdentities /
	 IncomeCompositionId
	 WageShareId
	 ProfitShareId
	 IncomeTotalityId
/;


* This equation is model dependent. It is not an accounting identity
* \( \frac{\Pi}{Y} = \mathrm{m}/(1+\mathrm{m}) \)

Equation ProfitShareFromMarkup;
	 ProfitShareFromMarkup.. ProfitShare =e= MarkUpMultiplier/(1+MarkUpMultiplier);
