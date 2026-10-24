$onText
===========================================================
	---------> INPUTS <--------------
		   \((\mathrm{m}, \mathrm{C}, \mathrm{a}))\)
===========================================================
$offText
$include parameters/Costs.gms
$include parameters/MarkUpMultiplier.gms
$include parameters/Productivity.gms

$onText
===========================================================
	---------> MACROS <--------------
===========================================================
$offText

* \(\mathrm{p} = \mathrm{m} \cdot (\sum FC) / (\sum \mathrm{a}_{K,L})\)
$macro setPrice(cost,markup,totalProductivity) markup*averageUnitCost(cost)/totalFactorProductivityOver(totalProductivity)

$onText
===========================================================
	---------> OUTPUTS <--------------
		   \(\mathrm{p}\) 
===========================================================
$offText



