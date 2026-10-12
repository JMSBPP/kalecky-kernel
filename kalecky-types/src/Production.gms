Set Technology, CapitalStock, Labor;

Parameter Capacity(Technology, CapitalStock, Labor);

Variables
	Output(Technology, CapitalStock,Labor)
	Utilization(Technology, CapitalStock,Labor);

Positive Variable Output;
Positive Variable Utilization;

Equations excessCapacity;
 	  excessCapacity(Technology, CapitalStock, Labor).. Output(Technology, CapitalStock, Labor)=l=Capacity(Technology, CapitalStock,Labor) ;
