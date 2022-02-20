-- Deliverable 1
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

