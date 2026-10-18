$onText
================================================
	-------> MACROS <-----------------
================================================
$offText

$if not declared Labor $include parameters/Production.gms

* \(\frac{W}{P}\cdot\frac{L}{Y} + \frac{\Pi}{K}\cdot\frac{K}{Y}\)
$macro incomeAt(realWage,profitRate,employment,capitalStock,output,capacity) (realWage*unitLaborRequirement(employment,output)+profitRate*unitCapitalRequirement(capitalStock,capacity,output))
