/*Data Import*/
proc import out=product

datafile='/home/u62273481/ban130/practice/AdventureWorks(2).xlsx'
dbms=xlsx replace;
sheet='Product';
getnames=Yes;

run;
proc import out=SalesOrderDetail

datafile='/home/u62273481/ban130/practice/AdventureWorks(2).xlsx'
dbms=xlsx replace;
sheet='SalesOrderDetail';
getnames=Yes;

run;
proc print data=product(obs=10) noobs;run;
proc print data=salesOrderDetail(obs=10) noobs;run;
proc contents data=product varnum;run;
/*Data Cleaning*/
data product_clean;
set product(keep=ProductID Name ProductNumber Color ListPrice);
if missing(Color) then Color='NA';
ListPrice1=input(ListPrice,9.2);
drop ListPrice;
rename ListPrice1=ListPrice;
format ListPrice1 Dollar9.2;
run;
proc print data=product_clean(obs=10) noobs;run;
proc contents data=product_clean varnum;run;
proc contents data=salesorderdetail varnum;run;
data SalesOrderDetail_Clean1;
set SalesOrderDetail
(Keep=SalesOrderID SalesOrderDetailID OrderQty ProductID
UnitPrice LineTotal ModifiedDate);
ModifiedDate1=input(ModifiedDate,yymmdd10.);
UnitPrice1=input(UnitPrice,Dollar10.2);
LineTotal1=input(LineTotal,Dollar10.2);
OrderQty1=input(OrderQty,10.);
yyyy=year(ModifiedDate1);
drop UnitPrice LineTotal OrderQty ModifiedDate;
rename ModifiedDate1=ModifiedDate UnitPrice1=UnitPrice
LineTotal1=LineTotal OrderQty1=OrderQty;
format ModifiedDate1 mmddyy10. UnitPrice1 LineTotal1 dollar10.2;
if yyyy in (2013,2014);
run;
data SalesOrderDetail_Clean;set SalesOrderDetail_Clean1(drop=yyyy);run;
proc print data=salesorderdetail_clean(obs=10) noobs; run;
proc contents data=salesorderdetail_clean varnum;run;
/*Joining & Merging*/
proc sort data=product_clean;by ProductID;run;
proc sort data=salesorderdetail_clean;by ProductID;run;
Data SalesDetails(drop=SalesOrderID SalesOrderDetailID ProductNumber ListPrice);
merge product_clean(in=Q1) salesorderdetail_clean(in=Q2);
by ProductID;
if Q1=1 and Q2=1;
run;
proc print data = salesdetails (obs=10) noobs; run;
proc sort data=SalesDetails;
by ProductID;
run;
Data SalesAnalysis;set salesdetails;
by ProductID;
if First.ProductID then SubTotal=0;
SubTotal + LineTotal;
if Last.ProductID then output;
format SubTotal Dollar12.2;
run;