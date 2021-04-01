--            *******  Temporary Tables  ******* 
/*
1. 
Using the example from the lesson, re-create the employees_with_departments table.
*/
-- First I did a joint to combine employees and departments table.
SELECT employees.employees.first_name, employees.employees.last_name, employees.departments.dept_name
FROM employees.employees
JOIN employees.dept_emp USING (emp_no)
JOIN employees.departments USING (dept_no)

-- Create the new table named: employees_with_departments
CREATE TEMPORARY TABLE employees_with_departments AS(
	SELECT employees.employees.first_name, employees.employees.last_name, employees.departments.dept_name
	FROM employees.employees
	JOIN employees.dept_emp USING (emp_no)
	JOIN employees.departments USING (dept_no)
);

/*
Add a column named full_name to this table. It should be a VARCHAR
whose length is the sum of the lengths of the first name and last name columns
Update the table so that full name column contains the correct data
Remove the first_name and last_name columns from the table.
*/
-- Add a column named full_name to this table.
--calculate the length
SELECT (sum(length(first_name)) + Sum(length(last_name))) AS total_length
FROM employees_with_departments; 

-- or
SELECT MAX(((length(first_name)) + (length(last_name))))
FROM employees_with_departments;

ALTER TABLE employees_with_departments
ADD full_name VARCHAR(30);

--Update the table so that full name column contains the correct data
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

ALTER TABLE sakila_payment  CHANGE amount2 amount INT(6);

/*
Find out how the current average pay in each department compares to the overall, historical average pay.
 In order to make the comparison easier, you should use the Z-score for salaries. In terms of salary, 
 what is the best department right now to work for? The worst?
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
WHERE employees.salaries.to_date > now();

-- list avg salaries in each  deparments


SELECT  employees.departments.dept_name, 
AVG(employees.salaries.salary) AS avg_salary,
STDDEV(employees.salaries.salary) AS standard_deviation    
FROM employees.salaries 
JOIN employees.dept_emp USING (emp_no)
JOIN employees.departments USING (dept_no)
WHERE employees.salaries.to_date > now()
GROUP BY employees.departments.dept_name
ORDER BY avg_salary DESC;

-- list historical avg salaries in each deparments
SELECT  employees.departments.dept_name,
AVG(employees.salaries.salary) AS hist_avg_salary,
STDDEV(employees.salaries.salary) AS standard_deviation  
FROM employees.salaries 
JOIN employees.dept_emp USING (emp_no)
JOIN employees.departments USING (dept_no)
GROUP BY employees.departments.dept_name
ORDER BY hist_avg_salary DESC;

-- I create a remporary table for  current avg salaries and for historical average salaries.
CREATE TEMPORARY TABLE current_avg_salary AS(
	SELECT  employees.departments.dept_name, 
	AVG(employees.salaries.salary) AS avg_salary   
	FROM employees.salaries 
	JOIN employees.dept_emp USING (emp_no)
	JOIN employees.departments USING (dept_no)
	WHERE employees.salaries.to_date > now()
	GROUP BY employees.departments.dept_name
	ORDER BY avg_salary DESC
);


CREATE TEMPORARY TABLE historical_salary AS(
SELECT  employees.departments.dept_name,
AVG(employees.salaries.salary) AS hist_avg_salary,
STDDEV(employees.salaries.salary) AS standard_deviation  
FROM employees.salaries 
JOIN employees.dept_emp USING (emp_no)
JOIN employees.departments USING (dept_no)
GROUP BY employees.departments.dept_name
ORDER BY hist_avg_salary DESC
);


-- I calculate de Z score


SELECT *, ((avg_salary - hist_avg_salary)/ standard_deviation) AS Z_score
FROM current_avg_salary
JOIN historical_salary USING( dept_name)
ORDER BY Z_score DESC;