CREATE TABLE tbl_ProductSales (ColID int, Product_Category  varchar(64), Product_Name  varchar(64), TotalSales int); 
INSERT INTO tbl_ProductSales VALUES (1,'Game','Mobo Game',200),(2,'Game','PKO Game',400),(3,'Fashion','Shirt',500),(4,'Fashion','Shorts',100);

SELECT CAST(SUM(TotalSales) as BIGINT) AS TotalSales FROM tbl_ProductSales;

SELECT 
    CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY (); --global aggregate

SELECT 
    CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY (), (); --does the same global aggregate

SELECT 
    CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY Product_Category;

SELECT 
    CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY Product_Name;

SELECT 
    CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY Product_Category, Product_Name;

-- ROLLUP

SELECT 
    CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY ROLLUP (); --error, rollup must have at least one column

SELECT
    Product_Category, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY ROLLUP(Product_Category);

SELECT
    Product_Name, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY ROLLUP(Product_Name);

SELECT
    Product_Category, Product_Name, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY ROLLUP(Product_Category, Product_Name);

SELECT
    Product_Category, Product_Name, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY ROLLUP(Product_Category, Product_Name) HAVING SUM(TotalSales) > 400;

-- CUBE

SELECT 
    CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY CUBE(); --error, cube must have at least one column

SELECT 
    Product_Category, CAST(SUM(TotalSales) as BIGINT) AS TotalSales FROM tbl_ProductSales
GROUP BY CUBE(Product_Category);

SELECT
    Product_Name, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY CUBE(Product_Name);

SELECT
    Product_Category, Product_Name, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY CUBE(Product_Category, Product_Name);

SELECT
    Product_Category, Product_Name, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY CUBE(Product_Category, Product_Name) ORDER BY Product_Category, Product_Name;

-- ROLLUP/CUBE with column

SELECT
    Product_Category, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY ROLLUP(Product_Category), 1+1; --error, group by with expressions and rollup/cube not possible right now

SELECT
    Product_Category, Product_Name, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY ColID, ROLLUP(Product_Category, Product_Name);

SELECT
    Product_Category, Product_Name, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY (ColID), ROLLUP(Product_Category, Product_Name);

SELECT
    Product_Category, Product_Name, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY (ColID), CUBE(Product_Category, Product_Name);

-- Combining ROLLUP and CUBE

SELECT 
    Product_Category, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY ROLLUP(Product_Category), ROLLUP(Product_Category);

SELECT
    Product_Category, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY CUBE(Product_Category), CUBE(Product_Category);

SELECT
    Product_Category, Product_Name, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY ROLLUP(Product_Category, Product_Name), ROLLUP(Product_Category, Product_Name);

SELECT
    Product_Category, Product_Name, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY CUBE(Product_Category, Product_Name), CUBE(Product_Category, Product_Name);

SELECT
    Product_Category, Product_Name, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY ROLLUP(Product_Category, Product_Name), CUBE(Product_Category, Product_Name);

-- Sets of columns

SELECT
    Product_Name, CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY CUBE((Product_Name));

SELECT 
    CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY CUBE((Product_Category, Product_Name, ColID));

SELECT
    CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY ROLLUP((Product_Category, Product_Name), ColID);

SELECT
    CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY ROLLUP((Product_Category, Product_Name), ColID), ColID;

SELECT
    COUNT(*), CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY CUBE((Product_Category, Product_Name), ColID), ColID , ROLLUP((Product_Category, ColID), Product_Name);

SELECT
    DISTINCT CAST(SUM(TotalSales) as BIGINT) AS TotalSales
FROM tbl_ProductSales
GROUP BY CUBE((Product_Category, Product_Name), ColID), ColID , ROLLUP((Product_Category, ColID), Product_Name);

DROP TABLE tbl_ProductSales;
