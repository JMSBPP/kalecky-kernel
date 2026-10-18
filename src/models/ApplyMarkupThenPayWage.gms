$onText
================================================
	-------> ACTION MODEL <-----------------
	 Apply markup → set \(p\) → \(\frac{\Pi}{Y}\) → pay \(\frac{W}{p}\)
================================================
$offText

$include equations/Income.gms

Model ApplyMarkupThenPayWage /
	 SetPriceFromMarkup
	 ProfitShareFromMarkup
	 PayWageFromProfitShare
/;
