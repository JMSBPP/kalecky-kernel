$onText
================================================
	-------> INPUTS <-----------------
		 \((L,K,A)\)
================================================
$offText

$if not declared Labor $include parameters/Production.gms
Parameter LaborProductivity(Labor);
Parameter CapitalProductivity(Capital);
Parameter TotalFactorProductivity(Capital, Labor);

$onText
================================================
	-------> MACROS <-----------------
================================================
$offText

* \(\sum_L \mathrm{a}_L\)
$macro laborProductivitySum(laborProductivity) sum(Labor, laborProductivity(Labor))

* \(\sum_K \mathrm{a}_K\)
$macro capitalProductivitySum(capitalProductivity) sum(Capital, capitalProductivity(Capital))

* \(\mathrm{a} = \sum_L \mathrm{a}_L + \sum_K \mathrm{a}_K\)
$macro totalFactorProductivitySum(laborProductivity, capitalProductivity) laborProductivitySum(laborProductivity) + capitalProductivitySum(capitalProductivity)

* \(\sum_{K,L} \mathrm{a}_{K,L}\)
$macro totalFactorProductivityOver(totalFactorProductivity) sum((Capital, Labor), totalFactorProductivity(Capital, Labor))

$onText
================================================
	-------> OUTPUTS <-----------------
	 \((\mathrm{a}_L, \mathrm{a}_K, \mathrm{a}_{K,L})\)
================================================
$offText
