/*Hiltbrand, Dave STT-305 850418330 HW 2*/
libname orion '\\seashare\blumj\SAS Programming Data\Orion';
libname mysas '\\seashare\blumj\SAS Programming Data';
run;


options noimplmac;
run;
data orion1;
length country $13;
length job_cat $8;
set orion.sales orion.nonsales(rename=(first=first_name) rename=(last=last_name));
if substr(country,1,1)='A' then country='Australia';
	else if substr(country,1,1)='a' then country='Australia';
	else if substr(country,1,1)='U' then country='United States';
	else if substr(country,1,1)='u' then country='United States';
if substr(job_title,1,3)='Sal' then job_cat='Sales';
	else job_cat='Nonsales';
label country='Country' job_cat='Job Category' employee_ID='Employee ID Number' First_name='First Name' 
last_name='Last Name' job_title='Job Title' birth_date='Date of Birth' hire_date='Date of Hire';
format salary dollar8.;
run;/**OK**/

data emp;
	set mysas.employees;
	yos=yrdif(hiredate,today(),'ACT');
	if yos ge 35 then bump=3500;
	else if yos ge 25 then bump=2000;
	else bump=0;

	if bump=3500 and substr(jobcode,6,1)='1' then raise=salary*0.025;
	else if bump=3500 and substr(jobcode,6,1)='2' then raise=salary*0.025;
	else if bump=3500 and substr(jobcode,6,1)='3' then raise=salary*0.015;
	else if bump=3500 then raise=salary*0.02;

	if bump=2000 and substr(jobcode,6,1)='1' then raise=salary*0.02;
	else if bump=2000 and substr(jobcode,6,1)='2' then raise=salary*0.02;
	else if bump=2000 and substr(jobcode,6,1)='3' then raise=salary*0.01;
	else if bump=2000 then raise=salary*0.0175;

	if bump=0 and substr(jobcode,6,1)='1' then raise=salary*0.0275;
	else if bump=0 and substr(jobcode,6,1)='2' then raise=salary*0.0275;
	else if bump=0 and substr(jobcode,6,1)='3' then raise=salary*0.0175;
	else if bump=0 then raise=salary*0.025;
	employee_name=catx(', ',propcase(lastname),propcase(firstname));
	new_salary=salary+raise+bump;
	label salary='Old Salary' yos='Years of Service' employee_name='Employee Name' new_salary='New Salary';
	format yos 2. new_salary dollar8.;
	drop lastname firstname bump raise;
run;

proc sort data=emp;
	by empid;
run;/**OK**/


proc means data=mysas.fish nonobs mean median noprint;
class lt dam;
var hg;
output out=fish_cal mean=mean_hg median=median_hg;
run;

proc sort data=mysas.fish out=fish_sort;
	by lt dam;
run;

proc sort data=fish_cal;
	by lt dam;
run;

data fishy;
	merge fish_sort fish_cal;
	by lt dam;
	diff_mean=hg-mean_hg;
	diff_median=hg-median_hg;
	perc_mean=diff_mean/mean_hg;
	perc_median=diff_median/median_hg;
	keep name hg lt dam mean_hg median_hg diff_mean diff_median perc_mean perc_median;
	label mean_hg='Mean Hg (within Dam & Lake Type)' median_hg='Median Hg (within Dam & Lake Type)'
		diff_mean='Difference from Mean' diff_median='Difference from Median' perc_mean='Percent Difference from Mean'
		perc_median='Percent Difference from Median';
	format mean_hg median_hg diff_mean diff_median 6.3 perc_mean perc_median percentn9.2;
	where lt and dam ne .;
run;

proc sort data=fishy;
	by name;
run;/**OK

30/30

**/
 



