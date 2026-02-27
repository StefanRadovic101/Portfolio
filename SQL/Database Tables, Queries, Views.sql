-- Creating Database Tables
CREATE TABLE users (
    region VARCHAR(50) PRIMARY KEY,
    manager VARCHAR(100)
);

CREATE TABLE returns (
    order_id INT PRIMARY KEY,
    status VARCHAR(20)
);

CREATE TABLE orders_central (
    row_id INT PRIMARY KEY,
    order_id INT,
    order_priority VARCHAR(20),
    discount NUMERIC(5,2),
    unit_price NUMERIC(10,2),
    shipping_cost NUMERIC(10,2),
    customer_id INT,
    customer_name VARCHAR(100),
    ship_mode VARCHAR(50),
    customer_segment VARCHAR(50),
    product_category VARCHAR(50),
    sub_category VARCHAR(50),
    region VARCHAR(50),
    state_or_province VARCHAR(50),
    city VARCHAR(50),
    postal_code VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    profit NUMERIC(10,2),
    quantity_ordered INT,
    sales NUMERIC(10,2),

    CONSTRAINT central_region FOREIGN KEY (region) REFERENCES users(region),
    CONSTRAINT central_returns FOREIGN KEY (order_id) REFERENCES returns(order_id)
);

CREATE TABLE orders_east (
    row_id INT PRIMARY KEY,
    order_id INT,
    order_priority VARCHAR(20),
    discount NUMERIC(5,2),
    unit_price NUMERIC(10,2),
    shipping_cost NUMERIC(10,2),
    customer_id INT,
    customer_name VARCHAR(100),
    ship_mode VARCHAR(50),
    customer_segment VARCHAR(50),
    product_category VARCHAR(50),
    sub_category VARCHAR(50),
    region VARCHAR(50),
    state_or_province VARCHAR(50),
    city VARCHAR(50),
    postal_code VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    profit NUMERIC(10,2),
    quantity_ordered INT,
    sales NUMERIC(10,2),

    CONSTRAINT east_region FOREIGN KEY (region) REFERENCES users(region),
    CONSTRAINT east_returns FOREIGN KEY (order_id) REFERENCES returns(order_id)
);



CREATE TABLE orders_west (
    row_id INT PRIMARY KEY,
    order_id INT,
    order_priority VARCHAR(20),
    discount NUMERIC(5,2),
    unit_price NUMERIC(10,2),
    shipping_cost NUMERIC(10,2),
    customer_id INT,
    customer_name VARCHAR(100),
    ship_mode VARCHAR(50),
    customer_segment VARCHAR(50),
    product_category VARCHAR(50),
    sub_category VARCHAR(50),
    region VARCHAR(50),
    state_or_province VARCHAR(50),
    city VARCHAR(50),
    postal_code VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    profit NUMERIC(10,2),
    quantity_ordered INT,
    sales NUMERIC(10,2),

    CONSTRAINT west_region FOREIGN KEY (region) REFERENCES users(region),
    CONSTRAINT west_returns FOREIGN KEY (order_id) REFERENCES returns(order_id)
);


CREATE TABLE orders_south (
    row_id INT PRIMARY KEY,
    order_id INT,
    order_priority VARCHAR(20),
    discount NUMERIC(5,2),
    unit_price NUMERIC(10,2),
    shipping_cost NUMERIC(10,2),
    customer_id INT,
    customer_name VARCHAR(100),
    ship_mode VARCHAR(50),
    customer_segment VARCHAR(50),
    product_category VARCHAR(50),
    sub_category VARCHAR(50),
    region VARCHAR(50),
    state_or_province VARCHAR(50),
    city VARCHAR(50),
    postal_code VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    profit NUMERIC(10,2),
    quantity_ordered INT,
    sales NUMERIC(10,2),

    CONSTRAINT south_region FOREIGN KEY (region) REFERENCES users(region),
    CONSTRAINT south_returns FOREIGN KEY (order_id) REFERENCES returns(order_id)
);


-- QUERIES
-- 1. Top 3 customers with highest total sales in East region
SELECT
    customer_id,
    customer_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_pk) AS number_of_orders
FROM orders_east
GROUP BY customer_id, customer_name
ORDER BY total_sales DESC
LIMIT 3;
-- 2. Top 3 product subcategories with highest number of orders
SELECT
   product_sub_category,
   COUNT(DISTINCT order_id) AS number_of_orders,
   SUM(sales) AS total_sales,
   SUM(profit) AS total_profit
FROM (
    SELECT product_sub_category, order_id, sales, profit FROM orders_central
	UNION ALL
	SELECT product_sub_category, order_id, sales, profit FROM orders_east
	UNION ALL
	SELECT product_sub_category, order_id, sales, profit FROM orders_west
	UNION ALL
	SELECT product_sub_category, order_id, sales, profit FROM orders_south
) all_orders
GROUP BY product_sub_category
ORDER BY number_of_orders DESC
LIMIT 3;
-- 3. Average prododuct base margin, profit, sales by month 
SELECT 
  DATE_TRUNC('month', order_date) AS month,
  AVG(product_base_margin) AS avg_product_base_margin,
  AVG(profit) AS profit,
  AVG(sales) AS sales
FROM (
  SELECT order_date, product_base_margin, profit, sales, quantity_ordered_new FROM orders_central
  UNION ALL
  SELECT order_date, product_base_margin, profit, sales, quantity_ordered_new FROM orders_east
  UNION ALL
  SELECT order_date, product_base_margin, profit, sales, quantity_ordered_new FROM orders_west
  UNION ALL
  SELECT order_date, product_base_margin, profit, sales, quantity_ordered_new FROM orders_south
) all_orders
WHERE quantity_ordered_new > 10
AND sales > (
    SELECT AVG(sales)
	FROM (SELECT sales FROM orders_central
	      UNION ALL
          SELECT sales FROM orders_east
		  UNION ALL
		  SELECT sales FROM orders_west
		  UNION ALL
		  SELECT sales FROM orders_south
	)s
)
GROUP BY DATE_TRUNC('month', order_date)
-- 4. Top 5 best-selling subcategories using rank
SELECT
    product_sub_category,
    SUM(sales) AS total_sales,
    RANK() OVER (ORDER BY SUM(sales) DESC) AS sales_rank
FROM (
    SELECT product_sub_category, sales FROM orders_central
    UNION ALL
    SELECT product_sub_category, sales FROM orders_east
    UNION ALL
    SELECT product_sub_category, sales FROM orders_west
    UNION ALL
    SELECT product_sub_category, sales FROM orders_south
) all_orders
GROUP BY product_sub_category
ORDER BY sales_rank
LIMIT 5;
 -- 5. Assign rank to each manager by total profits
SELECT
    u.manager,
    SUM(o.profit) AS total_profit,
    RANK() OVER (ORDER BY SUM(o.profit) DESC) AS profit_rank
FROM (
    SELECT region, profit FROM orders_central
    UNION ALL
    SELECT region, profit FROM orders_east
    UNION ALL
    SELECT region, profit FROM orders_west
    UNION ALL
    SELECT region, profit FROM orders_south
) o
JOIN users u
  ON o.region = u.region
GROUP BY u.manager
ORDER BY profit_rank;
 -- 6. Which product subcategory is returned most times
SELECT
    o.product_sub_category,
    COUNT(*) AS number_of_returns
FROM (
    SELECT order_pk, product_sub_category FROM orders_central
    UNION ALL
    SELECT order_pk, product_sub_category FROM orders_east
    UNION ALL
    SELECT order_pk, product_sub_category FROM orders_west
    UNION ALL
    SELECT order_pk, product_sub_category FROM orders_south
) o
JOIN returns r
    ON o.order_pk = r.order_pk
GROUP BY o.product_sub_category
ORDER BY number_of_returns DESC
LIMIT 1;

-- Views
-- 1. Create a view that combines orders from all regions
CREATE VIEW vw_all_orders_new AS
SELECT * FROM orders_central
UNION ALL
SELECT * FROM orders_east
UNION ALL
SELECT * FROM orders_west
UNION ALL
SELECT * FROM orders_south;
-- Proveri
SELECT COUNT(*) FROM vw_all_orders_new;
-- 2.Create a view that combines previously created orders view with returns and
--users
CREATE VIEW vw_orders_full_new AS
SELECT 
    o.*,
    r.status AS return_status,
    u.manager
FROM vw_all_orders_new o
LEFT JOIN returns r
    ON o.order_pk = r.order_pk
LEFT JOIN users u
    ON o.region = u.region;
-- Proveri 
SELECT *
FROM vw_orders_full_new;
-- 3. Create a view that shows customer id’s, customer names and their total
-- discounts, total profits and total sales. Sort table by total sales descending
CREATE VIEW vw_customer_summary_new AS
SELECT
    o.customer_id,
    o.customer_name,
    SUM(o.discount) AS total_discounts,
    SUM(o.profit)   AS total_profits,
    SUM(o.sales)    AS total_sales
FROM vw_orders_full_new o
GROUP BY 
    o.customer_id,
    o.customer_name
ORDER BY 
    total_sales DESC;
-- Proveri
SELECT * 
FROM vw_customer_summary_new;
-- trimovanje critical
UPDATE orders_central SET order_priority = TRIM(order_priority);
UPDATE orders_east    SET order_priority = TRIM(order_priority);
UPDATE orders_west    SET order_priority = TRIM(order_priority);
UPDATE orders_south   SET order_priority = TRIM(order_priority);
-- pravljenje jedne fact tabele za Power BI
CREATE TABLE fact_orders AS
SELECT * FROM orders_central
UNION ALL
SELECT * FROM orders_east
UNION ALL
SELECT * FROM orders_west
UNION ALL
SELECT * FROM orders_south