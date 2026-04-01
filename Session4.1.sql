create database sales;
use sales;

CREATE TABLE employee_sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(50),
    department VARCHAR(30),
    product VARCHAR(50),
    region VARCHAR(30),
    sale_amount INT,
    sale_date DATE
);

insert into employee_sales (employee_name, department, product, region, sale_amount, sale_date) values
('Anjali', 'Furniture', 'Chair', 'Pune', 12000, '2025-01-02'),
('Karan', 'Electronics', 'Mobile', 'Delhi', 25000, '25-01-02'),
('Neha', 'Stationery', 'Notebook', 'Mumbai', 3000, '2025-01-03');

insert into employee_sales (employee_name, department, product, region, sale_amount, sale_date) values 
('Rohan', 'Electronics', 'Laptop', 'Mumbai', 55000, '2025-01-01');