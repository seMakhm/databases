--1
--a
select * from course where credits > 3;

--b
select * from classroom where building = 'Watson' or building = 'Packard';

--c
select * from course where dept_name = 'Comp. Sci.';

--d
select * from section  where semester = 'Fall';

--e
select * from student where tot_cred between 45 and 90;

--f
select * from student where name ~ '[^aeiou]$';

--g
select * from prereq where prereq_id = 'CS-101';

--2
--a
select i.dept_name,
       avg(i.salary)
    from instructor i
group by i.dept_name
order by i.dept_name asc;

--b
select building --, count(course_id)
    from section
group by building;

--c
select dept_name --, (count(course_id))
    from course
group by dept_name
order by count(*) asc
limit 1;

--d
select s.id, s.name
    from student s
    inner join course c on s.dept_name = c.dept_name
        where s.dept_name = 'Comp. Sci.' and c.credits > 3;

--e
select id from instructor where dept_name = 'Biology' or dept_name = 'Philosophy' or dept_name = 'Music';

--f

select t.id
    from teaches t
    inner join section s on t.course_id = s.course_id;

--3
--a
select ID from takes where grade = 'A' or grade = 'A-' group by ID;

--b
select a.i_ID
    from advisor a
        inner join takes t on t.ID = a.s_ID
    where grade = 'F'
        or grade = 'F-'
        or grade = 'F+'
        or grade = 'C+'
        or grade = 'C-'
        or grade = 'C'
group by a.i_ID;

--c
select dept_name
    from takes t
        inner join student s on t.ID = s.ID
    where grade != 'F'
    and grade != 'C'
    group by dept_name;

--d
select i.i_ID--, grade
    from takes t
        inner join advisor i on i.s_ID = t.id
    where grade != 'A'
    group by i.i_ID;

--e
select time_slot_id, end_hr, end_min
    from time_slot
    where end_hr <=13 and end_min = 0
    or end_hr <=12 and end_min <=59;