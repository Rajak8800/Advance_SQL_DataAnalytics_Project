/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================

create view Customer_report as 
with base_query as (
-- basic Query retrive core columns 
select 
       s.product_key,
	   s.order_number,
	   s.order_date,
	   s.sales_amount,
	   s.quantity,
	   c.customer_key,
	   c.customer_number,
	   concat(c.first_name ,' ' ,last_name) as customer_name ,
	   DATEDIFF(year,c.birthdate,getdate()) as Age 
from sales as s 
left join customers as c
on c.customer_key=s.customer_key
where order_date is not null) 

, customer_aggregate as (
--- Customer Aggregations : summarizes key metrics at the customer level 
select 
		customer_key,
		customer_number,
		customer_name,
		age,
		count(distinct order_number) as total_orders,
		sum(sales_amount) as total_sales,
		count(distinct product_key) as total_products,
		sum(quantity) as total_quantity,
		max(order_date) as last_order_date,
		datediff(month,min(order_date) ,max(order_date) ) as lifespan
from base_query
group by customer_key,
		customer_number,
		customer_name,
		age )

select 
	customer_key,
		customer_number,
		customer_name,
		age,
	      case 
		  		 WHEN age < 20 THEN 'Under 20'
				 WHEN age between 20 and 29 THEN '20-29'
				 WHEN age between 30 and 39 THEN '30-39'
				 WHEN age between 40 and 49 THEN '40-49'
				 ELSE '50 and above'
	    end as age_group ,
         case 
		      when lifespan >=12 and  total_sales >5000 then 'Vip'
			  when lifespan >=12 and  total_sales <=5000 then 'Regular'
			  ELSE 'New'
         end as customer_segment ,
			total_orders,
			total_products,
			total_quantity,
			total_sales,
			lifespan,
			-- recency (months since last order)
		 last_order_date,
		 DATEDIFF(month,last_order_date ,getdate()) as recency,
		 --average order value
		 case 
		     when total_sales =0 then 0
			 else total_sales/total_orders 
	     end as average_order_value,
		 --average monthly spend
		 case when lifespan = 0 then total_sales
		 else  total_sales/lifespan
		 end as avg_monthly_spend

from customer_aggregate;

--- Customer_segment_wise _total_customers
select 
     customer_segment,
	 count(customer_segment) as Total_customer
  from Customer_report
  group by customer_segment
  order by Total_customer desc;

  -- age_group wise Total_customers
  select age_group,
         count(age_group) as total_customers,
		 sum(total_sales) as Total_sales
  from Customer_report
  group by age_group
  order by total_customers desc