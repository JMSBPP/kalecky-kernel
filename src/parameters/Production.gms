$onText
================================================
	-------> OUTPUTS <-----------------
		 \(((L,K,A), Y, Y_K, (\frac{L}{Y}) , (\frac{K}{Y_K}))\)
================================================
$offText

Set Technology, Capital, Labor;
Parameter Capacity(Technology, Capital, Labor);
Parameter Output(Technology, Capital, Labor);


* NOTE: Potentially temporary
Parameter Stock(Capital);
Parameter Employment(Labor);

$onText
================================================
	-------> MACROS <-----------------
================================================
$offText

$onMultiR
* \(\frac{Y}{Y_K}\)
$macro utilizationAt(output, capacity) (output(Technology, Capital, Labor)/capacity(Technology, Capital, Labor))

* \(\frac{L}{Y}\)
$macro unitLaborRequirement(employment,output) (employment(Labor)/output(Technology, Capital, Labor))

* \(\frac{K}{Y_K}\)
$macro capitalOutputRatio(capitalStock, capacity) (capitalStock(Capital)/capacity(Technology, Capital, Labor))

* \(\frac{K}{Y} = \frac{K}{Y_K} / \frac{Y}{Y_K}\)
$macro unitCapitalRequirement(capitalStock, capacity,output) (capitalOutputRatio(capitalStock,capacity)/utilizationAt(output,capacity))

* \(\frac{\sum_{K,L}}{Y} = \frac{L}{Y} + \frac{K}{Y}\)

$macro unitFactorRequirement(capitalStock, employment, capacity, output) unitCapitalRequirement(capitalStock, capacity, output) + unitLaborRequirement(employment,output)

$offMulti
