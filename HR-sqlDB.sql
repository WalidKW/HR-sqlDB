/**
* You are free to perform, distribute, and duplicate the work—even for business.
* 
* @Author: Walid K. Alsafadi
*/

DROP SCHEMA

IF EXISTS hr;
	CREATE SCHEMA hr COLLATE = utf8_general_ci;

USE hr;

/* ############# CREATING TABLES ############# */

CREATE TABLE employee(
employee_id INT PRIMARY KEY,
firstname varchar(30) NOT NULL,
secondname varchar(30) NULL,
family varchar(30) NOT NULL,
address varchar(30) NULL,
salary DECIMAL(8, 2) NOT NULL,
manager_id INT NULL,
department_id INT NULL
);

CREATE TABLE department(
	department_id INT PRIMARY KEY,
	department_name VARCHAR(30) NOT NULL,
    employee_id INT NULL
);

CREATE TABLE location(
location_id INT PRIMARY KEY,
location_name VARCHAR(30) NOT NULL,
department_id INT NULL
);

CREATE TABLE dependent(
dependent_id INT PRIMARY KEY,
birthday DATE NULL,
relationship VARCHAR(30) NULL,
dependent_name VARCHAR(30) NULL,
employee_id INT NULL
);

CREATE TABLE project(
project_id INT PRIMARY KEY,
project_name VARCHAR(30) NOT NULL,
department_id INT NULL
);

CREATE TABLE work_on(
work_on_id INT PRIMARY KEY,
employee_id INT NULL,
project_id INT NULL,
numhours INT NULL
);

/* ############# FOREIGN KEYS ############# */


ALTER TABLE employee ADD FOREIGN KEY (manager_id) REFERENCES employee(employee_id);    
ALTER TABLE employee ADD FOREIGN KEY (department_id) REFERENCES department(department_id);
ALTER TABLE location ADD FOREIGN KEY (department_id) REFERENCES department(department_id);
ALTER TABLE department ADD FOREIGN KEY (employee_id) REFERENCES employee(employee_id);
ALTER TABLE project ADD FOREIGN KEY (department_id) REFERENCES department(department_id);
ALTER TABLE dependent ADD FOREIGN KEY (employee_id) REFERENCES employee(employee_id);
ALTER TABLE work_on ADD FOREIGN KEY (employee_id) REFERENCES employee(employee_id);
ALTER TABLE work_on ADD FOREIGN KEY (project_id) REFERENCES project(project_id);

/* ############# 15 Database Applications ############# */

/*1- create sequence each id(start=50, incremental=7,maximum=500).*/

CREATE SEQUENCE employee_seq START WITH 50 INCREMENT BY 7 MAXVALUE 500;
CREATE SEQUENCE department_seq START WITH 50 INCREMENT BY 7 MAXVALUE 500;
CREATE SEQUENCE location_seq START WITH 50 INCREMENT BY 7 MAXVALUE 500;
CREATE SEQUENCE project_seq START WITH 50 INCREMENT BY 7 MAXVALUE 500;
CREATE SEQUENCE work_on_seq START WITH 50 INCREMENT BY 7 MAXVALUE 500;
CREATE SEQUENCE dependent_seq START WITH 50 INCREMENT BY 7 MAXVALUE 500;


/*2- Insert two rows for each table (use sequence to insert id).*/

INSERT INTO employee (employee_id, firstname, secondname, family, address, salary, manager_id, department_id)
VALUES (nextval('employee_seq'), 'Aurthur', 'Burton', 'Morgan', 'IOWA', 2000, 100, 10),
VALUES (nextval('employee_seq'), 'Franklin', NULL, 'Clinton', 'Los Angeles', 100, 110, 20);

INSERT INTO department (department_id, department_name, employee_id)
VALUES (nextval('department_seq'), 'Engineering', 100),
VALUES (nextval('department_seq'), 'Administration', 110);

INSERT INTO location (location_id, location_name, department_id)
VALUES (nextval('location_seq'), 'San Diego', 10),
VALUES (nextval('location_seq'), 'San Francisco', 20);

INSERT INTO project (project_id, project_name, department_id)
VALUES (nextval('project_seq'), 'School', 10),
VALUES (nextval('project_seq'), 'Campus', 20);

INSERT INTO work_on (work_on_id, employee_id, project_id, numhours)
VALUES (nextval('work_on_seq'), 100, 2023001, 4),
VALUES (nextval('work_on_seq'), 110, 2023002, 3);

INSERT INTO dependent (dependent_id, birthday, relationship, dependent_name, employee_id)
VALUES (nextval('dependent_seq'), '1997-01-02', 'Single', 'name1', 100),
VALUES (nextval('dependent_seq'), '1998-03-13', 'Married', 'name2', 110);



/*3- Write a query to retrieve dependent_name, relationship that fathers firstname begins with letter B.*/

SELECT dp.dependent_name, dp.relationship
FROM dependent dp
JOIN employee e ON dp.employee_id = e.employee_id
WHERE e.firstname LIKE 'B%';



/*4- Write a query to retrieve full name for employee(firstname, secondname and family) and address if salary above the 5000.*/

SELECT CONCAT(firstname, ' ', secondname, ' ', family) AS full_name, address
FROM employee
WHERE salary > 5000



/*5- Write a query to retrieve manager name(firstname only) and first name for each employee work on it department.*/

SELECT e1.firstname AS manager_name, e2.firstname AS employee_name
FROM employee e1
JOIN employee e2 ON e1.employee_id = e2.manager_id
JOIN department d ON e2.department_id = d.department_id



/*6- Write a query to get number of dependent for each employee_id.*/

SELECT employee_id, COUNT(*) AS num_dependents
FROM dependent
GROUP BY employee_id



/*7- Write a query retrieve numhours for project is work on it department.*/

SELECT p.project_name, SUM(w.numhours) AS num_hours
FROM project p
JOIN work_on w ON p.project_id = w.project_id
JOIN department d ON p.department_id = d.department_id
GROUP BY p.project_name



/*8- Delete rows in employee if this employee is not work in any project.*/

DELETE FROM employee
WHERE employee_id NOT IN (SELECT employee_id FROM work_on);



/*9- Update salary to plus 100 for manager.*/

UPDATE employee
SET salary = salary + 100
WHERE employee_id IN (SELECT manager_id FROM employee);



/*10- Add a constraint on salary if salary above 1000.*/

ALTER TABLE employee ADD CHECK(salary > 1000);



/*11- Create view to retrieve firstname and project_name and numhours and department_name.*/

CREATE VIEW eFirstname_project_view AS
SELECT e.firstname, p.project_name, w.numhours, d.department_name
FROM employee e
JOIN work_on w ON e.employee_id = w.employee_id
JOIN project p ON w.project_id = p.project_id
JOIN department d ON p.department_id = d.department_id;



/*12- Create synonym for work_on table.*/

CREATE SYNONYM work_syn FOR work_on;



/*13- Drop location table.*/

DROP TABLE location;



/*14- write a query retrieve firstname and project_name where numhours less than 20 and department_name contains "eng" word.*/

SELECT e.firstname, p.project_name
FROM employee e
JOIN work_on w ON e.employee_id = w.employee_id
JOIN project p ON w.project_id = p.project_id
JOIN department d ON p.department_id = d.department_id
WHERE w.numhours < 20 AND d.department_name LIKE '%eng%';



/*15- Modify employee table, add a new column "phone_number". make the column such that if does not accept null values.*/

ALTER TABLE employee ADD phone_number VARCHAR(20) NOT NULL;




