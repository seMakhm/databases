/*Functions*/
create or replace FUNCTION inc(val integer) RETURNS integer AS $$
    BEGIN
        RETURN val + 1;
    END;
    $$ LANGUAGE PLPGSQL;
select inc(20);

create or replace FUNCTION summa(val1 integer, val2 integer) RETURNS integer AS $$
    BEGIN
        RETURN val1 + val2;
    END;
    $$ LANGUAGE PLPGSQL;
select summa(20, 21);

create or replace FUNCTION divbytwo(val integer) RETURNS bool AS $$
    declare a bool;
    BEGIN
        if mod(val,2) = 0 then
        a = true;
        end if;
        if mod(val,2) != 0 then
        a = false;
        end if;
        return a;
    END;
    $$ LANGUAGE PLPGSQL;
select divbytwo(19);

create or replace FUNCTION password(val varchar(10)) RETURNS bool AS $$
    declare a bool;
    BEGIN
        if val = '123456' then
        a = true;
        end if;
        if val != '123456' then
        a = false;
        end if;
        return a;
    END;
    $$ LANGUAGE PLPGSQL;
select password('123456');

create or replace FUNCTION twooutput(val int, out a int, out b int) AS $$
    BEGIN
        a = val/2;
        b = val*2;
    END;
    $$ LANGUAGE PLPGSQL;
select twooutput(20);

drop table first_one;
create table first_one (
    id int primary key,
    timestamp timestamp
);

create or replace function time_trigger()
    returns trigger as $$
    declare timing timestamp;
    begin
        timing = new.timetamp;
        return new;
    end;
    $$ language plpgsql;

drop table second cascade;
create table second (
    id int primary key,
    date_of_birth timestamp,
    age int,
    price float,
    price_with_tax int
);

CREATE OR REPLACE FUNCTION age_in_years() RETURNS TRIGGER AS $$
    declare
BEGIN
  new.age := date_part('year' , AGE(now()::timestamp,new.date_of_birth));
  return new;
END
$$ LANGUAGE plpgsql;

drop trigger age_trigger on second;
create trigger age_trigger
    before insert
    on second
    for each row
    execute procedure age_in_years();
truncate second;
insert into second (id, date_of_birth) values (1, '2012-12-12');
select * from second;

create or replace function  tax() returns trigger as $$
    begin
        new.price_with_tax := new.price * 1.12;
        return new;
    end;
    $$ language plpgsql;
drop trigger tax_trigger on second;
create trigger tax_trigger
    before insert or update
    on second
    for each row
    execute procedure tax();
update second set price = 100 where id = 1;
select * from second;

CREATE OR REPLACE FUNCTION no_delete() RETURNS trigger AS $$
    BEGIN
        RAISE EXCEPTION 'no_delete';
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_del_cat BEFORE DELETE ON second /*table name*/
    FOR EACH ROW EXECUTE PROCEDURE no_delete();

delete from second where id = 1;

create or replace function twofunction() returns trigger as $$
    begin
        execute password();
        execute twooutput();
    end;
    $$ language plpgsql;
drop trigger launcher;
create trigger launcher
    before insert
    on second
    for each row
    execute function twofunction();

/*in postgres, procedure has no return, procedure can commit or roll back transactions during its execution, so long as the invoking CALL command is not part of an explicit transaction block*/

drop table first cascade ;
create table first (
    id int primary key,
    date_of_birth timestamp,
    age int,
    salary int,
    workexperience int,
    discount int
);

create or replace procedure bonuses(id int) as $$
    declare
    begin
        update first
        set salary = salary * (1 + 0.1 * (workexperience/2));
        update first
        set discount = 10
        where workexperience >=2;
        update first
        set discount = discount * (1 + 0.01 * (workexperience/5));
        commit;
    end;
    $$ LANGUAGE plpgsql;
truncate first;
insert into first values (1, null, 54, 100, 10, null);
select * from first;
call bonuses(1);
select * from first;

create or replace procedure an_bonuses(id int) as $$
    begin
        update first
        set salary = salary * 1.15
        where age >=40;
        update first
        set salary = salary * 1.15
        where workexperience >=8;
        update first
        set discount = 20
        where workexperience >=8;
    end;
    $$ language plpgsql;
call an_bonuses(1);
select * from first;

drop table members cascade;
create table members (
    memid int primary key,
    surname varchar(200),
    firstname varchar(200),
    address varchar(300),
    zipcode int,
    telephone varchar(20),
    recommendedby int references members(memid),
    joindate timestamp
);

drop table facilities cascade;
create table facilities (
    facid int primary key ,
    name varchar(100),
    membercost numeric,
    guestcost numeric,
    initialoutlay numeric,
    mouthlymaintenance numeric
);

drop table bookings cascade;
create table bookings (
    facid int references facilities(facid),
    memid int references members(memid),
    starttime timestamp,
    slots int,
    primary key(facid, memid)
);

insert into members values (12, 'a', 'a', 'a', 1, 'a', 22 , null);
insert into members values (22, 'b', 'b', 'b', 2, 'b', null, null);
insert into facilities values  (1, 'a', 1, 1,1,1);
insert into bookings values (1,12, null, 1);

with recursive recommenders(recommender) as (
	select recommendedby from members where memid = 12
	union all
	select mems.recommendedby
		from recommenders recs
		inner join members mems
			on mems.memid = recs.recommender
)
select recs.recommender, mems.firstname, mems.surname
	from recommenders recs
	inner join members mems
		on recs.recommender = mems.memid
order by memid desc
