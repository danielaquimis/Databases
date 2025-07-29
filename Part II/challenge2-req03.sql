-- 2.3. Requirement 3 (4 points)
-- Create a new procedure that given two parameters (date to be checked, and currency code)
-- returns in another parameter FALSE if the given date is not present in conversion tables (check
-- both tables) or the value for our specified currency and date is 0 or null. Return TRUE otherwise.

DELIMITER $$

DROP PROCEDURE IF EXISTS req03_check_conversion$$
CREATE PROCEDURE req03_check_conversion(
    IN date_to_check DATE,
    IN currency_code CHAR(3),
    OUT result BOOLEAN
)
BEGIN
    DECLARE conversion_value DECIMAL(15, 9);
    DECLARE sql_query VARCHAR(500);

    -- Convert currency code to uppercase
    SET currency_code = UPPER(currency_code);

    -- Construct dynamic SQL to check the value in both tables
    SET sql_query = CONCAT(
        'SELECT COALESCE(SUM(value), 0) INTO @conversion_value FROM (',
        'SELECT `', currency_code, '` AS value FROM fx_from_usd WHERE `date` = ? UNION ALL ',
        'SELECT `', currency_code, '` AS value FROM fx_to_usd WHERE `date` = ?) AS combined_values'
    );

    -- Prepare and execute the dynamic SQL
    PREPARE stmt FROM sql_query;
    SET @input_date = date_to_check;
    EXECUTE stmt USING @input_date, @input_date;
    DEALLOCATE PREPARE stmt;

    -- Check the resulting value
    IF @conversion_value IS NULL OR @conversion_value = 0 THEN
        SET result = FALSE;
    ELSE
        SET result = TRUE;
    END IF;
END$$

DELIMITER ;
