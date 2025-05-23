# Brazilian E-Commerce Public Dataset Analysis (Olist)

## Overview

This project analyzes the Brazilian E-Commerce dataset provided by Olist to extract business insights using PostgreSQL.

The dataset includes detailed information on customers, orders, products, sellers, payments, and reviews.

## Project Setup

1. **Download Dataset:**  
   Download the dataset from [Kaggle - Olist Brazilian E-Commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

2. **Database:**  
   - Created a PostgreSQL database named `olist_ecommerce`
   - Import CSV files into corresponding tables (`customers`, `orders`, `order_items`, `products`, `sellers`, `order_payments`, `order_reviews`, `category_translation`, `geolocation`).  

3. **Tools Used:**  
   - PostgreSQL (query engine)  
   - DBeaver (for data import and query execution)

## Data Analysis

I ran various analyses with SQL queries to understand the dataset and uncover key insights, such as:

### 1. Top Product Categories by Sales Volume
Identify the most sold product categories.

### 2. Payment Method Distribution
Analyze which payment types are most popular.

### 3. Customer Satisfaction
Calculate average review scores by product category.

### 4. Customer Spending
Calculate average order value per customer.

### 5. Delivery Performance
Analyze average delivery delays by month and year.

### 6. Geographic Distribution
Review order counts by Brazilian states.

### 7. Seller Performance
Identify sellers with the highest number of orders.

### 8. Freight Cost vs Product Price
Compare average freight costs against product prices by category.

## Example Query (What were the most popular days?)
```sql
SELECT o.order_purchase_timestamp::date AS purchase_date,
       COUNT(*) AS order_count
FROM orders o
GROUP BY purchase_date
ORDER BY order_count DESC
LIMIT 10;
```
This query identifies the days with the highest number of orders. Notably, November 24, 2017, stands out as the busiest day, corresponding to Black Friday — a major sales event in Brazil and worldwide.
