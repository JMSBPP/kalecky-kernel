$onText
================================================
	-------> EQUATIONS <-----------------
================================================
$offText

$if not declared Utilization $include variables/Production.gms

* \(Y < Y_K \implies \Big (\frac{Y}{Y_K} < 1\Big)\)
Equations excessCapacity;
 	  excessCapacity(Technology, Capital, Labor).. utilizationAt(Output, Capacity)=l=1 ;
