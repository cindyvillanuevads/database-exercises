-- 1. Create a file named where_exercises.sql. Make sure to use the employees database.
USE employees;

-- 2. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya' using IN. Enter a comment with 
-- the number of records returned.  (709 records)

SELECT * FROM employees;

SELECT * 
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya');

/*
3. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', as in Q2, but use OR instead of IN. 
Enter a comment with the number of records returned. Does it match number of rows from Q2? yes, (709 records)
*/

SELECT * 
FROM employees
WHERE first_name = 'Irena' 
	OR first_name = 'Vidya' 
	OR first_name = 'Maya';
	
/*
4. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', using OR, and who is male. 
Enter a comment with the number of records returned. 441 records
*/
SELECT * 
FROM employees
WHERE (first_name ='Irena' OR first_name ='Vidya' OR first_name ='Maya')
	AND gender = 'M';

SELECT * 
FROM employees
WHERE gender = 'M' 
	AND (first_name ='Irena'	
	OR first_name ='Vidya'
	OR first_name ='Maya');
	

/*
5. Find all current or previous employees whose last name starts with 'E'. 
Enter a comment with the number of employees whose last name starts with E.  (7330 records)
*/

SELECT last_name
FROM employees
WHERE last_name LIKE 'E%';

/*
6. Find all current or previous employees whose last name starts or ends with 'E'. 
Enter a comment with the number of employees whose last name starts or ends with E.  30723 records
How many employees have a last name that ends with E, but does not start with E? 23393 records
*/
SELECT last_name
FROM employees
WHERE last_name LIKE "E%" 
	OR last_name LIKE "%E";

SELECT last_name
FROM employees
WHERE last_name LIKE "%E" 
	AND last_name NOT LIKE "E%";

/*7. Find all current or previous employees  whose last name starts and ends with 'E'. 
Enter a comment with the number of employees whose last name starts and ends with E. 899 RECORDS
How many employees' last names end with E, regardless of whether they start with E? 24292 records
*/

SELECT last_name
FROM employees
WHERE last_name LIKE 'E%'
	AND last_name LIKE '%E';
-- OTHER WAY TO DO FISRT question	
SELECT *
FROM employees
WHERE last_name LIKE 'E%E';

SELECT last_name
FROM employees
WHERE last_name LIKE '%E';

/*
8. Find all current or previous employees hired in the 90s. 
Enter a comment with the number of employees returned.  135214 records
*/


SELECT *
FROM employees
WHERE hire_date LIKE '199%';


-- 9. Find all current or previous employees born on Christmas. Enter a comment with the number of employees returned. (842 records)

SELECT *
FROM employees
WHERE birth_date LIKE '%-12-25';

/*
10. Find all current or previous employees hired in the 90s and born on Christmas. 
Enter a comment with the number of employees returned. (362 records)
*/

SELECT *
FROM employees
WHERE birth_date LIKE '%-12-25'
	AND hire_date LIKE '199%';

/*
11.Find all current or previous employees with a 'q' in their last name. 
Enter a comment with the number of records returned. (1873 records)
*/

SELECT *
FROM employees
WHERE last_name LIKE '%q%';

/*
12. Find all current or previous employees with a 'q' in their last name but not 'qu'. 
How many employees are found? 547 records
*/
SELECT *
FROM employees
WHERE last_name LIKE '%q%'
	AND last_name NOT LIKE '%qu%';
	
