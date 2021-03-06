/*
1. Write a query that returns all employees (emp_no), their department number, their start date, their end date,
and a new column 'is_current_employee' that is a 1 if the employee is still with the company and 0 if not.
 */

 --first, I check what table I need to get employees (emp_no), their department number, their start date, their end date. 
 -- I will be using dept_emp.
 select *
 FROM employees.dept_emp

-- in this table we have  duplicated emp_no, so we can get a list of all employees with the latest to_date
-- we get a list of all employees with the latest end date ( to_date) (300024 records)
SELECT dept_emp.emp_no,  max(dept_emp.to_date)
FROM employees.dept_emp
GROUP BY dept_emp.emp_no;


-- i will create a temporary table for this
CREATE TEMPORARY TABLE all_employees AS (
SELECT dept_emp.emp_no,  max(dept_emp.to_date) AS end_date
FROM employees.dept_emp
GROUP BY dept_emp.emp_no);


-- in order to get  department number and  start date (this is the start date  when the employee starts working  in a department)
-- I will join all_employees table with dept_emp
-- NOTE this table will have the latest department where an employee is/was working. 
SELECT de.emp_no, de.dept_no, de.from_date, de.to_date
FROM employees.dept_emp AS de
JOIN all_employees ON de.emp_no = all_employees.emp_no AND de.to_date = all_employees.end_date;
 
-- ADD a  new column 'is_current_employee' that is a 1 if the employee is still with the company and 0 if not
SELECT de.emp_no, de.dept_no, de.from_date, de.to_date,
	IF(de.to_date > now(), 1, 0) AS is_current_employee
FROM employees.dept_emp AS de
JOIN all_employees ON de.emp_no = all_employees.emp_no AND de.to_date = all_employees.end_date;


-- *************** BONUS: INCLUDE THE START DATE AS THE HIRE DATE **********

-- in this case we need the employees table and we need to join them

SELECT de.emp_no, de.dept_no, b.hire_date, de.to_date,
	IF(de.to_date > now(), 1, 0) AS is_current_employee
FROM employees.dept_emp AS de
JOIN all_employees ON de.emp_no = all_employees.emp_no AND de.to_date = all_employees.end_date
JOIN employees.employees AS b ON b.emp_no = all_employees.emp_no;
-- *************** OTHER WAY  USING group_concat for dept_no ************************
select emp_no, group_concat(dept_no, ' ') as department_nums , min(from_date) as from_date , max(to_date) as to_date,
max(if(to_date = '9999-01-01', true, false )) as is_current_employment
from dept_emp
group by emp_no;

-- _______________________________________________________________________________________________________________________
/*
2. Write a query that returns all employee names (previous and current), and a new column 'alpha_group' that returns 'A-H', 
'I-Q', or 'R-Z' depending on the first letter of their last name.
 */


--   using employees table
SELECT first_name,
CASE 
 	WHEN SUBSTRING(employees.employees.first_name, 1, 1) <'I' THEN 'A-H'
 	WHEN SUBSTRING(employees.employees.first_name, 1, 1) <'R' THEN 'I-Q'
	ELSE 'R-Z' 
	END AS 'alpha_group'
FROM employees;


-- ____________________________________________________________________________________________________________
/*
3. How many employees (current or previous) were born in each decade?
 */
SELECT 
	CASE
		WHEN birth_date LIKE '195%' THEN "50's"
		WHEN birth_date LIKE '196%' THEN "60's"
		ELSE 'other'
		END AS  born_decade,
		count(*) AS no_employees
FROM employees
GROUP BY born_decade;


-- ________________________________________________________________________________________________________________
-- ######################## BONUS  ########################
/*
What is the current average salary for each of the following department groups: R&D, Sales & Marketing, Prod & QM, Finance & HR, Customer Service?

+-------------------+-----------------+
| dept_group        | avg_salary      |
+-------------------+-----------------+
| Customer Service  |                 |
| Finance & HR      |                 |
| Sales & Marketing |                 |
| Prod & QM         |                 |
| R&D               |                 |
+-------------------+-----------------+
 */
-- FIRST. I check the tables that I need :
--  salaries (I get the current salaries using to_date > now() and emp_no),
--  dept_emp (I can get current emp_no and dept_no using to_date > now())
-- dept_name ( I can get dept_no and dept_name)

-- SECOND. I combine the  3 tables using a join  ( current employees = 240, 124 )

SELECT  emp_no, dept_no, dept_name, salary
FROM salaries AS sa
JOIN dept_emp AS de USING (emp_no)
JOIN  departments USING (dept_no)
WHERE sa.to_date > now() AND de.to_date > now();

-- THIRD. I reorder the deparmens as dept_group

SELECT emp_no, dept_no, dept_name, salary,
	CASE 
		WHEN dept_name = 'Finance' THEN 'Finance & HR'
		WHEN dept_name = 'Human Resources' THEN 'Finance & HR'
		WHEN dept_name = 'Sales' THEN 'Sales & Marketing '
		WHEN dept_name = 'Marketing' THEN 'Sales & Marketing'
		WHEN dept_name = 'Production' THEN 'Prod & QM'
		WHEN dept_name = 'Quality Management' THEN 'Prod & QM'
		WHEN dept_name = 'Research' THEN ' R&D '
		WHEN dept_name = 'Development' THEN ' R&D '
		WHEN dept_name = 'Development' THEN ' R&D '
		ELSE 'Customer Service '
		END AS  dept_group
FROM salaries AS sa
JOIN dept_emp AS de USING (emp_no)
JOIN  departments USING (dept_no)
WHERE sa.to_date > now() AND de.to_date > now();

-- FOURTH. I calculate the average salary by dept_group. I use group by dept_group


 SELECT  
	CASE 
		WHEN dept_name = 'Finance' THEN 'Finance & HR'
		WHEN dept_name = 'Human Resources' THEN 'Finance & HR'
		WHEN dept_name = 'Sales' THEN 'Sales & Marketing '
		WHEN dept_name = 'Marketing' THEN 'Sales & Marketing'
		WHEN dept_name = 'Production' THEN 'Prod & QM'
		WHEN dept_name = 'Quality Management' THEN 'Prod & QM'
		WHEN dept_name = 'Research' THEN ' R&D '
		WHEN dept_name = 'Development' THEN ' R&D '
		WHEN dept_name = 'Development' THEN ' R&D '
		ELSE 'Customer Service '
		END AS  dept_group,
		 AVG(salary) AS current_average_salary
FROM salaries AS sa
JOIN dept_emp AS de USING (emp_no)
JOIN  departments USING (dept_no)
WHERE sa.to_date > now() AND de.to_date > now()
GROUP BY dept_group
ORDER BY current_average_salary;