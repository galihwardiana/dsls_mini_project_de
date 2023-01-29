INSERT INTO Northwind.dbo.product_performance
(orderdate, productname, categoryname, quantity, sales)
SELECT
	orderdate
	, productname
	, categoryname
	, SUM(quantity) quantity
	, SUM(quantity * od.unitprice) sales
FROM Northwind.dbo.orders o
LEFT JOIN Northwind.dbo.[Order Details] od ON o.orderid = od.orderid
LEFT JOIN Northwind.dbo.products p ON od.productid = p.productid
LEFT JOIN Northwind.dbo.categories ct ON p.categoryid = ct.categoryid
GROUP BY orderdate, productname, categoryname
ORDER BY 1;

SELECT
    SUM(CASE WHEN c.city = s.city AND c.region = s.region AND c.country = s.country THEN 1 ELSE 0 END) AS same_city_shipment, 
    SUM(CASE WHEN c.city != s.city OR c.region != s.region OR c.country != s.country THEN 1 ELSE 0 END) AS different_city_shipment
FROM Northwind.dbo.orders o
JOIN Northwind.dbo.customers c ON o.customerid = c.customerid
JOIN Northwind.dbo.[Order Details] od ON o.orderid = od.orderid
JOIN Northwind.dbo.products p ON od.productid = p.productid
JOIN Northwind.dbo.suppliers s ON p.supplierid = s.supplierid;


SELECT
	TOP 5
	e.firstname + ' ' + e.lastname employee_name
	, SUM(unitprice * quantity * (1 - discount)) sales
FROM Northwind.dbo.orders o
LEFT JOIN Northwind.dbo.[Order Details] od ON o.orderid = od.orderid
LEFT JOIN Northwind.dbo.employees e ON o.employeeid = e.employeeid
WHERE YEAR(orderdate) = '1997'
GROUP BY firstname, lastname