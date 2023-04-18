USE classicmodels;
DROP PROCEDURE IF EXISTS createEmailList;

DELIMITER $$
CREATE PROCEDURE createEmailList(
    # Variable to hold the email list
    INOUT emailList varchar(4000)
)
BEGIN
    # Variable to know when the cursor is finished
    DECLARE finished INTEGER DEFAULT 0;
    # Variable to hold the current email address
    DECLARE emailAddress varchar(100) DEFAULT '';

    -- declare cursor for employee email
    DEClARE curEmail
        CURSOR FOR
        SELECT email FROM employees;

    -- declare NOT FOUND handler
    # Handle was created to avoid the error when the cursor is empty
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET finished = 1;

    -- open cursor
    OPEN curEmail;
    # Loop to fetch the email addresses
    getEmail:
    LOOP
        # Fetch the email address
        FETCH curEmail INTO emailAddress;
        # Check if the cursor is finished
        IF finished = 1 THEN
            LEAVE getEmail;
        END IF;
        -- build email list
        # Concatenate the email address to the list
        SET emailList = CONCAT(emailAddress, ' ', emailList);
    END LOOP getEmail;
    CLOSE curEmail;

END$$
DELIMITER ;
SET @emailList = '';
CALL createEmailList(@emailList);
SELECT @emailList;

# mgerard@classicmodelcars.com ykato@classicmodelcars.com mnishi@classicmodelcars.com tking@classicmodelcars.com pmarsh@classicmodelcars.com afixter@classicmodelcars.com bjones@classicmodelcars.com lbott@classicmodelcars.com pcastillo@classicmodelcars.com ghernande@classicmodelcars.com lbondur@classicmodelcars.com gvanauf@classicmodelcars.com ftseng@classicmodelcars.com spatterson@classicmodelcars.com jfirrelli@classicmodelcars.com lthompson@classicmodelcars.com ljennings@classicmodelcars.com abow@classicmodelcars.com gbondur@classicmodelcars.com wpatterson@classicmodelcars.com jfirrelli@classicmodelcars.com mpatterso@classicmodelcars.com dmurphy@classicmodelcars.com