use joins;

CREATE TABLE sizes (
    size VARCHAR(10)
);
create table colors (
color varchar(10));
INSERT INTO colors VALUES
('Red'),
('Blue');
INSERT INTO sizes VALUES
('S'),
('M'),
('L');


CREATE TABLE employees (
    emp_id INT,
    emp_name VARCHAR(50),
    manager_id INT
);

INSERT INTO employees VALUES
(1, 'CEO', NULL),
(2, 'Manager', 1),
(3, 'Developer', 2),
(4, 'Intern', 3);

-- cross join (ON is not needed here)
select c.color, s.size
from colors c
cross join sizes s;

-- self join
select e1.emp_name, e2.emp_name
from employees e1
join employees e2
on e1.emp_id = e2.manager_id;
