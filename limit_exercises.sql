
-- ***** LIMIT  ****
/*
2.MySQL provides a way to return only unique results from our queries with the keyword DISTINCT. For example, to find all the unique titles within the company, we could run the following query:

SELECT DISTINCT title FROM titles;
List the first 10 distinct last name sorted in descending order.
Technique Leader
Staff
Senior Staff
Senior Engineer
Manager
Engineer
Assistant Engineer
*/

SELECT * FROM titles;
SELECT DISTINCT title FROM titles
ORDER BY title DESC
LIMIT 10;

/*
3.Find all previous or current employees hired in the 90s and born on Christmas.
 Find the first 5 employees hired in the 90's by sorting by hire date and limiting your results to 
 the first 5 records. 
Write a comment in your code that lists the five names of the employees returned.
243297	1962-12-25	Alselm	Cappello	F	1990-01-01
34335	1960-12-25	Utz	Mandell	M	1990-01-03
400710	1963-12-25	Bouchung	Schreiter	M	1990-01-04
465730	1959-12-25	Baocai	Kushner	F	1990-01-05
490744	1959-12-25	Petter	Stroustrup	M	1990-01-10

*/


SELECT * FROM employees
WHERE hire_date LIKE '199%' 
	AND birth_date LIKE '%-12-25'
ORDER BY hire_date
LIMIT 5;

/*
4.Try to think of your results as batches, sets, or pages. The first five results are your first page. 
The five after that would be your second page, etc. Update the query to find the tenth page of results.

LIMIT and OFFSET can be used to create multiple pages of data. 
What is the relationship between OFFSET (number of results to skip), 
LIMIT (number of results per page), and the page number?
243297	1962-12-25	Alselm	Cappello	F	1990-01-01
34335	1960-12-25	Utz	Mandell	M	1990-01-03
400710	1963-12-25	Bouchung	Schreiter	M	1990-01-04
465730	1959-12-25	Baocai	Kushner	F	1990-01-05
490744	1959-12-25	Petter	Stroustrup	M	1990-01-10
*/

SELECT * FROM employees
WHERE hire_date LIKE '199%' 
	AND birth_date LIKE '%-12-25'
ORDER BY hire_date
LIMIT 5 OFFSET 45;


