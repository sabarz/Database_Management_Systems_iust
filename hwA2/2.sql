CREATE DATABASE SCHOOLFynal;
USE SCHOOLFynal;

----------------------------------------------------------------------------------------------------------
CREATE TABLE CLASS (
	C_Id			INT PRIMARY KEY,
	C_name			VARCHAR(50)				NOT NULL,
	C_comment		VARCHAR(500) ,
	condition		VARCHAR(3)				NOT NULL	CHECK(condition IN ('N', 'NA', 'AC')),
	C_StartDate		DATE					NOT NULL,
	C_FinishDate	DATE					NOT NULL,
	CHECK(DATEDIFF(DAY ,C_StartDate , C_FinishDate) > 0) ,
	grade			INT						NOT NULL	CHECK(grade IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 , 12)) , 
	teacherName		VARCHAR(50)				NOT NULL,
	C_subject		CHAR(1)					NOT NULL	CHECK(C_subject IN('M','P','C','B','F','E','A','R'))
);

----------------------------------------------------------------------------------------------------------
CREATE TABLE STUDENT(
	S_Id			INT PRIMARY KEY, 
	S_UserName		VARCHAR(50)			NOT NULL ,
	S_PASS			VARCHAR(30)			NOT NULL ,
	S_Fname			VARCHAR(50)			NOT NULL,
	S_Lname			VARCHAR(50)			NOT NULL,
	S_Email			VARCHAR(60) , 
	S_BirthDate		DATE				NOT NULL	CHECK(DATEDIFF(YEAR ,S_BirthDate , GETDATE()) > 5),
	S_NationalID	VARCHAR(10)			NOT NULL	CHECK(ISNUMERIC(S_NationalID) = 1 and LEN(S_NationalID) = 10),
	S_address		VARCHAR(MAX)		NOT NULL,
	S_PHONE			VARCHAR(8)			NOT NULL	CHECK(LEN(S_PHONE)= 8 AND ISNUMERIC(S_PHONE) = 1 AND S_PHONE LIKE '0%'),
	S_class			INT					NOT NULL	FOREIGN KEY REFERENCES CLASS(C_Id) ON DELETE CASCADE
);

----------------------------------------------------------------------------------------------------------
CREATE TABLE SCHDULE(
	SCH_Id				INT PRIMARY KEY,
	SCHE_class			INT				NOT NULL FOREIGN KEY REFERENCES CLASS(C_Id) ON DELETE CASCADE ,
	SCHE_StartTime		TIME			NOT NULL,
	SCHE_EndTime		TIME			NOT NULL,
	CHECK(DATEDIFF(MINUTE, SCHE_StartTime, SCHE_EndTime) > 0),
	SCHE_DayTime		INT				NOT NULL CHECK(SCHE_DayTime IN(1, 2, 3, 4, 5, 6, 7))
);

-----------------------------------------------------------------------------------------------------------
CREATE TABLE HOMEWORK(
	HW_Id				INT PRIMARY KEY,
	HW_Title			VARCHAR(50)			NOT NULL,
	HW_comment			VARCHAR(500),
	HW_class			INT					NOT NULL	FOREIGN KEY REFERENCES CLASS(C_Id) ON DELETE CASCADE,
	HM_File				VARCHAR(MAX)		NOT NULL,
	HW_CreateDate		DATE				NOT NULL,
	HW_DeliverDate		DATE				NOT NULL ,
	CHECK(DATEDIFF(DAY , HW_CreateDate , HW_DeliverDate) >= 0),
);

-----------------------------------------------------------------------------------------------------------
CREATE TABLE HOMEWORK_ANS(
	HWA_ID				INT PRIMARY KEY,
	HWA_comment			VARCHAR(500),
	HMA_File			VARCHAR(MAX)		NOT NULL,
	HWA_HomeWork		INT					NOT NULL FOREIGN KEY REFERENCES HOMEWORK(HW_Id) ON DELETE CASCADE ON UPDATE CASCADE,
	HWA_student			INT					NOT NULL FOREIGN KEY REFERENCES STUDENT(S_Id) ON DELETE no action,
	UNIQUE(HWA_HomeWork , HWA_student),
	HWA_subject			CHAR(1)				NOT NULL CHECK(HWA_subject IN('M','P','C','B','F','E','A','R')),
	HWA_CreateDate		DATE				NOT NULL,
	HWA_DeliverDate		DATE				NOT NULL ,
	CHECK(DATEDIFF(DAY , HWA_CreateDate , HWA_DeliverDate) >= 0),
);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE SCORE(
	SCORE_HomeWork		INT					NOT NULL FOREIGN KEY REFERENCES HOMEWORK(HW_Id) ON DELETE CASCADE,
	SCORE_HomeWorkANS	INT					NOT NULL FOREIGN KEY REFERENCES HOMEWORK_ANS(HWA_ID) ON UPDATE CASCADE,
	UNIQUE(SCORE_HomeWorkANS , SCORE_HomeWork),
	number				INT					CHECK(number BETWEEN 0 AND 20)
);

----------Q1 P1------------------------------------------------------------------------------------------------
CREATE FUNCTION NumberOfClass()
RETURNS INT 
AS 
BEGIN
	DECLARE @Cnt INT 
	SET @Cnt = (SELECT COUNT(C_Id) from CLASS) ;
	return @Cnt
end
SELECT dbo.NumberOfClass() NOC;

----------Q1 P2------------------------------------------------------------------------------------------------
CREATE FUNCTION NumberOfClassGrade()
RETURNS TABLE 
AS  
	RETURN (SELECT COUNT(C_Id) NUMBER , C_Id CLASS_ID
			FROM CLASS	
			GROUP BY C_Id ) ;

SELECT * FROM dbo.NumberOfClassGrade();

----------Q1 P3------------------------------------------------------------------------------------------------
CREATE FUNCTION NumberOfStudent()
RETURNS INT 
AS 
BEGIN
	DECLARE @Cnt INT 
	SET @Cnt = (SELECT COUNT(S_Id) from STUDENT) ;
	RETURN @Cnt
end

SELECT dbo.NumberOfStudent() NOS;
----------Q2 ------------------------------------------------------------------------------------------------
CREATE FUNCTION ScoreReports(@ID INT)
RETURNS TABLE
AS
RETURN
	SELECT MIN(S.number) MinScore, MAX(S.number) MaxScore, AVG(S.number) AvrageScore ,PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY S.number) OVER() Median, VAR(S.number) Variance
	FROM SCORE S JOIN HOMEWORK H ON S.SCORE_HomeWork = H.HW_Id  
	WHERE H.HW_class = @ID 
	GROUP BY H.HW_Id , S.number;

SELECT * FROM dbo.ScoreReports(2);

----------Q3 ------------------------------------------------------------------------------------------------
CREATE FUNCTION ScoreHW(@ID INT)
RETURNS TABLE
AS
RETURN 
	SELECT S.number
	FROM SCORE S
	WHERE S.SCORE_HomeWork = @ID;

SELECT * FROM dbo.ScoreHW(1);

----------Q4 ------------------------------------------------------------------------------------------------
CREATE FUNCTION Student_Schedule(@ID INT)
RETURNS TABLE
AS
RETURN 
	SELECT SCHE.SCHE_class Class_ID , SCHE.SCHE_DayTime Day_class , SCHE.SCHE_StartTime Begin_Time , SCHE.SCHE_EndTime End_Time
	FROM SCHDULE SCHE , STUDENT S
	WHERE S.S_Id = @ID AND SCHE.SCHE_class = S.S_class
	GROUP BY SCHE.SCHE_DayTime , SCHE.SCHE_StartTime ,SCHE.SCHE_class, SCHE.SCHE_EndTime ;

SELECT * FROM dbo.Student_Schedule(4);

-----------------------------------------------------------------------------------------------------
ALTER TRIGGER Protect_Delete
ON HOMEWORK_ANS
FOR DELETE 
AS 
BEGIN
	IF EXISTS (SELECT S.SCORE_HomeWorkANS
				  FROM SCORE S 
				  WHERE S.SCORE_HomeWorkANS IN(SELECT S.SCORE_HomeWorkANS FROM deleted))
	BEGIN
		RAISERROR('Not Allowed to delete Home work answer', 16, 1);
        ROLLBACK TRANSACTION;
        Return;
	END

	DELETE FROM HOMEWORK_ANS WHERE HWA_ID IN(SELECT HWA_ID from deleted) ;
END


DELETE FROM HOMEWORK_ANS ;
-----------------------------------------------------------------------------------------------------

insert into CLASS(C_ID, C_name, C_comment, condition, C_subject, C_StartDate, C_FinishDate, grade, teacherName) values (1, 'Shayla Beran', null, 'AC', 'P', '10/17/2019', '7/7/2021', 2, 'Malia Maydwell');
insert into CLASS(C_ID, C_name, C_comment, condition, C_subject, C_StartDate, C_FinishDate, grade, teacherName) values (2, 'Faythe Wealleans', null, 'NA', 'C', '10/10/2019', '6/27/2021', 7, 'Errol Ondra');
insert into CLASS(C_ID, C_name, C_comment, condition, C_subject, C_StartDate, C_FinishDate, grade, teacherName) values (3, 'Douglas Dawtre', null, 'AC', 'C', '1/18/2020', '1/14/2022', 8, 'Rois Threader');
insert into CLASS(C_ID, C_name, C_comment, condition, C_subject, C_StartDate, C_FinishDate, grade, teacherName) values (4, 'Natka McQuilty', null, 'AC', 'C', '2/6/2020', '9/19/2021', 7, 'Robbie Warbys');
insert into CLASS(C_ID, C_name, C_comment, condition, C_subject, C_StartDate, C_FinishDate, grade, teacherName) values (5, 'Andrej Mowbray', null, 'N', 'B', '12/22/2019', '9/8/2021', 2, 'Cly Fairleigh');
insert into CLASS(C_ID, C_name, C_comment, condition, C_subject, C_StartDate, C_FinishDate, grade, teacherName) values (6, 'Pip Bavage', null, 'N', 'A', '12/1/2019', '12/23/2021', 11, 'Kath Pidcock');
insert into CLASS(C_ID, C_name, C_comment, condition, C_subject, C_StartDate, C_FinishDate, grade, teacherName) values (7, 'Witty Norton', null, 'AC', 'R', '2/18/2020', '9/17/2021', 9, 'Jennette Ades');
insert into CLASS(C_ID, C_name, C_comment, condition, C_subject, C_StartDate, C_FinishDate, grade, teacherName) values (8, 'Mill Hugland', null, 'NA', 'P', '11/20/2019', '2/6/2022', 7, 'Viole Bonanno');
insert into CLASS(C_ID, C_name, C_comment, condition, C_subject, C_StartDate, C_FinishDate, grade, teacherName) values (9, 'Kissiah Cutress', null, 'NA', 'C', '3/3/2020', '11/18/2021', 3, 'Merry Chapelhow');
insert into CLASS(C_ID, C_name, C_comment, condition, C_subject, C_StartDate, C_FinishDate, grade, teacherName) values (10, 'Catlee Gault', null, 'NA', 'A', '8/22/2019', '5/24/2022', 8, 'Alexis Halt');
DELETE FROM CLASS;


insert into STUDENT(S_Id, S_UserName, S_PASS, S_Fname, S_Lname, S_Email, S_class, S_BirthDate, S_NationalID, S_Address, S_PHONE) values (1, 'ldiclaudio0', 'cehgba', 'Leonie', 'Di Claudio', 'ldiclaudio0@wordpress.org', 1, '6/4/2000', '1000637289', '0 Dayton Plaza', '05480852');
insert into STUDENT(S_Id, S_UserName, S_PASS, S_Fname, S_Lname, S_Email, S_class, S_BirthDate, S_NationalID, S_Address, S_PHONE) values (2, 'yeaken1', '6LRXJDvfQXp', 'Yardley', 'Eaken', 'yeaken1@biblegateway.com', 1, '6/24/2001', '9999999999', '454 Buell Place', '04923279');
insert into STUDENT(S_Id, S_UserName, S_PASS, S_Fname, S_Lname, S_Email, S_class, S_BirthDate, S_NationalID, S_Address, S_PHONE) values (3, 'kburfoot2', 'OvpNQp', 'Kent', 'Burfoot', 'kburfoot2@istockphoto.com', 1, '7/22/2005', '7326387135', '4039 John Wall Center', '06404061');
insert into STUDENT(S_Id, S_UserName, S_PASS, S_Fname, S_Lname, S_Email, S_class, S_BirthDate, S_NationalID, S_Address, S_PHONE) values (4, 'aebbotts3', 'ZPZ5OJQ4o8O', 'Ax', 'Ebbotts', 'aebbotts3@tinypic.com', 2, '4/14/2010', '3749163849', '28 Grover Drive', '03503990');
insert into STUDENT(S_Id, S_UserName, S_PASS, S_Fname, S_Lname, S_Email, S_class, S_BirthDate, S_NationalID, S_Address, S_PHONE) values (5, 'gtatlowe4', 'u50RYTBOl8rU', 'Garfield', 'Tatlowe', 'gtatlowe4@github.io', 3, '8/1/2011', '5172536849', '254 Springs Plaza', '078682246');
insert into STUDENT(S_Id, S_UserName, S_PASS, S_Fname, S_Lname, S_Email, S_class, S_BirthDate, S_NationalID, S_Address, S_PHONE) values (6, 'sziemke5', '0ewQIER', 'Saloma', 'Ziemke', 'sziemke5@w3.org', 2, '5/22/2012', '2738109222', '32 Hooker Lane', '09482315');
insert into STUDENT(S_Id, S_UserName, S_PASS, S_Fname, S_Lname, S_Email, S_class, S_BirthDate, S_NationalID, S_Address, S_PHONE) values (7, 'fpowner6', 'SaXSSLSn', 'Francisca', 'Powner', 'fpowner6@blog.com', 2, '3/21/2012','1111111111', '633 Hovde Terrace', '06046562');
insert into STUDENT(S_Id, S_UserName, S_PASS, S_Fname, S_Lname, S_Email, S_class, S_BirthDate, S_NationalID, S_Address, S_PHONE) values (8, 'cpaddell7', '2PIbUMh', 'Catrina', 'Paddell', 'cpaddell7@cisco.com', 3, '11/4/2003', '2222222222', '2 Brentwood Place', '04311879');
insert into STUDENT(S_Id, S_UserName, S_PASS, S_Fname, S_Lname, S_Email, S_class, S_BirthDate, S_NationalID, S_Address, S_PHONE) values (9, 'tsimonyi8', 'GMUyr4', 'Tandie', 'Simonyi', 'tsimonyi8@bloglines.com', 3, '11/17/2004', '33333333333', '693 Dorton Place', '06884220');
insert into STUDENT(S_Id, S_UserName, S_PASS, S_Fname, S_Lname, S_Email, S_class, S_BirthDate, S_NationalID, S_Address, S_PHONE) values (10, 'atant9', 'gArVZBE1AR', 'Anita', 'Tant', 'atant9@nyu.edu', 1, '4/8/2002', '2223221111', '357 Union Lane', '09925640');
DELETE FROM STUDENT;
select * from STUDENT;

insert into SCHDULE  (SCH_Id ,SCHE_class, SCHE_DayTime, SCHE_StartTime, SCHE_EndTime) values (1,1, 1, '10:55:38', '18:35:24');
insert into SCHDULE  (SCH_Id ,SCHE_class, SCHE_DayTime, SCHE_StartTime, SCHE_EndTime) values (2 ,2, 4, '8:59:57', '15:39:29');
insert into SCHDULE  (SCH_Id ,SCHE_class, SCHE_DayTime, SCHE_StartTime, SCHE_EndTime) values (3 ,2, 2, '5:11:47', '17:08:04');
insert into SCHDULE  (SCH_Id ,SCHE_class, SCHE_DayTime, SCHE_StartTime, SCHE_EndTime) values (4,2, 2, '9:34:03', '17:43:48');
insert into SCHDULE  (SCH_Id ,SCHE_class, SCHE_DayTime, SCHE_StartTime, SCHE_EndTime) values (5,3, 1, '4:45:28', '16:58:09');
insert into SCHDULE  (SCH_Id ,SCHE_class, SCHE_DayTime, SCHE_StartTime, SCHE_EndTime) values (6,10, 1, '9:04:52', '23:11:53');
insert into SCHDULE  (SCH_Id ,SCHE_class, SCHE_DayTime, SCHE_StartTime, SCHE_EndTime) values (7,2, 2, '8:25:34', '12:03:45');
insert into SCHDULE  (SCH_Id ,SCHE_class, SCHE_DayTime, SCHE_StartTime, SCHE_EndTime) values (8,1, 1, '6:18:12', '16:52:10');
insert into SCHDULE  (SCH_Id ,SCHE_class, SCHE_DayTime, SCHE_StartTime, SCHE_EndTime) values (9,3, 5, '8:59:02', '19:03:32');
DELETE FROM SCHDULE;

insert into HOMEWORK(HW_Id, HW_Title, HW_comment, HM_File, HW_class, HW_CreateDate, HW_DeliverDate) values (1, 'Meagan', null, 'EratFermentumJusto.avi', 1, '6/11/2019', '3/24/2022');
insert into HOMEWORK(HW_Id, HW_Title, HW_comment, HM_File, HW_class, HW_CreateDate, HW_DeliverDate) values (2, 'Halimeda', null, 'Eros.mp3', 2, '1/28/2020', '3/7/2022');
insert into HOMEWORK(HW_Id, HW_Title, HW_comment, HM_File, HW_class, HW_CreateDate, HW_DeliverDate) values (3, 'Gerta', null, 'Morbi.xls', 4, '1/14/2020', '12/3/2021');
insert into HOMEWORK(HW_Id, HW_Title, HW_comment, HM_File, HW_class, HW_CreateDate, HW_DeliverDate) values (4, 'Miriam', null, 'DuiVelSem.tiff', 1, '6/27/2019', '6/7/2021');
insert into HOMEWORK(HW_Id, HW_Title, HW_comment, HM_File, HW_class, HW_CreateDate, HW_DeliverDate) values (5, 'Hugues', null, 'Eu.ppt', 2, '9/26/2019', '9/12/2021');
insert into HOMEWORK(HW_Id, HW_Title, HW_comment, HM_File, HW_class, HW_CreateDate, HW_DeliverDate) values (6, 'Aurora', null, 'Duis.tiff', 1, '10/5/2019', '1/2/2022');
insert into HOMEWORK(HW_Id, HW_Title, HW_comment, HM_File, HW_class, HW_CreateDate, HW_DeliverDate) values (7, 'Hendrika', null, 'Duis.tiff',2 , '3/23/2020', '11/28/2021');
insert into HOMEWORK(HW_Id, HW_Title, HW_comment, HM_File, HW_class, HW_CreateDate, HW_DeliverDate) values (8, 'Kassey', null, 'Quam.mp3', 3, '6/4/2020', '8/31/2021');
insert into HOMEWORK(HW_Id, HW_Title, HW_comment, HM_File, HW_class, HW_CreateDate, HW_DeliverDate) values (9, 'Rodney', null, 'InPurusEu.jpeg', 5, '6/28/2019', '2/13/2022');
insert into HOMEWORK(HW_Id, HW_Title, HW_comment, HM_File, HW_class, HW_CreateDate, HW_DeliverDate) values (10, 'Calida', null, 'LacusPurus.mp3', 2, '10/31/2019', '7/1/2021');
DELETE FROM HOMEWORK;
--1 4 6
--1 2 6 7
insert into HOMEWORK_ANS(HWA_ID, HWA_comment, HMA_File, HWA_HomeWork, HWA_student, HWA_subject, HWA_CreateDate , HWA_DeliverDate) values (1, null, 'TristiqueEst.jpeg', 1, 4, 'P', '5/26/2022','5/2/2023');
insert into HOMEWORK_ANS(HWA_ID, HWA_comment, HMA_File, HWA_HomeWork, HWA_student, HWA_subject, HWA_CreateDate , HWA_DeliverDate) values (2, null, 'PellentesqueVolutpat.xls', 1, 2, 'R', '8/3/2021' , '5/26/2022');
insert into HOMEWORK_ANS(HWA_ID, HWA_comment, HMA_File, HWA_HomeWork, HWA_student, HWA_subject, HWA_CreateDate , HWA_DeliverDate) values (3, null, 'Etiam.gif', 2, 2, 'B', '9/8/2021','5/26/2022');
insert into HOMEWORK_ANS(HWA_ID, HWA_comment, HMA_File, HWA_HomeWork, HWA_student, HWA_subject, HWA_CreateDate , HWA_DeliverDate) values (4, null, 'InterdumInAnte.xls', 4, 2, 'E', '1/30/2022','5/26/2022');
insert into HOMEWORK_ANS(HWA_ID, HWA_comment, HMA_File, HWA_HomeWork, HWA_student, HWA_subject, HWA_CreateDate , HWA_DeliverDate) values (5, null, 'NuncDonecQuis.avi',2, 1, 'M', '9/7/2021','5/26/2022');
insert into HOMEWORK_ANS(HWA_ID, HWA_comment, HMA_File, HWA_HomeWork, HWA_student, HWA_subject, HWA_CreateDate , HWA_DeliverDate) values (6, null, 'SitAmetCursus.mpeg', 1, 1, 'P', '3/21/2022','5/26/2022');
insert into HOMEWORK_ANS(HWA_ID, HWA_comment, HMA_File, HWA_HomeWork, HWA_student, HWA_subject, HWA_CreateDate , HWA_DeliverDate) values (7, null, 'FuscePosuereFelis.doc',1, 1, 'P', '10/13/2021','5/26/2022');
insert into HOMEWORK_ANS(HWA_ID, HWA_comment, HMA_File, HWA_HomeWork, HWA_student, HWA_subject, HWA_CreateDate , HWA_DeliverDate) values (8, null, 'ConsequatMetusSapien.xls',5, 2, 'M', '6/10/2021','5/26/2022');
insert into HOMEWORK_ANS(HWA_ID, HWA_comment, HMA_File, HWA_HomeWork, HWA_student, HWA_subject, HWA_CreateDate , HWA_DeliverDate) values (9, null, 'NisiVolutpat.png',7, 2, 'F', '12/12/2021','5/26/2022');
insert into HOMEWORK_ANS(HWA_ID, HWA_comment, HMA_File, HWA_HomeWork, HWA_student, HWA_subject, HWA_CreateDate , HWA_DeliverDate) values (10, null, 'UltriciesEuNibh.ppt', 5, 2, 'R', '4/7/2022','5/26/2022');

insert into SCORE(SCORE_HomeWork, SCORE_HomeWorkANS, number) values (1, 1, 20);
insert into SCORE(SCORE_HomeWork, SCORE_HomeWorkANS, number) values (2, 1, 12);
insert into SCORE(SCORE_HomeWork, SCORE_HomeWorkANS, number) values (2, 3, 16);
insert into SCORE(SCORE_HomeWork, SCORE_HomeWorkANS, number) values (2, 2, 2);
insert into SCORE(SCORE_HomeWork, SCORE_HomeWorkANS, number) values (4, 1, 17);
insert into SCORE(SCORE_HomeWork, SCORE_HomeWorkANS, number) values (1, 3, 19);
insert into SCORE(SCORE_HomeWork, SCORE_HomeWorkANS, number) values (1, 2, 17);
insert into SCORE(SCORE_HomeWork, SCORE_HomeWorkANS, number) values (1, 3, 16);
insert into SCORE(SCORE_HomeWork, SCORE_HomeWorkANS, number) values (2, 2, 15);
insert into SCORE(SCORE_HomeWork, SCORE_HomeWorkANS, number) values (4, 2, 18);
insert into SCORE(SCORE_HomeWork, SCORE_HomeWorkANS, number) values (3, 1, 5);
insert into SCORE(SCORE_HomeWork, SCORE_HomeWorkANS, number) values (3, 1, 7);
select * from SCORE;
--2 5 7 10
--12 16 2 