-- 4. List all the tables in the database
SHOW DATABASES;


-- 5. Explore the employees table. What different data types are present on this table? DATA TYPES :INT, DATA, VARCHAR, ENUM,  DATE
USE employees;

-- 6. Which table(s) do you think contain a numeric type column? Salaries, departments, dept_emp, dept_manager, employees, titles

-- 7. Which table(s) do you think contain a string type column? Departments, dept_emp, dept_manager, employees, titles

-- 8. Which table(s) do you think contain a date type column? dept_emp, dept_manager, employees, salaries

-- 9. What is the relationship between the employees and the departments tables? they do not have any column in common. the table dept_emp is where
-- we can see a relation empl_no and dept_no

-- 10.Show the SQL that created the dept_manager table. it is found in Table info.
CREATE TABLE `dept_manager` (
  `emp_no` int(11) NOT NULL,
  `dept_no` char(4) NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  PRIMARY KEY (`emp_no`,`dept_no`),
  KEY `dept_no` (`dept_no`),
  CONSTRAINT `dept_manager_ibfk_1` FOREIGN KEY (`emp_no`) REFERENCES `employees` (`emp_no`) ON DELETE CASCADE,
  CONSTRAINT `dept_manager_ibfk_2` FOREIGN KEY (`dept_no`) REFERENCES `departments` (`dept_no`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;