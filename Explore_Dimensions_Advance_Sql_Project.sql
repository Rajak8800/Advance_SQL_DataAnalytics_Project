/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Retrieve a list of unique countries from which customers originate
select distinct country 
  from customers;

-- Retrive A list of different types of Products(Category,Sub_Category)

select Distinct category,subcategory,product_name from Products
where category is not null
order by 1,2,3;

-- 