-- 2.4. Requirement 4 (10 points)
/*
As you may know, in every music festival you can find people from around the world. Therefore
there are many coin currencies moving in and out.
In this requirement we need to create a stored procedure to solve currency conversions form
USD and to USD using the conversion tables.
Create a stored procedure with the following parameters:
1. Currency of origin: The 3 letters of the currency of origin (name of the column, the tables
of conversions).
2. Currency of destination. The 3 letters of the currency of destination (name of the column,
the tables of conversions).
3. Date of conversion. Date of the conversion could be today or we could need to convert
with a past date.
4. Numeric amount to be converted. Value that is needed to be converted. This parameter
will also be reused to return the value after the conversion (INOUT parameter).
5. Error message. Parameter with an error text if something goes wrong.
Considerations:
1. Make use of the previous developed functions to simplify the code.
2. Assume that the date of conversion will always be given as ‘YYYY-MM-DD’ format.
3. Input currency parameters should be converted to uppercase before use.
4. If there is no problem with our checks, the error message parameter should return null
value.
5. If there is a problem with our checks, the returned amount parameter should be 0.
6. The monetary amounts must have only two decimal places.
7. If some of the following considerations fails (8 to 14), an error message should be written
in the specified parameter for that matter.
8. The amount to be converted should be bigger than 0.
9. Conversion date should be in the past up to today; not a future date.
10. The currency of origin should be USD or a currency in our conversion tables.
11. The currency of destination should be USD or a currency in our conversion tables.
12. The currency conversion has to always involve USD (from or to) and it makes no sense to
convert to and from the same currency.
13. Conversion rate should exist for the given date and should not be 0 or null.
Hint: You can use the LEAVE command to end the procedure before ending all the execution.
*/

DELIMITER $$

DROP PROCEDURE IF EXISTS req04_currency_conversion$$
CREATE PROCEDURE req04_currency_conversion(
    IN origin_currency CHAR(3),
    IN destination_currency CHAR(3),
    IN conversion_date DATE,
    INOUT amount DECIMAL(15, 2),
    OUT error_message TEXT
)
BEGIN
    DECLARE rate_from_usd DECIMAL(15, 9) DEFAULT 1; -- Default for USD
    DECLARE rate_to_usd DECIMAL(15, 9) DEFAULT 1; -- Default for USD
    DECLARE dynamic_query TEXT;

    -- Begin main block with label for LEAVE
    main_block: BEGIN

        -- Convert the currency codes to uppercase for consistency
        SET origin_currency = UPPER(origin_currency);
        SET destination_currency = UPPER(destination_currency);

        -- Initialize error_message and amount
        SET error_message = NULL;

        -- Initial Validations

        -- Check if the amount is greater than 0
        IF amount <= 0 THEN
            SET error_message = 'Amount must be greater than 0.';
            SET amount = 0;
            LEAVE main_block;
        END IF;

        -- Check if the conversion date is not in the future
        IF conversion_date > CURDATE() THEN
            SET error_message = 'Conversion date cannot be in the future.';
            SET amount = 0;
            LEAVE main_block;
        END IF;

        -- Validate that the origin currency is valid
        IF NOT (origin_currency = 'USD' OR req02_currency_exists(origin_currency)) THEN
            SET error_message = 'Invalid origin currency.';
            SET amount = 0;
            LEAVE main_block;
        END IF;

        -- Validate that the destination currency is valid
        IF NOT (destination_currency = 'USD' OR req02_currency_exists(destination_currency)) THEN
            SET error_message = 'Invalid destination currency.';
            SET amount = 0;
            LEAVE main_block;
        END IF;

        -- Ensure that origin and destination currencies are not the same
        IF origin_currency = destination_currency THEN
            SET error_message = 'Origin and destination currencies must be different.';
            SET amount = 0;
            LEAVE main_block;
        END IF;

        -- Fetch conversion rates based on the scenario
        IF origin_currency = 'USD' THEN
            -- Convert from USD to another currency
            SET dynamic_query = CONCAT(
                'SELECT `', destination_currency, '` INTO @rate_from_usd ',
                'FROM fx_from_usd WHERE `date` = ?'
            );
            PREPARE stmt_from_usd FROM dynamic_query;
            SET @conversion_date = conversion_date;
            EXECUTE stmt_from_usd USING @conversion_date;
            DEALLOCATE PREPARE stmt_from_usd;

            SET rate_from_usd = @rate_from_usd; -- Assign fetched rate

            -- Multiply amount by the rate
            SET amount = amount * rate_from_usd;

        ELSEIF destination_currency = 'USD' THEN
            -- Convert from another currency to USD
            SET dynamic_query = CONCAT(
                'SELECT `', origin_currency, '` INTO @rate_to_usd ',
                'FROM fx_to_usd WHERE `date` = ?'
            );
            PREPARE stmt_to_usd FROM dynamic_query;
            SET @conversion_date = conversion_date;
            EXECUTE stmt_to_usd USING @conversion_date;
            DEALLOCATE PREPARE stmt_to_usd;

            SET rate_to_usd = @rate_to_usd; -- Assign fetched rate

            -- Multiply amount by the rate
            SET amount = amount * rate_to_usd;

        ELSE
            -- Convert between two currencies (through USD)

            -- Step 1: Convert origin_currency to USD
            SET dynamic_query = CONCAT(
                'SELECT `', origin_currency, '` INTO @rate_to_usd ',
                'FROM fx_to_usd WHERE `date` = ?'
            );
            PREPARE stmt_to_usd FROM dynamic_query;
            SET @conversion_date = conversion_date;
            EXECUTE stmt_to_usd USING @conversion_date;
            DEALLOCATE PREPARE stmt_to_usd;

            SET rate_to_usd = @rate_to_usd; -- Assign fetched rate

            -- Step 2: Convert USD to destination_currency
            SET dynamic_query = CONCAT(
                'SELECT `', destination_currency, '` INTO @rate_from_usd ',
                'FROM fx_from_usd WHERE `date` = ?'
            );
            PREPARE stmt_from_usd FROM dynamic_query;
            EXECUTE stmt_from_usd USING @conversion_date;
            DEALLOCATE PREPARE stmt_from_usd;

            SET rate_from_usd = @rate_from_usd; -- Assign fetched rate

            -- Perform conversion through USD
            SET amount = (amount * rate_to_usd) * rate_from_usd;
        END IF;

        -- Validate the conversion rates
        IF rate_from_usd IS NULL OR rate_from_usd = 0 OR rate_to_usd IS NULL OR rate_to_usd = 0 THEN
            SET error_message = 'Conversion rate is missing or zero.';
            SET amount = 0;
            LEAVE main_block;
        END IF;

        -- Round the amount to 2 decimal places
        SET amount = ROUND(amount, 2);

        -- If everything is fine, set error_message to NULL
        SET error_message = NULL;

    END main_block;

END$$

DELIMITER ;
