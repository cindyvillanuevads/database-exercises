-- ***** GROUP  BY  EXERCISES  ******

/*
2.In your script, use DISTINCT to find the unique titles in the titles table.
 How many unique titles have there ever been? Answer that in a comment in your SQL file.
*/
SELECT DISTINCT	(title)
FROM titles;
-- 7 titles --


/*
3. Write a query to to find a list of all unique last names of all employees that start and end with 'E' using GROUP BY.
*/

SELECT last_name
FROM employees
WHERE last_name LIKE 'e%e'
GROUP BY last_name;
--5 unique last names

/*
4. Write a query to to find all unique combinations of first and last names of all employees
 whose last names start and end with 'E'.
*/
SELECT  first_name, last_name
FROM employees
WHERE last_name LIKE 'e%e'
GROUP BY  last_name, first_name;  
-- 846 records--



/*
5. Write a query to find the unique last names with a 'q' but not 'qu'. 
Include those names in a comment in your sql code.
*/

SELECT  DISTINCT (last_name)
FROM employees
WHERE last_name LIKE '%q%'
AND last_name NOT LIKE '%qu%';

--Chleq,  Lindqvist, Qiwen

/*
6. Add a COUNT() to your results (the query above) and 
use ORDER BY to make it easier to find employees whose unusual name is shared with others.

*/
SELECT last_name,first_name,  COUNT(last_name) 
FROM employees
WHERE last_name LIKE '%q%'
AND last_name NOT LIKE '%qu%'
GROUP BY last_name, FIRST_name;

-- OTHER WAY THAT SHOWS FIRST T

SELECT last_name,first_name,  COUNT(last_name) AS No_empl
FROM employees
WHERE last_name LIKE '%q%'
AND last_name NOT LIKE '%qu%'
GROUP BY last_name, FIRST_name
ORDER BY No_empl DESC;
/*
7. Find all all employees with first names 'Irena', 'Vidya', or 'Maya'. Use COUNT(*) and 
GROUP BY to find the number of employees for each gender with those names.
*/
SELECT gender,first_name, COUNT(first_name) 
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya') 
GROUP BY gender, first_name;

/*
M	Irena	144
M	Maya	146
M	Vidya	151
F	Irena	97
F	Maya	90
F	Vidya	81
*/

/*
8. Using your query that generates a username for all of the employees, generate a count employees for each unique username.
 Are there any duplicate usernames? BONUS: How many duplicate usernames are there?
*/
SELECT 
 LOWER(
CONCAT(
(SUBSTR(first_name, 1, 1)), SUBSTR(last_name, 1, 4),'_', SUBSTR(birth_date, 6, 2), SUBSTR(birth_date, 3, 2))) AS Username,
COUNT(*) AS No_Emp
FROM employees
GROUP BY Username;

-- yes, there are duplicates  usernames

---The following shows all the duplicate usernames. Total 13,251
SELECT 
 LOWER(
CONCAT(
(SUBSTR(first_name, 1, 1)), SUBSTR(last_name, 1, 4),'_', SUBSTR(birth_date, 6, 2), SUBSTR(birth_date, 3, 2))) AS Username,
COUNT(*) AS No_Emp
FROM employees
GROUP BY Username
HAVING No_Emp > 1
ORDER BY No_emp DESC;


