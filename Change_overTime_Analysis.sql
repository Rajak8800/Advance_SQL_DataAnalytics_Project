use SqlDataAnalyticsProject;
/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions

select 
	 year(order_date),
	sum(sales_amount) as Total_Sales
from Sales 
where order_date is not null
group by year(order_date) 
order by year(order_date);

-- Analyse sales performance monthly 
select 
      month(order_date) as Monthly,
	  sum(sales_amount) as Total_Amount 
from sales 
where order_date is not null 
group by month(order_date) 
order by month(order_date) ;

-- Sales Performance Along With Custoners ,Order Quantity 

select 
      year(order_date)  as Yearly_sales,
	  month(order_date) as Monthly_sales ,
	  sum(sales_amount) as Total_Sales ,
	  count( distinct customer_key) as Total_customers ,
	  count(distinct order_number ) as Total_orders 
from sales 
where order_date is not null 
group by year(order_date),month(order_date) 
order by  year(order_date),month(order_date) ;

-- Using "DateTrunc" to see the combine year and month date

select 
      DATETRUNC(month,order_date) as Order_date,
	  sum(sales_amount) as Total_sales ,
	  count(distinct customer_key )as Total_customers ,
	  count(distinct order_number) as Total_orders
from sales
where order_date is not null
group by DATETRUNC(month,order_date)
order by DATETRUNC(month,order_date);

-- Using "FORMAT()"
select 
      FORMAT(order_date,'yyyy-MMM') as Order_date,
	  sum(sales_amount) as Total_sales ,
	  count(distinct customer_key )as Total_customers ,
	  count(distinct order_number) as Total_orders
from sales
where order_date is not null
group by FORMAT(order_date,'yyyy-MMM')
order by FORMAT(order_date,'yyyy-MMM');
