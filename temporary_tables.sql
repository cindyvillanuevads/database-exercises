--            *******  Temporary Tables  ******* 
/*
1. 
Using the example from the lesson, re-create the employees_with_departments table.
*/
-- First I did a join to combine employees and departments table.
SELECT employees.employees.first_name, employees.employees.last_name, employees.departments.dept_name
FROM employees.employees
JOIN employees.dept_emp USING (emp_no)
JOIN employees.departments USING (dept_no)
WHERE to_date> now();

-- Create the new table named: employees_with_departments
CREATE TEMPORARY TABLE employees_with_departments AS(
	SELECT employees.employees.first_name, employees.employees.last_name, employees.departments.dept_name
	FROM employees.employees
	JOIN employees.dept_emp USING (emp_no)
	JOIN employees.departments USING (dept_no)
    WHERE to_date> now()
);

/*
Add a column named full_name to this table. It should be a VARCHAR
whose length is the sum of the lengths of the first name and last name columns
Update the table so that full name column contains the correct data
Remove the first_name and last_name columns from the table.
*/

--calculate the length, we can check the length here
DESCRIBE employees_with_departments ;

-- Add a column named full_name to this table.

ALTER TABLE employees_with_departments
ADD full_name VARCHAR(30);

-- Update the table so that full name column contains the correct data
UPDATE employees_with_departments SET full_name = CONCAT(first_name,' ', last_name);

-- Remove the first_name and last_name columns from the table.
ALTER TABLE employees_with_departments DROP COLUMN first_name;
ALTER TABLE employees_with_departments DROP COLUMN last_name;

-- What is another way you could have ended up with this same table?
CREATE TEMPORARY TABLE employees_with_departments AS(
	SELECT concat(employees.employees.first_name,' ', employees.employees.last_name) AS full_name,
	employees.departments.dept_name
	FROM employees.employees
	JOIN employees.dept_emp USING (emp_no)
	JOIN employees.departments USING (dept_no)
);

/*
2
Create a temporary table based on the payment table from the sakila database.
*/
CREATE TEMPORARY TABLE sakila_payment AS(
SELECT *
FROM sakila.payment
);
/*
Write the SQL necessary to transform the amount column such that it is stored as an integer representing
 the number of cents of the payment. For example, 1.99 should become 199
*/
ALTER TABLE sakila_payment  CHANGE amount amount2 DECIMAL(6,2);
UPDATE sakila_payment SET amount2 = amount2*100;

ALTER TABLE sakila_payment  CHANGE amount2 amount_in_pennies INT(6);

-- other way to do it if when we create the table we multiply by 100 the amount
create temporary table payments as (
    select payment_id, customer_id, staff_id, rental_id, amount * 100 as amount_in_pennies, payment_date, last_update
    from sakila.payment
);

ALTER TABLE payments MODIFY amount_in_pennies int NOT NULL

/*
Find out how the current average pay in each department compares to the overall, historical average pay.
 In order to make the comparison easier, you should use the Z-score for salaries. In terms of salary, 
 what is the best department right now to work for? The worst?
 best
Sales	Z score=	1.48136523

 worst
Human Resources	Z score=	0.00657534
*/

-- current salaries
SELECT * 
FROM employees.salaries
WHERE employees.salaries.to_date > now();

--list of current salaries for each employee with department
SELECT   employees.departments.dept_name, employees.salaries.salary   
FROM employees.salaries 
JOIN employees.dept_emp USING (emp_no)
JOIN employees.departments USING (dept_no)
WHERE employees.salaries.to_date > now()
and employees.dept_emp.to_date > now();

-- list avg salaries in each  deparments


SELECT  employees.departments.dept_name, 
AVG(employees.salaries.salary) AS avg_salary 
FROM employees.salaries 
JOIN employees.dept_emp USING (emp_no)
JOIN employees.departments USING (dept_no)
WHERE employees.salaries.to_date > now()
and employees.dept_emp.to_date > now()
GROUP BY employees.departments.dept_name
ORDER BY avg_salary DESC;

-- list historical avg salaries and standar deviation in general
-- historical general avg =63810.7448	
-- historical general standar deviation =16904.82828800014
SELECT 
AVG(employees.salaries.salary) AS hist_avg_salary,
STDDEV(employees.salaries.salary) AS standard_deviation  
FROM employees.salaries 

-- I create a temporary table for  current avg salaries.
CREATE TEMPORARY TABLE current_avg_salary AS(
	SELECT  employees.departments.dept_name, 
    AVG(employees.salaries.salary) AS avg_salary   
    FROM employees.salaries 
    JOIN employees.dept_emp USING (emp_no)
    JOIN employees.departments USING (dept_no)
    WHERE employees.salaries.to_date > now()
    AND employees.dept_emp.to_date > now()
    GROUP BY employees.departments.dept_name
);
-- I add columns hist_avg_salary and standard_deviation to my temporary table current_avg_salary . 
ALTER TABLE current_avg_salary  ADD hist_avg_salary DECIMAL(10,5);
ALTER TABLE current_avg_salary  ADD standard_deviation DECIMAL(10,10);
 -- I set the value for each one 
UPDATE current_avg_salary 
SET hist_avg_salary = 63810.7448;
UPDATE current_avg_salary 
SET standard_deviation = 16904.8282;

-- I calculate de Z score


SELECT *, ((avg_salary - hist_avg_salary)/ standard_deviation) AS Z_score
FROM current_avg_salary
JOIN historical_salary USING( dept_name)
ORDER BY Z_score DESC;
-- ***********************************************
-- ***  other way to do it as we seen in class ***
-- ***********************************************
-- Exercise 3 in a more programmatic way
-- Historic average and standard deviation b/c the problem says "use historic average"
-- 63,810 historic average salary
-- 16,904 historic standard deviation
create temporary table historic_aggregates as (
    select avg(salary) as avg_salary, std(salary) as std_salary
    from employees.salaries 
);

create temporary table current_info as (
    select dept_name, avg(salary) as department_current_average
    from employees.salaries
    join employees.dept_emp using(emp_no)
    join employees.departments using(dept_no)
    where employees.dept_emp.to_date > curdate()
    and employees.salaries.to_date > curdate()
    group by dept_name
);

select * from current_info;

alter table current_info add historic_avg float(10,2);
alter table current_info add historic_std float(10,2);
alter table current_info add zscore float(10,2);

update current_info set historic_avg = (select avg_salary from historic_aggregates);
update current_info set historic_std = (select std_salary from historic_aggregates);

select * from current_info;

update current_info 
set zscore = (department_current_average - historic_avg) / historic_std;

select * from current_info
order by zscore desc;