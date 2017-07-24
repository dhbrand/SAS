/**Hiltbrand Dave Homework 6 STT 305 850418330**/

options noimplmac nodate nonumber;
libname mysas '//seashare/blumj/SAS Programming Data';
run;

/**Problem 1**/
proc sgplot data=sashelp.heart;
	histogram systolic / /**dataskin=pressed**/ binwidth=10 transparency=.5;
	histogram diastolic / /**dataskin=pressed**/ binwidth=10 transparency=.5;
	xaxis label='Blood Pressure';
	yaxis values=(0 to 30 by 10)offsetmax=.12;
	title 'Blood Pressure Distributions';
	keylegend / position=topright location=inside across=1;
run;

/**Problem 2**/
proc sgplot data=sashelp.orsales /**noborder**/;
	hbar year / response=profit group=product_line groupdisplay=cluster dataskin=pressed;
	xaxis values=(0 to 8000000 by 1000000) display=(nolabel) minor tickvalueformat=dollar10.;
	title 'Total Profit';
	keylegend / location=inside position=topright across=1 title='Product Line';
run;

/**Problem 3**/
proc sgplot data=sashelp.orsales noautolegend;
	hbar year / response=profit fillattrs=(color=cx3333CC) dataskin=pressed barwidth=.4 discreteoffset=.2;
	hbar year / response=quantity x2axis fillattrs=(color=cxCC3333) dataskin=pressed  barwidth=.4 discreteoffset=-.2; 
	xaxis  values=(0 2e6 4e6 6e6 8e6 10e6 12e6 14e6 16e6) valueattrs=(color=cx3333CC family='Arial Bold' size=12pt)
		labelattrs=(family='Arial Bold' size=12pt) tickvalueformat=dollar10.;
	x2axis values=(0 to 4000 by 1000) valueattrs=(color=cxCC3333 family='Arial Bold' size=12pt);/**x2axis not displaying**/
	title 'Summary 1999 to 2002';
run;

/**Problem 4**/
proc sgplot data=mysas.real_estate;
	scatter x=sq_ft y=price / group=bedrm grouporder=ascending;/**group 4+ **/
	where year ge 1985 and bedrm ne 0;
	xaxis tickvalueformat=comma.;
	yaxis display=(nolabel) tickvalueformat=dollar8.;
	title j=right 'Sale Price v. Square Footage';
	title2 j=right 'Homes Built in 1985 and After';
	keylegend / location=inside position=topleft title='Number of Bedrooms';
run;

/**Problem 5**/
proc sgplot data=mysas.real_estate;
	loess x=year y=bedrm / y2axis legendlabel='Bedrooms' lineattrs=(color=red pattern=solid)
		smooth=0.6 degree=2 markerattrs=(symbol=circlefilled color=red size=4px);
	loess x=year y=price/ legendlabel='Price' lineattrs=(color=blue pattern=solid)
		smooth=0.3 degree=1 interpolation=cubic markerattrs=(symbol=circle color=blue);
	where year between 1960 and 2000;
	yaxis display=(nolabel) values=(0 to 9e5 by 1e5) tickvalueformat=dollar8. offsetmax=.1 offsetmin=.1;
	y2axis display=(nolabel) values=(1 to 7 by 1) offsetmax=.1 offsetmin=.1;
	title j=left height=14pt 'Price & Bedrooms v. Year Built';
	keylegend / location=outside position=topleft;
run;
