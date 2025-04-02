-- DATA CLEANING
-- In "orders" table we have date and time col in TEXT data type
-- We want to change them to DATE and TIME formart
ALTER TABLE orders
	MODIFY date date,
    MODIFY time TIME;


-- BASIC:
-- Q1: Retrieve the total number of orders placed.
select count(*)
from orders

-- Q2: Calculate the total revenue generated from pizza sales.
select ROUND(SUM(price),2) AS total_revenue
from pizzas P JOIN order_details od on p.pizza_id = od.pizza_id


-- Q3: Identify the highest-priced pizza.
select name
from pizzas p join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
where price = (select MAX(price) from pizzas)
-- 2nd way
select pt.name,p.price
from pizzas p join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
order by p.price desc
limit 1


-- Q4: Identify the most common pizza size ordered.
select  size,SUM(quantity) as count_pizza_sizes
from pizzas p join order_details od on p.pizza_id = od.pizza_id
group by size
order by count_pizza_sizes desc



select  *
from pizzas p join order_details od on p.pizza_id = od.pizza_id

-- Q5: List the top 5 most ordered pizza types along with their quantities.
select  pizza_type_id,SUM(quantity) as count_pizza_sizes
from pizzas p join order_details od on p.pizza_id = od.pizza_id
group by pizza_type_id
order by count_pizza_sizes desc
limit 5

-- Intermediate:
-- Q6: Join the necessary tables to find the total quantity of each pizza category ordered.
Select  category,sum(quantity) as pizza_counts
from pizzas p join order_details od on p.pizza_id = od.pizza_id
JOIN pizza_types pt on p.pizza_type_id = pt.pizza_type_id
group by category
order by pizza_counts desc

-- Q7: Determine the distribution of orders by hour of the day.
select HOUR(time) AS hours,count(*) as count_of_orders
from orders
group by hours
order by hours asc

-- Q8: Join relevant tables to find the category-wise distribution of pizzas.
-- Means different names of pizzas within each category
Select  category,COUNT(name) as count_of_names
from pizza_types 
group by category
order by count_of_names

-- Q9: Group the orders by date and calculate the average number of pizzas ordered per day.
select *
from order_details od join orders o on od.order_id = o.order_id

with cte as  (
select date,SUM(quantity) as sum_of_quantity
from order_details od join orders o on od.order_id = o.order_id
group by`date`
)
select 	avg(sum_of_quantity) AS avg__order_per_day	
from cte

-- Q10: Determine the top 3 most ordered pizza types based on revenue.
-- pizza type here means name of pizza
select pt.name,sum(od.quantity * p.price) AS revenue
from pizzas p join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
join order_details od on p.pizza_id = od.pizza_id
group by pt.name
order by revenue desc
limit 3

-- ADVANCED:
-- Q11: Calculate the percentage contribution of each pizza Category type  to total revenue.
-- pizza type here means name of pizza
with cte as (
select pt.category,sum(od.quantity * p.price) AS revenue
from pizzas p join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
join order_details od on p.pizza_id = od.pizza_id
group by pt.category
)
select category,revenue,ROUND((revenue/ (select sum(revenue) from cte))*100,2) AS percenatge_revenue
from cte
order by percenatge_revenue desc

-- Q12: Analyze the cumulative revenue generated over time.
-- Initial build up
select o.date,ROUND(sum(od.quantity * p.price),2) AS revenue
from pizzas p join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
join order_details od on p.pizza_id = od.pizza_id
join orders o  on od.order_id = o.order_id
group by o.date

-- Final result
SELECT 
    o.date,
    ROUND(SUM(od.quantity * p.price), 2) AS daily_revenue,
    ROUND(SUM(SUM(od.quantity * p.price)) OVER (ORDER BY o.date), 2) AS cumulative_revenue
FROM pizzas p 
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY o.date
ORDER BY o.date;


-- Q13: Determine the top 3 most ordered pizza types based on revenue for each pizza category
-- Initial Sub Query
select pt.category,name,ROUND(SUM(od.quantity * p.price), 2) AS pizza_type_revenue,
RANK() OVER(PARTITION BY category ORDER BY ROUND(SUM(od.quantity * p.price), 2) desc) AS name_rank
from pizzas p join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
join order_details od on p.pizza_id = od.pizza_id
GROUP BY  pt.category,name
ORDER BY pt.category ASC, pizza_type_revenue DESC;
-- Final Result
with cte as (
select pt.category,name,ROUND(SUM(od.quantity * p.price), 2) AS pizza_type_revenue,
RANK() OVER(PARTITION BY category ORDER BY ROUND(SUM(od.quantity * p.price), 2) desc) AS name_rank
from pizzas p join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
join order_details od on p.pizza_id = od.pizza_id
GROUP BY  pt.category,name
ORDER BY pt.category ASC, pizza_type_revenue DESC
)
select category,name,pizza_type_revenue,name_rank
from cte
where name_rank <= 3


-- END of PROJECT