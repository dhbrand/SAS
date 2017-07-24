%macro courses(crsnum=);
proc sql;
	create table concatenated as
	select *
	from mysas.courses, mysas.schedule
	where courses.course_code eq schedule.course_code
	;
quit;

%if &crsnum eq %then %do;

proc sort data=mysas.register out=crsnums(keep=course_number) nodupkey;
	by course_number;
run;

data _null_;
	set crsnums end=last;
	call symput(cats('coursenum',put(_n_,2.)),strip(course_number));
	if last then do;
		call symput('num',put(_n_,2.));
	end;
run;
%put &coursenum10 &num;

%do i = 1 %to &num;

	data _null_;
		set concatenated;
		where course_number=&&coursenum&i;
		call symput('city',trim(location));
		call symput('date',put(begin_date,mmddyy10.));
		call symput('teacher',teacher);
		call symput('crscode',course_code);
		call symput('crstitle',course_title);
		call symput('fee',fee);
	run;

	data revenue&i;
		set mysas.register end=final;
		where course_number=&&coursenum&i;

		total+1;
		if paid='Y' then paidup+1;

		if final then do;
			call symput('paidup',put(paidup,2.));
			call symput('total',put(total,2.));
			call symput('owed',put(&fee*(total-paidup),dollar8.));
		end;
	run;


	options nodate pageno=1;	
	ods pdf file="&&coursenum&i...pdf";
	title1 "Paid Status for &crstitle";
	title2 "Taught by &teacher";
	title3 "Location: &city, Begin Data: &date";

	proc report data=revenue nowd;
		column student_name paid;
	run;
	footnote1 "&paidup out of &total paid";
	footnote2 "Note: &owed in Unpaid Fees";
	ods pdf close;

%end;

%end;/**ends do loop for no input**/

%else %do;

%let c=1;
%let course=%scan(&crsnum,&c);
%do %while(&course ne );

data _null_;
	set concatenated;
	where course_number=&course;
	call symput('city',trim(location));
	call symput('date',put(begin_date,mmddyy10.));
	call symput('teacher',teacher);
	call symput('crscode',course_code);
	call symput('crstitle',course_title);
	call symput('fee',fee);
run;

	data revenue;
		set mysas.register end=final;
		where course_number=&course;

		total+1;
		if paid='Y' then paidup+1;

		if final then do;
			call symput('paidup',put(paidup,2.));
			call symput('total',put(total,2.));
			call symput('owed',put(&fee*(total-paidup),dollar8.));
		end;
	run;


	options nodate pageno=1;	
	ods pdf file="&course..pdf";
	title1 "Paid Status for &crstitle";
	title2 "Taught by &teacher";
	title3 "Location: &city, Begin Data: &date";

	proc report data=revenue nowd;
		column student_name paid;
	run;
	footnote1 "&paidup out of &total paid";
	footnote2 "Note: &owed in Unpaid Fees";
	ods pdf close;

	%let c=%eval(&c+1);
	%let course=%scan(&crsnum,&c);

%end;

%end; /**ends do loop for user input**/

%mend;
options mlogic mprint;
%courses(crsnum=);






