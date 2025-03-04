/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

with Yearly_Product_Sales as (
select 
       year(s.order_date ) as order_date ,
	   p.product_name as Product_name ,
	   sum(s.sales_amount)as Current_sales 
from sales as s 
join products as p on p.product_key=s.product_key
where s.order_date is not null 
group by year(s.order_date ),  p.product_name

)
select 
       order_date,
	   Product_name,
	   Current_sales,
	   avg(Current_sales) over (partition by Product_name) as Average_sales,
	   Current_sales - avg(Current_sales) over (partition by Product_name) as Diff_Average,
	   case 
	       when   Current_sales - avg(Current_sales) over (partition by Product_name)  > 0 then 'Above_Average'
		   when  Current_sales - avg(Current_sales) over (partition by Product_name) < 0 then 'Below_Average'
		   else 'Average'
	    end As avg_Change,
-- year over year change  Analysis
       lag(Current_sales) over(partition by Product_name order by year(order_date) ) as  Pervious_year_Sale,
	   Current_sales-lag(Current_sales) over(partition by Product_name order by year(order_date) ) as Diff_PYS,
	   case 
	       when  Current_sales-lag(Current_sales) over(partition by Product_name order by year(order_date) )>0 then 'Increasing '
		   when  Current_sales-lag(Current_sales) over(partition by Product_name order by year(order_date) )<0 then 'Decreasing'
		   else 'No_Change'
	  end as PY_Chnage
from Yearly_Product_Sales
order by Product_name,order_date

