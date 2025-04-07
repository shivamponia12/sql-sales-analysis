create database retail_DA;
use retail_DA;

select* from features;
select* from sales;
select*from stores;


--Total weekly sales for each store

select round(sum(weekly_sales),2) as total_weekly_sales , store
from sales
group by store;

--Average weekly sales by department

select round(avg(weekly_sales),2) as avg_weekly_sales, dept
from sales
group by dept;

-- Join Store Details to Sales

select * from
sales s 
join stores st on s.store=st.store

--. Weekly Sales on Holidays vs Non-Holidays

select isHoliday, round(sum(weekly_sales),2) as weekly_sales_holiday_vs_nonholiday
from sales
group by IsHoliday

--highest weekly sales per store

select store, round(max(weekly_sales),2) as max_weekly_sales_per_store
from sales
group by store
order by store asc;

--Top 3 stores by total_sales

select top 3 store, round(sum(weekly_sales),2) as total_sales
from sales 
group by store
order by total_sales desc;

-- Total Sales per Store per Month
select round(sum(weekly_sales),2) as total_sales_per_month, month(date) as sales_month
from sales
group by month(date)
order by sales_month;

--Weekly Sales with Temperature Info

select 
s.store,s.[date],s.dept,s.weekly_sales,f.temperature
from sales s
join features f on s.store=f.store

-- Running Total of Sales for Each Store

select 
store, [date], 
sum(weekly_sales) over(
partition by store order by cast(date as DATE)
) as running_total
from sales;

--Rank Departments by Sales Within Each Store

select 
store, dept,sum(weekly_sales) as total_sales,
rank()over(
partition by store order by sum(weekly_sales) desc) as dept_rank
from sales
group by store, dept;

--moving average of weekly sales(3 week-window)

select store, dept,[date],weekly_sales,
avg(weekly_sales) over(partition by store order by [date] 
rows between 2 preceding and current row) as moving_avg_3week
from sales;

-- Ranking Top Performing Weeks per Store
select 
store, date, weekly_sales ,
dense_rank() over(partition by store order by weekly_sales desc) as week_rank
from sales;

-- Find High Performing Departments(using CTE)

WITH dept_avg AS (
    SELECT Dept, AVG(Weekly_Sales) AS Avg_Sales
    FROM sales
    GROUP BY Dept
)
select *from dept_avg 
where avg_sales >16030


--. Create a Stored Procedure to Get Sales by Store


CREATE PROCEDURE GetSalesByStore
    @store_id INT
AS
BEGIN
    SELECT 
        Date, 
        Dept, 
        Weekly_Sales
    FROM sales
    WHERE Store = @store_id;
END;












