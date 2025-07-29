-- 2.5. Requirement 5 (8 points)
/*
As you may have detected, the conversion tables only have data until 2024-10-24, we need a
procedure to insert new data as needed.

In the action of inserting new conversion data for every currency, two situations can be found:

1. The last conversion rate has value 0: then we will keep a 0 for further days.
2. The last conversion is a value >0: then we will pick a random currency conversion value bigger 
than 0 from some day of the last year.

Keep in mind that from and to USD conversions should be consistent (it must be the consistent changing from 
USD to EUR than to EUR to USD).
For each currency, the random pick should be different.
At the moment of execution, this procedure will create conversion entries (new rows) from the next 
missing day in the conversion tables and until the next day after the execution of the procedure.

Hint: Try first to populate the next missing day in conversion tables and then automate this action with a LOOP for the rest of the days in the past.
Hint: Use RAND() and DATE_ADD functions.

*/

DELIMITER $$

DROP PROCEDURE IF EXISTS req05_populate_conversion_data$$
CREATE PROCEDURE req05_populate_conversion_data()
BEGIN
    -- General variables
    DECLARE last_date DATE;
    DECLARE next_date DATE;

    -- Get the last date with data
    SELECT MAX(`date`) INTO last_date FROM fx_from_usd;
    SET next_date = DATE_ADD(last_date, INTERVAL 1 DAY);

    -- **Process fx_from_usd**
    BEGIN
        -- Specific variables for fx_from_usd
        DECLARE random_rate_from DECIMAL(15, 9);
        DECLARE last_rate_from DECIMAL(15, 9);
        DECLARE currency_code_from CHAR(3);
        DECLARE finished_from BOOLEAN DEFAULT FALSE;

        -- Cursor to iterate over the currencies in fx_from_usd
        DECLARE cur_from CURSOR FOR
            SELECT COLUMN_NAME
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = 'fx_from_usd'
              AND TABLE_SCHEMA = DATABASE()
              AND COLUMN_NAME NOT IN ('date'); -- Exclude "date" column

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished_from = TRUE;

        -- Add a new row with `next_date` in `fx_from_usd`
        INSERT INTO fx_from_usd (`date`) VALUES (next_date);

        -- Process the currencies in fx_from_usd
        OPEN cur_from;
        fx_from_usd_loop: LOOP
            FETCH cur_from INTO currency_code_from;
            IF finished_from THEN
                LEAVE fx_from_usd_loop;
            END IF;

            -- Get the last recorded rate in fx_from_usd
            SET @last_rate_query_from = CONCAT(
                'SELECT `', currency_code_from, '` INTO @last_rate_from ',
                'FROM fx_from_usd WHERE `date` = ?'
            );
            PREPARE stmt_last_rate_from FROM @last_rate_query_from;
            EXECUTE stmt_last_rate_from USING last_date;
            DEALLOCATE PREPARE stmt_last_rate_from;

            -- Generate a new rate in fx_from_usd
            IF @last_rate_from = 0 THEN
                -- Keep 0 if the last rate is 0
                SET @update_query_from = CONCAT(
                    'UPDATE fx_from_usd SET `', currency_code_from, '` = 0 WHERE `date` = ?'
                );
                PREPARE stmt_update_from FROM @update_query_from;
                EXECUTE stmt_update_from USING next_date;
                DEALLOCATE PREPARE stmt_update_from;
            ELSE
                -- Generate a random rate if the last rate is >0
                SET @random_rate_query_from = CONCAT(
                    'SELECT `', currency_code_from, '` INTO @random_rate_from ',
                    'FROM fx_from_usd WHERE `date` BETWEEN DATE_SUB(?, INTERVAL 1 YEAR) AND ? ',
                    'AND `', currency_code_from, '` > 0 ORDER BY RAND() LIMIT 1'
                );
                PREPARE stmt_random_from FROM @random_rate_query_from;
                EXECUTE stmt_random_from USING last_date, last_date;
                DEALLOCATE PREPARE stmt_random_from;

                -- Update the new rate in fx_from_usd
                SET @update_query_from = CONCAT(
                    'UPDATE fx_from_usd SET `', currency_code_from, '` = ? WHERE `date` = ?'
                );
                PREPARE stmt_update_from FROM @update_query_from;
                EXECUTE stmt_update_from USING @random_rate_from, next_date;
                DEALLOCATE PREPARE stmt_update_from;
            END IF;
        END LOOP;
        CLOSE cur_from;
    END;

    -- **Process fx_to_usd**
    BEGIN
        -- Specific variables for fx_to_usd
        DECLARE random_rate_to DECIMAL(15, 9);
        DECLARE reciprocal_rate DECIMAL(15, 9);
        DECLARE currency_code_to CHAR(3);
        DECLARE finished_to BOOLEAN DEFAULT FALSE;

        -- Cursor to iterate over the currencies in fx_to_usd
        DECLARE cur_to CURSOR FOR
            SELECT COLUMN_NAME
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = 'fx_to_usd'
              AND TABLE_SCHEMA = DATABASE()
              AND COLUMN_NAME NOT IN ('date'); -- Exclude column "date"

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished_to = TRUE;

        -- Add the new line of `next_date` in `fx_to_usd`
        INSERT INTO fx_to_usd (`date`) VALUES (next_date);
        
        -- Process the currencies in fx_to_usd
        OPEN cur_to;
        fx_to_usd_loop: LOOP
            FETCH cur_to INTO currency_code_to;
            IF finished_to THEN
                LEAVE fx_to_usd_loop;
            END IF;

            -- Get the rate generated in fx_from_usd
            SET @reciprocal_query = CONCAT(
                'SELECT `', currency_code_to, '` INTO @random_rate_to ',
                'FROM fx_from_usd WHERE `date` = ?'
            );
            PREPARE stmt_reciprocal FROM @reciprocal_query;
            EXECUTE stmt_reciprocal USING next_date;
            DEALLOCATE PREPARE stmt_reciprocal;

            -- Calculate the reciprocal rate
            IF @random_rate_to > 0 THEN
                SET @reciprocal_rate = ROUND(1 / @random_rate_to, 9);
            ELSE
                SET @reciprocal_rate = 0; -- Keep 0 if the rate is 0
            END IF;

            -- Update the reciprocal rate in fx_to_usd
            SET @update_query_to = CONCAT(
                'UPDATE fx_to_usd SET `', currency_code_to, '` = ? WHERE `date` = ?'
            );
            PREPARE stmt_update_to FROM @update_query_to;
            EXECUTE stmt_update_to USING @reciprocal_rate, next_date;
            DEALLOCATE PREPARE stmt_update_to;
        END LOOP;
        CLOSE cur_to;
    END;

END$$

DELIMITER ;
