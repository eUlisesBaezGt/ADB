use classicmodels;

# Calculate product between quantityOrdered and priceEach as total price for each order
select orderNumber, SUM(quantityOrdered * priceEach) as total
from orderdetails
group by orderNumber;

# Calculate product between price for each customer
select customerNumber, SUM(quantityOrdered * priceEach) as total
from orderdetails
         join orders
where orderdetails.orderNumber = orders.orderNumber
group by customerNumber;

select customerNumber, sum(quantityOrdered * priceEach)
from orderdetails,
     orders
where orderdetails.orderNumber = orders.orderNumber
group by customerNumber;

# Calculate product between price for each customer & order
select customerNumber, orders.orderNumber, sum(quantityOrdered * priceEach) as total
from orderdetails,
     orders
where orderdetails.orderNumber = orders.orderNumber
group by customerNumber, orders.orderNumber;

# Producto que más se ha facturado (desc)
select productCode, sum(quantityOrdered * priceEach) as total
from orderdetails,
     orders
where orderdetails.orderNumber = orders.orderNumber
group by productCode
order by total desc;

# Producto que más se ha vendido por unidades (desc)
select productCode, sum(quantityOrdered) as total
from orderdetails,
     orders
where orderdetails.orderNumber = orders.orderNumber
group by productCode
order by total desc;

# Categoría más rentable ($)
select productLine, sum(quantityOrdered * priceEach) as total
from orderdetails,
     orders,
     products
where orderdetails.orderNumber = orders.orderNumber
  and orderdetails.productCode = products.productCode
group by productLine
order by total desc;

# Ticket promedio por cliente
select customerNumber, avg(quantityOrdered * priceEach) as total
from orderdetails,
     orders
where orderdetails.orderNumber = orders.orderNumber
group by customerNumber;

# Ticket promedio del total de ordenes
# Gasto promedio de todas las ordenes
select AVG(x.total) as total
from (select sum(quantityOrdered * priceEach) as total
      from orderdetails
      group by orderNumber) x;


# Total facturado por cada linea de producto en cada país (oficina)
select offices.country, productlines.productLine, sum(quantityOrdered * priceEach) as total
from offices,
     employees,
     customers,
     orders,
     orderdetails,
     products,
     productlines
where offices.officeCode = employees.officeCode
  and employees.employeeNumber = customers.salesRepEmployeeNumber
  and customers.customerNumber = orders.customerNumber
  and orders.orderNumber = orderdetails.orderNumber
  and orderdetails.productCode = products.productCode
  and products.productLine = productlines.productLine
group by offices.country, productlines.productLine
order by offices.country, productlines.productLine;


# Total facturado por cada linea de producto en cada país (oficina) con order status
select offices.country, productlines.productLine, sum(quantityOrdered * priceEach) as total, orders.status
from offices,
     employees,
     customers,
     orders,
     orderdetails,
     products,
     productlines
where offices.officeCode = employees.officeCode
  and employees.employeeNumber = customers.salesRepEmployeeNumber
  and customers.customerNumber = orders.customerNumber
  and orders.orderNumber = orderdetails.orderNumber
  and orderdetails.productCode = products.productCode
  and products.productLine = productlines.productLine
group by offices.country, productlines.productLine, orders.status
order by offices.country, productlines.productLine, orders.status;

# Total facturado por cada linea de producto en cada país (oficina)
select offices.country, productlines.productLine, sum(quantityOrdered * priceEach) as total, OO.ST_ as ACTUAL
from offices,
     employees,
     customers,
     orderdetails,
     products,
     productlines,
     (SELECT orderNumber,
             customerNumber,
             status,
             CASE WHEN status IN ('Shipped', 'In Process') THEN 'Active' ELSE 'Pasive' END as ST_
      FROM orders) as OO
where offices.officeCode = employees.officeCode
  and employees.employeeNumber = customers.salesRepEmployeeNumber
  and customers.customerNumber = OO.customerNumber
  and OO.orderNumber = orderdetails.orderNumber
  and orderdetails.productCode = products.productCode
  and products.productLine = productlines.productLine
group by offices.country, productlines.productLine, OO.ST_
order by offices.country, productlines.productLine, OO.ST_;

# Show if status is active or passive
SELECT orderNumber,
       customerNumber,
       status,
       CASE WHEN status IN ('Shipped', 'In Process') THEN 'Active' ELSE 'Pasive' END as ST_
FROM orders;


# CREATE VIEW
CREATE VIEW salespercpls AS
SELECT offices.country,
       productlines.productLine,
       OO.St_,
       SUM(quantityOrdered * priceEach) AS total
FROM offices,
     employees,
     customers,
     orderdetails,
     products,
     productlines,
     (SELECT orderNumber,
             customerNumber,
             status,
             CASE
                 WHEN status IN ('Shipped', 'In Process') THEN 'Activo'
                 ELSE 'Pasivo'
                 END AS St_
      FROM orders) OO
WHERE offices.officeCode = employees.officeCode
  AND employees.employeeNumber = customers.salesRepEmployeeNumber
  AND customers.customerNumber = OO.customerNumber
  AND OO.orderNumber = orderdetails.orderNumber
  AND orderdetails.productCode = products.productCode
  AND products.productLine = productlines.productLine
GROUP BY offices.country, productlines.productLine, OO.St_
ORDER BY offices.country, productlines.productLine, OO.St_;

# USE VIEW
Select country, productline, sum(total) as TotCPL
FROM salespercpls
group by country, productline
order by country, productline;


# NUEVA TABLA
CREATE TABLE employees_audit
(
    id             int auto_increment primary key,
    employeeNumber int         not null,
    lastName       varchar(50) not null,
    changedadte    datetime    default null,
    action         varchar(50) default null
);

# TRIGGER
CREATE TRIGGER
    before_employees_update
    BEFORE UPDATE
    ON Employees
    FOR EACH ROW
    INSERT INTO employees_audit
    SET ACTION         = 'UPDATE',
        employeeNumber = old.employeeNumber,
        lastname       = old.lastName,
        changeDate     = NOW();

# VIEW TRIGGER
SHOW TRIGGERS IN classicmodels;

# START CHANGING 
SELECT *
from employees;
SELECT *
from employees_audit;

# CREATE PROCEDURE
delimiter //
CREATE PROCEDURE InsLog(IN pENum INT, IN pLName VARCHAR(50), in pDATE DATETIME, IN pAct VARCHAR(50))
BEGIN
    INSERT INTO employees_audit
        (employeeNumber, lastname, changedate, action)
    VALUES (pENum, pLName, pDate, pAct);
END //

# RETURN TO ";" DELIMITER
delimiter ;

# CALL PROCEDURE
CALL InsLog(1, 'test', NOW(), 'test');
SELECT *
from employees_audit;



#####
-- Listar todos los productos del que más se vende al que menos, por unidades vendidas.
SELECT productCode, SUM(quantityOrdered) AS UnidadesVendidas
FROM orderdetails
GROUP BY productCode
ORDER BY UnidadesVendidas DESC;

SELECT products.productName AS Nombre, SUM(orderdetails.quantityOrdered) AS Cantidad
FROM products,
     orderdetails
WHERE products.productCode = orderdetails.productCode
GROUP BY products.productName
ORDER BY Cantidad DESC;

-- 2. Listar todos los productos del que más se vende al que menos, por unidades vendidas, pero segmentado por el año de
-- la fecha de orden. El año se puede tomar con: https://www.w3resource.com/mysql/date-and-time-functions/mysql-year-function.php
SELECT YEAR(orders.orderDate) AS year, products.productName, SUM(orderdetails.quantityOrdered) as cantidad
FROM orders,
     orderdetails,
     products
WHERE orders.orderNumber = orderdetails.orderNumber
  AND products.productCode = orderdetails.productCode
GROUP BY productName, year
ORDER BY cantidad DESC;

-- --3 Listar todos los productos del que más se vende al que menos, por unidades vendidas, pero segmentado por oficina (ciudad).
SELECT offices.city, products.productName, SUM(orderdetails.quantityOrdered) AS cantidad
FROM offices,
     employees,
     customers,
     orders,
     orderdetails,
     products
WHERE offices.officeCode = employees.officeCode
  AND employees.employeeNumber = customers.salesRepEmployeeNumber
  AND customers.customerNumber = orders.customerNumber
  AND orders.orderNumber = orderdetails.orderNumber
  AND orderdetails.productCode = products.productCode
GROUP BY offices.city, products.productName
ORDER BY cantidad DESC;


-- 4
SELECT products.productName AS Nombre, SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS factura
FROM orderdetails,
     products
WHERE orderdetails.productCode = products.productCode
GROUP BY products.productName
ORDER BY factura DESC;

-- 5
SELECT YEAR(orders.orderDate)                                     as Año,
       products.productName,
       products.productCode,
       SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS Cantidad
FROM orders,
     orderdetails,
     products
WHERE orders.orderNumber = orderdetails.orderNumber
  AND orderdetails.productCode = products.productCode
GROUP BY Año, products.productName, products.productCode
ORDER BY Cantidad DESC;

-- 6
SELECT offices.city                                               as Oficina,
       products.productName                                       as Nombre,
       SUM(orderdetails.priceEach * orderdetails.quantityOrdered) as Total
FROM offices,
     employees,
     customers,
     orders,
     orderdetails,
     products
WHERE offices.officeCode = employees.officeCode
  AND employees.employeeNumber = customers.salesRepEmployeeNumber
  AND customers.customerNumber = orders.customerNumber
  AND orders.orderNumber = orderdetails.orderNumber
  AND products.productCode = orderdetails.productCode
GROUP BY products.productName, offices.city
ORDER BY Total DESC;

-- 7
CREATE VIEW querie2 AS
SELECT YEAR(orders.orderDate) AS year, products.productName, SUM(orderdetails.quantityOrdered) as cantidad
FROM orders,
     orderdetails,
     products
WHERE orders.orderNumber = orderdetails.orderNumber
  AND products.productCode = orderdetails.productCode
GROUP BY productName, year
ORDER BY cantidad DESC;

-- 8
CREATE VIEW querie6 AS
SELECT products.productName AS Nombre, SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS factura
FROM orderdetails,
     products
WHERE orderdetails.productCode = products.productCode
GROUP BY products.productName
ORDER BY factura DESC;

-- 9
-- Hacer una tabla, un trigger y un stored-procedure para que cada vez que se inserta una orden nueva, se inserte en la tabla
-- nueva la fecha, ciudad y país de destino.
-- Notas:
-- i) Use la fecha shippedDate para las operaciones.
-- ii) Le puede ser de utilidad: https://www.mysqltutorial.org/mysql-triggers/mysql-after-insert-trigger/
CREATE TABLE new_order
(
    orderID int auto_increment primary key,
    fecha   date,
    ciudad  varchar(50),
    pais    varchar(50)
);

DELIMITER $$
CREATE PROCEDURE
    insert_order(IN pFecha DATE, IN pCiudad VARCHAR(50), IN pPais VARCHAR(50))
BEGIN
    INSERT INTO new_order
        (fecha, ciudad, pais)
    VALUES (pFecha, pCiudad, pPais);
END$$;
DELIMITER ;


CREATE TRIGGER
    shipping_order
    AFTER INSERT
    ON orders
    FOR EACH ROW
    INSERT INTO new_order
    SET fecha  = new.shippedDate,
        ciudad = (SELECT city
                  FROM customers
                  WHERE customerNumber = new.customerNumber),
        pais   = (SELECT country
                  FROM customers
                  WHERE customerNumber = new.customerNumber);

#-- CREATE A TRIGGER THAT USES A STORED PROCEDURE
CREATE TRIGGER
    shipping_order2
    AFTER INSERT
    ON orders
    FOR EACH ROW
    CALL insert_order(new.shippedDate, (SELECT city
                                        FROM customers
                                        WHERE customerNumber = new.customerNumber), (SELECT country
                                                                                     FROM customers
                                                                                     WHERE customerNumber = new.customerNumber);





-- 001 Listar por país de la oficina, año de solicitud y línea de producto, todo lo facturado (nombrado como total), de las órdenes con estatus en (‘Shipped’, ‘In process’)
SELECT offices.country,
       YEAR(orders.orderDate)                                     AS year,
       productLines.productLine,
       SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS total
FROM offices,
     employees,
     customers,
     orders,
     orderdetails,
     products,
     productLines
WHERE offices.officeCode = employees.officeCode
  AND employees.employeeNumber = customers.salesRepEmployeeNumber
  AND customers.customerNumber = orders.customerNumber
  AND orders.orderNumber = orderdetails.orderNumber
  AND orderdetails.productCode = products.productCode
  AND products.productLine = productLines.productLine
  AND orders.status IN ('Shipped', 'In Process')
GROUP BY offices.country, year, productLines.productLine
ORDER BY total DESC;


SELECT offices.country, YEAR(orders.orderDate), products.productLine, SUM(orderdetails.priceEach * orderdetails.quantityOrdered) as Total
FROM
	offices, employees, customers, orders, orderdetails, products
WHERE
	offices.officecode = employees.officecode
	AND employees.employeeNumber = customers.salesRepEmployeeNumber
	AND customers.customerNumber = orders.customerNumber
	AND orders.orderNumber = orderdetails.orderNumber
	AND orderdetails.productCode = products.productCode AND
 	orders.status IN ('Shipped', 'In Process')
GROUP BY offices.country, YEAR(orders.orderDate), products.productLine
ORDER BY Total DESC;

-- 002 Liste el país del cliente, línea de producto y lo comprado (nombrado como total), agrupado por país y línea de producto, para el año de su elección.
SELECT customers.country,
       products.productLine,
       SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS total
FROM customers,
        orders,
        orderdetails,
        products
    WHERE customers.customerNumber = orders.customerNumber
    AND orders.orderNumber = orderdetails.orderNumber
    AND orderdetails.productCode = products.productCode
    AND YEAR(orders.orderDate) = 2003
GROUP BY customers.country, products.productLine
ORDER BY total DESC;

SELECT customers.country, products.productLine, SUM(orderdetails.priceEach * orderdetails.quantityOrdered) as Total
FROM
  customers, orders, orderdetails, products
WHERE
  customers.customerNumber = orders.customerNumber
  AND orders.orderNumber = orderdetails.orderNumber
  AND orderdetails.productCode = products.productCode AND
 	YEAR(orders.orderDate) = 2003
GROUP BY customers.country, products.productLine
ORDER BY Total DESC;

-- 003.- Genere una vista del query 001.
CREATE VIEW querie1 AS
SELECT offices.country,
       YEAR(orders.orderDate)                                     AS year,
       productLines.productLine,
       SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS total
FROM offices,
        employees,
        customers,
        orders,
        orderdetails,
        products,
        productLines
    WHERE offices.officeCode = employees.officeCode
    AND employees.employeeNumber = customers.salesRepEmployeeNumber
    AND customers.customerNumber = orders.customerNumber
    AND orders.orderNumber = orderdetails.orderNumber
    AND orderdetails.productCode = products.productCode
    AND products.productLine = productLines.productLine
    AND orders.status IN ('Shipped', 'In Process')
GROUP BY offices.country, year, productLines.productLine
ORDER BY total DESC;

CREATE VIEW query001 AS
SELECT offices.country, YEAR(orders.orderDate), products.productLine, SUM(orderdetails.priceEach * orderdetails.quantityOrdered) as Total
FROM
	offices, employees, customers, orders, orderdetails, products
WHERE
	offices.officecode = employees.officecode
	AND employees.employeeNumber = customers.salesRepEmployeeNumber
	AND customers.customerNumber = orders.customerNumber
	AND orders.orderNumber = orderdetails.orderNumber
	AND orderdetails.productCode = products.productCode AND
 	orders.status IN ('Shipped', 'In Process')
GROUP BY offices.country, YEAR(orders.orderDate), products.productLine;

CREATE VIEW query0001 AS
SELECT offices.country, YEAR(orders.orderDate), products.productLine, SUM(orderdetails.priceEach * orderdetails.quantityOrdered) as Total
FROM
	offices, employees, customers, orders, orderdetails, products
WHERE
	offices.officecode = employees.officecode
	AND employees.employeeNumber = customers.salesRepEmployeeNumber
	AND customers.customerNumber = orders.customerNumber
	AND orders.orderNumber = orderdetails.orderNumber
	AND orderdetails.productCode = products.productCode AND
 	orders.status IN ('Shipped', 'In Process')
GROUP BY offices.country, YEAR(orders.orderDate), products.productLine;

-- 004.- Genere una tabla para almacenar los cambios hechos en el correo electrónico del empleado, como el ejemplo visto en clase.
CREATE TABLE email_changes (
    employeeNumber INT,
    email VARCHAR(50),
    change_date DATETIME
);


-- 005 Genere un trigger que se dispara si el correo electrónico del empleado cambia y registre el cambio en la tabla del punto 004, como el visto en clase.
DELIMITER $$
CREATE TRIGGER email_changes
    AFTER UPDATE
    ON employees
    FOR EACH ROW
    INSERT INTO email_changes (employeeNumber, email, change_date)
    VALUES (old.employeeNumber, old.email, NOW());
$$
DELIMITER ;