$onText
================================================
	-------> EQUATIONS <-----------------
================================================
$offText

$if not declared Price $include variables/Pricing.gms
$if not declared MarkUpMultiplier $include variables/MarkUpMultiplier.gms

* \( p = \mathrm{m} \cdot (\sum FC) / (\sum \mathrm{a}_{K,L}) \)
Equation SetPriceFromMarkup;
	 SetPriceFromMarkup.. Price =e= setPrice(FixedUnitCost, MarkUpMultiplier, TotalFactorProductivity);
