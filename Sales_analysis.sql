-- create database sales;
use sales;
show tables;
select* from sales_data;
-- What is the total number of records?
SELECT COUNT(*) AS total_records
FROM sales_data;
-- What are total sales, cost, and profit?
SELECT
    SUM(Sales)  AS total_sales,
    SUM(Cost)   AS total_cost,
    SUM(Profit) AS total_profit
FROM sales_data;
-- What is the overall profit margin?
SELECT
    ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin_percent
FROM sales_data;
-- Year-wise sales and profit
SELECT
    Year,
    SUM(Sales)  AS total_sales,
    SUM(Profit) AS total_profit
FROM sales_data
GROUP BY Year
ORDER BY Year;
-- Which months generate the highest sales?
SELECT
    Month,
    SUM(Sales) AS monthly_sales
FROM sales_data
GROUP BY Month
ORDER BY monthly_sales DESC;
-- Region-wise sales performance
SELECT
    Region,
    SUM(Sales) AS total_sales
FROM sales_data
GROUP BY Region
ORDER BY total_sales DESC;
-- Region-wise profit margin
SELECT
    Region,
    ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
FROM sales_data
GROUP BY Region
ORDER BY profit_margin DESC;
-- Product-wise profit contribution
SELECT
    Product,
    SUM(Profit) AS total_profit
FROM sales_data
GROUP BY Product
ORDER BY total_profit DESC;
-- Top 5 customers by revenue
SELECT
    Customer,
    SUM(Sales) AS revenue
FROM sales_data
GROUP BY Customer
ORDER BY revenue DESC
LIMIT 5;
-- Which products have high sales but low margins?
SELECT
    Product,
    SUM(Sales) AS total_sales,
    ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
FROM sales_data
GROUP BY Product
ORDER BY total_sales DESC;
-- Cost-to-sales ratio by product
SELECT
    Product,
    ROUND(SUM(Cost)/SUM(Sales)*100,2) AS cost_ratio
FROM sales_data
GROUP BY Product
ORDER BY cost_ratio DESC;
-- Detect loss-making transactions
SELECT *
FROM sales_data
WHERE Profit < 0;
-- Best region–product combinations
SELECT
    Region,
    Product,
    SUM(Profit) AS total_profit
FROM sales_data
GROUP BY Region, Product
ORDER BY total_profit DESC;
-- Year-over-Year (YoY) Sales Growth
WITH yearly_sales AS (
    SELECT
        Year,
        SUM(Sales) AS total_sales
    FROM sales_data
    GROUP BY Year
)
SELECT
    Year,
    total_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY Year)) /
        LAG(total_sales) OVER (ORDER BY Year) * 100, 2
    ) AS yoy_growth_percent
FROM yearly_sales;
-- Business KPI Dashboard (CTE)
WITH base_kpis AS (
    SELECT
        SUM(Sales)  AS total_sales,
        SUM(Cost)   AS total_cost,
        SUM(Profit) AS total_profit
    FROM sales_data
)
SELECT
    total_sales,
    total_cost,
    total_profit,
    ROUND(total_profit/total_sales*100,2) AS profit_margin
FROM base_kpis;
-- Customer Revenue Concentration
WITH customer_revenue AS (
    SELECT
        Customer,
        SUM(Sales) AS revenue
    FROM sales_data
    GROUP BY Customer
),
total_revenue AS (
    SELECT SUM(revenue) AS total FROM customer_revenue
)
SELECT
    c.Customer,
    c.revenue,
    ROUND(c.revenue/t.total*100,2) AS contribution_percent
FROM customer_revenue c
CROSS JOIN total_revenue t
ORDER BY contribution_percent DESC;
-- Region Efficiency Analysis (CTE)
WITH region_metrics AS (
    SELECT
        Region,
        SUM(Sales)  AS total_sales,
        SUM(Profit) AS total_profit
    FROM sales_data
    GROUP BY Region
)
SELECT
    Region,
    total_sales,
    total_profit,
    ROUND(total_profit/total_sales*100,2) AS profit_margin
FROM region_metrics
ORDER BY profit_margin DESC;
