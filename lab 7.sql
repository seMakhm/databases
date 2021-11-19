drop table customers cascade ;
create table customers (
    id integer primary key /*not null*/ ,
    name varchar(255) /*not null*/ ,
    birth_date date /*not null*/
);
drop table accounts cascade ;
create table accounts(
    account_id varchar(40) primary key /*not null*/,
    customer_id integer references customers(id) /*not null*/,
    currency varchar(3) /*not null*/,
    balance float /*not null*/ ,
    "limit" float /*not null*/
);
drop table transactions cascade ;
create table transactions (
    id serial primary key /*not null*/,
    date timestamp /*not null*/,
    src_account varchar(40) references accounts(account_id) /*not null*/,
    dst_account varchar(40) references accounts(account_id) /*not null*/,
    amount float /*not null*/,
    status varchar(20) /*not null*/
);

INSERT INTO customers VALUES (201, 'John', '2021-11-05');
INSERT INTO customers VALUES (202, 'Anny', '2021-11-02');
INSERT INTO customers VALUES (203, 'Rick', '2021-11-24');

INSERT INTO accounts VALUES ('NT10204', 201, 'KZT', 1000, null);
INSERT INTO accounts VALUES ('AB10203', 202, 'USD', 100, 0);
INSERT INTO accounts VALUES ('DK12000', 203, 'EUR', 500, 200);
INSERT INTO accounts VALUES ('NK90123', 201, 'USD', 400, 0);
INSERT INTO accounts VALUES ('RS88012', 203, 'KZT', 5000, -100);

INSERT INTO transactions(date,src_account,dst_account,amount,status) VALUES ('2021-11-05 18:00:34.000000', 'NT10204', 'RS88012', 1000, 'commited');
INSERT INTO transactions(date,src_account,dst_account,amount,status) VALUES ('2021-11-05 18:01:19.000000', 'NK90123', 'AB10203', 500, 'rollback');
INSERT INTO transactions(date,src_account,dst_account,amount,status) VALUES ('2021-06-05 18:02:45.000000', 'RS88012', 'NT10204', 400, 'init');

drop role accountant;
drop role administrator;
drop role support;

create role accountant;
alter role accountant createdb;

create role administrator;
alter role u_adm superuser createdb createrole;

create role support;
alter role u_sup createrole createdb;

drop user u_acc;
create user u_acc password '123456';
grant accountant to u_acc;

drop user u_adm;
create user u_adm password '123456';
grant administrator to u_adm;

drop user u_sup;
create user u_sup password '123456';
grant support to u_sup;

grant select on transactions to u_sup;
revoke select on transactions from u_sup;

update accounts set "limit" = 0 where "limit" is null;
alter table accounts alter column "limit" set not null;

create unique index single_origin
    on accounts (customer_id, currency);

drop materialized view view1;
create materialized view view1 as
SELECT t.id,
       t.date,
       t.src_account,
       t.dst_account,
       t.amount,
       t.status,
       a.currency  AS a1cur,
       a.balance   AS a1bal,
       a2.currency AS a2cur,
       a2.balance  AS a2bal
FROM transactions t
         JOIN accounts a ON a.account_id::text = t.src_account::text
         JOIN accounts a2 ON a2.account_id::text = t.dst_account::text;

create index byCurandBal
    on view1 (a1cur, a1bal, a2cur, a2bal);

alter table accounts
        add constraint limit_check
    check( balance > "limit");

begin;
    UPDATE accounts
        set balance = balance - 400 where account_id = 'RS88012';
    UPDATE accounts
        set balance = balance + 400 where account_id = 'NT10204';
    update transactions set status = 'commited' where status = 'init';
end;

update transactions set status = 'rollback' where status = 'init';


--delete from transactions cascade;
--delete from accounts cascade;
--delete from customers cascade;

