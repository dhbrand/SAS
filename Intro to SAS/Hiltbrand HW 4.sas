options noimplmac;
run;

filename rawdata '\\timmy.uncw.edu\students\dh4545';

data hw1;
	infile rawdata ('payroll 2.txt') dsd missover;
	input @1 dob date9. @10 hire_date date9. empID 19-22 gender$ 23
		jobcode$ 24-26 @27 salary comma8.;
	yos=yrdif(hire_date,today(),'ACT');
	yralive=yrdif(dob,today(),'ACT');
	select(substr(jobcode,3,1));
		when('1')
			do;
				raise=salary*0.03;
				if yos ge 25 then bump=1500;
					else bump=0;
			end;

		when('2')
			do;
				raise=salary*0.0375;
				if yos ge 25 then bump=2500;
					else bump=0;
			end;
		when('3')
			do;
				raise=salary*0.045;
				if yos ge 25 then bump=3000;
					else bump=0;
			end;
		otherwise 
			do; 
				raise=salary*0.035;
				if yos ge 25 then bump=2000;
					else bump=0;
			end;
	end;
	newsalary=salary+raise+bump;
	length retired $10;
	if yralive ge 62 then retired='Eligible';
		else if yralive ge 55 and yos ge 25 then retired='Eligible';
			else retired='Ineligible';
	format dob hire_date mmddyy10. salary raise bump newsalary dollar10.2 yos yralive 2.;
	label dob='Date of Birth' hire_date='Date of Hire' empID='Employee ID' gender='Gender' jobcode='Job Code' salary='Old Salary'
		yos='Years of Service' yralive='Age' raise='Raise' bump='Year End Bonus' newsalary='New Salary' retired='Eligible for Retirement';
run;

data hw2;
	infile rawdata('december 2.txt') dlm='09'x dsd missover;
	input routeID$ dp_date:date9. dp_time:time. fstrev:comma. busrev:comma. ecorev:comma. cgorev:comma.;
	if busrev=. then busrev=0;
	passrev=fstrev+busrev+ecorev;
	totrev=passrev+cgorev;
	length dest $3;
	select(routeID);
		when('02') 
			do;
				origin='ATL';
				dest='RDU';
			end;
		when('24')
			do;
				origin='JFK';
				dest='RDU';
			end;
		when('43')
			do;
				origin='RDU';
				dest='JFK';
			end;
		when('45')
			do;
				origin='RDU';
				dest='ATL';
			end;
		when('47')
			do;
				origin='RDU';
				dest='ORD';
			end;
		when('49')
			do;
				origin='RDU';
				dest='DCA';
			end;
		when('51')
			do;
				origin='DCA';
				dest='RDU';
			end;
		when('67')
			do;
				origin='CLT';
				dest='ORD';
			end;
		when('69')
			do;
				origin='CLT';
				dest='LDA';
			end;
		when('79')
			do;
				origin='ORD';
				dest='RDU';
			end;
		when('81')
			do;
				origin='ORD';
				dest='CLT';
			end;
		when('83')
			do;
				origin='LGA';
				dest='CLT';
			end;
	end;
	if dp_time lt '07:00't then timeofday=0;
		else if dp_time le '10:00't then timeofday=1;
			else if dp_time le '13:00't then timeofday=2;
				else if dp_time le '16:00't then timeofday=3;
					else if dp_time le '19:00't then timeofday=4;
						else timeofday=5;
	
	fltnum=cats(substr(origin,1,1),substr(dest,1,1),routeID,timeofday);
	format dp_date ddmmyy. dp_time time. fstrev busrev ecorev cgorev passrev totrev dollar11.2;
	label routeID='Route ID' dp_date='Date of Departure' dp_time='Time of Departure' fstrev='First Class Revenue' busrev='Business Class Revenue'
		ecorev='Economy Class Revenue' cgorev='Cargo Revenue' passrev='Total Revenue from Passengers' totrev='Total Flight Revenue'
		dest='City of Destination' origin='City of Origin' fltnum='Flight Number';
	drop timeofday;
run;



