--Tulis query untuk mendapatkan jumlah customer tiap bulan yang melakukan order pada tahun 1997.
SELECT
	DATENAME(month, orderdate) Month
	, COUNT(DISTINCT customerID) Customer_Count
FROM Northwind.dbo.orders
WHERE YEAR(orderdate) = '1997'
GROUP BY MONTH(orderdate),
         DATENAME(month, orderdate)
ORDER BY MONTH(orderdate);


--Tulis query untuk mendapatkan nama employee yang termasuk Sales Representative.
SELECT
	firstname + ' ' + lastname name
FROM Northwind.dbo.employees e
WHERE title = 'Sales Representative'


--Tulis query untuk mendapatkan top 5 nama produk yang quantitynya paling banyak diorder pada bulan Januari 1997.
SELECT TOP 5
	productname
	, SUM(quantity) qty
FROM Northwind.dbo.orders o
LEFT JOIN Northwind.dbo[Order Details] od ON o.orderid = od.orderid
LEFT JOIN Northwind.dbo.Products p ON od.productid = p.productid
GROUP BY productname
ORDER BY qty DESC;


--Tulis query untuk mendapatkan nama company yang melakukan order Chai pada bulan Juni 1997.
SELECT
	DISTINCT companyname
FROM orders o
LEFT JOIN [Order Details] od ON o.orderid = od.orderid
LEFT JOIN Products p ON od.productid = p.productid
LEFT JOIN customers c ON o.customerid = c.customerid
WHERE productname = 'Chai'
AND DATETRUNC(month, orderdate) = '1997-06-01';


--Tulis query untuk mendapatkan jumlah OrderID yang pernah melakukan pembelian (unit_price dikali quantity) <=100, 100<x<=250, 250<x<=500, dan >500.
SELECT
SUM(CASE WHEN unitprice * quantity <= 100 THEN 1 ELSE 0 END) AS "Total Order <= 100",
SUM(CASE WHEN unitprice * quantity > 100 AND unitprice * quantity <= 250 THEN 1 ELSE 0 END) AS "Total Order > 100 and <= 250",
SUM(CASE WHEN unitprice * quantity > 250 AND unitprice * quantity <= 500 THEN 1 ELSE 0 END) AS "Total Order > 250 and <= 500",
SUM(CASE WHEN unitprice * quantity > 500 THEN 1 ELSE 0 END) AS "Total Order > 500"
FROM Northwind.dbo.[Order Details];


--Tulis query untuk mendapatkan Company name pada tabel customer yang melakukan pembelian di atas 500 pada tahun 1997.
SELECT
	DISTINCT c.companyname 'Company Name'
FROM Northwind.dbo.Orders o
LEFT JOIN Northwind.dbo.[Order Details] od ON o.orderid = od.orderid
LEFT JOIN Northwind.dbo.customers c ON o.customerid = c.customerid
WHERE YEAR(orderdate) = '1997'
AND unitprice * quantity > 500;


--Tulis query untuk mendapatkan nama produk yang merupakan Top 5 sales tertinggi tiap bulan di tahun 1997.
SELECT
	TOP 5
	productname 'Product Name'
FROM Northwind.dbo.orders o
LEFT JOIN Northwind.dbo.[Order Details] od ON o.orderid = od.orderid
LEFT JOIN Northwind.dbo.products p ON od.productid = p.productid
ORDER BY od.unitprice * quantity;


--Buatlah view untuk melihat Order Details yang berisi OrderID, ProductID, ProductName, UnitPrice, Quantity, Discount, Harga setelah diskon.
CREATE VIEW Order_Details AS
SELECT
	o.orderid
	, p.productid
	, p.productname
	, od.unitprice
	, od.quantity
	, od.discount
	, od.unitprice * od.quantity * (1 - discount) 'Price After Discount'
FROM Northwind.dbo.orders o
LEFT JOIN Northwind.dbo.[Order Details] od ON o.orderid = od.orderid
LEFT JOIN Northwind.dbo.products p ON od.productid = p.productid;


--Buatlah procedure Invoice untuk memanggil CustomerID, CustomerName/company name, OrderID, OrderDate, RequiredDate, ShippedDate jika terdapat inputan CustomerID tertentu.
CREATE PROCEDURE Invoice (@customerID INT)
AS
BEGIN
    SELECT 
        c.customerID, c.companyName AS 'CustomerName',
        o.orderID, o.orderdate, o.requireddate, o.shippeddate
    FROM customers c
    LEFT JOIN orders o ON c.customerID = o.customerID
    WHERE c.CustomerID = @customerID
END