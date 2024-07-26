--show position of product in storage and the storage id and type
SELECT P.P_column column_IN_storage, P.P_row row_IN_storage, S.S_number Storage_id, S.S_type Storage_type
FROM STORAGE S , PRODUCT P
WHERE P.P_ID = 736726 AND P.P_storage_number = S.S_number;

--enter and exit info of a product
SELECT P.P_enterDate , P.P_exitDate
FROM PRODUCT P 
WHERE P.P_ID = 736726;


--number of products
select COUNT(*) as count_product , PRODUCT.P_type product_type
from PRODUCT
group by PRODUCT.P_type;

--show reports

select M_report
from MANAGER
where M_storage_num=@s_id

--show working hours of each manager in each storage
select M_name,M_working_hours,M_storage_num
from MANAGER
group by M_storage_num,M_name,M_working_hours;

--show types of products in storage

select distinct S_type 
from STORAGE
where S_number=@s_id

--show free capacity of storage 
declare @s_id as int ;
set @s_id = 111;
select S_capacity-(select count(*)
				   from PRODUCT
                   where P_exitDate is null AND P_storage_number=@s_id)
from STORAGE
where S_number=@s_id

-- enter and exit date 
Select P_name , P_enterDate , P_exitDate
From PRODUCT 
order by P_name, PRODUCT.P_enterDate , PRODUCT.P_exitDate;

-- type of product ordered by id
Select P_name , P_type
From PRODUCT as P 
Where P.P_storage_number = 111  
order by P_ID;

-- not yet out
Select *
From PRODUCT
Where P_exitDate is not null;

-- type of product in any storage
Select *
From PRODUCT as P
Where P.P_storage_number = 666
GROUP BY P_type ;
