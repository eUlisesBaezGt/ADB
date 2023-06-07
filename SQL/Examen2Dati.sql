-- a)	Cursor que genere una cadena con la suma del jobTitle, firstName y lastName, separados por espacios, de la tabla de
-- employees. Cada registro se debe separar por pipe.
USE classicmodels;
DROP PROCEDURE IF EXISTS `EmployeeString`;

DELIMITER $$
CREATE PROCEDURE EmployeeString(
    # Variable to hold the string
    INOUT nString varchar(21845)
)
BEGIN
    # Variable to know when the cursor is finished
    DECLARE finished INTEGER DEFAULT 0;
    # Variable to hold the current Employee Info
    DECLARE jobTitle varchar(50) DEFAULT '';
    DECLARE firstName varchar(50) DEFAULT '';
    DECLARE lastName varchar(50) DEFAULT '';

    -- declare cursor for employee info
    DEClARE curEmployee
        CURSOR FOR
        SELECT employees.jobTitle, employees.firstName, employees.lastName FROM employees;

    -- declare NOT FOUND handler
    # Handle was created to avoid the error when the cursor is empty
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET finished = 1;

    -- open cursor
    OPEN curEmployee;
    # Loop to fetch the employee info
    getEmployee:
    LOOP
        # Fetch the employee info
        FETCH curEmployee INTO jobTitle, firstName, lastName;
        # Check if the cursor is finished
        IF finished = 1 THEN
            LEAVE getEmployee;
        END IF;
        -- build employee string
        # Concatenate the employee info to the string
        SET nString = CONCAT(nString, jobTitle, ' ', firstName, ' ', lastName);
        IF NOT finished THEN
            SET nString = CONCAT(nString, ' | ');
        END IF;
    END LOOP getEmployee;

    CLOSE curEmployee;
END$$
DELIMITER ;
SET @nString = '';
CALL EmployeeString(@nString);
SELECT @nString;

-- b)	Cursor que genere una cadena con la suma del contactFirstName y contactLastName, separados por espacios,
-- de la tabla de customers. Cada registro se debe separar por pipe.
USE classicmodels;
DROP PROCEDURE IF EXISTS `CustomerString`;
DELIMITER $$
CREATE PROCEDURE CustomerString(
    # Variable to hold the string
    INOUT nString varchar(21845)
)
BEGIN
    # Variable to know when the cursor is finished
    DECLARE finished INTEGER DEFAULT 0;
    # Variable to hold the current Employee Info
    DECLARE contactFirstName varchar(50) DEFAULT '';
    DECLARE contactLastName varchar(50) DEFAULT '';

    -- declare cursor for employee info
    DEClARE curCustomer
        CURSOR FOR
        SELECT customers.contactFirstName, customers.contactLastName FROM customers;

    -- declare NOT FOUND handler
    # Handle was created to avoid the error when the cursor is empty
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET finished = 1;

    -- open cursor
    OPEN curCustomer;

    # Loop to fetch the employee info
    getCustomer:
    LOOP
        # Fetch the employee info
        FETCH curCustomer INTO contactFirstName, contactLastName;
        # Check if the cursor is finished
        IF finished = 1 THEN
            LEAVE getCustomer;
        END IF;
        -- build employee string
        # Concatenate the employee info to the string
        SET nString = CONCAT(nString, contactFirstName, ' ', contactLastName);
        IF NOT finished THEN
            SET nString = CONCAT(nString, ' | ');
        END IF;
    END LOOP getCustomer;

    CLOSE curCustomer;
END$$
DELIMITER ;
SET @nString = '';
CALL CustomerString(@nString);
SELECT @nString;


-- a)	Buscar una cadena por lenguaje natural en la tabla de productlines.
USE classicmodels;
ALTER TABLE productlines
    ADD FULLTEXT (textDescription);
SELECT *
FROM productlines
WHERE MATCH(textDescription) AGAINST('classic cars' IN NATURAL LANGUAGE MODE);

-- b)	Buscar una cadena por modo booleano en la tabla de productlines.
USE classicmodels;
SELECT *
FROM productlines
WHERE MATCH(textDescription) AGAINST('classic cars' IN BOOLEAN MODE);

-- c)	Buscar una cadena por lenguaje natural en la tabla de customers.
USE classicmodels;
ALTER TABLE customers
    ADD FULLTEXT (contactFirstName, contactLastName);
SELECT *
FROM customers
WHERE MATCH(contactFirstName, contactLastName) AGAINST('Mary Patterson' IN NATURAL LANGUAGE MODE);

-- d)	Buscar una cadena por modo booleano en la tabla de customers.
USE classicmodels;
SELECT *
FROM customers
WHERE MATCH(contactFirstName, contactLastName) AGAINST('Mary Patterson' IN BOOLEAN MODE);
