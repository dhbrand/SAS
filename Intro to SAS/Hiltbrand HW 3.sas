libname mysas '\\seashare\blumj\SAS Programming Data';
options nodate nonumber noimplmac;
run;

title 'Monthly Returns Summary';
title2 '2001 Through 2005';
proc report data=mysas.funds nowd headline;
	column indicename dt return=min return=median return=max;
	define indicename / 'Fund' group;
	define dt / 'Year' group format=Year.;
	define min / 'Mininum Return' min format=percentn7.2;
	define median / 'Median Return' median format=percentn7.2;
	define max / 'Max Return' max format=percentn7.2;
	break after indicename / summarize ol suppress skip;
	where dt between '01Jan2001'd and '12Dec2005'd and indicecode ne 'TESIX';
run;

ods pdf file='Problem 1.pdf';
proc report data=mysas.funds nowd
	style(header)=[background=black foreground=white font_face='century schoolbook']
	style(summary)=[background=cx444444 foreground=white];
		column indicename dt return=min return=median return=max;
		define indicename / 'Fund' group;
		define dt / 'Year' group format=Year.;
		define min / 'Mininum Return' min format=percentn8.2 style(column)=[background=cxcccccc];
		define median / 'Median Return' median format=percentn8.2 style(column)=[background=cxbbbbbb];
		define max / 'Max Return' max format=percentn8.2 style(column)=[background=cxaaaaaa];
		break after indicename / summarize ol suppress skip;
		where dt between '01Jan2001'd and '12Dec2005'd and indicecode ne 'TESIX';
run;
ods pdf close;

title 'Equipment and Personnel Costs' italic;
options number pageno=1;

proc report data=mysas.projects nowd headline;
		column pol_type region jobtotal equipmnt=meaneq equipmnt=maxeq personel=meanper personel=maxper;
		define pol_type / 'Pollutant' group width=9;
		define region / 'Regional Office' group;
		define jobtotal / n 'Number of Jobs';
		define meaneq / mean 'Mean Equipment Cost' format=dollar10.2;
		define maxeq / max 'Maximum Equipment Cost' format=dollar10.2;
		define meanper / mean 'Mean Personnel Cost' format=dollar10.2;
		define maxper / max 'Maximum Personnel Cost' format=dollar10.2;
		break after pol_type / summarize ol suppress skip;
run;

ods pdf file='Problem 2.pdf';
proc report data=mysas.projects nowd 
	style(header)=[background=black foreground=white font_face='century schoolbook']
	style(summary)=[foreground=blue];
	column pol_type region jobtotal equipmnt=meaneq equipmnt=maxeq personel=meanper personel=maxper;
	define pol_type / 'Pollutant' group width=9;
	define region / 'Regional Office' group;
	define jobtotal / n 'Number of Jobs' style(column)=[background=cxffffff];
	define meaneq / mean 'Mean Equipment Cost' format=dollar10.2 style(column)=[background=cxcccccc];
	define maxeq / max 'Maximum Equipment Cost' format=dollar10.2 style(column)=[background=cxaaaaaa];
	define meanper / mean 'Mean Personnel Cost' format=dollar10.2 style(column)=[background=cxcccccc] ;
	define maxper / max 'Maximum Personnel Cost' format=dollar10.2 style(column)=[background=cxaaaaaa];
	break after pol_type / summarize ol suppress skip;
run;
ods pdf close;
