-- 2.2. Requirement 2 (4 points)
-- Create a new function that given a currency code returns TRUE if the currency code exists or
-- FALSE if it does not exist. Input should always be capitalised once we receive the parameter

DELIMITER $$

DROP FUNCTION IF EXISTS req02_currency_exists$$
CREATE FUNCTION req02_currency_exists(currency_code CHAR(3))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE result BOOLEAN;

    -- Convert input currency code to uppercase
    SET currency_code = UPPER(currency_code);
    
    -- Check if the currency code exists in the fx_from_usd or fx_to_usd tables
    IF currency_code = 'USD' OR 
       EXISTS (
           SELECT 1
           FROM information_schema.COLUMNS
           WHERE TABLE_SCHEMA = DATABASE() 
             AND TABLE_NAME IN ('fx_from_usd', 'fx_to_usd')
             AND COLUMN_NAME = currency_code
       ) THEN
        SET result = TRUE;
    ELSE
        SET result = FALSE;
    END IF;
    
    RETURN result;
END$$

DELIMITER ;
