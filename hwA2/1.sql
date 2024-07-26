
Create database COMPANYFinal;
use COMPANYFinal;

---- Q1 & Q2 -----------------------------------------------------------------------------------------------------------
CREATE TABLE Employees (
    nationalId BIGINT UNIQUE,
	id INt PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    Parent_id INT,
	E_role VARCHAR(50),
    FOREIGN KEY (parent_id) REFERENCES Employees(id)
);

insert into Employees values
(1234567890 ,1,'Ali', 'Jafari', NULL,'CEO'),
(1236547524 ,2,'Zahra','Kazemi', 1 ,'HRM'),
(1236523654 ,3,'Saleh','Akbari', 1 ,'FM'),
(1246578125 ,4,'Reza','Bageri', 1 ,'TM'),
(4512547856 ,5,'Sina','Ahmadi',3 ,'E'),
(2365478941 ,6,'Melika','Zare', 4 ,'E'),
(1230212015 ,7,'Maryam','Askari', 4 ,'E'),
(1203201458 ,8,'Mehrdad','Moradi', 4 ,'E')

SELECT * FROM Employees;

---- Q3 -----------------------------------------------------------------------------------------------------------
CREATE PROCEDURE SUBemp @Id INT
AS
BEGIN
	IF((SELECT Employees.E_role 
				FROM Employees
				WHERE Employees.id = @Id) = 'HRM')
		SELECT * FROM Employees

	ELSE
	BEGIN
		with cte as
		(  
		  select E.*
		  from Employees as E
		  where E.id = @Id
		  union all
		  select E.*
		  from Employees as E
			inner join cte as C
			  on E.Parent_id = C.id
		)

			SELECT *
			FROM cte  
	END
END

Exec SUBemp @Id = 2;

---- Q4 -----------------------------------------------------------------------------------------------------------
ALTER PROCEDURE SWAP (@id1 INT ,@id2 INT)
	AS
	BEGIN
	
		SELECT * INTO #CHIDS1 FROM Employees WHERE id = @id1;
		SELECT * INTO #CHIDS2 FROM Employees WHERE id = @id2;
		SELECT Parent_id PID , id II ,E_role rr INTO #NEWTBL2 FROM Employees;
		SELECT * INTO #NEWTBL FROM Employees;
		SELECT * INTO #NEWTBL3 FROM Employees;
		
		UPDATE Employees
		SET Parent_id = @id1
		FROM #NEWTBL2
		WHERE #NEWTBL2.II = Employees.id AND #NEWTBL2.PID = @id2;

		UPDATE Employees
		SET Parent_id = @id2
		FROM #NEWTBL2
		WHERE #NEWTBL2.II= Employees.id AND #NEWTBL2.PID = @id1;
		
		UPDATE Employees
		SET E_role = E.E_role
		FROM #CHIDS1 E
		WHERE E.id = @id1 AND Employees.id = @id2;

		UPDATE Employees
		SET E_role = E.E_role
		FROM #CHIDS2 E
		WHERE E.id = @id2 AND Employees.id = @id1;

		UPDATE Employees
		SET Employees.Parent_id = #NEWTBL.Parent_id
		FROM #NEWTBL
		WHERE Employees.id = @id1 AND #NEWTBL.id = @id2;

		UPDATE Employees
		SET Employees.Parent_id = #NEWTBL3.Parent_id
		FROM #NEWTBL3
		WHERE Employees.id = @id2 AND #NEWTBL3.id = @id1;
	
		UPDATE Employees
		SET Parent_id = @id2
		WHERE Parent_id = id AND Parent_id = @id1;

		UPDATE Employees
		SET Parent_id = @id1
		WHERE Parent_id = id AND Parent_id = @id2;
	END;


EXEC SWAP @id1 = 1 , @id2 = 3 ;
GO 
SELECT * FROM Employees;
DELETE FROM Employees;

---- Q6 -----------------------------------------------------------------------------------------------------------
CREATE PROCEDURE AddEmp @national VARCHAR(50), @firstname VARCHAR(50), @lastname VARCHAR(50),
						@pId INT ,@role VARCHAR(50)
AS
BEGIN
	DECLARE @Id INT;
	SET @Id = (SELECT MAX(id) FROM Employees);
	INSERT INTO Employees VALUES(@national , @Id + 1, @firstname , @lastname ,
						@pId,@role)
END

EXEC AddEmp @national = 99521316 , @firstname = 'saba' , @lastname = 'razi' ,@pId = 2, @role = 'PO' ;