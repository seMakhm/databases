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
