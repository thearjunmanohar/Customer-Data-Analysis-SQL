-- Command to use database.
use project_db;

-- Viewing tables in the database.
show tables;

-- Viewing the table.
select * from customer_data1; 

-- Removing the unknown column.
alter table customer_data1 drop column  `MyUnknownColumn`;

-- >> SQL ANALYSIS.

-- 1. Retrieve all customer records.
select * from customer_data1;

-- 2. Count total number of customers.
select count(*) as `Total row count` from customer_data1;

-- 3. List unique payment methods.
select payment_method from customer_data1 group by payment_method;
-- OR
select distinct payment_method from customer_data1;

-- 4. Find customers older than 50.
select * from customer_data1 where age > 50;

-- 5. Count number of male and female customers.
select gender,count(gender) as `No of customers` from customer_data1 group by gender;

-- 6. Find average age of customers.
select avg(age) as `Average age` from customer_data1;

-- 7. Count customers per payment method.
select payment_method,count(*) as `Number of customers` from customer_data1 group by payment_method;

-- 8. Find the most used payment method.
select payment_method,count(*) as `total` from customer_data1 group by payment_method order by total desc limit 1;

-- 9. Find average age by gender.
select gender,avg(age) as `Average age` from customer_data1 group by gender;

-- 10. Find customers between age 20 and 30.
select * from customer_data1 where age between 20 and 30;	

-- 11. Find top 3 most common age groups.
select age,count(*) as `freq` from customer_data1 group by age order by `freq` desc limit 3;

-- 12. Find gender distribution within each payment method.
select payment_method,gender,count(gender) as `Number of customers` from customer_data1 group by payment_method,gender;

-- 13. Find customers whose age is above average.
select * from customer_data1 where age > ( select avg(age) from customer_data1 );

-- 14. Rank customers by age (Using Window Function).
select customer_id,age,rank() over (order by age desc) as age_rank from customer_data1;

-- 15. Find percentage usage of each payment method.
select payment_method,
round((count(*)/(select count(*) from customer_data1))*100.0,2) as `Payment percentage` from customer_data1 group by payment_method;

-- 16 Find total customers in each age group.
select 
case 
	when age < 20 then 'Teen'
    when age between 20 and 40 then 'Adult'
    when age between 40 and 60 then 'Middle Age'
    Else 'Senior'
end
as age_group,count(*) as `No of customers` from customer_data1 group by age_group;

-- 17. Top payment method per Age group ( CTE + Win Func ).
with age_grp_tb as 
(select 
	case 
		when age < 20 then 'Teen' 
        when age between 20 and 40 then 'Adult'
        when age between 40 and 60 then 'Middle Age'
        Else 'Senior'
	end
as age_group,payment_method from customer_data1)
select * from (select age_group,payment_method,
rank() over(partition by age_group order by count(*) desc) as rnk from age_grp_tb group by age_group,payment_method) temp
where rnk=1;
 

-- 18. Top Payment Method per Gender. ( Using Ranking ) 
select * from 
(select gender,payment_method,
rank() over(partition by gender order by count(*) desc) as rnk
from customer_data1 group by gender,payment_method) temp 
where rnk=1;






