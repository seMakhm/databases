--2-----------------------------------------------------------------------
create table customer (
    id integer primary key,
    full_name varchar(50),
    timestamp timestamp,
    delivery_address text
);

create table orders (
    code integer primary key,
    customer_id integer references customer(id),
    total_sum double precision,
    is_paid boolean
);

create table products (
    id varchar primary key,
    name varchar,
    description text,
    price double precision
);

create table order_items (
    order_code int references orders(code),
    product_id varchar references products(id),
    quantity integer,
    primary key (order_code, product_id)
);

--3-----------------------------------------------------------------------
create table students (
    id integer primary key,
    full_name varchar(50),
    age integer,
    birth_date date,
    gender varchar(10),
    average_grade real,
    info_ab_yourself text,
    dormitory boolean,
    add_info text
);

SELECT * from students;

create table instructors (
    id integer primary key ,
    full_name varchar(50),
    speaking_lan varchar(50),
    work_exp int,
    can_remote boolean
);

SELECT * from instructors;

create table students_instr(
    student_id integer references students(id),
    instructor_id integer references instructors(id)
);


create table lesson_participants(
    lesson_title varchar(30),
    teaching_instructor integer references students_instr(student_id) ,
    studying_students integer references students_instr(instructor_id),
    room_number varchar(30)
);

select * from lesson_participants;

--4-----------------------------------------------------------------------

SELECT * from customer;
insert into customer values (1, 'John John John', '2020-10-10 00:00:00.000000', 'Abay str. 17');
insert into customer values (2, 'John notJohn John', '2020-10-10 00:00:00.000000', 'Abay str. 18');
insert into customer values (3, 'John notJohn notJohn', '2020-10-10 00:00:00.000000', 'Abay str. 19');
SELECT * from customer;

insert into orders values (1, 1, 100000, false);
insert into orders values (2, 3, 500000, false);
SELECT * from orders;

update orders set is_paid = true where total_sum<500000;
SELECT * from orders;

delete from orders where is_paid = true;
SELECT * from orders;

truncate customer cascade ;
SELECT * from customer;
SELECT * from orders;