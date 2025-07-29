-- 2.1. Requirement 1 (1 points)
-- Create a new function that, given a float number, if its value has more than 2 decimals returns it
-- rounded with two decimals at max. If the number does not have more than 2 decimals return the
-- number as is.


DELIMITER $$

DROP FUNCTION IF EXISTS req01_currency_rounder$$
CREATE FUNCTION req01_currency_rounder(input_number FLOAT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE result FLOAT;
    -- Check if the number has more than 2 decimal places
    IF input_number != ROUND(input_number, 2) THEN
        SET result = ROUND(input_number, 2);
    ELSE
        SET result = input_number;
    END IF;
    RETURN result;
END$$

DELIMITER ;
