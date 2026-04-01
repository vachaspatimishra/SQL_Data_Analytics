create database cricket;
use cricket;

create table team(
player_id int auto_increment primary key,
player_name varchar(30),
age int,
score int
);

insert into team(player_name, age, score)
values("Virat Kohli", 36, 5000),
("Rohit Sharma", 37, 6000),
("MS Dhoni", 40, 7000);

select * from team;

