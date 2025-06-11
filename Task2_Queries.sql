-- Task 2: Data Analysis with Advanced SQL
-- Author: Tushar Jha
-- Date: June 2025

-- Step 1: Creating Sales table
CREATE TABLE Sales (
    sale_id INT,
    employee_name VARCHAR(50),
    sale_amount DECIMAL(10, 2),
    sale_date DATE,
    region VARCHAR(20)
);

-- Step 2: Inserting sample data
INSERT INTO Sales VALUES
(1, 'Tushar', 1000.00, '2025-06-01', 'East'),
(2, 'Tushar', 1200.00, '2025-06-03', 'East'),
(3, 'Anjali', 800.00, '2025-06-02', 'North'),
(4, 'Rohit', 2000.00, '2025-06-01', 'East'),
(5, 'Simran', 1500.00, '2025-06-04', 'North'),
(6, 'Anjali', 950.00, '2025-06-05', 'North'),
(7, 'Rohit', 1800.00, '2025-06-06', 'East');

-- Query 1: Window Function - Ranking sales by employee
SELECT 
  employee_name,
  sale_amount,
  RANK() OVER (PARTITION BY employee_name ORDER BY sale_amount DESC) AS sale_rank
FROM Sales;

-- Query 2: Subquery - Sales above employee's average
SELECT 
  employee_name, 
  sale_amount
FROM Sales
WHERE sale_amount > (
    SELECT AVG(sale_amount) 
    FROM Sales AS S2 
    WHERE S2.employee_name = Sales.employee_name
);

-- Query 3: CTE - Monthly sales total per employee
WITH MonthlySales AS (
    SELECT 
      employee_name,
      MONTH(sale_date) AS sale_month,
      SUM(sale_amount) AS total_sales
    FROM Sales
    GROUP BY employee_name, MONTH(sale_date)
)
SELECT * FROM MonthlySales;

-- Query 4: CTE + Window Function - Top seller per region
WITH RankedSales AS (
    SELECT 
      employee_name,
      region,
      SUM(sale_amount) AS total_sales,
      RANK() OVER (PARTITION BY region ORDER BY SUM(sale_amount) DESC) AS rnk
    FROM Sales
    GROUP BY employee_name, region
)
SELECT * FROM RankedSales WHERE rnk = 1;
