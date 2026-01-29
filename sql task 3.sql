1. DATABASE SETUP & DATA ONBOARDING
create table customer_details(customer_id varchar primary key ,	customer_name varchar(100) not null ,	age int,	contact_number bigint unique,
email varchar unique not null,	pancard_no varchar unique,	aadhaar_card_no bigint unique,	 area varchar,	city varchar,	state varchar,	zipcode int)
create table employee_details(employee_id serial primary key,	FirstName varchar,	LastName varchar,	Department varchar,	City varchar,	manager_id int,	Salary int,
constraint fk_manager Foreign key (manager_id) references employee_details(employee_id))
ls(customer_id,customer_name,age,contact_number,email) values ('CUS-1031-ID'
create table order_details(order_id varchar primary key,	order_date date not null,	customer_id varchar  ,
order_status varchar,	payment_mode varchar,	total_amount decimal , constraint fk_customer foreign key (customer_id)references customer_details(customer_id))
create table sale_details(sale_id varchar primary key,	order_id varchar not null,	product_id varchar not null,	quantity_sold int,	unit_price numeric,	
discount_pct numeric,tax_pct numeric,line_total numeric,	delivery_date date,constraint fk_order foreign key (order_id)references order_details(order_id),constraint fk_product foreign key 
(product_id)references product_details(product_id))
create table product_details(product_id varchar primary key,	product_name varchar not null,	category varchar,	price_inr numeric)

copy customer_details from 'C:\Users\HP\Downloads\customer_details - customer_details.csv' delimiter ',' csv header;
copy employee_details from 'C:\Users\HP\Downloads\employee_details - employee_details (3).csv' delimiter ',' csv header;
copy product_details from 'C:\Users\HP\Downloads\product_details - product_details.csv' delimiter ',' csv header;
copy order_details from 'C:\Users\HP\Downloads\order_details - order_details.csv' delimiter ',' csv header;
copy sale_details from 'C:\Users\HP\Downloads\sale_details - sale_details.csv' delimiter ',' csv header;

2.CUSTOMER & ORDER FILTERING
select * from order_details o join customer_details c on o.customer_id = c.customer_id where c.city in ('Mumbai','Pune'); 
select * from product_details p where price_inr between 5000 and 50000;
select * from customer_details where city in ('Mumbai','Nagpur','Pune');
select * from order_details where order_status = 'Delivered' and  payment_mode = 'UPI';
select * from sale_details where unit_price > 2 and tax_pct =0.18;

3.DATA CORRECTION & STANDARDIZATION
update order_details set order_status ='cancelled' where total_amount < 500 and order_status = 'cancelled';
update employee_details set salary = salary *1.10 where department='HR';
update customer_details set city ='Mumbai' where area ='Andheri';
update product_details set product_name = 'laptop' where category ='Electronic'
update customer_details set email = concat(email,'@',1,'@company.com') where email ILIKE '%@gmail'; 

4.BUSINESS & AGGREGATION
select SUM(total_amount) as total_revenue from order_details;
select AVG(salary)as department from employee_details ;
select order_status,COUNT(*) AS total_orders from order_details group by order_status ;
select category ,  MAX(price_inr) as highest_price,
MIN(price_inr) as lowest_price from product_details group by category; 
select product_id,SUM(quantity_sold) as quantity_sold from sale_details group by product_id;

5.RANKING & PAGINATION
select * from product_details order by price_inr DESC limit 5;
select * from order_details order by order_date DESC limit 3;
select distinct city from customer_details;
select customer_id , sum(total_amount) as total_amount from order_details group by customer_id order by total_amount DESC limit 10;
select * from order_details order by order_id limit 5 offset 5;

6.TEXT PROCESSING
select upper(customer_name) from customer_details;
select left(product_name,9) as product_code from product_details;
select firstname || ' ' || lastname as full_name from employee_details;
select length(customer_name) as char_length from customer_details;
select product_name,replace(product_name,'','_') as product_name_system from product_details;



7.DATE & TIME ANALYSIS
select extract(Year from order_date) as year, extract(month from order_date) as month from order_details
select customer_id,order_date,order_date - Lag(order_date) over (Partition by customer_id order by order_date) as days_between_orders from order_details;
select delivery_date as today_date,
current_timestrap as current_time;
select * from order_details where order_date between '2024-09-01' and '2024-09-30';
select order_id,order_date,order_date + interval '7 days' as expected_delivery_date from order_details;

8.NUMERICAL & FINANCIAL CALCULATIONS
select product_id, Round(price_inr,2) as rounded_price from product_details;
select order_id,unit_price,discount_pct,unit_price - (unit_price * discount_pct / 100) as final_price from sale_details
select employee_id, ABS(salary - salary) as salary_variance from employee_details;
select employee_id,salary,Power(salary ,2) as salary_power from employee_details;
select order_id,RANDOM() * 25+5 as random_discount_percent from order_details;

9.MULTI-TABLE JOINS
select c.customer_id,c.customer_name,o.order_id,o.order_date from customer_details c inner join order_details o on o.customer_id = c.customer_id;
select o.order_id,o.order_date,s.product_id,s.quantity_sold,s.unit_price  from sale_details s left join order_details o on o.order_id = s.order_id;



10.SET OPERATION
1.-- select city from customer_details
UNION
select city from employee_details;

2. select city from customer_details
UNION ALL
select city from employee_details;

3.-- select city from customer_details
INTERSECT
select city from employee_details;

4.-- select city from customer_details
EXCEPT
select city from employee_details;

5.-- select customer_id from customer_details
INTERSECT
select city from employee_details
INTERSECT
select distinct c.city from customer_details c join order_details o on c.customer_id = o.customer_id where c.city in (select city from employee_details);


11.NULL HANDLING & CONDITIONAL FUCTIONS
1.select coalesce (payment_mode, 'Not Initiated') as payment_mode from order_details;
select line_total / nullif(quantity_sold, 0) from sale_details; 
3.select employee_id,firstname,lastname, GREATEST(salary,50000) as higest_salary from employee_details;
4.select product_name,LEAST(price_inr,100) as lowest_price from product_details;
5.select coalesce (city,'Unknown') as city from customer_details;


12.SUBQUERIES
1.select * from employee_details where salary >(select AVG(salary) from employee_details);
2.select * from product_details where price_inr >(select AVG(price_inr) from product_details p where category = p.category);
3.select customer_id from order_details group by customer_id having COUNT(*) > 3;
4.select * from order_details where total_amount >(select AVG(total_amount) from order_details);
5.select department from employee_details group by department order by AVG(salary) DESC limit 1;
6.select * from employee_details e where salary =(select MAX(salary) from employee_details where department=e.department);
7.select * from customer_details where customer_id NOT IN(select customer_id from order_details);
select * from product_details where product_id NOT IN(select product_id from ;
9.select * from order_details where total_amount = (select MAX(total_amount) from order_details);
10.select customer_id ,SUM(total_amount) as total_spent from order_details group by customer_id order by total_spent DESC limit 1; 

13.VIEWS & MATERIALIZED VIEWS
1.create view customer_order_summary as select customer_id, count (order_id) as total_order, SUM(total_amount) as total_spent from order_details group by customer_id;
2.create view product_level_sales as select product_id , sum (quantity_sold) as total_sold , sum(quantity_sold * unit_price) as revenue from sale_details group by product_id;
create materialized view mv_monthly_revenue as select date_trunc('month',order_date) as month,sum(total_amount) as revenue from order_details group by month;
refresh materialized view mv_monthly_reveune;
select * from mv_monthly_revenue;
5. WHEN TO USE VIEWS VS MATERIALIZED VIEWS ?
ANS:VIEWS: A view is PostgreSQL is a virtual table that represents the result of a query. Views always show latest data. 
Views are useful for simplifying complex queries,enhancing security,and improving data abstraction.
Views are slower for heavy queries. No storage used. Good for simple reports. Viwes are auto-updated.

MATERIALIZED VIEWS :MATERIALIZED VIEWS stores data physically.
Much faster for reporsts.Uses storage. Best for dashboards & analytics. Must be refreshed manually.

14.TEMP TABLES, CTEs & RECURSIVE LOGIC
1.create temp table high_value_orders as select * from order_details where total_amount > 5000;
2.insert into high_value_orders select * from order_details where total_amount between 3000 and 5000;
3.with department_salary as(select department, AVG(salary) as avg_salary from employee_details group by department) 
select * from department_salary;
4.with customer_spend as(select customer_id,sum(total_amount) as total_spent from order_details group by customer_id) 
select * from customer_spend where total_spent > 10000;
5.with customer_spend as(select customer_id,sum(total_amount) as total_spent from order_details group by customer_id),
premium_customers as(select * from customer_spend where total_spent > 10000)
select * from premium_customers;
with recursive emp_hierarchy as (select employee_id,firstname,manager_id,1 as level from employee_details where manager_id is null
union all
select e.employee_id,e.firstname,e.manager_id, h.level + 1
from employee_details e join emp_hierarchy h on e.manager_id = h.employee_id)
select * from emp_hierarchy;
7.select * from employee_details where manager_id is null;
8.WITH RECURSIVE hierarchy AS (
    SELECT employee_id, manager_id, 1 AS depth
    FROM employee_details
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.employee_id, e.manager_id, h.depth + 1
    FROM employee_details e
    JOIN hierarchy h ON e.manager_id = h.employee_id
)
SELECT MAX(depth) AS max_depth
FROM hierarchy;
9.WITH RECURSIVE chain AS (
SELECT employee_id, firstname, manager_id, firstname::TEXT AS path
FROM employee_details
WHERE manager_id IS NULL
UNION ALL
SELECT e.employee_id, e.firstname, e.manager_id,
c.path || ' → ' || e.firstname
FROM employee_details e
JOIN chain c ON e.manager_id = c.employee_id
)
SELECT * FROM chain;
10.drop table if exists high_value_orders;


15.WINDOW FUNCTIONS
1. select employee_id , firstname, department , salary, 
RANK() over (Partition by department order by salary DESC) from employee_details;
2.select product_id,product_name,category,price_inr,
DENSE_RANK() over (Partition by category order by price_inr DESC ) as rank from product_details;
3.select order_id,order_date,total_amount,
SUM(total_amount) over (order by order_date) as running_total from order_details;
4.select order_id,order_date,total_amount,
AVG(total_amount) over(order by order_date rows between 2 preceding and current row) as moving_avg from order_details;
5.select order_id,customer_id,order_date,total_amount,
LAG(total_amount) over (Partition by customer_id order by order_date) as prev_order from order_details;
6.select employee_id,firstname,salary, LAG(salary) over (order by employee_id) as previous_salary from employee_details;
7.select customer_id,order_date,LEAD(order_date) over (partition by customer_id order by order_date) as next_order from order_details;
8.select customer_id,order_status,total_amount,SUM(total_amount) over(Partition by customer_id order by order_date) as cumulative_spend from order_details;
9. delete from order_details where order_id in(select order_id from (select order_id,row_number() over (Partition by customer_id, order_date, total_amount order by order_id)
 from order_details)
 sub
 where row_number > 1);
10.select * from (select product_id,product_name,category,price_inr, RANK() over (Partition by category order by price_inr DESC) as rank from product_details)
ranked
where rank <= 3;