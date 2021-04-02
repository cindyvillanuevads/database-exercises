--                ******** SUBQUERIES EXERCISES  ********


/*
1. Find all the current employees with the same hire date as employee 101010 using a sub-query
** 55 records
*/

--  hire date of employee 101010     
SELECT hire_date
FROM employees
WHERE emp_no = 101010; 

--  current employees
SELECT emp_no, to_date
FROM dept_emp
WHERE to_date > now();   
   

-- all employees that have the same hire date  1990-10-22

SELECT emp_no, first_name, last_name 
FROM employees
WHERE hire_date = (
	SELECT hire_date
	FROM employees
	WHERE emp_no = 101010);
      
-- combine all three 

SELECT emp_no, first_name, last_name, hire_date 
FROM employees
WHERE emp_no IN(
	SELECT emp_no
	FROM dept_emp
	WHERE to_date > now()  
)
AND  hire_date = (
					SELECT hire_date
					FROM employees
					WHERE emp_no = 101010);  


/*
*********************************************************************************
                          other way to do it using a join
*********************************************************************************
*/
SELECT
	first_name,
	last_name,
	hire_date
FROM employees
JOIN salaries USING(emp_no)
WHERE to_date > CURDATE()
	AND hire_date = (
					SELECT hire_date
					FROM employees
					WHERE emp_no = 101010);



/*
2. Find all the titles ever held by all current employees with the first name Aamod.

Assistant Engineer
Engineer
Senior Engineer
Senior Staff
Staff
Technique Leader
*/
--  current employees, titles and salary tables have 240, 124 current employees
SELECT emp_no, to_date
FROM titles
WHERE to_date > now();   
   
-- all employees that have Aamod as a first name
SELECT emp_no, first_name
FROM employees
WHERE first_name = 'Aamod';

-- combine all and group by title
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
3.How many people in the employees table are no longer working for the company? 59,900
 Give the answer in a comment in your code.
*/

-- current employees  240,124
SELECT  (emp_no)
FROM dept_emp
WHERE to_date > NOW();

-- NOW WE USE the current empoyees that are not in the employees table.
SELECT COUNT(*) AS "former employees"
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM dept_emp
	WHERE to_date < NOW()
);
--  59,900
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
-- historical average 

SELECT AVG (salary)
FROM salaries; 

-- higher salary emp_no list > average salary (we are using the code for historical average salary ) 

SELECT emp_no
FROM salaries
WHERE salary > (
	SELECT AVG (salary)
	FROM salaries)
AND to_date > now();

--now we use employees table to  get the list of emp_no, first_name, last_name whit the condition  above. 
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
How many current salaries are within 1 standard deviation of the current highest salary? (83 salaries)
(Hint: you can use a built in function to calculate the standard deviation.)
 What percentage of all salaries is this?
 */

 -- first.  I calculate the current standar deviation and highest salary
-- Highest current salary =158220
-- current standard deviation.=	17309.95933634675

SELECT max(salary), STDDEV(salary) 
FROM salaries;

-- second, I calculate current salaries are within 1 standard deviation of the current highest salary. (83 salaries)
SELECT Count(*)
FROM salaries
WHERE salary >= (
	SELECT (max(salary)- STDDEV(salary) )
	FROM salaries
	WHERE to_date > now()
)
AND  to_date > now();

-- I calculate the total current  salaries (240,124)
SELECT Count(*)
FROM salaries
where  to_date > now();
-- finally, I calculate 83 * 100 / 240124
SELECT (
	SELECT Count(*)
	FROM salaries
	WHERE salary >= (
		SELECT (max(salary)- STDDEV(salary) )
		FROM salaries
		WHERE to_date > now()
	)
	AND  to_date > now()
) *100 /
(SELECT Count(*)
FROM salaries
WHERE  to_date > now()) AS "Percent of Salaries";


-- Now I can get the percentage of all salaries that are within 1 standard deviation of the current highest salary
-- 
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

-- combine everything to get the department names


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