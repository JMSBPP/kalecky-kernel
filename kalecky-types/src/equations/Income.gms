$onText
================================================
	-------> EQUATIONS <-----------------
================================================
$offText

$if not declared RealWage $include variables/Income.gms
$if not declared SetPriceFromMarkup $include equations/Pricing.gms

* \( \frac{\Pi}{Y} = \mathrm{m}/(1+\mathrm{m}) \)
Equation ProfitShareFromMarkup;
	 ProfitShareFromMarkup.. ProfitShare =e= MarkUpMultiplier/(1+MarkUpMultiplier);

* \( \frac{W}{Y} = 1 - \frac{\Pi}{Y} = \frac{W}{p}\frac{L}{Y} \)
Equation PayWageFromProfitShare;
	 PayWageFromProfitShare(Technology, Capital, Labor)..
	     (1-ProfitShare) =e= RealWage*unitLaborRequirement(Employment, Output);

* Deferred to later models when \(\frac{\Pi}{K}\) is endogenous
Scalar TotalIncome /1/;

* \( 1 = \frac{W}{p}\frac{L}{Y} + \frac{\Pi}{K}\frac{K}{Y} \)
Equations IncomeTotality;
	 IncomeTotality(Technology, Capital, Labor).. TotalIncome =e= incomeAt(RealWage, ProfitRate, Employment, Stock, Output, Capacity);
