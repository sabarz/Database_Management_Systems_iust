--SABA RAZI 99521316
use Northwind;
SELECT * FROM suppliers;
SELECT * FROM Employees;
SELECT * FROM Orders;
SELECT * FROM Customers;
SELECT * FROM [Order Details];
SELECT * FROM Products;
SELECT * FROM Territories;

/*Q1*/
SELECT S.phone
FROM Suppliers AS S
WHERE S.CompanyName LIKE 's%';

/*Q2*/
SELECT Employees.FirstName , Employees.LastName
FROM Employees 
WHERE (SELECT COUNT(E.EmployeeID)
		FROM Employees AS E , Orders AS O
		WHERE E.EmployeeID = O.EmployeeID) > 3 ;

/*Q3*/
SELECT E.LastName , HireAge = DATEDIFF(YEAR,BirthDate,HireDate)
FROM Employees AS E
WHERE E.Title!='Sales Representative';

/*Q4*/
SELECT C.Address , C.ContactName
FROM Customers AS C
WHERE (SELECT SUM(OD.UnitPrice*OD.Quantity)
		FROM [Order Details] AS OD , Orders AS O
		WHERE OD.OrderID=O.OrderID AND C.CustomerID= O.CustomerID) > 6000;
		
/*Q5*/
SELECT SUM(CAST(OD.Quantity AS real))
FROM [Order Details] AS OD , Orders AS O
WHERE O.OrderID=OD.OrderID AND O.ShipCountry='France';