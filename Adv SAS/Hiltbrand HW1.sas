libname mysas '\\seashare.uncw.edu\blumj\SAS Programming Data';

options nodate;
/**problem 1**/
title "Salary Summary All Job Codes";
proc sql;
	select jobcode, mean(salary) as avg_salary, freq(jobcode) as n,
			min(salary) as min_salary, max(salary) as max_salary
		from mysas.employees
		group by jobcode
	;
quit;

/**problem 2**/
options nodate;
title "Salary Summary All Job Codes";
proc sql;
	select jobcode , mean(salary) as avg_salary label 'Average Salary' format=dollar11., freq(jobcode) as n
			label 'Number of Employees', min(salary) as min_salary format=dollar8. label 'Minimum Salary',
			max(salary) as max_salary format=dollar8. label 'Maximum Salary'
		from mysas.employees
		group by jobcode
	;
quit;

/**problem 3**/
title "Ponds and Lakes in Maine";
title2 "with Mercury Levels more than 3 Standard Errors Above Mean";

proc sql;
	create table intermediary as
	select name, lt, dam, hg, mean(hg) as avg_hg, stderr(hg) as sd_hg
	from mysas.fish
	order by hg
	;

proc sql;
	select name, lt, dam, hg
	from work.intermediary
		where hg gt (3*sd_hg+avg_hg)
		order by hg desc
	;
quit;

/**problem 4**/

title 'Annual Average Returns of Mutual Funds';
title2 'where Annual Average Exceeds Overall S&P 500 Average';
title3 'for Years 2002 through 2005';

proc sql;
	select indicename, year(date) as year, mean(return) as avg_return
		from mysas.stockdata
		group by indicename, calculated year
		having avg_return gt (select mean(ret)
								from mysas.sp500
								where year between 2002 and 2006
								)
		;
quit;

/**couldn't figure out how to get the date to format to yyyymm. or to substr the first 4 numbers out so i could get the average return for each year**/



