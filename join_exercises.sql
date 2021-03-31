-- *** JOINS EXERCISES ****


-- 1.Use the join_example_db. Select all the records from both the users and roles tables.
SELECT * 
FROM users;
SELECT *
FROM roles;

/*
2. Use join, left join, and right join to combine results from the users and roles tables as we did in the lesson.
 Before you run each query, guess the expected number of results.
*/

-- left join
SELECT *
FROM users
LEFT JOIN roles ON users.role_id = roles.id;
/*
id  name    email                role_id     id      name
1	bob	    bob@example.com	        1	        1	    admin
2	joe	    joe@example.com	        2	        2	    author
3	sally	sally@example.com	    3	        3	    reviewer
4	adam	adam@example.com	    3	        3	    reviewer
5	jane	jane@example.com	    NULL	    NULL	NULL
6	mike	mike@example.com	    NULL	    NULL	NULL
*/
--Right join
SELECT *
FROM users
RIGHT JOIN roles ON users.role_id = roles.id;
/*
id  name    email                role_id     id      name
1	bob	    bob@example.com	        1	    1	    admin
2	joe	    joe@example.com	        2	    2	    author
3	sally	sally@example.com	    3	    3	    reviewer
4	adam	adam@example.com	    3	    3	    reviewer
NULL	NULL	    NULL	    NULL	    4	    commenter
*/
-- Inner Join
SELECT *
FROM users
JOIN roles ON users.role_id = roles.id;

/*
id  name    email                role_id     id      name
1	bob	    bob@example.com	        1	      1	    admin
2	joe	    joe@example.com	        2	      2	    author
3	sally	sally@example.com	    3	      3     reviewer
4	adam	adam@example.com	    3	      3	    reviewer
*/


/*
3. Although not explicitly covered in the lesson, aggregate functions like count can be used with
 join queries.
 Use count and the appropriate join type to get a list of roles along with the number of users 
 that has the role. 
 Hint: You will also need to use group by in the query.
*/
SELECT role_id, roles.name, COUNT(*) AS total_users
FROM users
JOIN roles ON users.role_id = roles.id
GROUP BY role_id;
--  **** Employees Database *****

/*
2.Using the example in the Associative Table Joins section as a guide,
 write a query that shows each department along with the name of the current manager for that department.
*/

SELECT dept_name as "Department Name", CONCAT (C.first_name, '  ',C.last_name) AS "Department Manager"
FROM departments AS A
JOIN dept_manager AS B ON A.dept_no = B.dept_no
JOIN employees AS C ON B.emp_no = C.emp_no
WHERE to_date LIKE '9999%'
ORDER BY dept_name;

-- 3. Find the name of all departments currently managed by women.

SELECT dept_name, CONCAT (C.first_name, '  ',C.last_name) AS Manager_Name
FROM departments AS A
JOIN dept_manager AS B ON A.dept_no = B.dept_no
JOIN employees AS C ON B.emp_no = C.emp_no
WHERE to_date LIKE '9999%' AND gender ='F'  --WHERE to_date > NOW() AND gender ='F' is other way
ORDER BY dept_name;

--4. Find the current titles of employees currently working in the Customer Service department.
SELECT  title,   COUNT(title) AS total_employees
FROM employees AS A
JOIN titles AS B ON A.emp_no = B.emp_no
JOIN dept_emp AS C ON B.emp_no = C.emp_no	
WHERE C.dept_no = 'd009' AND B.to_date LIKE '9999%'
AND C.to_date > now()
GROUP BY title;

--5.  Find the current salary of all current managers.

SELECT dept_name AS "Department Name", CONCAT (C.first_name, '  ',C.last_name) AS "Name", salary
FROM departments AS A
JOIN dept_manager AS B ON A.dept_no = B.dept_no
JOIN employees AS C ON B.emp_no = C.emp_no
JOIN salaries AS D ON D.emp_no = C.emp_no
WHERE B.to_date LIKE '9999%' AND D.to_date LIKE '9999%'
ORDER BY dept_name;

-- 6. Find the number of current employees in each department.
SELECT dept_no, dept_name, count(*) AS num_employees
FROM departments
JOIN dept_emp USING (dept_no)
WHERE to_date LIKE '9999%'
GROUP BY dept_no;


/*
7 Which department has the highest average salary? 
Hint: Use current not historic information.
*/

SELECT dept_name, AVG (salary) AS average_salary
FROM departments
JOIN dept_emp USING (dept_no)
JOIN salaries USING (emp_no) 
WHERE dept_emp.to_date > now()  AND salaries.to_date > now() 
GROUP BY dept_name
ORDER BY AVG (salary) DESC
LIMIT  1;



-- 8.  Who is the highest paid employee in the Marketing department?
SELECT first_name, last_name, salary
FROM employees
JOIN dept_emp USING(emp_no)
JOIN salaries USING(emp_no)
WHERE dept_no = 'd001' AND salaries.to_date LIKE '999%'
ORDER BY salary DESC
LIMIT 1

-- 9. Which current department manager has the highest salary?
SELECT  C.first_name, C.last_name,  salary, dept_name
FROM departments AS A
JOIN dept_manager AS B ON A.dept_no = B.dept_no
JOIN employees AS C ON B.emp_no = C.emp_no
JOIN salaries AS D ON D.emp_no = C.emp_no
WHERE B.to_date LIKE '9999%' AND D.to_date LIKE '9999%'
ORDER BY salary DESC
LIMIT 1

--10.  Bonus Find the names of all current employees, their department name,
-- and their current manager's name.

SELECT   CONCAT(emp.first_name, ' ', emp.last_name) AS 'Employee_Name', 
departments.dept_name AS "Department Name",
CONCAT(mn.first_name,' ', mn.last_name) AS "Employee Manager"
FROM employees AS emp
JOIN dept_emp AS dep ON emp.emp_no = dep.emp_no
	AND dep.to_date > now()  	
JOIN departments ON dep.dept_no = departments.dept_no
JOIN dept_manager AS man ON man.dept_no = departments.dept_no
AND man.to_date > now()	
JOIN employees AS mn ON mn.emp_no = man.emp_no
ORDER BY departments.dept_name, emp.emp_no ;


--11. Bonus Who is the highest paid employee within each department.

SELECT  C.first_name, C.last_name,  salary, dept_name
FROM departments AS A
JOIN dept_manager AS B ON A.dept_no = B.dept_no
JOIN employees AS C ON B.emp_no = C.emp_no
JOIN salaries AS D ON D.emp_no = C.emp_no
WHERE B.to_date LIKE '9999%' AND D.to_date LIKE '9999%'
ORDER BY salary DESC;
