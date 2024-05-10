use SHOP_DB;

CREATE FUNCTION dbo.SelectDataFunction
(
@StartDate DATE,
@EndDate DATE
)
RETURNS TABLE
AS
RETURN
(
SELECT *
FROM products
WHERE date >= @StartDate AND date <= @EndDate
)

CREATE FUNCTION dbo.SelectDataFunctionOrders
(
@StartDate DATE,
@EndDate DATE
)
RETURNS TABLE
AS
RETURN
(
SELECT *
FROM orders
WHERE order_date >= @StartDate AND order_date <= @EndDate
)
