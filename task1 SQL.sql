--SELECT * FROM public.employee_details
-- Update Employee_Details
-- set DepartmentID=0 Where IsActive = False;

-- update Employee_Details
-- set salary = Salary * 1.08 where IsActive = False and DepartmentID = 0 and Job_Title in('HR Manager', 'Financial Analyst','Business Analyst','Data Analyst');
--select FirstName ,LastName from Employee_Details where salary between 30000 and 50000
--select * from Employee_Details where FirstName like 'A%';
--delete from Employee_Details where employee_id between 1 and 5;
--Rename table
-- select * from Employee_Details
-- Alter table Employee_Details 
-- Rename to employee_database;
-- Alter table employee_database
-- Rename Column FirstName to Name;
-- Alter table employee_database
-- Rename Column LastName to Surname;
--Alter table employee_database
--Add Column State varchar not null default 'India';
-- Update employee_database
-- set State = 'India'
--  Where IsActive = True;
Update employee_database
set State = 'USA'
 Where IsActive = False;

