/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
select sum(sales_amount) as Total_Sales from sales;

-- Find how many items are sold
select sum(quantity) as Quantity_sold from sales ;

-- find the Average sale Price
select avg(price) as Average_Price from sales;

-- find the Total NUumber Of Orders 
select count(order_number) as total_Orders from sales;
select count(distinct order_number) as Total_orders  from sales;

-- Find the Total Number of Products 
select count(product_name) from products;

--Find the Total Number Of Customers
select count(customer_key) from customers

--Find the Total Number Of customers that have placed Orders
select count(customer_key) from sales;
select count(distinct customer_key ) from customers;

-- Generate Report that all show th key metrics of Business 
select 'Total_Sales' as Measure_Name ,sum(sales_amount) as Measure_Value from sales 
union all 
select 'Total_Quantity' as Measure_Name ,sum(quantity) as Measure_Value from sales 
union all
select 'Average_Price' as Measure_Name ,Avg(price) as Measure_Value from sales 
union all 
select 'Total_NR_Orders' as Measure_Name ,count(distinct order_number) as Measure_Value from sales 
union all 
select 'Total_NR_Products' as Measure_Name ,count(product_name) as Measure_Value from products
union all 
select 'Total_NR_Customers' as Measure_Name ,count(distinct customer_key) as Measure_Value from sales ;

