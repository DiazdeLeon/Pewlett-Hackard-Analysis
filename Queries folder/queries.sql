-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
  emp_no INT NOT NULL,
  dept_no VARCHAR(4) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL
);

CREATE TABLE title (
  emp_no INT NOT NULL,
  title VARCHAR(4) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL
);

SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM title;

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- Create new table for retiring employees
DROP TABLE retirement_info,
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info_v1.emp_no,
    retirement_info_v1.first_name,
	retirement_info_v1.last_name,
    dept_emp.to_date
FROM retirement_info_v1
LEFT JOIN dept_emp
ON retirement_info_v1.emp_no = dept_emp.emp_no;

SELECT ri.emp_no,
       ri.first_name,
	   ri.last_name,
       de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;
WHERE de.to_date = ('9999-01-01');


SELECT ri.emp_no,
       ri.first_name,
       ri.last_name,
	   de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

--What is the average cost of rent a film in the Sakila stores?
select avg(rental_rate) as rental_av_rate
from film;

-- What is the average rental cost of films by rating? 
--On average, what is the cheapest rating of films to rent? What is the most expensive?
select rating, avg(rental_rate) as rental_av_rate_by_rating
from film
group by rating
order by avg(rental_rate)

-- How much would it cost to replace all films in the database?
select sum(replacement_cost) as total_cost
from film

-- How much would it cost to replace all films in each ratings category?
select rating, sum(replacement_cost) as total_cost
from film
group by rating

-- How long is the longest movie in the database? 
select max(length)
from film

--How long is the shortest movie?
select min(length)
from film

select rental_rate, round(avg(length),2) as "Average Length"
from film
group by rental_rate

select replacement_cost, round(avg(length),2) as Average_Length
from film
group by replacement_cost
order by Average_Length DESC, replacement_cost
Limit 5

-- Determine the count of actor first names ordered in descending order.
select first_name, count(first_name) as namecount
from actor
group by first_name
order by namecount desc

-- Determine the average rental duration for each rating rounded to two decimals. Order these in ascending order.
Select rating, round(avg(rental_duration),2) as rentalduration
from film
group by rating
order by rentalduration

-- Determine the top 10 average replace costs for length of the movie.
select length, round(sum(replacement_cost),2) as replacement_cost
from film
group by length
order by replacement_cost desc
limit 10

-- Bonus. Using the city and country tables, determine the number of cities in each country from the database in descending order.
select cr.country, count(ci.city) as cities
from city as ci
inner join country as cr
on ci.country_id = cr.country_id
group by cr.country
order by cities desc

---DISTINCT EXERCISES
Select count(customer_id)
from rental

Select count(DISTINCT customer_id)
from rental

Select DISTINCT customer_id, inventory_id
from rental
order by customer_id, inventory_id desc;

Select DISTINCT ON (customer_id)customer_id, inventory_id
from rental
order by customer_id, inventory_id desc;

Select Count(DISTINCT customer_id) from rental;

--Retrieve the latest rental for each customer's first and last name and email address.
select distinct on (c.customer_id)
c.first_name,
c.last_name,
c.email,
r.rental_date
from rental as r
inner join customer as c
on r.customer_id = c.customer_id
order by c.customer_id, r.rental_date desc

--Retrieve the latest rental date for each title.
select distinct on (f.title)
f.title,
r.rental_date
from rental as r
inner join inventory as i
on i.inventory_id = r.inventory_id
inner join film as f
on i.inventory_id = f.film_id
order by f.title, r.rental_date desc

--missing movies
select film_id, title
from film
where film_id not in
    (select film_id
       from inventory)

       -- Deliverable 1
DROP TABLE retirement_titles;
SELECT em.emp_no, 
        em.first_name, 
	    em.last_name,
	    tt.title,
	    tt.from_date,
	    tt.to_date
INTO retirement_titles
FROM employees as em
INNER JOIN title as tt
ON em.emp_no = tt.emp_no
	WHERE (em.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY em.emp_no;

SELECT * FROM retirement_titles;

--Removing duplicates
DROP TABLE unique_titles;
SELECT DISTINCT ON (rt.emp_no)
	   rt.emp_no,
	   rt.first_name,
	   rt.last_name,
	   rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY rt.emp_no, rt.to_date DESC;


--keep only current employees--

DROP TABLE retirement_titles;
SELECT COUNT(ut.title), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY count DESC;

SELECT * FROM retiring_titles;


-- Joining departments and dept_emp tables
SELECT departments.dept_name,
     dept_emp.emp_no,
     dept_emp.from_date,
     dept_emp.to_date
INTO full_dep
FROM departments
INNER JOIN dept_emp
ON departments.dept_no = dept_emp.dept_no;

SELECT ut.emp_no,
     ut.title,
	 ut.first_name,
	 ut.last_name,
	 fp.dept_name
INTO retirees_per_dep
FROM unique_titles as ut
INNER JOIN full_dep as fp
ON ut.emp_no = fp.emp_no

select * from retirees_per_dep; 

select dept_name, title, count(title) as titlecount
from retirees_per_dep
group by dept_name, title
order by dept_name desc
limit 15

-- DELIVERABLE 2
SELECT DISTINCT ON (em.emp_no)
        em.first_name, 
	    em.last_name,
		em.birth_date,
		dep.from_date,
		dep.to_date,
		tt.title
INTO mentorship_eligibility 	
FROM employees as em
INNER JOIN dept_emp as dep
ON em.emp_no = dep.emp_no
INNER JOIN title as tt
ON em.emp_no = tt.emp_no
WHERE (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (dep.to_date = '9999-01-01')
ORDER BY em.emp_no, tt.from_date DESC;

select * from mentorship_eligibility 

select title, count(title) as titlecount
from mentorship_eligibility
group by title
order by titlecount desc


--Deliverable 3
SELECT ut.emp_no,
	   ut.first_name,
	   ut.last_name,
	   ut.title,
	   em.gender
INTO unique_titles_by_gender
FROM unique_titles as ut
INNER JOIN employees as em
on em.emp_no = ut.emp_no

SELECT * FROM unique_titles_by_gender;

select gender, count(gender) as gendercount
from unique_titles_by_gender
group by gender
order by gendercount desc;

select gender, title, count(title) as titlecount
from unique_titles_by_gender
group by title, gender
order by gender desc;

SELECT ug.emp_no,
	   ug.first_name,
	   ug.last_name,
	   ug.title,
	   ug.gender,
	   sa.salary
INTO unique_titles_by_salaries_and_gender
FROM unique_titles_by_gender as ug
INNER JOIN salaries as sa
on sa.emp_no = ug.emp_no

select * from unique_titles_by_salaries_and_gender;

--table of averge salary by gender
select gender, round(avg(salary),2) as avgsalary
from unique_titles_by_salaries_and_gender
group by gender
order by avgsalary desc;

--table of gender and title and salary

select title, round(avg(salary),2) as F_avgsalary
into female_salary
from unique_titles_by_salaries_and_gender
where unique_titles_by_salaries_and_gender.gender = 'F'
group by title
select title, round(avg(salary),2) as M_avgsalary
into male_salary
from unique_titles_by_salaries_and_gender
where unique_titles_by_salaries_and_gender.gender = 'M'
group by title

select f.title, f.F_avgsalary, m.M_avgsalary
from female_salary f
inner join male_salary m
on f.title = m.title

--table of gender and title

select title, count(title) as F_countitle
into female_title
from unique_titles_by_gender
where unique_titles_by_gender.gender = 'F'
group by title
select title, count(title) as M_countitle
into male_title
from unique_titles_by_gender
where unique_titles_by_gender.gender = 'M'
group by title

select f.title, f.F_countitle, m.M_countitle
from female_title f
inner join male_title m
on f.title = m.title

--Count current employees
select gender, count(gender) as gender_count
from employees
group by gender

