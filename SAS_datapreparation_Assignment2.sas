proc import out = Orders
datafile='/home/u62273481/ban110/Superstore(1).xlsx'
out=Orders dbms=xlsx;
getnames=Yes;
sheet="Orders";
run;

proc import out = Returns
datafile='/home/u62273481/ban110/Superstore(1).xlsx'
out=Returns dbms=xlsx;
getnames=Yes;
sheet="Returns";
run;

proc sort data=orders out=sorted_orders;
by 'order ID'n;
run;

proc sort data=returns out=sorted_returns;
by 'order ID'n;
run;

data order_returned;
merge sorted_orders(IN=inorders) sorted_returns(IN=inreturns);
by 'order ID'n;
if Inorder=1 and Inreturns=1;
run;















proc sort data=orders out=sorted_order;
by 'order ID'n;
run;
proc sort data=returns out=sorted_returns;
by 'order ID'n;
run;

data Orders_Returned;

merge sorted_order(IN=Inorder) sorted_returns(IN=Inreturns);
by 'Order ID'n;
if Inorder=1 and Inreturns=1;
if state = 'California' and Category = 'Technology' and Quantity >5;

label 'order date'n = "Order_date"
      'customer name'n = "Customer_name"
      'Postal_code'n = "Postal_Code"
      'Product Name'n = "Product_Name";
      
	
run;

proc print data=orders_returned noobs label;
var 'order date'n 'customer name'n city 'Postal Code'n 'Product Name'n Sales quantity ;
run;

 


