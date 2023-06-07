# b)	Cursor que genere una cadena con la suma del contactFirstName y contactLastName, separados por espacios, de la
# tabla de customers. Cada registro se debe separar por pipe.
USE classicmodels;
DROP PROCEDURE IF EXISTS `CustomerString`;
DELIMITER $$
CREATE PROCEDURE CustomerString(
    INOUT nString varchar(21845)
)
BEGIN
    -- Variable to know when the cursor is finished
    DECLARE finished INTEGER DEFAULT 0;
    -- Variable to hold the current Employee Info
    DECLARE contactFirstName varchar(50) DEFAULT '';
    DECLARE contactLastName varchar(50) DEFAULT '';

    -- declare cursor for employee info
    DEClARE curCustomer
        CURSOR FOR
        SELECT customers.contactFirstName, customers.contactLastName FROM customers;

    -- declare NOT FOUND handler
    -- Handle was created to avoid the error when the cursor is empty
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET finished = 1;

    -- open cursor
    OPEN curCustomer;

    -- Loop to fetch the employee info
    getCustomer:
    LOOP
        -- Fetch the employee info
        FETCH curCustomer INTO contactFirstName, contactLastName;
        -- Check if the cursor is finished
        IF finished = 1 THEN
            LEAVE getCustomer;
        END IF;
        -- build employee string
        -- Concatenate the employee info to the string
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


# c)	Buscar una cadena por lenguaje natural en la tabla de customers.
USE classicmodels;
-- Add fulltext index to table
ALTER TABLE customers
    ADD FULLTEXT (contactFirstName, contactLastName);
SELECT *
FROM customers
WHERE MATCH(contactFirstName, contactLastName) AGAINST('Bergulfsen Ferguson' IN NATURAL LANGUAGE MODE);