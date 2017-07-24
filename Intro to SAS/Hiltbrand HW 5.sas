libname mysas '//timmy.uncw.edu/students/dh4545';
options noimplmac nodate nonumber;
run;

data hw1;
	set mysas.grades;
	if quiz1--quiz4 then type='Quiz';
	else if test1--test4 then type='Test';
	array quiz(4);
	do number=1 to 4;
		score=quiz(number);
	output;
	end;
	array test(4);
	do number=1 to 4;
		score=test(number);
	output;
	end;
	drop quiz1--quiz4 test1--test4;
run;

proc sort data=mysas.fish;
	by lt;
run;


data hw2;
	set mysas.fish;
	by lt;;
	if lt=1 then do;
		count=0;
	end;
	count+1;
	keep lt count;
run;
