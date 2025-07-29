-- File: challenge2-load-data.sql
-- Authors: Daniela Quimis, Donyinsola Samuel, Jesús Santos
-- Description: This script creates two tables (fx_from_usd, fx_to_usd) and loads data into them
-- from CSV files using the LOAD DATA LOCAL INFILE statement. These tables are isolated and
-- not linked to any other tables in the schema.

-- Drop existing tables if they exist to avoid conflicts
DROP TABLE IF EXISTS fx_to_usd;
DROP TABLE IF EXISTS fx_from_usd;

-- Create fx_from_usd table
-- This table stores exchange rates from USD to other currencies.
-- Columns: 
--   - 'date': the date of the exchange rate
--   - Remaining columns: exchange rates for different currencies with high precision (DECIMAL(15,9)).

CREATE TABLE fx_from_usd (
    date DATE NOT NULL,
    `EUR` DECIMAL(15,9), `JPY` DECIMAL(15,9), `BGN` DECIMAL(15,9), `CZK` DECIMAL(15,9),
    `DKK` DECIMAL(15,9), `GBP` DECIMAL(15,9), `HUF` DECIMAL(15,9), `PLN` DECIMAL(15,9),
    `RON` DECIMAL(15,9), `SEK` DECIMAL(15,9), `CHF` DECIMAL(15,9), `ISK` DECIMAL(15,9),
    `NOK` DECIMAL(15,9), `HRK` DECIMAL(15,9), `RUB` DECIMAL(15,9), `TRL` DECIMAL(15,9),
    `TRY` DECIMAL(15,9), `AUD` DECIMAL(15,9), `BRL` DECIMAL(15,9), `CAD` DECIMAL(15,9),
    `CNY` DECIMAL(15,9), `HKD` DECIMAL(15,9), `IDR` DECIMAL(15,9), `ILS` DECIMAL(15,9),
    `INR` DECIMAL(15,9), `KRW` DECIMAL(15,9), `MXN` DECIMAL(15,9), `MYR` DECIMAL(15,9),
    `NZD` DECIMAL(15,9), `PHP` DECIMAL(15,9), `SGD` DECIMAL(15,9), `THB` DECIMAL(15,9),
    `ZAR` DECIMAL(15,9),
    PRIMARY KEY (date)
);


-- Load data into fx_from_usd
-- Make sure the path to the CSV file is correct for your local system
-- Use your path
LOAD DATA LOCAL INFILE 'C:/Users/Jesus/OneDrive/Escritorio/Bases de Datos/DB - Practicas/LABs-Challenge 2 - PART I/FX_USD_conversions/FX_from_USD.csv'
INTO TABLE fx_from_usd
COLUMNS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 2 LINES;



-- FX_to_USD
-- Create fx_to_usd table
-- This table stores exchange rates to USD from other currencies.
-- Columns: 
--   - 'date': the date of the exchange rate
--   - Remaining columns: exchange rates for different currencies with high precision (DECIMAL(15,9)).
CREATE TABLE fx_to_usd (
    date DATE NOT NULL,
    `EUR` DECIMAL(15,9), `JPY` DECIMAL(15,9), `BGN` DECIMAL(15,9), `CZK` DECIMAL(15,9),
    `DKK` DECIMAL(15,9), `GBP` DECIMAL(15,9), `HUF` DECIMAL(15,9), `PLN` DECIMAL(15,9),
    `RON` DECIMAL(15,9), `SEK` DECIMAL(15,9), `CHF` DECIMAL(15,9), `ISK` DECIMAL(15,9),
    `NOK` DECIMAL(15,9), `HRK` DECIMAL(15,9), `RUB` DECIMAL(15,9), `TRL` DECIMAL(15,9),
    `TRY` DECIMAL(15,9), `AUD` DECIMAL(15,9), `BRL` DECIMAL(15,9), `CAD` DECIMAL(15,9),
    `CNY` DECIMAL(15,9), `HKD` DECIMAL(15,9), `IDR` DECIMAL(15,9), `ILS` DECIMAL(15,9),
    `INR` DECIMAL(15,9), `KRW` DECIMAL(15,9), `MXN` DECIMAL(15,9), `MYR` DECIMAL(15,9),
    `NZD` DECIMAL(15,9), `PHP` DECIMAL(15,9), `SGD` DECIMAL(15,9), `THB` DECIMAL(15,9),
    `ZAR` DECIMAL(15,9),
    PRIMARY KEY (date)
);


-- Load data into fx_to_usd
-- Make sure the path to the CSV file is correct for your local system
-- Use your path
LOAD DATA LOCAL INFILE 'C:/Users/Jesus/OneDrive/Escritorio/Bases de Datos/DB - Practicas/LABs-Challenge 2 - PART I/FX_USD_conversions/FX_to_USD.csv'
INTO TABLE fx_to_usd
COLUMNS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 2 LINES;