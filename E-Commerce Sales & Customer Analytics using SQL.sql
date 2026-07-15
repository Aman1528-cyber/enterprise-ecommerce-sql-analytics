create database ecommerce_db;
use ecommerce_db;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    city VARCHAR(50),
    state VARCHAR(50),
    registration_date DATE);
   CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50)
); 
  CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2),
    stock INT,
    FOREIGN KEY(category_id)
    REFERENCES categories(category_id)
);  
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY(customer_id)
    REFERENCES customers(customer_id)
);
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY(order_id)
    REFERENCES orders(order_id),
    FOREIGN KEY(product_id)
    REFERENCES products(product_id)
);
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    payment_date DATE,
    FOREIGN KEY(order_id)
    REFERENCES orders(order_id)
);    
CREATE TABLE shipping (
    shipping_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    shipping_status VARCHAR(30),
    shipping_date DATE,
    delivery_date DATE,
    FOREIGN KEY(order_id)
    REFERENCES orders(order_id)
);    
INSERT INTO customers
(first_name,last_name,email,phone,city,state,registration_date)
VALUES
('Rahul','Sharma','rahul@gmail.com','9876543210','Delhi','Delhi','2023-01-01'),
('Amit','Verma','amit@gmail.com','9876543211','Lucknow','UP','2023-02-10'),
('Priya','Singh','priya@gmail.com','9876543212','Jaipur','Rajasthan','2023-03-12');
INSERT INTO categories(category_name)
VALUES
('Electronics'),
('Clothing'),
('Furniture');    
INSERT INTO products(product_name,category_id,price,stock)
VALUES
('Laptop',1,65000,20),
('Mobile',1,25000,50),
('Chair',3,3500,100),
('T-Shirt',2,800,200);    
INSERT INTO orders(customer_id,order_date,total_amount)
VALUES
(1,'2024-01-10',65800),
(2,'2024-01-12',25000),
(3,'2024-01-15',4300);    
 INSERT INTO order_items(order_id,product_id,quantity,price)
VALUES
(1,1,1,65000),
(1,4,1,800),
(2,2,1,25000),
(3,3,1,3500),
(3,4,1,800);   
INSERT INTO payments(order_id,payment_method,payment_status,payment_date)
VALUES
(1,'UPI','Paid','2024-01-10'),
(2,'Card','Paid','2024-01-12'),
(3,'Cash','Paid','2024-01-15');    
 INSERT INTO shipping(order_id,shipping_status,shipping_date,delivery_date)
VALUES
(1,'Delivered','2024-01-11','2024-01-15'),
(2,'Delivered','2024-01-13','2024-01-17'),
(3,'Shipped','2024-01-16',NULL);   
 SELECT COUNT(*) FROM customers;
 SELECT COUNT(*) FROM orders;
   SELECT SUM(total_amount)
FROM orders; 
SELECT
customers.first_name,
orders.order_date,
orders.total_amount
FROM customers
JOIN orders
ON customers.customer_id=orders.customer_id;
 SELECT
c.first_name,
SUM(o.total_amount) TotalSpent
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
GROUP BY c.first_name
ORDER BY TotalSpent DESC; 
SELECT
product_name,
price,
RANK() OVER(ORDER BY price DESC) Ranking
FROM products;  
DELIMITER //

CREATE PROCEDURE TotalRevenue()
BEGIN
SELECT SUM(total_amount)
FROM orders;
END //

DELIMITER ;    
CALL TotalRevenue();    
DELIMITER //

CREATE TRIGGER reduce_stock
AFTER INSERT
ON order_items
FOR EACH ROW
BEGIN
UPDATE products
SET stock=stock-NEW.quantity
WHERE product_id=NEW.product_id;
END //

DELIMITER ;    
CREATE INDEX idx_customer
ON orders(customer_id);
SELECT
    p.product_name,
    SUM(oi.quantity) AS Total_Sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY Total_Sold DESC;    
  SELECT
    YEAR(order_date) AS Year,
    MONTH(order_date) AS Month,
    SUM(total_amount) AS Revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY Year, Month;  
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,
    COUNT(o.order_id) AS Total_Orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, Customer_Name
HAVING COUNT(o.order_id) > 1;    
SELECT
    product_name,
    price
FROM products
ORDER BY price DESC
LIMIT 5;    
SELECT
    p.product_name,
    SUM(oi.quantity*oi.price) AS Sales,
    ROUND(SUM(oi.quantity*oi.price)*0.30,2) AS Estimated_Profit
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id;
SELECT *
FROM orders
ORDER BY total_amount DESC
LIMIT 1;
SELECT
    DATE_FORMAT(order_date,'%Y-%m') AS Month,
    SUM(total_amount) AS Revenue
FROM orders
GROUP BY Month
ORDER BY Month;