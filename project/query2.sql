USE INVENTORY_SYSTEM;

--ADD a new column in company table
ALTER TABLE COMPANY 
ADD C_Employee_count INT;

ALTER TABLE EMPLOYEE 
ADD E_salary INT NOT NULL;

ALTER TABLE MANAGER 
ADD M_salary INT NOT NULL;

--change the type of a column to another
ALTER TABLE COMPANY
ALTER COLUMN C_name VARCHAR(100);

ALTER TABLE EMPLOYEE
ALTER COLUMN E_working_hours INT NOT NULL;

--drop a column 
ALTER TABLE PRODUCT
DROP COLUMN P_number;

--insert data in tables
insert into FACTORY values (2232 , 'golrang' , 'tehran , azadi');
insert into FACTORY values (7848 , 'sehat', 'tehran , enghelab');
insert into FACTORY values (2358 , 'dov', 'tehran , gheytarie');
insert into FACTORY values (4904 , 'kale', 'tehran , arzhantin');
insert into FACTORY values (9847 , 'gooshtiran', 'karaj , jahanshahr');
insert into FACTORY values (7648 , 'mihan','karaj , mehrshahr');
insert into FACTORY values (0930 , 'domino' ,'karaj , azimie');
insert into FACTORY values (3875 , 'kave' , 'ghaemshahr');

insert into COMPANY values (0 , 'c0' , 160);
insert into COMPANY values (1 , 'c1' ,120);
insert into COMPANY values (2 , 'c2' , 67);
insert into COMPANY values (3 , 'c3' , 674);
insert into COMPANY values (4 , 'c4' , 77);
insert into COMPANY values (5 , 'c5' , 873);
insert into COMPANY values (10 , 'c10' , 90);
insert into COMPANY values (20 , 'c20', 100);

insert into STORAGE values (111 , 0 , 'labaniat' , 10000);
insert into STORAGE values (444 , 0 , 'arayeshi' , 5000);
insert into STORAGE values (666 , 3 , 'labaniat' , 3000);
insert into STORAGE values (655 , 3 , 'labaniat' , 20000);

insert into EMPLOYEE values (99521316 , 20 , 'SABA' , 30 , '6/11/2019' , 100);
insert into EMPLOYEE values (87382997 , 0 , 'mojtaba' , 21 , '6/11/2019' , 98);
insert into EMPLOYEE values (65262687 , 20 , 'ali' , 11 , '6/11/2019' , 387);
insert into EMPLOYEE values (23708392 , 10 , 'maryam' , 12 , '6/11/2019' , 879);
insert into EMPLOYEE values (39402943 , 0 , 'mirza' , 32 , '6/11/2019' , 873);
insert into EMPLOYEE values (72637268 , 0 , 'bakintash' , 28 , '6/11/2019' , 883);
insert into EMPLOYEE values (93849389 , 20 , 'SAma' , 34 , '6/11/2019' , 100);


insert into MANAGER values (99521361 , 111 , 'REYHANE' , '35' , NULL , NULL , '6/11/2019' , 100);
insert into MANAGER values (83749729 , 111 , 'hoorie' , '32' , NULL , NULL , '6/11/2019' , 120);
insert into MANAGER values (93890334 , 444 , 'farnnaz' , '30' , NULL , NULL , '6/11/2019' , 130);
insert into MANAGER values (73880000 , 444 , 'atra' , '22' , NULL , NULL , '6/11/2019' , 100);
insert into MANAGER values (63828729 , 444 , 'pooria' , '28' , NULL , NULL , '6/11/2019' , 100);
insert into MANAGER values (12131323 , 444 , 'hasan' , '28' , NULL , NULL , '6/11/2019' , 90);
insert into MANAGER values (42636289 , 666 , 'shakiba' , '27' , NULL , NULL , '6/11/2019' ,20);
insert into MANAGER values (76732673 , 655 , 'sina' , '26' , NULL , NULL , '6/11/2019' , 120);

insert into REPAIRMAN values(99521361);
insert into KEEPER values(83749729);
insert into CODER values(93890334);
insert into SHOPPING_DEMAND_CONTROLLER values(73880000);
insert into INVENTORY_CONTROLLER values(63828729);
insert into INVENTORY_CONTROLLER values(12131323);
insert into INVENTORY_CONTROLLER values(42636289);
insert into INVENTORY_CONTROLLER values(76732673);

insert into PRODUCT values (736726 , 'bastani' , '6/11/2023' , '6/10/2022'  , 'labaniat' , '6/11/2023' , null , 20 , 2 , 4 , 2232 ,111);
insert into PRODUCT values (271593 , 'shokolat' , '6/11/2020' , '6/10/2022'  , 'shirini' , '6/11/2023' , null , 21 , 4 , 9 , 7848 ,444);
insert into PRODUCT values (837483 , 'esmartiz' , '6/11/2023' , '6/10/2022'  , 'shirini' , '6/11/2023' , null , 10 , 23 , 40 , 2232 ,111);
insert into PRODUCT values (983924 , 'cake' , '6/11/2023' , '6/10/2022'  , 'labaniat' , '6/11/2023' , null , 19 , 22 , 4 , 2232 ,111);
insert into PRODUCT values (827044 , 'shampoo' , '6/11/2023' , '6/10/2022'  , 'shirini' , '6/11/2023' , null , 10 , 23 , 40 , 2358 ,111);
insert into PRODUCT values (389282 , 'mesvak' , '6/11/2023' , '6/10/2022'  , 'labaniat' , '6/11/2023' , null , 19 , 22 , 4 , 2358 ,111);
insert into PRODUCT values (003738 , 'pashe kosh' , '6/11/2023' , '6/10/2022'  , 'shirini' , '6/11/2023' , null , 10 , 23 , 40 , 4904 ,111);
insert into PRODUCT values (394893 , 'A1' , '6/11/2021' , '6/10/2022'  , 'labaniat' , '6/11/2023' , null , 20 , 2 , 4 , 2232 ,111);
insert into PRODUCT values (209302 , 'A2' , '6/11/2021' , '6/10/2022'  , 'labaniat' , '6/11/2023' , null , 20 , 2 , 4 , 2232 ,111);

SET IDENTITY_INSERT PRODUCT_update_table ON;

--change the company to id=20 of employees that work more then 30 hours and work in the company id=10
UPDATE EMPLOYEE
SET E_componey_id = 10
WHERE EMPLOYEE.E_working_hours > 30 AND EMPLOYEE.E_componey_id = 20;

SELECT * FROM EMPLOYEE;
DELETE FROM EMPLOYEE;


-- add salary 10 to all the managers that work in the storages that have capacity > 1000
UPDATE MANAGER
SET M_salary = MANAGER.M_salary + 10
WHERE MANAGER.M_storage_num in (SELECT STORAGE.S_number FROM STORAGE
								WHERE STORAGE.S_capacity > 1000)
SELECT * FROM MANAGER;

--change the position of a product to another
UPDATE PRODUCT
SET P_column = 10 , P_row = 3 , P_storage_number = 444 , P_block = 12
WHERE PRODUCT.P_row = 2 AND PRODUCT.P_column = 4 AND PRODUCT.P_block = 20 AND PRODUCT.P_storage_number = 111;

SELECT * FROM PRODUCT;

--delete all the products that eexpire date is past
DELETE 
FROM PRODUCT 
WHERE P_expireDate < GETDATE();

--delete storages for a company named c0
DELETE 
FROM STORAGE
WHERE S_componey_id = (SELECT COMPANY.C_ID
						FROM COMPANY
						WHERE COMPANY.C_name = 'c0');

SELECT * FROM STORAGE;

-- function show all factories working with a company 
ALTER FUNCTION factories_work_with_company(@name NVARCHAR(50))
RETURNS TABLE 
AS 
	RETURN (SELECT distinct F.F_name factory_name , F.F_code
			FROM COMPANY C , FACTORY F , PRODUCT P , STORAGE S
			WHERE @name = C.C_name AND S.S_componey_id = C.C_ID 
					AND P.P_storage_number = S.S_number AND F.F_code = P.P_factory_ID);

SELECT * FROM dbo.factories_work_with_company('c0') ;

-- function show number of managers working with a factory
CREATE FUNCTION MANAGER_FACTORY(@ID INT)
RETURNS INT 
AS 
BEGIN
	DECLARE @Cnt INT 
	SET @Cnt = (SELECT COUNT(M.M_code)
				FROM MANAGER M ,STORAGE S , PRODUCT P
				WHERE P.P_factory_ID = @ID AND S.S_number = P.P_storage_number
					AND S.S_number = M.M_storage_num);
	RETURN @Cnt;
END


SELECT dbo.MANAGER_FACTORY(2232);

--procedure for deleting a product using its id
create procedure DeleteProduct(@id int)
as
begin
	delete from PRODUCT where PRODUCT.P_ID=@id;
end	


--procedure for setting exit date of product
create procedure SetExitDate(@id int)
as
begin
	update PRODUCT set P_exitDate=GETDATE() where P_ID=@id;
end	


-- create view for product information of storage
CREATE VIEW PRODUCT_info
AS
Select *
From PRODUCT 
INNER JOIN STORAGE on PRODUCT.P_storage_number = STORAGE.S_number
INNER JOIN FACTORY on PRODUCT.P_factory_ID = FACTORY.F_code ;

 Select * 
 From PRODUCT_info ;


-- create view for employee information
CREATE VIEW EMPLOYEE_info
AS
Select *
From EMPLOYEE INNER JOIN COMPANY on  EMPLOYEE.E_componey_id = COMPANY.C_ID ;

Select * 
From EMPLOYEE_info ;


--add constrains
alter table PRODUCT
add constraint place_unique unique(P_block, P_row, P_column)

alter table EMPLOYEE
add constraint check_working_hours check(E_working_hours>10)

alter table PRODUCT
add constraint check_expireDate check(DateDiff(DAY , P_expireDate,GETDATE())> 0)

--delete constraint
alter table PRODUCT
drop constraint check_expireDate;

-- trigger for update product table
CREATE TABLE PRODUCT_update_table(
	change_id INT IDENTITY ,
	P_ID INT NOT NULL  ,
	P_name NVARCHAR(70) NOT NULL,
	P_expireDate DATE NOT NULL,
	P_produceDate DATE NOT NULL,
	P_type NVARCHAR(50) NOT NULL,
	P_enterDate DATE NOT NULL,
	P_exitDate DATE,
	P_block INT NOT NULL, 
	P_row INT NOT NULL,
	P_column INT NOT NULL,
	P_factory_ID INT NOT NULL,
	P_storage_number INT NOT NULL,
	date_update DATETIME NOT NULL,
	update_operation CHAR(6) NOT NULL,
	CHECK (update_operation = 'INSERT' or update_operation = 'DELETE')
);

DELETE FROM PRODUCT_update_table;
DELETE FROM PRODUCT;

CREATE TRIGGER TRG_PRODUCT_update_table
on PRODUCT
After INSERT, DELETE
as
Begin 
	Set NOCOUNT on;
	INSERT Into PRODUCT_update_table(
		change_id,
		P_ID,
		P_name,
		P_expireDate,
		P_produceDate,
		P_type,
		P_enterDate,
		P_exitDate,
		P_block, 
		P_row,
		P_column,
		P_factory_ID,
		P_storage_number,
		date_update,
		update_operation
	)
	SELECT  i.P_ID,
			P_ID,
			P_name,
			P_expireDate,
			P_produceDate,
			P_type,
			P_enterDate,
			P_exitDate,
			P_block, 
			P_row,
			P_column,
			P_factory_ID,
			P_storage_number,
			GETDATE(),
			'INSERT'
	From inserted i
	UNION ALL
	SELECT  d.P_ID,
			P_ID,
			P_name,
			P_expireDate,
			P_produceDate,
			P_type,
			P_enterDate,
			P_exitDate,
			P_block, 
			P_row,
			P_column,
			P_factory_ID,
			P_storage_number,
			GETDATE(),
			'DELETE'
	From deleted d;
End

SET IDENTITY_INSERT PRODUCT_update_table ON;
DROP TRIGGER TRG_PRODUCT_update_table;
insert into PRODUCT values (8278392 , 'bani' , '6/11/2023' , '6/10/2022'  , 'labaniat' , '6/11/2023' , null , 20 , 2 , 4 , 2232 ,111);

Select *
From PRODUCT_update_table ;

