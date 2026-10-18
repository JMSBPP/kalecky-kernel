$onText
================================================
	-------> ENDOGENOUS VARIABLES <-----------------
		 \((\mathrm{m})\)
================================================
$offText

$if not declared Competition $include parameters/MarkUpMultiplier.gms
Variable MarkUp(Competition,Concentration);
Variable MarkUpMultiplier;
Positive Variable MarkUpMultiplier;
