create database Bank;
use Bank;

create table customer(
customer_id int auto_increment primary key,
first_name varchar(30) not null,
last_name varchar(30) not null,
email varchar(30) unique,
phone_no int unique,
age int check(age>18)
);

create table branch(
branch_id int auto_increment primary key,
branch_name varchar(50) not null,
city varchar(30),
ifsc_code int unique
);

insert into customer(first_name, last_name, email, phone_no, age) values
("vachas", "mishra", "vm@gmail.com", 123456789, 29),
("priya", "chauhan", "pc@gmail.com", 987654321, 30),
("gautam", "jha", "gj@gmail.com", 361245789, 30),
("pushkar", "rawat", "pr@gmail.com", 654987123, 29),
("manjeet", "kaur", "mk@gmail.com", 326541987, 28);

insert into customer(first_name, last_name, email, phone_no, age) values
("Donald", "Trump", "dt@gmail.com", 123458789, 80),
("Narendra", "Modi", "nm@gmail.com", 987684321, 75),
("Vladimir", "Putin", "vp@gmail.com", 963258741, 65),
("Xi", "Zinping", "xz@gmail.com", 789456123, 70),
("Emmanuel", "Macron", "em@gmail.com", 753698124, 75),
("Georgia", "Meloni", "gm@gmail.com", 321456789, 50),
("Kim jong", "Un", "ku@gmail.com", 139824767, 55);

select * from customer;

insert into branch(branch_name, city, ifsc_code) values
("sbi saket", "delhi", 123456789),
("sbi andheri west", "mumbai", 321654498),
("sbi gaur city", "greater noida west", 369852147);

select * from branch;
select * from customer;
describe customer;
describe branch;
truncate table customer;
alter table customer modify phone_no varchar(30) unique;
