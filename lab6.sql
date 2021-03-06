create table dealer (
    id integer primary key ,
    name varchar(255),
    location varchar(255),
    charge float
);

INSERT INTO dealer (id, name, location, charge) VALUES (101, 'Ерлан', 'Алматы', 0.15);
INSERT INTO dealer (id, name, location, charge) VALUES (102, 'Жасмин', 'Караганда', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (105, 'Азамат', 'Нур-Султан', 0.11);
INSERT INTO dealer (id, name, location, charge) VALUES (106, 'Канат', 'Караганда', 0.14);
INSERT INTO dealer (id, name, location, charge) VALUES (107, 'Евгений', 'Атырау', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (103, 'Жулдыз', 'Актобе', 0.12);

create table client (
    id integer primary key ,
    name varchar(255),
    city varchar(255),
    priority integer,
    dealer_id integer references dealer(id)
);

INSERT INTO client (id, name, city, priority, dealer_id) VALUES (802, 'Айша', 'Алматы', 100, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (807, 'Даулет', 'Алматы', 200, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (805, 'Али', 'Кокшетау', 200, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (808, 'Ильяс', 'Нур-Султан', 300, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (804, 'Алия', 'Караганда', 300, 106);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (809, 'Саша', 'Шымкент', 100, 103);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (803, 'Маша', 'Семей', 200, 107);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (801, 'Максат', 'Нур-Султан', null, 105);

create table sell (
    id integer primary key,
    amount float,
    date timestamp,
    client_id integer references client(id),
    dealer_id integer references dealer(id)
);

INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (201, 150.5, '2012-10-05 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (209, 270.65, '2012-09-10 00:00:00.000000', 801, 105);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (202, 65.26, '2012-10-05 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (204, 110.5, '2012-08-17 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (207, 948.5, '2012-09-10 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (205, 2400.6, '2012-07-27 00:00:00.000000', 807, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (208, 5760, '2012-09-10 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (210, 1983.43, '2012-10-10 00:00:00.000000', 804, 106);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (203, 2480.4, '2012-10-10 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (212, 250.45, '2012-06-27 00:00:00.000000', 808, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (211, 75.29, '2012-08-17 00:00:00.000000', 803, 107);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (213, 3045.6, '2012-04-25 00:00:00.000000', 802, 101);

-- drop table client;
-- drop table dealer;
-- drop table sell;

--join

--a
SELECT *, c.id, c.name
FROM dealer as d
    FULL OUTER JOIN client as c
        ON d.id = c.dealer_id;

--b
SELECT *
FROM sell as s
    inner join client as c
        on c.id = s.client_id
    inner join dealer as d
        on d.id = s.dealer_id;


--c
SELECT d.id, c.id
FROM dealer as d
    INNER JOIN client as c
        ON d.location = c.city;

--e
select dealer.id from dealer;

--d
SELECT s.id, s.amount, c.name, c.city
from client as c
    join sell as s
        on c.id = s.client_id
where amount between 100 and 500;

--f
select c.name,  c.city, d.name, d.charge
from dealer as d
    join client c on d.id = c.dealer_id;

--g
select c.name,  c.city, d.name, d.charge
from dealer as d
    join client c on d.id = c.dealer_id
where charge > 0.12;

--h
select c.name, c.city, s.id, s.date, s.amount, d.name, d.charge
from client c
    left join sell s on c.id = s.client_id
    left join dealer d on s.dealer_id = d.id;

--i
select  c.name, c.priority, d.name, s.id, s.amount
from dealer d
    inner join client c on c.dealer_id = d.id
    inner join sell s on s.client_id = c.id
        where (c.priority is not null and s.amount>2000) or c.priority is not null;

--views

--a
drop view a_view;
create or replace view a_view as
    select count(c.name),
       s.date,
        avg(s.amount),
        sum(s.amount)
    from sell s
        inner join client c on s.client_id = c.id group by s.date;

--b

drop view b_view;
create or replace view b_view as
select s.date, sum(amount)
from sell s
    group by s.date
    order by sum(amount)
    limit 5;

--c
drop view c_view;
create or replace view c_view as
select s.dealer_id,
       count(s.amount),
       avg(s.amount),
       sum(s.amount)
from sell s
group by dealer_id;

--d
drop view d_view;
create or replace view d_view as
select location, sum(s.amount*d.charge)
    from sell s
    left join dealer d on d.id = s.dealer_id
    group by location;

--e
drop view e_view;
create or replace view e_view as
select d.location, count(s.amount), avg(s.amount), sum(s.amount)
from sell s
    inner join dealer d on d.id = s.dealer_id
group by location;

--f
drop view f_view;
create or replace view f_view as
select c.city, count(s.amount), avg(s.amount), sum(s.amount)
    from client c
        left join sell s on c.id = s.client_id
group by c.city;

--g
drop view g_view;
create or replace view g_view as
select f.city, f.sum as exp, e.sum as sales
from f_view f
    inner join e_view e on f.city = e.location
where f.sum > e.sum;



