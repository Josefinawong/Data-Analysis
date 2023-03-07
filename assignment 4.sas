proc import file="/home/u62273481/ban100/bikes_sharing.csv"
out=bikes_sharing
dbms=csv replace;
run;

proc contents data=bikes_sharing;
run;

proc reg data=bikes_sharing;
model count=season holiday workingday weather temp atemp humidity windspeed;
run;

proc reg data= bikes_sharing;
model count = season holiday workingday weather temp atemp humidity windspeed
/ selection = stepwise slentry=0.15 slstay=0.15 details;
run;

proc import file="/home/u62273481/ban100/titanic.csv"
out=titanic
dbms=csv replace;
run;

proc logistic data=titanic;
model survived (event = '1') =age;
run;

