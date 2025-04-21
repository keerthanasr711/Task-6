create database project;
use project;

create table online_sales
(
transactions_id int,
sale_date date,
sale_time time,
customer_id int,
gender varchar(15),
age int,
category varchar(15),
quantiy int,
price_per_unit float,
cogs float,
total_sale float
);

select count(*) from online_sales;

-- checking for cleaning of data whether there is any null or duplicates.
select * from online_sales
where 
transactions_id = '0'
or 
sale_time= '0'
or
customer_id = '0'
or
gender = '0'
or
category = '0'
or
quantiy = '0'
or
price_per_unit = '0'
or
cogs = '0'
or
total_sale = '0';

SET SQL_SAFE_UPDATES = 0;
-- deleted the null values.
delete from online_sales
where quantiy = '0';

-- Q. 1 How many customer we have?
select count(distinct customer_id) as total_customers from online_sales;

-- Q. 2 How many types of  category present?
select distinct(category) from online_sales;

-- Q.3 write SQL query to retrive all column for sales made on '2022-11-05' & total revenue on this date?
select * from online_sales where sale_date = '05-11-2022';
select sum(total_sale) as revenue from online_sales where sale_date = '05-11-2022';

-- Q.4 write SQL query to retrive all transactions where the category is 'Clothing' and the quantity sold is more than 4?
select * from online_sales 
where category = 'Clothing'
and
quantiy >= 4;

-- Q .5 write a SQL query to calculate the total sales and there order_count for each category?
select category,sum(total_sale) as Total_revenue from online_sales
group by category;

-- Q.6 write a SQL query to find the average age of the customer who purchased items from the 'Beauty' category?
select round(avg(age),2)  as Avg_age_of_customer from online_sales
where category = 'Beauty';

-- Q.7 Write an SQL query to find the total number of transaction(transaction_id) made by each gender in each category?
select gender,category,count(*) from online_sales 
group by category,gender
order by category;

-- Q .8 write a SQL query to extract months from the sale_date ?
select 
	month(str_to_date(sale_date,'%d-%m-%y')) as Month_number from online_sales;
    -- date_format(str_to_date(sale_date,'%d-%m-%y'), '%m') as Month_name from online_sales;

-- Q.9 write a SQL query to calculate the average sales for each month.Find out Best selling month in each Year?
-- Here we use year and month function to Extract the year and month from the sale_date so that we can slove the query.
-- For finding best selling month in the year we do this below query in subquer or CTE.and we use where clause.

select 
	year,
    month,
    avg_sale
from
( select
	year(sale_date) as Year,
    month(sale_date) as Month,
    avg(total_sale) as avg_sale,
    rank() over(partition by year(sale_date) order by avg(total_sale) desc) as rank_sales
from online_sales
group by Year,Month
) as t1
where rank_sales = '1';

-- Q.10 write a SQL query to create each shift and no of orders (Example Morning <=12 , Afternoon 12 & 17 , Evening >17)?
with hourly_sales as
(
select *,
case
when hour(sale_time) <= 12 then 'Morning'
when hour(sale_time) between 12 and 17 then 'Afternoon'
when hour(sale_time) >17 then 'Evening'
End as shift
from online_sales
)
select shift,count(transactions_id) from hourly_sales
group by shift;

	














