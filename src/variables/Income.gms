$onText
================================================
	-------> ENDOGENOUS VARIABLES <-----------------
		 \(\Big(\frac{W}{p},\ \frac{\Pi}{Y},\ \frac{\Pi}{K}\Big)\)
================================================
$offText

$if not declared Labor $include parameters/Income.gms

* \(\frac{W}{p}\)
Variable RealWage;
Positive Variable RealWage;

* \(\frac{\Pi}{Y}\)
Variable ProfitShare;
Positive Variable ProfitShare;

* \(\frac{\Pi}{K}\)
Variable ProfitRate;
Positive Variable ProfitRate;
