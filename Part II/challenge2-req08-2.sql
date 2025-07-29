
DELIMITER $$

DROP TRIGGER IF EXISTS req08_trigger_beerman_sells$$
CREATE TRIGGER req08_trigger_beerman_sells
AFTER INSERT ON beerman_sells
FOR EACH ROW
BEGIN
    DECLARE default_currency CHAR(3) DEFAULT 'USD'; -- Default to USD
    DECLARE converted_price DECIMAL(15, 9);
    DECLARE payment_status BOOLEAN DEFAULT TRUE;
    DECLARE error_message TEXT DEFAULT NULL;
    DECLARE rate_from_usd DECIMAL(15, 9) DEFAULT 1; -- Default to 1 (for USD)

    -- Determine the default currency for the festivalgoer
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
        ELSE 'USD' -- Assign USD as the default currency if no match is found
    END INTO default_currency
    FROM person
    WHERE id_person = NEW.id_festivalgoer;
    
    -- Retrieve the conversion rate from USD to the default currency
    IF default_currency = 'USD' THEN
        SET rate_from_usd = 1; -- No conversion needed
    ELSEIF default_currency = 'CAD' THEN
        SELECT CAD INTO rate_from_usd FROM fx_from_usd WHERE `date` = (CURDATE() - INTERVAL 1 DAY);
    ELSEIF default_currency = 'GBP' THEN
        SELECT GBP INTO rate_from_usd FROM fx_from_usd WHERE `date` = (CURDATE() - INTERVAL 1 DAY);
    ELSEIF default_currency = 'JPY' THEN
        SELECT JPY INTO rate_from_usd FROM fx_from_usd WHERE `date` = (CURDATE() - INTERVAL 1 DAY);
    ELSEIF default_currency = 'EUR' THEN
        SELECT EUR INTO rate_from_usd FROM fx_from_usd WHERE `date` = (CURDATE() - INTERVAL 1 DAY);
    ELSE
        SET payment_status = FALSE;
        SET error_message = 'Conversion rate missing or unsupported currency.';
    END IF;

    -- Validate the conversion rate 
    IF rate_from_usd IS NULL OR rate_from_usd = 0 THEN
        SET payment_status = FALSE;
        SET error_message = 'Conversion rate missing or invalid for the previous day.';
        SET converted_price = 0;
    ELSE
        -- Calculate the price in the default currency
        SET converted_price = ROUND(3.00 * rate_from_usd, 2); -- Fixed price of 3 USD for beerman
    END IF;

    -- Insert the record in the payments table
    INSERT INTO payments (
        transaction_type,
        transaction_date,
        price_usd,
        buyer_id,
        default_currency,
        price_in_currency,
        payment_status,
        error_message
    )
    VALUES (
        'beerman',
        NOW(),
        3.00,
        NEW.id_festivalgoer,
        default_currency,
        converted_price,
        payment_status,
        error_message
    );
END$$

DELIMITER ;
