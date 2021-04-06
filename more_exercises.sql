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