-- 2.7. Requirement 7 (3 points)
-- Make a function to identify default or preferred currency for a given person/festivalgoer. Given an
-- id as input, it will return:
-- 1. USD if the person/festivalgoer has United States nationality.
-- 2. CAD if the person/festivalgoer has Canada nationality.
-- 3. GBP id the person has U.K. nationality.
-- 4. JPY if the person/festivalgoer has Japanese nationality.
-- 5. EUR if the person/festivalgoer is an Eurozone member.
-- 6. 0 if the id is not found.
-- 7. null in any other case.


DELIMITER $$

DROP FUNCTION IF EXISTS req07_get_preferred_currency$$
CREATE FUNCTION req07_get_preferred_currency(person_id INT)
RETURNS CHAR(3)
DETERMINISTIC
BEGIN
    -- Determine the preferred currency directly based on the nationality in the table
    RETURN (
        SELECT CASE 
            WHEN UPPER(TRIM(nationality)) IN ('UNITED STATES', 'UNITED STATES OF AMERICA') THEN 'USD'
            WHEN UPPER(TRIM(nationality)) = 'CANADA' THEN 'CAD'
            WHEN UPPER(TRIM(nationality)) = 'UNITED KINGDOM' THEN 'GBP'
            WHEN UPPER(TRIM(nationality)) = 'JAPAN' THEN 'JPY'
            WHEN UPPER(TRIM(nationality)) IN (
                'AUSTRIA', 'BELGIUM', 'CYPRUS', 'ESTONIA', 'FINLAND', 
                'FRANCE', 'GERMANY', 'GREECE', 'IRELAND', 'ITALY', 
                'LATVIA', 'LITHUANIA', 'LUXEMBOURG', 'MALTA', 
                'NETHERLANDS', 'PORTUGAL', 'SLOVAKIA', 'SLOVENIA', 'SPAIN'
            ) THEN 'EUR'
            ELSE NULL
        END
        FROM person
        WHERE id_person = person_id
        LIMIT 1
    );
END$$

DELIMITER ;
