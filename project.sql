drop table country cascade;
create table country(
    id int primary key,
    name varchar(255)
);

drop table city cascade ;
create table city (
    id int primary key,
    name varchar(255),
    country int references country(id)
);

drop table street cascade ;
create table street (
    id int primary key,
    name varchar(255),
    city int references city(id)
);

drop table client cascade;
create table client (
    id integer primary key,
    name varchar(255),
    type varchar(255),
    address int references street(id)
);

drop table payment_type cascade;
create table payment_type(
    id int primary key,
    type varchar(255),
    discount float
);

drop table packaging cascade ;
create table packaging (
id int primary key,
package varchar(255),
cost float
);

drop table content_type cascade;
create table content_type(
    id int primary key,
    name varchar(255), /* что лежит в посылке (стеклянныйй предмет, электроника и тд) */
    packaging int references packaging(id)/* как нужно упаковать посылку*/
);

drop table content cascade;
create table content(
    id int primary key,
    name varchar(255),
    type int references content_type(id),
    length float,
    wight float,
    height float,
    client_from int references client(id), /* чью посылку отправили */
    client_to int references client(id), /* к кому должны отправить */
    cost float,
    time_limit date
);

drop table payment cascade;
create table payment(
    id int primary key, /* один и тот же человек может заказать один и тот же товар */
    type int references payment_type(id), /* как оплатили */
    content int references content(id), /* что находится в посылке */
    date date, /* когда оплатили */
    amount float /* сколько заплатили */
);

drop table place_type cascade;
create table place_type (
id int primary key,
type varchar(255), /* что за место (фургон, склад) */
number int, /* номер места(фургона, склада)*/
charge float
/* ,firm varchar(255)*/
);

drop table place cascade;
create table place (
place_type int references place_type(id), /* вид транспортировки */
content int references content(id), /* какие посылки находились в этом месте */
date date, /* дата когда посылка попала сюда */
latitude float,
longitude float,
time_limit date, /* до какого числа должны доставить */
primary key (content, place_type)
);
/* INSERTS*/

insert into country (id, name) values (1, 'Kazakhstan');
insert into country (id, name) values (2, 'Russia');
insert into country (id, name) values (3, 'China');

insert into city (id, name, country) VALUES (1, 'Almaty',       1);
insert into city (id, name, country) VALUES (2, 'Nur-sultan',   1);
insert into city (id, name, country) VALUES (3, 'Moscow',       3);
insert into city (id, name, country) VALUES (4, 'Rostov',       2);
insert into city (id, name, country) VALUES (5, 'Beijing',      3);

insert into street (id, name, city) VALUES (1, 'Gogol', 1);
insert into street (id, name, city) VALUES (2, 'Pushkin', 2);
insert into street (id, name, city) VALUES (3, 'Dostyk', 2);
insert into street (id, name, city) VALUES (4, 'Furmanov', 1);
insert into street (id, name, city) VALUES (5, 'Gogol', 3);
insert into street (id, name, city) VALUES (6, 'Gogol', 4);
insert into street (id, name, city) VALUES (7, 'Xi', 5);

insert into client (id, name, type, address ) values (1,    'ABC Astana',          'company',   2);
insert into client (id, name, type, address) values (2,     'Farhad Aibek',        'customer',  2);
insert into client (id, name, type, address) values (3,     'Ivan Ivanov',         'customer',  5);
insert into client (id, name, type, address) values (4,     'Svetlana Nevazhnova', 'customer',  1);
insert into client (id, name, type, address) values (5,     'Zhansait Tulebekov',  'customer',  4);
insert into client (id, name, type, address) values (6,     'Kaspiskiy',           'company',   5);
insert into client (id, name, type, address) values (7,     'Ashahid Utebaev',     'customer',  1);
insert into client (id, name, type, address) values (8,     'Vladimir Morozov',    'customer',  1);
insert into client (id, name, type, address) values (9,     'Aset Tasbulat',       'customer',  2);
insert into client (id, name, type, address) values (10,    'Aigul Kadirova',      'customer',  3);
insert into client (id, name, type, address) values (11,    'Xin Lea',             'customer',  7);

insert into payment_type (id, type, discount) values (1, 'cash', 1);
insert into payment_type (id, type, discount) values (2, 'card', 1);
insert into payment_type (id, type, discount) values (3, 'card with discount', 0.9);

insert into packaging (id, package, cost) values (1, 'box', 10);
insert into packaging (id, package, cost) values (2, 'waterproof box', 15);
insert into packaging (id, package, cost) values (3, 'waterproof box for breakable things', 20);

insert into content_type (id, name, packaging) values (1, 'electronics', 3);
insert into content_type (id, name, packaging) values (2, 'textile', 2);
insert into content_type (id, name, packaging) values (3, 'plastic materials', 1);
insert into content_type (id, name, packaging) values (4, 'glass', 3);
insert into content_type (id, name, packaging) values (5, 'wood', 1);

insert into content (id, name, type, length, wight, height, client_from, client_to, cost, time_limit) VALUES (1,'keyboard',1, 0.1, 0.01, 0.01, 11, 9, 99.99, '2021-12-03');
insert into content (id, name, type, length, wight, height, client_from, client_to, cost, time_limit) VALUES (2 ,'Boch wineglasses',4, 0.1, 0.1, 0.1, 3, 4, 50, '2021-12-03');
insert into content (id, name, type, length, wight, height, client_from, client_to, cost, time_limit) VALUES (3 ,'SonyTV-18924b',4, 3, 1, 2, 10, 3, 10000, '2021-12-03');
insert into content (id, name, type, length, wight, height, client_from, client_to, cost, time_limit) VALUES (4 ,'Samsung galaxy s10', 1, 0.01, 0.01, 0.01, 9, 7, 1000, '2021-12-03');
insert into content (id, name, type, length, wight, height, client_from, client_to, cost, time_limit) VALUES (5 ,'Apple Iphone 11', 1, 0.01, 0.01, 0.01, 9, 7, 1000,'2021-12-01');
insert into content (id, name, type, length, wight, height, client_from, client_to, cost, time_limit) VALUES (6 ,'Ikea table', 5, 0.3, 0.3, 0.3, 6, 8, 79,'2021-12-04');
insert into content (id, name, type, length, wight, height, client_from, client_to, cost, time_limit) VALUES (7 ,'KitchenAid coffee machine 78abc', 4, 3, 1, 2, 10, 3, 10000,'2021-12-03');
insert into content (id, name, type, length, wight, height, client_from, client_to, cost, time_limit) VALUES (8 ,'Iron Gym horizontal bar', 4, 3, 1, 2, 10, 3, 10000,'2021-12-05');
insert into content (id, name, type, length, wight, height, client_from, client_to, cost, time_limit) VALUES (9 ,'Zara t-short',4, 3, 1, 2, 10, 3, 10000,'2021-11-30');
insert into content (id, name, type, length, wight, height, client_from, client_to, cost, time_limit) VALUES (10 ,'Intex inflatable pool', 2, 0.3, 0.3, 0.3, 1, 3, 1000,'2021-11-29');
insert into content (id, name, type, length, wight, height, client_from, client_to, cost, time_limit) VALUES (11 ,'Rehau window', 4, 3, 0.4, 2, 1, 2, 500,'2021-11-30');

insert into payment (id, type, content, date, amount) VALUES (1,1, 1, '2021-12-01', 10);
insert into payment (id, type, content, date, amount) VALUES (2, 1, 2, '2021-12-01', 10);
insert into payment (id, type, content, date, amount) VALUES (3, 1, 3, '2021-12-01', 100);
insert into payment (id, type, content, date, amount) VALUES (4, 1, 4, '2021-12-01', 10);
insert into payment (id, type, content, date, amount) VALUES (5, 1, 5, '2021-12-01',10);
insert into payment (id, type, content, date, amount) VALUES (6, 1, 6, '2021-12-01', 10);
insert into payment (id, type, content, date, amount) VALUES (7, 1, 7, '2021-12-01', 10);
insert into payment (id, type, content, date, amount) VALUES (8, 1, 8, '2021-12-01', 20);
insert into payment (id, type, content, date, amount) VALUES (9, 1, 9, '2021-12-01', 10);
insert into payment (id, type, content, date, amount) VALUES (10, 1, 10, '2021-12-01',10);
insert into payment (id, type, content, date, amount) VALUES (11, 1, 11, '2021-12-01', 100);

insert into place_type (id, type, number, charge) VALUES (1, 'truck', '1721', 1);
insert into place_type (id, type, number, charge) VALUES (2, 'plane', '1848', 2);
insert into place_type (id, type, number, charge) VALUES (3, 'track', '84', 1);
insert into place_type (id, type, number, charge) VALUES (5, 'track', '18', 1);

insert into place (place_type, content, date, latitude, longitude) VALUES (1, 1, '2021-11-29', 43.238719, 76.889667);
insert into place (place_type, content, date, latitude, longitude) VALUES (1, 2, '2021-11-30', 43.253813, 76.931201);
insert into place (place_type, content, date, latitude, longitude) VALUES (1, 3, '2021-12-01',43.251091, 76.947109);
insert into place (place_type, content, date, latitude, longitude) VALUES (1, 4, '2021-12-01',43.251091, 76.947109);
insert into place (place_type, content, date, latitude, longitude) VALUES (2, 5, '2021-11-30', 47.733598, 74.268089);
insert into place (place_type, content, date, latitude, longitude) VALUES (2, 8, '2021-12-01',51.050058, 71.323885);
insert into place (place_type, content, date, latitude, longitude) VALUES (2, 7, '2021-12-01',43.858990, 77.043153);
insert into place (place_type, content, date, latitude, longitude) VALUES (2, 11,'2021-12-01', 43.212183, 76.647554);
insert into place (place_type, content, date, latitude, longitude) VALUES (3, 5, '2021-12-01', 43.139153, 76.903235);
insert into place (place_type, content, date, latitude, longitude) VALUES (3, 10,'2021-12-01', 43.217800, 77.098667);
insert into place (place_type, content, date, latitude, longitude) VALUES (3, 8, '2021-12-01', 43.231056, 76.951547);
insert into place (place_type, content, date, latitude, longitude) VALUES (3, 7, '2021-12-01', 43.237725, 76.916061);
insert into place (place_type, content, date, latitude, longitude) VALUES (5, 5, '2021-12-02', 43.240046, 76.894989);
insert into place (place_type, content, date, latitude, longitude) VALUES (5, 6, '2021-12-01', 43.249655, 76.853699);
insert into place (place_type, content, date, latitude, longitude) VALUES (5, 4, '2021-11-30', 52.901133, 70.194198);
insert into place (place_type, content, date, latitude, longitude) VALUES (5, 3, '2021-11-30', 52.259825, 76.755238);

/* QUERIES */

/*drop view first_view_1 cascade;*/
create view first_view_1 as
    select co.client_from as customers /*, pa.content*/
    from content co
        inner join place pl
            on co.id = pl.content
        inner join place_type pt
            on pl.place_type = pt.id
    where pt.type = 'truck'
      and pt.number = '1721'
      and pl.date = '2021-12-01'::date
/*group by cl.id*/;

/*drop view first_view_2 cascade;*/
create view first_view_2 as
    select co.client_to as recipients /*, pa.content*/
    from content co
        inner join place pl
            on co.id = pl.content
        inner join place_type pt
            on pl.place_type = pt.id
    where pt.type = 'truck'
      and pt.number = '1721'
      and pl.date = '2021-12-01'::date
/*group by cl.id*/;

/*drop view first_view_3 cascade;*/
create view first_view_3 as
    select co.id as last_content /*, pa.content*/
    from content co
        inner join place pl
            on co.id = pl.content
        inner join place_type pt
            on pl.place_type = pt.id
    where pt.type = 'truck'
      and pt.number = '1721'
      and pl.date < '2021-12-01'::date
    order by pl.date
    limit 1;

/*drop view second_view cascade;*/
create view second_view as
    select cl.id as client, count(co.id) as amount_packages
    from client cl
        inner join content co
            on cl.id = co.client_from
        inner join payment p
            on p.content = co.id and extract(year from p.date) = 2021
    group by cl.id
    limit 1;

/*drop view third_view cascade;*/
create view third_view as
    select cl.id as client, sum(p.amount) as amount_spent
    from client cl
    inner join content c
        on cl.id = c.client_from
    inner join payment p
        on c.id = p.content
    group by cl.id
    limit 1;

/* drop view forth_view cascade; */
create view forth_view as
    select mode() within group ( order by client.id ) as most_common_city from client;

/* drop view fifth_view cascade; */
create view fifth_view as
    select c.id from place p
    inner join content c on p.content = c.id
    where p.date < c.time_limit;

/* drop view first_bill cascade; */
create view first_bill as
    select cl.id, c.id, (pa.cost+p.amount) as total, s.name as street, ci.name as city, co.name as country from payment p
    inner join content c on p.content = c.id
    inner join client cl on cl.id = c.client_from
    inner join street s on cl.address = s.id
    inner join city ci on s.city = ci.id
    inner join content_type ct on c.type = ct.id
    inner join packaging pa on ct.packaging = pa.id
    inner join country co on ci.country = co.id
/*where cl.id = 1*/;

/* drop view second_bill cascade; */
select cl.id, pa.cost as for_packaging, p.amount as cost_of_shipping, (pa.cost+p.amount) as total from client cl
inner join content c on cl.id = c.client_from
inner join payment p on c.id = p.content
inner join content_type ct on c.type = ct.id
inner join packaging pa on ct.packaging = pa.id
inner join payment_type pt on p.type = pt.id
/*where cl.id = 1*/;

/* drop view third_bill cascade; */
