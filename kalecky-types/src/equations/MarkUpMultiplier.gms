$onText
================================================
	-------> EQUATIONS <-----------------
================================================
$offText

$if not declared MarkUp $include variables/MarkUpMultiplier.gms

* \(\sum_E \mathrm{m}_{E,S} \le \mathrm{m}^{+}\)
Equation MarkUpOnCompetitionIsBetterThanOn(Concentration);
	 MarkUpOnCompetitionIsBetterThanOn(Concentration).. sum( Competition, MarkUp(Competition,Concentration)) =l= TotalMarkUpOnlyOn(Concentration);

* \(\mathrm{m} = \sum_{E,S} \mathrm{m}_{E,S}\)
Equation TotalMarkUp;
	 TotalMarkUp.. MarkUpMultiplier =e= sum((Competition, Concentration), MarkUp(Competition,Concentration));
