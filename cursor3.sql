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
            SET nString = CONCAT(nString, '|');
        END IF;
    END LOOP getEmployee;

    CLOSE curEmployee;
END$$
DELIMITER ;
SET @nString = '';
CALL EmployeeString(@nString);
SELECT @nString;
