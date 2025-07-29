-- 2.8. Requirement 8 (10 points) 
/*
To keep track of bar and beer sellings, for every new consumption or beer sold we need to keep
track of the payments automatically.

At least, all this information must be filled in a new payments table:
1. Id of the transaction and if it’s from the beerman team or from a bar.
2. Date and hour of the transaction.
3. Price of the consumption that is in USD by default. (If it’s a beer sold by a beerman, assume a price of 3$).
4. Id of the buyer.
5. The default currency for the buyer (use req. 7, if it returns null, use a random currency that does not default to 0 in our conversion tables).
6. The price in the default currency (use req. 4)
7. Status of the payment: True if all is OK or false if currency conversion raises any error.
8. Error: null if it’s all OK or the raised error in the currency conversion.

Create all the needed database objects and structures to solve this requirement. Ensure data
consistency: we cannot be able to store fake data.
*/

-- Create payments table:

DROP TABLE IF EXISTS payments;

CREATE TABLE payments (
    id_payment INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each payment
    transaction_type ENUM('beerman', 'bar') NOT NULL, -- Indicates source of transaction
    transaction_date DATETIME NOT NULL DEFAULT NOW(), -- Date and hour of the transaction
    price_usd DECIMAL(10, 2) NOT NULL, -- Price of the transaction in USD
    buyer_id INT NOT NULL, -- ID of the buyer (festivalgoer)
    default_currency CHAR(3) NOT NULL, -- Default currency for the buyer
    price_in_currency DECIMAL(15, 9) NOT NULL, -- Price in the buyer's default currency
    payment_status BOOLEAN NOT NULL, -- True if payment successful, false otherwise
    error_message TEXT -- Error message if the payment failed
);
