/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and 
count how many products fall into each segment*/

with Product_segments as(
select 
     product_key,
	 product_name,
	 cost,
	 case 
	 when cost < 100 then 'Below_100'
	 when cost between 100 and 500 then '100-500'
	 when cost between 500 and 1000 then '500-1000'
	 else 'Above_1000'
   end as Cost_Range
from products
)
select 
	  Cost_Range,
	  count(product_key) as Total_products
from Product_segments
group by Cost_Range
order by Total_products desc;


/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

with Customer_Spending as (
select 
       c.customer_key ,
	   sum(s.sales_amount) as total_spending,
	   min(s.order_date)  as first_Order_date,
	   max(s.order_date) as Last_order_date,
	   DATEDIFF(month,min(s.order_date),max(s.order_date)) as lifespan
	   from sales as s
join customers as c on c.customer_key=s.customer_key
group by c.customer_key 

)
select 
    Customer_segment,
	count(Customer_segment) as Total_Customers
	 from(
select 
      customer_key,
	  case
	      when lifespan  >= 12 and total_spending >5000 then 'VIP'
		  when  lifespan >= 12 and total_spending <=5000 then 'Regular'
		  else 'New'
	 end as Customer_segment
from Customer_Spending) as segmented_Customers
group by Customer_segment
order by Total_Customers desc