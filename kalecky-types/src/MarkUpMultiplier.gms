Set Competition, Concentration;

Variable MarkUp(Competition,Concentration);

Variable MarkUpMultiplier;
Positive Variable MarkUpMultiplier;

Parameter TotalMarkUpOnlyOn(Concentration);
Equation MarkUpOnCompetitionIsBetterThanOn(Concentration);
	 MarkUpOnCompetitionIsBetterThanOn(Concentration).. sum( Competition, MarkUp(Competition,Concentration)) =l= TotalMarkUpOnlyOn(Concentration);	  

Equation TotalMarkUp;
	 TotalMarkUp.. MarkUpMultiplier =e= sum((Competition, Concentration), MarkUp(Competition,Concentration));
