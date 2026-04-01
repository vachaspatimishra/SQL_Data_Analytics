create database amazon_sales;
use amazon_sales;

create table orders(
order_id int,
product_name varchar(30),
quantity int,
price int
);

describe orders;
show tables;


create table student_details(
roll_no int primary key,
name varchar(30) not null,
email varchar(30) unique,
age int check(age<=18),
city varchar(30) default "Mumbai"
);

create table marks(
marks_id int primary key,
roll_no int,
subject varchar(30),
marks int,
foreign key(roll_no) references student_details(roll_no)
);

describe student_details;
describe marks;
describe orders;
describe top_orders;

-- adding a column
alter table student_details add phone_no int;

-- adding multiple columns
alter table orders add(product_category varchar(30), unit_price int);

-- renaming a column
alter table student_details rename column name to full_name;

-- modify table (change datatype or constraint)
alter table orders modify order_id int primary key;

-- change table name
rename table orders to top_orders;

-- delete a table
drop table top_orders;

-- delete a database
drop database amazon_sales;











