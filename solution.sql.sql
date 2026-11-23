USE shopeasy_db;
-- 1. Marketing wants to know which cities our orders Marketing wants to know which cities our orders come from and which payment methods customers use. Give me each as a separate list.
SELECT DISTINCT city FROM orders;
SELECT DISTINCT payment_mode FROM orders;


-- 2. The catalogue team needs a clean product list showing the product name, category and price, with proper headings.
select product_name as 'product name',category as 'category',unit_price as 'unit price'from orders;

-- 3. Finance is auditing the April to June 2026 quarter. Show me all delivered orders from Kochi or Chennai placed in that period.
select *from orders where city in('kochi','chennai')and order_status='delivered' and order_date between '2026-04-01'and '2026-06-30' ;

-- 4. The payments team is reviewing card and net banking activity. Show me the orders paid by credit card or net banking where more than 2 units were bought and the order was not cancelled.
select *FROM orders WHERE payment_mode IN ('Credit Card', 'Net Banking')AND quantity > 2 AND order_status <> 'cancelled';

-- 5.Which products are priced between ₹1,000 and ₹5,000 and are not in the Electronics category?
select*from orders where unit_price between 1000 and 5000 and category<>'electronics';

-- 6.The website search team is testing premium-sounding product names. Which products have "Pro" or "Max" in their name?
select product_name from orders where product_name like '%pro%'or'%max%';

-- 7. Marketing wants to send a message to customers whose names start with "S". Give me each such customer once.
select distinct customer_name from orders where customer_name like 's%';

-- 8. Show me all cancelled or returned orders where we gave no discount.
select*from orders where discount_percent is null and order_status in('cancelled','returned');
select *from orders;
select*from products;

-- 9. Which products launched in 2026 have not received a customer rating yet?
select*from products where year(launch_date)='2026' and rating is null;

-- 10.Who are our 5 most expensive products, and what do they cost?
SELECT product_name, price FROM products ORDER BY price DESC LIMIT 5;

-- 11.Give me the full product list sorted by category from A to Z, and within each category with the most expensive product first.
select *FROM products ORDER BY category ASC, price DESC;

-- 12.Show me our 10 biggest delivered orders: who ordered, from which city, and how much they paid.
select customer_name,city,total_amount from orders where order_status='delivered' order by  total_amount desc limit 10;

-- 13.Give management a one-line summary of all orders that were not cancelled: how many orders, total revenue, average order value, smallest order and largest order. Use readable headings.
select count(order_id)as 'total orders',sum(total_amount)as 'total revenue',avg(total_amount)as 'avg order value',min(total_amount)as 'smallest order',max(total_amount)as 'largest order'from 
orders where order_status<>'cancelled';

-- 14. How many orders do we have in total, how many of them had a discount, and how many different customers have ordered?
SELECT COUNT(order_id) AS 'Total Orders',SUM(CASE WHEN discount_percent > 0 THEN 1 ELSE 0 END) AS 'Discounted Orders',
COUNT(DISTINCT customer_name) AS 'Different Customers'FROM orders;


-- 15.For delivered orders, show each city with its number of orders and revenue, biggest revenue first.
SELECT city,COUNT(*) AS 'Number of Orders',SUM(total_amount) AS 'Revenue'FROM orders WHERE order_status = 'Delivered'GROUP BY city
ORDER BY SUM(total_amount) DESC;

-- 16.For orders that were not cancelled, show each payment method with its number of orders and average order value. Only include methods used on more than 12 orders.
SELECT payment_mode,COUNT(*) AS 'Number of Orders',ROUND(AVG(total_amount), 2) AS 'Average Order Value'FROM orders
WHERE order_status <> 'Cancelled'GROUP BY payment_mode HAVING COUNT(*) > 12;

-- 17.We want to reward loyal customers. Who has placed more than 4 orders (not counting cancelled ones)? Show their name, number of orders and total spend, and give me only the top 5 spenders.
SELECT customer_name,COUNT(*) AS 'Number of Orders',SUM(total_amount) AS 'Total Spend'FROM orders WHERE order_status <> 'Cancelled'
GROUP BY customer_name HAVING COUNT(*) > 4 ORDER BY SUM(total_amount) DESC LIMIT 5;


-- 18.For each product category, show how many products we sell, their average price and the total units in stock. Leave out categories with 3 products or fewer.
SELECT category,COUNT(*) AS 'Number of Products',ROUND(AVG(price), 2) AS 'Average Price',SUM(stock_qty) AS 'Total Stock'
FROM products GROUP BY category HAVING COUNT(*) > 3;


-- 19. Operations wants to find slow cities. Among delivered orders, which cities take more than 6 days on average to deliver? Show the average, slowest first.
SELECT city,ROUND(AVG(delivery_days), 2) AS 'Average Delivery Days'FROM orders WHERE order_status = 'Delivered'
GROUP BY city HAVING AVG(delivery_days) > 6 ORDER BY AVG(delivery_days) DESC;


-- 20.Looking only at delivered orders placed on or after 1 April 2026, and leaving out Delhi, show the number of orders and revenue for each payment method. Only include methods with revenue above ₹15,000, and show just the top 2.
SELECT payment_mode,COUNT(*) AS 'Number of Orders',
SUM(total_amount) AS 'Revenue'FROM orders
WHERE order_status = 'Delivered'AND order_date >= '2026-04-01'AND city <> 'Delhi'
GROUP BY payment_mode HAVING SUM(total_amount) > 15000 ORDER BY SUM(total_amount) DESC LIMIT 2;