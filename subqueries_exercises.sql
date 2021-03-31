--                ******** SUBQUERIES EXERCISES  ********


/*
1. Find all the current employees with the same hire date as employee 101010 using a sub-query
** 55 records
*/

--  hire date of employee 101010     
SELECT *
FROM employees
WHERE emp_no = 101010; 

--  current employees
SELECT emp_no, to_date
FROM dept_emp
WHERE to_date > now();   
   

-- all employees that have the same hire date  1990-10-22

SELECT emp_no, first_name, last_name 
FROM employees
WHERE hire_date = '1990-10-22'; 
      
-- combine

SELECT emp_no, first_name, last_name, hire_date 
FROM employees
WHERE emp_no IN(
SELECT emp_no
FROM dept_emp
WHERE to_date > now()  
)
AND  hire_date = '1990-10-22';    

/*
2. Find all the titles ever held by all current employees with the first name Aamod.

Assistant Engineer
Engineer
Senior Engineer
Senior Staff
Staff
Technique Leader
*/
--  current employees
SELECT emp_no, to_date
FROM titles
WHERE to_date > now();   
   
-- all employees that have Aamod as a first name
SELECT emp_no, first_name
FROM employees
WHERE first_name = 'Aamod';


SELECT title
FROM titles
WHERE emp_no IN(
	SELECT emp_no
	FROM employees
	WHERE first_name = 'Aamod'
)
AND to_date > now()
GROUP BY title;


/*
3.How many people in the employees table are no longer working for the company? 85108
 Give the answer in a comment in your code.
*/

-- current employees
SELECT emp_no, to_date
FROM dept_emp
WHERE to_date < NOW();

SELECT COUNT(*) AS "former employees"
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM dept_emp
	WHERE to_date < NOW()
);
--  85108
/*
4. Find all the current department managers that are female. List their names in a comment in your code.

Isamu	Legleitner
Karsten	Sigstam
Leon	DasSarma
Hilary	Kambil
*/

-- current managers
SELECT emp_no, dept_no, to_date
FROM dept_manager
WHERE to_date > now();

 -- female employees
SELECT emp_no, first_name, last_name
FROM employees
WHERE gender =  'F';
-- now let's combine the queries
SELECT  first_name, last_name
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM dept_manager
WHERE to_date > now()
)
AND gender =  'F';


/*
5. Find all the employees who currently have a higher salary than the companies overall,
 historical average salary.  154,543 employees
*/
-- average 

SELECT AVG (salary)
FROM salaries; 

-- higher salary employees list with the query above 
SELECT emp_no
FROM salaries
WHERE salary > (
	SELECT AVG (salary)
	FROM salaries)
AND to_date > now();

--combine the 2 
SELECT emp_no, first_name, last_name
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM salaries
	WHERE salary > (
		SELECT AVG (salary)
		FROM salaries)
	AND to_date > now()
);
/*
6.
How many current salaries are within 1 standard deviation of the current highest salary?
(Hint: you can use a built in function to calculate the standard deviation.)
 What percentage of all salaries is this?
 */


/*
 *******         BONUS    ******* 

***** Find all the department names that currently have female managers.

Development
Finance
Human Resources
Research
*/

-- current managers
SELECT emp_no, dept_no, to_date
FROM dept_manager
WHERE to_date > now();

 -- female employees
SELECT emp_no 
FROM employees
WHERE gender =  'F';

-- -females manager
SELECT dept_no, emp_no
FROM dept_manager
WHERE emp_no IN (
	SELECT emp_no
	FROM employees
	WHERE gender =  'F'		
)
AND  to_date > now();

-- combine everythin to get the department names


SELECT dept_no, dept_name
FROM departments
WHERE dept_no IN (
	SELECT dept_no
	FROM dept_manager
	WHERE emp_no IN (
		SELECT emp_no
		FROM employees
		WHERE gender =  'F'		
	)
	AND  to_date > now()
);

/*
**** Find the first and last name of the employee with the highest salary.
43624	Tokuyasu	Pesch
*/

 

-- highest salary
SELECT  max(salary)
FROM salaries;


-- employee number WITH highest salary
SELECT emp_no
FROM salaries
WHERE salary = (
	SELECT max(salary)
	FROM salaries);

-- combine 

SELECT emp_no, first_name, last_name
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM salaries
	WHERE salary = (
		SELECT max(salary)
		FROM salaries)
);

/*
Find the department name that the employee with the highest salary works in.  
** Sales
*/

-- highest salary
SELECT  max(salary)
FROM salaries;


-- employee number WITH highest salary
SELECT emp_no
FROM salaries
WHERE salary = (
	SELECT max(salary)
	FROM salaries);

-- depto number and employee number

SELECT dept_no 
FROM dept_emp
WHERE emp_no IN (
	SELECT emp_no
	FROM salaries
	WHERE salary = (
		SELECT max(salary)
		FROM salaries)
)
AND to_date > now();
--- combine everything
SELECT dept_name
FROM departments
WHERE dept_no IN (
	SELECT dept_no 
	FROM dept_emp
	WHERE emp_no IN (
		SELECT emp_no
		FROM salaries
		WHERE salary = (
			SELECT max(salary)
			FROM salaries)
	)
	AND to_date > now()
);