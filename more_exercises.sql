-- ************************************************* ******* Employees Database ************************************* ******************* 
/*
How much do the current managers of each department get paid, relative to the average salary for the department?
 Is there any department where the department manager gets paid less than the average salary?
*/

-- **Manager Salary **the tables that I need is dept_manager and salary to get current  manager salary

SELECT emp_no, dept_no, salary
FROM dept_manager AS dm
JOIN salaries AS sa USING (emp_no)
WHERE dm.to_date >now() AND sa.to_date > now();

-- ***** avg salary by deparment ***** 
SELECT   dept_no, dept_name, AVG(salary) AS avg_salary_by_depto
FROM salaries AS sa
JOIN dept_emp AS de USING (emp_no)
JOIN  departments USING (dept_no)
WHERE sa.to_date > now() AND de.to_date > now()
GROUP BY dept_no;

-- I combine Manager Salary and avg salary by deparment


SELECT emp_no, dept_no, dept_name, salary, avg_salary_by_depto	
FROM (
	SELECT emp_no, dept_no, salary
	FROM dept_manager AS dm
	JOIN salaries AS sa USING (emp_no)
	WHERE dm.to_date >now() AND sa.to_date > now()
) AS manager_salary
JOIN (
	SELECT   dept_no, dept_name, AVG(salary) AS avg_salary_by_depto
	FROM salaries AS sa
	JOIN dept_emp AS de USING (emp_no)
	JOIN  departments USING (dept_no)
	WHERE sa.to_date > now() AND de.to_date > now()
	GROUP BY dept_no
	) AS department_avg USING (dept_no);


  -- I add a column to describe if the manager is paid less or more than the department average  
 SELECT emp_no, dept_no, dept_name, salary, avg_salary_by_depto,
	CASE
	 WHEN salary > avg_salary_by_depto THEN 'more'
	WHEN salary <  avg_salary_by_depto THEN 'less '
	ELSE 'same as avg'
	END AS "Salary in relation to department Avg "
FROM (
	SELECT emp_no, dept_no, salary
	FROM dept_manager AS dm
	JOIN salaries AS sa USING (emp_no)
	WHERE dm.to_date >now() AND sa.to_date > now()
) AS manager_salary
JOIN (
	SELECT   dept_no, dept_name, AVG(salary) AS avg_salary_by_depto
	FROM salaries AS sa
	JOIN dept_emp AS de USING (emp_no)
	JOIN  departments USING (dept_no)
	WHERE sa.to_date > now() AND de.to_date > now()
	GROUP BY dept_no
	) AS department_avg USING (dept_no);

-- ______________________________________________________________________________________________________________________________________________________________
 
 -- *******************************************          WORLD DATABASE          *******************************************  

 
/*
** What languages are spoken in Santa Monica?


+------------+------------+
| Language   | Percentage |
+------------+------------+
| Portuguese |        0.2 |
| Vietnamese |        0.2 |
| Japanese   |        0.2 |
| Korean     |        0.3 |
| Polish     |        0.3 |
| Tagalog    |        0.4 |
| Chinese    |        0.6 |
| Italian    |        0.6 |
| French     |        0.7 |
| German     |        0.7 |
| Spanish    |        7.5 |
| English    |       86.2 |
+------------+------------+
*/
SELECT LANGUAGE, percentage
FROM countrylanguage
WHERE countrycode = 'USA'
ORDER BY percentage;


-- ** How many different countries are in each region?
SELECT region, count(*) AS no_of_countries
FROM country
GROUP BY region
ORDER BY no_of_countries;


-- ** What is the population for each region?
SELECT region, sum(population) AS Population
FROM country
GROUP BY region
ORDER BY Population DESC;


-- ** What is the population for each continent?
SELECT continent, sum(population) AS Population
FROM country
GROUP BY continent
ORDER BY Population DESC;


-- ** What is the average life expectancy globally?
SELECT AVG(lifeexpectancy)
FROM country;

-- ** What is the average life expectancy for each region, each continent? Sort the results from shortest to longest

-- region
SELECT  region, AVG(lifeexpectancy) AS life_expectancy
FROM country
GROUP BY region
ORDER BY life_expectancy;

-- Continent
SELECT  continent, AVG(lifeexpectancy) AS life_expectancy
FROM country
GROUP BY continent
ORDER BY life_expectancy;


-- ***** BONUS **


-- Find all the countries whose local name is different from the official name (135 records)

SELECT NAME, localname
FROM country
WHERE NAME NOT LIKE localname;

-- How many countries have a life expectancy less than China?
SELECT count(*)
FROM country
WHERE lifeexpectancy < (
	SELECT lifeexpectancy
	FROM country
	WHERE NAME= 'China')
ORDER BY NAME;

-- What state is Monterrey located in?
SELECT NAME, district, countrycode
FROM city
WHERE NAME = 'Monterrey';

-- What region of the world is city Monterrey located in?
SELECT ci.name, ci.district, co.name, co.region
FROM city AS ci
JOIN country AS co ON ci.countrycode = co.code
WHERE ci.name = 'Amsterdam';







