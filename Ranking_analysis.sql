/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
 select top 5 
         p.product_name ,sum(s.sales_amount) as Total_revenue
from sales as s 
join products as p on p.product_key=s.product_key
group by p.product_name
order by Total_revenue desc;

-- Complex but Flexibly Ranking Using Window Functions
select * 
   from ( 
		select p.product_name ,sum(s.sales_amount) as total_revenue,
		 rank() over(order by sum(s.sales_amount) desc) as Product_ranking  
		from sales as s 
		join products as p on p.product_key=s.product_key
		group by p.product_name) as ranking 
	where Product_ranking <=5;

-- What are the 5 worst-performing products in terms of sales?
select top 5 
         p.product_name ,sum(s.sales_amount) as Total_revenue
from sales as s 
join products as p on p.product_key=s.product_key
group by p.product_name
order by Total_revenue ;

-- Find the top 10 customers who have generated the highest revenue
select top 10 
         c.customer_key ,
		 c.first_name ,
		 c.last_name,
		 sum(s.sales_amount) as Total_revenue 
from sales as s 
join customers as c on c.customer_key=s.customer_key
group by c.customer_key ,
		 c.first_name ,
		 c.last_name 
order by Total_revenue desc ;


-- The 3 customers with the fewest orders placed
select top 3 
         c.customer_key ,
		 c.first_name ,
		 c.last_name,
		 count(distinct s.order_number) as Total_orders
from sales as s 
join customers as c on c.customer_key=s.customer_key
group by c.customer_key ,
		 c.first_name ,
		 c.last_name 
order by Total_orders  ;

