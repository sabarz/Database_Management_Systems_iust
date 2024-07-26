--SABA RAZI 99521316
use BankRefah
/*select * from dbo.final*/

/*Q1*/
SELECT *
FROM dbo.final 
WHERE Cars_Count < (SELECT AVG(CAST(Cars_Count AS real)) FROM dbo.final);

/*Q2*/
SELECT final.Id , final.Gender
FROM final
WHERE CAST(Sood95 AS real)<CAST(Sood96 AS real) AND CAST(Sood96 AS real)<CAST(Sood97 AS real);

/*Q3*/
SELECT final.SenfName
FROM final
WHERE SenfName LIKE N'%ä%';

/*Q4*/
SELECT final.Daramad_Total_Rials , final.Id
FROM final
WHERE final.ProvinceName=N'ÊåÑÇä' AND DATEDIFF(YEAR,BirthDate,GETDATE())=50;

/*Q5*/
SELECT final.Id
FROM final
WHERE Gender=N'ãÑÏ' AND CAST(Bardasht97 AS real)>30000000;
