create database  ECommerce;
use ECommerce;

-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL default 0.0
);

select * from products;

-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) unique NOT NULL
);

select * from customers;

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL ,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

select * from orders;

-- Create Order_items table
CREATE TABLE Order_items (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
select * from order_items;

desc products;
desc customers;
desc orders;
desc order_items;

select product_id ,product_name , price  from products
order by price desc;

SELECT c.first_name, c.last_name, COUNT(o.order_id) AS order_count
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY order_count DESC;

SELECT p.product_name, SUM(oi.quantity * p.price) AS total_revenue
FROM Order_items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

SELECT c.first_name, c.last_name, COUNT(DISTINCT oi.product_id) AS distinct_products
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_items oi ON o.order_id = oi.order_id
GROUP BY c.first_name, c.last_name
ORDER BY distinct_products DESC;


SELECT o.order_date
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.first_name = 'John' AND c.last_name = 'Doe'
ORDER BY o.order_date ASC;

SELECT first_name,last_name 
FROM customers
WHERE (SELECT COUNT(*) FROM orders WHERE orders.customer_id = customers.customer_id) > 
      (SELECT AVG(order_count) FROM (SELECT COUNT(*) AS order_count FROM orders GROUP BY customer_id) AS avg_orders);


SELECT p.product_name
FROM Products p
LEFT JOIN Order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;


SELECT c.customer_id
FROM Customers c
WHERE c.customer_id NOT IN (
    SELECT o.customer_id
    FROM Orders o
    JOIN Order_items oi ON o.order_id = oi.order_id
    WHERE oi.product_id = 1
);


