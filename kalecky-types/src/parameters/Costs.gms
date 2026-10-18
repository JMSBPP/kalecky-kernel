$onText
================================================
	-------> INPUTS <-----------------
		 \((L,K,A)\)
================================================
$offText

$if not declared Labor $include parameters/Production.gms

$onText
================================================
	-------> MACROS <-----------------
================================================
$offText

* \(\sum_{L,A,K} FC(L,A,K)\)
$macro averageUnitCost(fixedUnitCost) sum((Labor, Technology, Capital), fixedUnitCost(Labor, Technology, Capital))

$onText
================================================
	-------> OUTPUTS <-----------------
		 \(FC(L,K,A), C(L,K)\)
================================================
$offText

Parameter FixedUnitCost(Labor, Technology, Capital);
Parameter UnitCost(Labor, Capital);
