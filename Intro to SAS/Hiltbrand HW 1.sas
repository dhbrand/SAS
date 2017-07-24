'**/Hiltbrand HW1.sas/**'
title 'MPG Summary Across Vehicle Origin';
title2 'SUVs, Sedans & Wagons';
options nonumber nodate ls=120;
proc means data=sashelp.cars mean median stddev min max maxdec=2;
	class origin type;
	where type IN('SUV','Sedan','Wagon'); 
	var mpg_city mpg_highway;
run;


title 'City MPG';
title2 'vs Type and Origin';
options nodate nonumber;
proc format;
	value $origin
		'Asia'='Non-US'
		'Europe'='Non-US'
		'USA'='United States'
		;
	value citympg
		low-15='15 MPG and below'
		15<-20='16 to 20 MPG'
		20<-25='21 to 25 MPG'
		25<-high='26 MPG or higher'
		;
Run;

proc freq data=sashelp.cars;
	table origin*mpg_city*type;
	where type='SUV' or type='Sedan' or type='Wagon';
	format origin $origin. mpg_city citympg.;
run;


libname mysas '\\seashare\blumj\SAS Programming Data';
title 'Delays vs. Destination';
footnote 'Minor Delay = 10 min or less';
options number pageno=1;
proc format;
	value delay
		low-0='No Delay'
		0<-10='Minor Delay'
		10<-high='Major Delay'
		;
	value $city
		'CDG'='De Gaulle'
		'CPH'='Copenhagen'
		'DFW'='Dallas/Ft. Worth'
		'FRA'='Frankfort'
		'LAX'='Los Angeles'
		'LHR'='London-Heathrow'
		'ORD'="O'Hare"
		'WAS'='DC-All Airports'
		'YYZ'='Toronto'
		;
run;

proc freq data=mysas.flightdelays;
	table destination*delay / norow nocol;
	format destination $city. delay delay.;
run;




title 'Summaries by Day and Destination Type';
title2 'For Delayed Flights';
footnote;
options number pageno=1;

proc format;
	value dayname
	1='Sunday'
	2='Monday'
	3='Tuesday'
	4='Wednesday'
	5='Thursday'
	6='Friday'
	7='Saturday'
	;
run;

proc means data=mysas.flightdelays min mean median max;
	where delay gt 0;
	class dayofweek destinationtype;
	var delay;
	format dayofweek dayname.;
run;




