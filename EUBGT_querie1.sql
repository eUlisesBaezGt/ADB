-- 001
-- Listar por país del cliente, año de solicitud y línea de producto, todo lo facturado (nombrado como total),
-- de las órdenes con estatus en (‘Disputed, ‘Resolved’, ‘On Hold’)
USE classicmodels;
SELECT customers.country                                          as PAIS,
       YEAR(orders.orderDate)                                     AS AÑO_SOLICITUD,
       productlines.productline                                   as LINEA_PRODUCTO,
       SUM(orderdetails.priceEach * orderdetails.quantityOrdered) AS TOTAL
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
  AND offices.country = customers.country
  AND orders.status IN ('Disputed', 'Resolved', 'On Hold')
GROUP BY customers.country, YEAR(orders.orderDate), productlines.productline
ORDER BY total DESC;


USE classicmodels;
SELECT customers.country                                          as PAIS,
       YEAR(orders.orderDate)                                     AS AÑO_SOLICITUD,
       productlines.productline                                   as LINEA_PRODUCTO,
       SUM(orderdetails.priceEach * orderdetails.quantityOrdered) AS TOTAL
FROM customers,
     orders,
     orderdetails,
     products,
     productLines
WHERE customers.customerNumber = orders.customerNumber
  AND orders.orderNumber = orderdetails.orderNumber
  AND orderdetails.productCode = products.productCode
  AND products.productLine = productLines.productLine
  AND orders.status IN ('Disputed', 'Resolved', 'On Hold')
GROUP BY customers.country, YEAR(orders.orderDate), productlines.productline
ORDER BY total DESC;

-- 002.- Liste el país de la oficina, línea de producto y lo comprado (nombrado como total), agrupado por país
-- y línea de producto, para el año de su elección.
SELECT offices.country                                            as PAIS,
       productlines.productline                                   as LINEA_PRODUCTO,
       SUM(orderdetails.priceEach * orderdetails.quantityOrdered) AS TOTAL
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
  AND offices.country = customers.country
  AND YEAR(orders.orderDate) = 2005
GROUP BY offices.country, productlines.productline
ORDER BY total DESC;

-- 003.- Genere una vista del query 001.
CREATE VIEW vista01 AS
SELECT customers.country                                          as PAIS,
       YEAR(orders.orderDate)                                     AS AÑO_SOLICITUD,
       productlines.productline                                   as LINEA_PRODUCTO,
       SUM(orderdetails.priceEach * orderdetails.quantityOrdered) AS TOTAL
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
  AND offices.country = customers.country
  AND orders.status IN ('Disputed', 'Resolved', 'On Hold')
GROUP BY customers.country, YEAR(orders.orderDate), productlines.productline
ORDER BY total DESC;

-- 004.- Genere una tabla para almacenar los cambios hechos en el primer nombre (firstName) del empleado,
-- como el ejemplo visto en clase.
CREATE TABLE cambios_empleados
(
    id          int auto_increment primary key,
    NumEmpleado int         not null,
    Nombre      varchar(50) not null,
    FechaCambio datetime default null
);

-- 005.- Genere un trigger que se dispara si el primer nombre (firstName) del empleado cambia y registre el
-- cambio en la tabla del punto 004, como el visto en clase.
DELIMITER $$
CREATE TRIGGER
    cambia_empleado
    AFTER UPDATE
    ON Employees
    FOR EACH ROW
    INSERT INTO cambios_empleados
    SET NumEmpleado = old.employeeNumber,
        Nombre      = old.firstName,
        FechaCambio = NOW();
$$
DELIMITER ;

SHOW TRIGGERS IN classicmodels;

UPDATE Employees
SET firstName = 'Juan'
WHERE employeeNumber = 1002;

SELECT *
FROM cambios_empleados;



