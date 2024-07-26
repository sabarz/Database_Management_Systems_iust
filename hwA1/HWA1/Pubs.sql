--SABA RAZI 99521316
use pubs;
SELECT * FROM titles;
SELECT * FROM sales;
SELECT * FROM titleauthor;
SELECT * FROM employee;
SELECT * FROM authors;

/*Q1*/
SELECT t.title , t.type
FROM titles AS t
WHERE t.price >= 17 AND t.price <= 21 AND t.type!='mod_cook';

/*Q2*/
SELECT A.au_id , A.phone , Full_Name=CONCAT(au_lname,' ',au_fname) 
FROM authors AS A
WHERE A.city='Oakland';

/*Q3*/
SELECT * , Experience=DATEDIFF(YEAR,hire_date,GETDATE())
FROM employee E
WHERE DATEDIFF(YEAR,hire_date,GETDATE())=(SELECT 
											MAX(DATEDIFF(YEAR,hire_date,GETDATE()))
											FROM employee);
/*Q4*/
SELECT *
FROM titles AS t
WHERE DATEDIFF(YEAR,pubdate,GETDATE())>30;

/*Q5*/
SELECT A.au_fname , A.address , count= COUNT(S.title_id)
FROM authors AS A , titleauthor AS T , sales AS S 
WHERE S.title_id=T.title_id AND A.au_id=T.au_id
GROUP BY A.au_id , A.au_fname , A.address;

				