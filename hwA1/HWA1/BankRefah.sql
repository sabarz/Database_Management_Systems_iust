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
WHERE SenfName LIKE N'%�%';

/*Q4*/
SELECT final.Daramad_Total_Rials , final.Id
FROM final
WHERE final.ProvinceName=N'�����' AND DATEDIFF(YEAR,BirthDate,GETDATE())=50;

/*Q5*/
SELECT final.Id
FROM final
WHERE Gender=N'���' AND CAST(Bardasht97 AS real)>30000000;
