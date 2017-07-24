
libname cdc '\\seashare\blumj\SAS Programming Data\cdc';

/**Problem 1**/

proc format;
	value bmi
		0-<18.5='Underweight'
		18.5-<25='Normal'
		25-<30='Overweight'
		30-high='Obese'
		;
run;


proc sql;
	select put(bmpbmi,bmi.) as bmi_lev, mean(hdp) as HDL, mean(lcp) as LDL, mean(sgp) as glucose, mean(chol) as chol_mean, mean(tfat) as tfat_mean, mean(sodi) as sodi_mean
	from (select bmpbmi, exam_results.seqn, chol, tfat, sodi
			from cdc.exam_results, (select  seqn, drpmn, sum(drpichol) as chol, sum(drpitfat) as tfat, sum(drpisodi) as sodi
						from cdc.iff
						where drpisodi le 400 and drpitfat le 100 and drpichol le 3000
						group by seqn,drpmn) as meal_sum
			where exam_results.seqn eq meal_sum.seqn
			and bmpbmi is not missing
			group by drpmn
				)
		as mealstuff

		inner join

		(select seqn, HDP, LCP, SGP
			from cdc.lab_results
			) as labstuff

		on mealstuff.seqn eq labstuff.seqn
		group by bmi_lev
		;
quit;

/**Problem 2**/

proc sql;
	create table nomcds as
		select hssex, mean(HDP) as HDL, mean(LCP) as LDL
		from (select hssex, adults_surveyed.seqn, HDP, LCP
			from cdc.adults_surveyed,cdc.lab_results
			where adults_surveyed.seqn eq lab_results.seqn
			and hdp ne 888 and lcp ne 888	
			group by hssex) as labs

		join

		(select distinct seqn, drpmn
			from cdc.brands, cdc.iff
			where brands.drpcomm eq iff.drpcomm
			and brands.drpcomm not between 10296 and 10363) as nomeals
		on labs.seqn eq nomeals.seqn
		group by hssex
		;
quit;

proc sql;
	create table mcds1 as
		select hssex, mean(HDP) as HDL, mean(LCP) as LDL
		from (select hssex, adults_surveyed.seqn, HDP, LCP
			from cdc.adults_surveyed,cdc.lab_results
			where adults_surveyed.seqn eq lab_results.seqn		
			and hdp ne 888 and lcp ne 888
			group by hssex) as labs

		join

		(select distinct seqn, drpmn
			from cdc.brands, cdc.iff
			where brands.drpcomm eq iff.drpcomm
			and brands.drpcomm between 10296 and 10363) as nomeals
		on labs.seqn eq nomeals.seqn
		group by hssex
		;
quit;

proc sql;
	create table mcds3 as
		select hssex, mean(HDP) as HDL, mean(LCP) as LDL
		from (select hssex, adults_surveyed.seqn, HDP, LCP
			from cdc.adults_surveyed,cdc.lab_results
			where adults_surveyed.seqn eq lab_results.seqn
			and hdp ne 888 and lcp ne 888	
			group by hssex) as labs

		join

		(select distinct seqn, put(drpmn,3.) as meals
			from cdc.brands, cdc.iff
			where brands.drpcomm eq iff.drpcomm
			and brands.drpcomm between 10296 and 10363
			group by seqn
			having count(meals)ge 3) as nomeals
		on labs.seqn eq nomeals.seqn
		group by hssex
		;
quit;



/** Problem 3**/

proc sql;
	create table BK as
	select hssex, count(meal) as mealno
	from (select hssex, iff.seqn, put(drpmn,3.) as meal
			from cdc.iff, cdc.adults_surveyed
			where iff.seqn eq adults_surveyed.seqn
			and drpcomm between 10031 and 10086
			group by hssex)
	group by hssex
	;
quit;

proc sql;
	create table KFC as
	select hssex, count(meal) as mealno
	from (select hssex, iff.seqn, put(drpmn,3.) as meal
			from cdc.iff, cdc.adults_surveyed
			where iff.seqn eq adults_surveyed.seqn
			and drpcomm between 10242 and 10269
			group by hssex)
	group by hssex
	;
quit;

proc sql;
	create table MAC as
	select hssex, count(meal) as mealno
	from (select hssex, iff.seqn, put(drpmn,3.) as meal
			from cdc.iff, cdc.adults_surveyed
			where iff.seqn eq adults_surveyed.seqn
			and drpcomm between 10296 and 10363
			group by hssex)
	group by hssex
	;
quit;

proc sql;
	create table fastfood as
	select bk.hssex, bk.mealno+kfc.mealno+mac.mealno as total, bk.mealno as bkmeals, kfc.mealno as kfcmeals, mac.mealno as macmeals
	from bk
	full join kfc 
	on bk.hssex eq kfc.hssex
	full join mac
	on kfc.hssex eq mac.hssex
	;
quit;
