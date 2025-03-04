/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
-- how many years of sales available
select 
      min(order_date) as First_order,
	  max(order_date) as last_order,
	  datediff(month,min(order_date),max(order_date)) as order_range_months
from sales;

-- Find the YOungest and Oldest Customer 
select 
      min(birthdate) as Oldest_customer,
	  datediff(year,min(birthdate),getdate()) as Oldest_Birthdate,
	  max(birthdate) as Youngest_customer,
	  datediff(year, max(birthdate), getdate()) as Youngest_Birthdate
from customers;

select * from customers