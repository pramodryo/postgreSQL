-- Window function in SQL

-- window function applies aggregate and ranking function over a perticular window (set or row) OVER clause is used with windw function to define that window



set search_path to public;

create table salary (
	name varchar(50) not null,
	age int,
	gender varchar,
	department varchar,
	salary int not null
)

insert into salary values('santosh pawar',24,'male','HR',24000),
('avikant sharma',22,'male','sales',25000),
('abhishek kumar',25,'male','HR',30000),
('pramshingh wadra',30,'male','HR',40000),
('santosh tyagi',27,'male','production',30000),
('sachin tyagi',24,'male','production',29000),
('pooja pawar',26,'female','HR',24000),
('payal kumari',24,'female','sales',28000),
('jitendra sharma',30,'male','sales',35000),
('baburao chavan',30,'male','production',32000),
('pramod rathod',24,'male','sales',28000),
('neha jaya',29,'female','production',30000),
('satish kumar',23,'male','production',34000);


select * from salary;

-- ROW NUMBER according to highest salary
select *, Row_Number() over(order by salary desc) as salary_ranking from salary;

-- ROW NUMBER according to highest salary for each department
select *, row_number() over(partition by department order by salary desc) as departmental_salary from salary;

-- RANK FUNCTION According to highest salary 
select *, RANK() over(order by salary desc) as high_salary_rank from salary;

-- RANK FUNCTION According to highest salary for each department 
select *, RANK() over(partition by department order by salary desc) as high_salary from salary;


-- DENSE_RANK FUNCTION According to highest salary 
select *, dense_RANK() over(order by salary desc) as high_salary from salary;

-- DENSE_RANK FUNCTION According to highest salary for each department 
select *, dense_RANK() over(partition by department order by salary desc) as high_salary from salary;



-- Differance between RANK and DENSE_RANK Function
select *, RANK() over(order by salary desc) as rank_high_salary, dense_RANK() over(order by salary desc) as dense_rank_high_salary  from salary;

-- Explanation: 
-- rank: rank function skip the number if privious number is repeated. like: 1,1,3,4,4,6 (2 & 5 are skiped)
-- dense_rank: This function will not skip values it will repeated or not privious number. like 1,1,2,3,4,4,5,6 (not skiped any number)

-- Percentile Rank Function
select *, percent_RANK() over(order by salary desc) as high_salary from salary;


-- NTILE FUNCTION
select *, ntile(salary) over(partition by department order by salary desc) as high_salary from salary;


-- First_Value: For highest Salary for each department (desc)
select *,  first_value(salary) over(partition by department order by salary desc) as highest_salary from salary;

-- First Value:  For Lowest salary for each depatment (asc)
select *,  first_value(salary) over(partition by department order by salary asc ) as lowest_salary from salary;




create table revenue(
	month varchar(20) not null,
	revenue int
)

insert into revenue values('january',25469),
('february',27846),
('march',24695),
('april',30696),
('may',34659),
('june',30359),
('july',40659),
('august',34256),
('september',25698),
('october',35659),
('november',40000),
('December',22155)


select * from revenue;



-- LAG FUNCTION

select *, lag(revenue,1) over() as nxt_rev from revenue;   -- (shows null value)

select *, lag(revenue,2,0) over() as nxt2_rev from revenue;  --(null = 0)


--LEAD FUNCTION
select *, lead(revenue,1) over() as nxt_rev from revenue;

select *, lead(revenue,2,0) over() as nxt_rev from revenue;


-- UES of lag 

-- Compaire the revenue of current month with privious month 
select *, (revenue - lag(revenue,1) over()) as comparision from revenue;





-- find the employee with highest salary
-- first method
create view temp_employee_rank as 
select s.*, dense_rank() over(partition by department order by salary desc) as rank_1st from salary as s;

select * from temp_employee_rank where rank_1st = 1 ;


-- second method to find highest salary of employee in each department
select s.*,
first_value(salary) over(partition by department order by salary desc) as top,
last_value(salary) over(partition by department order by salary asc) as bottom
from salary as s;




-- window function : any aggregate or ranking function

-- LIST OF AGGREGATE FUNCTION : count(), sum(), avg(), min(), max(), etc.
-- LIST OF RANKING FUNCTION : ROW_NUMBER(), RANK(, DENSE_RANK(), PERCENT_RANK(), NTILE()
-- first_value(), last_value()




--CTE's (common table expression) 

--syntax
--   with temp_table_name as 
--       (query)
-- 	     (query)

-- CTE's and views: both are virtual/temporary tables
-- the life of CTE's is within the query (use only for that query block)  where as the life of view is till we explicity drop it.

-- CTE's are uesd when the query need only ones and 
-- views are uesd when the query or table needed again and again 


-- when you create run time column if you want to apply the filters or any other operation,
-- then you would grt as error, to achive it you can use or CTE's or Views.



-- find the employee within department with highest salary

with emp_temp as
(select s.*, dense_rank() over(partition by department order by salary desc) as high_salary from salary s)
select * from emp_temp;


-- find the percentage of revenue increse for each month
with temp_revenue as
(select *, (lag(revenue) over()) as val_increse from revenue)
select *, ((revenue - val_increse)*100/revenue) as percentage from temp_revenue;



create table sales(
	city varchar(20) not null,
	sales int
)

insert into sales values('pune',254),
('mumbai',278),
('nagpur',246),
('nagpur',306),
('pune',346),
('mumbai',303),
('pune',406),
('mumbai',342),
('pune',256),
('mumbai',356),
('pune',400),
('nagpur',221)


-- Running Total 
-- ROWS UNBOUNDED PRECEDING: Keyword
select city,sales, sum(sales) over(order by city ROWS UNBOUNDED PRECEDING) as total_sales from sales;



-- in stock market: moving avreage 
-- for example of tcs stock price
-- 	day1 : 100
-- 	day2 : 110
-- 	day3 : 105
-- 	day4 : 120
-- 	day5 : 135
-- 	day6 : 115
-- 	day7 : 126
-- 	day8 : 119


