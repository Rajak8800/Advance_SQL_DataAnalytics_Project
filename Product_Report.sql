/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =======================================================================

with basic_query_products as (
select 
       p.product_id,
	   p.product_key,
	   s.customer_key,
	   s.order_number,
	   p.product_name,
	   p.product_number,
	   p.category_id,
	   p.category,
	   p.subcategory,
	   p.cost,
	   s.quantity,
	   s.order_date
from sales as s
left join products as p 
on p.product_key=s.product_key
where s.order_date is not null -- only consider valid order date
) 
, product_agreggation as (
select 
       product_key,
	   product_name,
	   product_number,
	   category_id,
	   category,
	   subcategory,
	   cost,
	   max(order_date) as last_order_date,
	   DATEDIFF(month,min(order_date) ,max(order_date)) as lifespan,
	   count(distinct order_number) as total_orders,
	   sum(cost) as total_sales,
	   count(distinct customer_key) as total_customers ,
	   sum(quantity) as total_quantity_sold,
	   round(avg(cast(cost as float)/nullif(quantity ,0)),1) as avg_selling_price

from basic_query_products
group by   product_name,
           product_key,
		   product_number,
		   category_id,
		   category,
		   subcategory,
		   cost
		   )


select  
	   product_key,
	   product_name,
	   category,
	   subcategory,
	   cost,
	   last_order_date,
	   DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency_in_months,
	   case 
	      when total_sales >50000 then 'Highly_Performing'
		  when total_sales >= 10000 then 'Mid-Range'
		  ELSE 'Low-Performer'
	  end as Product_segment,
	  lifespan,
	  total_orders,
	  total_sales,
	  total_quantity_sold,
	  total_customers,
	  avg_selling_price,
	  -- Average order revenue (AOR)
	  case when total_sales= 0 then 0
	  else total_sales/total_orders 
	  end as avg_order_revenue,
	  --- Average monthly revenue
	  case when lifespan = 0 then total_sales
	  else total_sales/lifespan
	  end as avg_monthly_revenue
from product_agreggation