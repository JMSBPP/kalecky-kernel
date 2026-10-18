$onText
================================================
	-------> ENDOGENOUS VARIABLES <-----------------
		 \((\mathrm{p})\)
================================================
$offText

$if not declared FixedUnitCost $include parameters/Pricing.gms

* \(\mathrm{p}\)
Variable Price;
Positive Variable Price;
