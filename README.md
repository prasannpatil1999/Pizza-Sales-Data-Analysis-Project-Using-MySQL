# Pizza Sales Data Analysis Project


## Tables of Contents: 
- [Project Overview](#project-overview)  
- [Tools Used](#tools-used)  
- [Data Sources](#data-sources)  
- [Data Cleaning/Preparation](#data-cleaningpreparation)  
- [Key Business Questions Answered](#key-business-questions-answered)  
- [Project Files](#project-files)  
- [How to Use](#how-to-use)  
- [Insights & Findings](#insights--findings)  
- [Recommendations](#recommendations)  
- [Conclusion](#conclusion)
  
### Project Overview
This project involves analyzing pizza sales data to uncover key insights regarding customer preferences, sales performance, and market trends. By examining various factors such as order frequency, popular pizza types, seasonal trends, and sales by location, the goal is to identify patterns that can help improve marketing strategies, optimize inventory management, and increase overall sales. Through this analysis, actionable recommendations will be made to enhance operational efficiency and customer satisfaction in the pizza sales domain.

### Tools Used
- MySQL
  
### Data Sources
-  The data for this analysis is sourced from four CSV files: order_details, orders, pizza_types, and pizzas. 
- The order_details file contains information about individual pizza orders, including order ID, pizza type, quantity, and price. 
- The orders file tracks customer orders with timestamps, order status, and delivery information.
- he pizza_types file categorizes different pizza options available in the store, including ingredients and size details. 
- he pizzas file includes information about specific pizzas sold, including their names, types, and associated prices.

### Data Cleaning/Preparation
- In the initial data preparation phase, we performed the following tasks:

1. Imported data into the MySQL database and conducted an inspection.
2. Removed duplicates, CHECKED FOR NULL VALUES
3. checked and Corrected spelling errors, typos, and inconsistencies.
  
### Key Business Questions Answered

- Q1: Retrieve the total number of orders placed.
- Q2: Calculate the total revenue generated from pizza sales.
- Q3: Identify the highest-priced pizza.
- Q4: Identify the most common pizza size ordered.
- Q5: List the top 5 most ordered pizza types along with their quantities.
- Q6: Join the necessary tables to find the total quantity of each pizza category ordered.
- Q7: Determine the distribution of orders by hour of the day.
- Q8: Join relevant tables to find the category-wise distribution of pizzas.
- Q9: Group the orders by date and calculate the average number of pizzas ordered per day.
- Q10: Determine the top 3 most ordered pizza types based on revenue.
- Q11: Calculate the percentage contribution of each pizza Category type  to total revenue.
- Q12: Analyze the cumulative revenue generated over time.
- Q13: Determine the top 3 most ordered pizza types based on revenue for each pizza category

### Project Files
- 📊 order_details, orders, pizza_types and pizzas" (CSV File) - Contains all data.
- 📝 Problem Statement (Word File) - Outlines the business questions and objectives.
  
### How to Use
- Review the Problem Statement PDF to understand the key objectives.
- Use the Readme file to get answers

### Insights & Findings
-- Q1: Retrieve the total number of orders placed.
````sql
select count(*)
from orders
````
**Results:**
Total Orders|
---------------------|
 21350     |

-- Q2: Calculate the total revenue generated from pizza sales.
````sql
select ROUND(SUM(price),2) AS total_revenue
from pizzas P JOIN order_details od on p.pizza_id = od.pizza_id
````
**Results:**
Total Revenue|
---------------------|
 801944.7    |


-- Q3: Identify the highest-priced pizza.
````sql
select name
from pizzas p join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
where price = (select MAX(price) from pizzas)
````
**Results:**
Highest-priced pizz|
---------------------|
The Greek Pizza    |

-- Q4: Identify the most common pizza size ordered.
````sql
select  size,SUM(quantity) as count_pizza_sizes
from pizzas p join order_details od on p.pizza_id = od.pizza_id
group by size
order by count_pizza_sizes desc
````
**Results:**
| Size | Count  |
|------|--------|
| L    | 18956  |
| M    | 15635  |
| S    | 14403  |
| XL   | 552    |
| XXL  | 28     |


-- Q5: List the top 5 most ordered pizza types along with their quantities.
````sql
select  pizza_type_id,SUM(quantity) as count_pizza_sizes
from pizzas p join order_details od on p.pizza_id = od.pizza_id
group by pizza_type_id
order by count_pizza_sizes desc
limit 5
````
**Results:**
| Pizza Type ID   | Count  |
|-----------------|--------|
| classic_dlx     | 2453   |
| bbq_ckn         | 2432   |
| hawaiian        | 2422   |
| pepperoni       | 2418   |
| thai_ckn        | 2371   |



-- Q6: Join the necessary tables to find the total quantity of each pizza category ordered.
````sql
Select  category,sum(quantity) as pizza_counts
from pizzas p join order_details od on p.pizza_id = od.pizza_id
JOIN pizza_types pt on p.pizza_type_id = pt.pizza_type_id
group by category
order by pizza_counts desc
````
**Results:**
| Category  | Count  |
|-----------------|--------|
| Classic         | 14888  |
| Supreme         | 11987  |
| Veggie          | 11649  |
| Chicken         | 11050  |


-- Q7: Determine the distribution of orders by hour of the day.
````sql
select HOUR(time) AS hours,count(*) as count_of_orders
from orders
group by hours
order by hours asc
````
**Results:**
| Hour   |Pizza Count  |
|-----------------|--------|
| 9               | 1      |
| 10              | 8      |
| 11              | 1231   |
| 12              | 2520   |
| 13              | 2455   |
| 14              | 1472   |
| 15              | 1468   |
| 16              | 1920   |
| 17              | 2336   |
| 18              | 2399   |
| 19              | 2009   |
| 20              | 1642   |
| 21              | 1198   |
| 22              | 663    |
| 23              | 28     |


-- Q8: Join relevant tables to find the category-wise distribution of pizzas.
````sql
Select  category,COUNT(name) as count_of_names
from pizza_types 
group by category
order by count_of_names
````
**Results:**
| Category   | Count of names  |
|--------------|--------|
| Chicken      | 6      |
| Classic      | 8      |
| Supreme      | 9      |
| Veggie       | 9      |


-- Q9: Group the orders by date and calculate the average number of pizzas ordered per day.
````sql
with cte as  (
select date,SUM(quantity) as sum_of_quantity
from order_details od join orders o on od.order_id = o.order_id
group by`date`
)
select 	avg(sum_of_quantity) AS avg__order_per_day	
from cte
````
**Results:**
| Average Pizza Order Per Day |
|-----------------------------|
| 138.4749                    |

-- Q10: Determine the top 3 most ordered pizza types based on revenue.
````sql
-- pizza type here means name of pizza
select pt.name,sum(od.quantity * p.price) AS revenue
from pizzas p join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
join order_details od on p.pizza_id = od.pizza_id
group by pt.name
order by revenue desc
limit 3
````
**Results:**
| Name                         | Revenue  |
|------------------------------|----------|
| The Thai Chicken Pizza        | 43434.25 |
| The Barbecue Chicken Pizza    | 42768    |
| The California Chicken Pizza  | 41409.5  |



-- Q11: Calculate the percentage contribution of each pizza Category type  to total revenue.
````sql
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
````
**Results:**
| Category  | Revenue        | Percentage of Revenue |
|-----------|----------------|-----------------------|
| Classic   | 220053.10      | 26.91                 |
| Supreme   | 208196.99      | 25.46                 |
| Chicken   | 195919.50      | 23.96                 |
| Veggie    | 193690.45      | 23.68                 |

-- Q12: Analyze the cumulative revenue generated over time.
````sql
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

````
**Results:**
| Date       | Value 1  | Value 2  |
|------------|----------|----------|
| 2015-01-01 | 2713.85  | 2713.85  |
| 2015-01-02 | 2731.9   | 5445.75  |
| 2015-01-03 | 2662.4   | 8108.15  |
| 2015-01-04 | 1755.45  | 9863.6   |
| 2015-01-05 | 2065.95  | 11929.55 |
| 2015-01-06 | 2428.95  | 14358.5  |
| 2015-01-07 | 2202.2   | 16560.7  |
| 2015-01-08 | 2838.35  | 19399.05 |
| 2015-01-09 | 2127.35  | 21526.4  |
| 2015-01-10 | 2463.95  | 23990.35 |
| 2015-01-11 | 1872.3   | 25862.65 |
| 2015-01-12 | 1919.05  | 27781.7  |
| 2015-01-13 | 2049.6   | 29831.3  |
| 2015-01-14 | 2527.4   | 32358.7  |
| 2015-01-15 | 1984.8   | 34343.5  |
| 2015-01-16 | 2594.15  | 36937.65 |
| 2015-01-17 | 2064.1   | 39001.75 |
| 2015-01-18 | 1976.85  | 40978.6  |
| 2015-01-19 | 2387.15  | 43365.75 |
| 2015-01-20 | 2397.9   | 45763.65 |
| 2015-01-21 | 2040.55  | 47804.2  |
| 2015-01-22 | 2496.7   | 50300.9  |
| 2015-01-23 | 2423.7   | 52724.6  |
| 2015-01-24 | 2289.25  | 55013.85 |
| 2015-01-25 | 1617.55  | 56631.4  |
| 2015-01-26 | 1884.4   | 58515.8  |
| 2015-01-27 | 2528.05  | 61043.85 |
| 2015-01-28 | 2016     | 63059.85 |
| 2015-01-29 | 2045.3   | 65105.15 |
| 2015-01-30 | 2270.3   | 67375.45 |
| 2015-01-31 | 2417.85  | 69793.3  |
| 2015-02-01 | 3189.2   | 72982.5  |
| 2015-02-02 | 2328.6   | 75311.1  |
| 2015-02-03 | 2614.8   | 77925.9  |
| 2015-02-04 | 2233.9   | 80159.8  |
| 2015-02-05 | 2215.8   | 82375.6  |
| 2015-02-06 | 2509.95  | 84885.55 |
| 2015-02-07 | 2237.65  | 87123.2  |
| 2015-02-08 | 2035     | 89158.2  |
| 2015-02-09 | 2195.35  | 91353.55 |
| 2015-02-10 | 2056.5   | 93410.05 |
| 2015-02-11 | 2460     | 95870.05 |
| 2015-02-12 | 2158.8   | 98028.85 |
| 2015-02-13 | 2754.5   | 100783.35|
| 2015-02-14 | 2319.15  | 103102.5 |
| 2015-02-15 | 2141.25  | 105243.75|
| 2015-02-16 | 1968.8   | 107212.55|
| 2015-02-17 | 2121.9   | 109334.45|
| 2015-02-18 | 2642.85  | 111977.3 |
| 2015-02-19 | 2030.25  | 114007.55|
| 2015-02-20 | 2891.15  | 116898.7 |
| 2015-02-21 | 2111     | 119009.7 |
| 2015-02-22 | 1579.95  | 120589.65|
| 2015-02-23 | 2168.55  | 122758.2 |
| 2015-02-24 | 2194.55  | 124952.75|
| 2015-02-25 | 2341.3   | 127294.05|
| 2015-02-26 | 2261.3   | 129555.35|
| 2015-02-27 | 2857.95  | 132413.3 |
| 2015-02-28 | 2539.6   | 134952.9 |
| 2015-03-01 | 1598.55  | 136551.45|
| 2015-03-02 | 2379.05  | 138930.5 |
| 2015-03-03 | 2287.9   | 141218.4 |
| 2015-03-04 | 2444.3   | 143662.7 |
| 2015-03-05 | 2350.65  | 146013.35|
| 2015-03-06 | 2513.95  | 148527.3 |
| 2015-03-07 | 2400.45  | 150927.75|
| 2015-03-08 | 2188.15  | 153115.9 |
| 2015-03-09 | 2334.55  | 155450.45|
| 2015-03-10 | 2388.7   | 157839.15|
| 2015-03-11 | 2207.7   | 160046.85|
| 2015-03-12 | 1994.9   | 162041.75|
| 2015-03-13 | 2786.65  | 164828.4 |
| 2015-03-14 | 2039.45  | 166867.85|
| 2015-03-15 | 2068.6   | 168936.45|
| 2015-03-16 | 2295.05  | 171231.5 |
| 2015-03-17 | 2965.3   | 174196.8 |
| 2015-03-18 | 2075.4   | 176272.2 |
| 2015-03-19 | 2388.6   | 178660.8 |
| 2015-03-20 | 2461.25  | 181122.05|
| 2015-03-21 | 2267.4   | 183389.45|
| 2015-03-22 | 1259.25  | 184648.7 |
| 2015-03-23 | 2232.55  | 186881.25|
| 2015-03-24 | 2162.3   | 189043.55|
| 2015-03-25 | 1927.75  | 190971.3 |
| 2015-03-26 | 2215.5   | 193186.8 |
| 2015-03-27 | 2744.8   | 195931.6 |
| 2015-03-28 | 2252.1   | 198183.7 |
| 2015-03-29 | 2154.25  | 200337.95|
| 2015-03-30 | 2255.45  | 202593.4 |
| 2015-03-31 | 2756.6   | 205350   |




-- Q13: Determine the top 3 most ordered pizza types based on revenue for each pizza category
````sql
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


````
**Results:**
| Pizza    | Name                         | Pizza Revenue | Name Rank |
|----------|------------------------------|---------------|-----------|
| Chicken  | The Thai Chicken Pizza        | 43434.25      | 1         |
| Chicken  | The Barbecue Chicken Pizza    | 42768         | 2         |
| Chicken  | The California Chicken Pizza  | 41409.5       | 3         |
| Classic  | The Classic Deluxe Pizza      | 38180.5       | 1         |
| Classic  | The Hawaiian Pizza            | 32273.25      | 2         |
| Classic  | The Pepperoni Pizza           | 30161.75      | 3         |
| Supreme  | The Spicy Italian Pizza       | 34831.25      | 1         |
| Supreme  | The Italian Supreme Pizza     | 33476.75      | 2         |
| Supreme  | The Sicilian Pizza            | 30940.5       | 3         |
| Veggie   | The Four Cheese Pizza         | 32265.7       | 1         |
| Veggie   | The Mexicana Pizza            | 26780.75      | 2         |
| Veggie   | The Five Cheese Pizza         | 26066.5       | 3         |


### Recommendations
- Increase Focus on Top Pizza Categories: Classic, Supreme, and Chicken categories account for a significant portion of total revenue, with Classic pizzas having the highest revenue share. Consider expanding or promoting these categories further.

- Promote High-Revenue Pizzas: Pizzas like "The Thai Chicken Pizza," "The Barbecue Chicken Pizza," and "The Classic Deluxe Pizza" are the top performers. Highlight these in marketing campaigns or bundle offers.

- Optimize Size Offerings: "L" size pizzas dominate orders. Consider introducing targeted discounts or promotions for other sizes like "M" and "S" to boost their sales.

- Analyze Peak Hours for Promotions: Orders peak during lunch and dinner hours (12 PM–2 PM and 5 PM–9 PM). You could consider offering special deals or discounts during these hours to increase volume.

- Expand Options for Veggie Pizzas: While Veggie pizzas generate decent revenue, consider introducing new and innovative flavors to cater to the increasing health-conscious audience.

- Investigate Order Timing Patterns: The number of orders tends to drop significantly after 9 PM. Consider offering late-night deals to capture orders during off-peak hours.

- Focus on Revenue Contribution: The "Classic" pizza category contributes the highest revenue. Develop a loyalty program or subscription services for customers who prefer classic pizzas to drive repeat orders.

- Monitor Pizza Category Growth: Supreme and Chicken pizza categories have a strong following. Regularly assess their growth and introduce limited-time offers or seasonal flavors to keep customers engaged.

- Explore Revenue Growth by Hour: Given that higher revenue correlates with certain hours of the day, consider adjusting staffing or introducing promotions around peak ordering times.

- Target Top Categories for Customization: Customization options for top-selling pizzas could increase customer satisfaction and average order value, particularly for popular pizzas like "The Thai Chicken Pizza" and "The Classic Deluxe Pizza."

### Conclusion
In conclusion, focusing on top-selling pizza categories like Classic, Supreme, and Chicken can significantly drive revenue growth. Promoting high-performing pizzas, optimizing size offerings, and targeting peak hours with special deals will enhance customer satisfaction and order volume. Additionally, expanding veggie options and introducing customization could attract a broader customer base, ensuring continued success.

### Author
- Prasannagoud Patil

### Email
- Prasannpatil31@gmail.com
