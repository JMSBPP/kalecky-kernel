$onText
================================================
	-------> ENDOGENOUS VARIABLES <-----------------
	\(\Big (\frac{Y}{Y_K}\Big)\)
================================================
$offText

$if not declared Labor $include parameters/Production.gms
Variables Utilization(Technology, Capital,Labor);
Positive Variable Utilization;
