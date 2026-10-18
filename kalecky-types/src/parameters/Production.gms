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

* \(\frac{Y}{Y_K}\)
$macro utilizationAt(output, capacity) (output(Technology, Capital, Labor)/capacity(Technology, Capital, Labor))

* \(\frac{L}{Y}\)
$macro unitLaborRequirement(employment,output) (employment(Labor)/output(Technology, Capital, Labor))

* \(\frac{K}{Y_K}\)
$macro capitalOutputRatio(capitalStock, capacity) (capitalStock(Capital)/capacity(Technology, Capital, Labor))

* \(\frac{K}{Y}\)
$macro unitCapitalRequirement(capitalStock, capacity,output) (capitalOutputRatio(capitalStock,capacity)/utilizationAt(output,capacity))
