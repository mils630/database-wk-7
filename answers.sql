-- Question 1: Achieving 1NF (First Normal Form)


-- The Products column in ProductDetail has multiple values.
-- We split them so each row contains only one product per order.

-- SQL Server Solution (uses STRING_SPLIT)
SELECT 
    OrderID,
    CustomerName,
    LTRIM(RTRIM(value)) AS Product
FROM ProductDetail
CROSS APPLY STRING_SPLIT(Products, ',');

-- Note:
-- In MySQL, you'd need a helper function or recursive CTE 
-- since STRING_SPLIT is not built-in.


-- ============================================================
-- Question 2: Achieving 2NF (Second Normal Form)
-- ============================================================

-- Problem: CustomerName depends only on OrderID, not on the composite key (OrderID, Product).
-- Solution: Separate into two tables → Orders and OrderProducts.

-- Step 1: Create Orders table to store Customer info
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Insert distinct OrderID - CustomerName pairs
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 2: Create OrderProducts table for product details
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert OrderID - Product - Quantity data
INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Final Result:
-- Orders table stores CustomerName (removes partial dependency).
-- OrderProducts table stores Products + Quantities per Order.
-- Now all non-key columns fully depend on the entire primary key.
