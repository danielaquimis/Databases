-- 	Challenge 2 - Queries
-- Students:
-- Doyinsola Samuel
-- Daniela Quimis
-- Jesus Santos


-- ------------------------------------------------------------------------------------------------- --


-- Query 1. 
-- We know that the artist Lew Sid loves to eat fried rice. It seems that he has declined to participate
-- in some of the music festivals because there were not enough non-spicy and veggie friendly food options
-- including rice. Get a list of all the dishes available matching those requirements including name and description for each one.

-- TODO: List of non-spicy, vegetarian dishes containing rice

-- Drop the view if it already exists
DROP VIEW IF EXISTS query_01;

-- Create the view with the required result
CREATE VIEW query_01 AS
SELECT 
    p.name AS dish_name, -- Product name
    p.description AS dish_description -- Product description
FROM 
    food f -- Table containing food attributes
JOIN 
    product p ON f.id_food = p.id_product -- Join food with product based on id_product
WHERE 
    f.is_spicy = 0 -- Filter for non-spicy dishes
    AND f.is_veggie_friendly = 1 -- Filter for vegetarian dishes
    AND p.description LIKE '%rice%'; -- Ensure the description mentions 'rice'

-- Select the number of rows from the view SELECT COUNT(*) AS total_rows FROM query_01;
-- Total rows: 1
-- There is only one product that is non-spicy, veggie friendly and contains rice




-- ------------------------------------------------------------------------------------------------- --


-- Query 2. 
-- How many security guards use guns and how many use martial arts? Retrieve a result set with two columns.

-- Drop the view if it already exists
DROP VIEW IF EXISTS query_02;

-- Create the view with the required result
CREATE VIEW query_02 AS
SELECT 
    SUM(is_armed) AS guards_with_guns, -- Count guards that are armed
    SUM(knows_martial_arts) AS guards_with_martial_arts -- Count guards that know martial arts
FROM 
    security; -- Table containing security guards information

-- Total: 1 row
-- Guards with guns: 141
-- Guards who knows martial arts: 304




-- ------------------------------------------------------------------------------------------------- --


-- Query 2. EXTRA
-- How many security guards use guns and how many use martial arts? Retrieve a result set with two columns.
-- EXTRA: Can you include the information for each festival name?

-- Query 2 Extra: Count guards by festival with guns and martial arts
-- Drop the view if it already exists
DROP VIEW IF EXISTS query_02_extra;

-- Create the view with the required result
CREATE VIEW query_02_extra AS
SELECT 
    COALESCE(security.festival_name, 'Unknown') AS festival_name, -- Festival name or 'Unknown' if NULL
    security.festival_edition, -- Edition of the festival
    SUM(security.is_armed) AS guards_with_guns, -- Count guards that are armed
    SUM(security.knows_martial_arts) AS guards_with_martial_arts -- Count guards that know martial arts
FROM 
    security -- Table containing security guard information
GROUP BY 
    security.festival_name, security.festival_edition -- Group results by festival name and edition
ORDER BY 
    security.festival_name ASC, security.festival_edition ASC; -- Sort the results for better readability

-- Count the total number of rows in the view: SELECT COUNT(*) AS total_rows FROM query_02_extra;

-- total rows: 55
-- Guards with guns where festival name is NUll or unknown: 87
-- Guards with martial arts where festival name/edition is null or unknown: 180




-- ------------------------------------------------------------------------------------------------- --


-- Query 3: 
-- Find the name of the ticket vendor where Jan Laporta got his ticket for Primavera Sound of
-- 2018. Which type of ticket was it?

-- Drop the view if it already exists
DROP VIEW IF EXISTS query_03;

-- Create the view with the required result
CREATE VIEW query_03 AS
SELECT 
    v.name AS vendor_name, -- Vendor's name
    t.type AS ticket_type -- Type of ticket
FROM 
    person p
JOIN 
    festivalgoer fg ON p.id_person = fg.id_festivalgoer -- Join person with festivalgoer
JOIN 
    ticket t ON fg.id_festivalgoer = t.id_festivalgoer -- Join festivalgoer with ticket
JOIN 
    vendor v ON t.id_vendor = v.id_vendor -- Join ticket with vendor
WHERE 
    p.name = 'Jan' AND p.surname = 'Laporta' -- Filter for Jan Laporta
    AND t.festival_name = 'Primavera Sound' -- Filter for Primavera Sound
    AND t.festival_edition = 2018; -- Filter for the 2018 edition

-- Total: 1 row




-- ------------------------------------------------------------------------------------------------- --ç


-- Query 04: 
-- For each festival, calculate how many different editions they have had. Build a list with
-- festival_name and the count of editions. Sort the result by the number of editions descending.

-- Drop the view if it already exists
DROP VIEW IF EXISTS query_04;

-- Create the view with the required result
CREATE VIEW query_04 AS
SELECT 
    name AS festival_name, -- Festival name
    COUNT(DISTINCT edition) AS edition_count -- Count of unique editions
FROM 
    festival -- Table containing festival information
GROUP BY 
    name -- Group results by festival name
ORDER BY 
    edition_count DESC; -- Sort by number of editions in descending order

-- Total: 12 rows




-- ------------------------------------------------------------------------------------------------- --


-- Query 05:
-- Which is the music festival which sold the biggest amount of tickets? How many tickets have
-- they sold?

-- Drop the view if it already exists
DROP VIEW IF EXISTS query_05;

-- Create the view with the required result
CREATE VIEW query_05 AS
SELECT 
    t.festival_name AS festival_name, -- Festival name
    COUNT(t.id_ticket) AS tickets_sold -- Total tickets sold
FROM 
    ticket t -- Table containing ticket information
JOIN 
    festival f ON t.festival_name = f.name AND t.festival_edition = f.edition -- Join with festival table
GROUP BY 
    t.festival_name -- Group by festival name
ORDER BY 
    tickets_sold DESC -- Sort by tickets sold in descending order
LIMIT 1; -- Return only the festival with the highest sales

-- Total: 1 row




-- ------------------------------------------------------------------------------------------------- --


-- Query 05: EXTRA
-- Which is the music festival which sold the biggest amount of tickets? How many tickets have they sold?
-- EXTRA: For each music festival name, provide the evolution in sellings year after year. Sort
-- the result for festival name and edition ascending.

-- TODO: Evolution of ticket sales per festival year after year

-- Drop the view if it already exists
DROP VIEW IF EXISTS query_05_extra;

-- Create the view with the required result
CREATE VIEW query_05_extra AS
SELECT 
    t.festival_name AS festival_name, -- Festival name
    t.festival_edition AS festival_edition, -- Festival edition (year)
    COUNT(t.id_ticket) AS tickets_sold -- Total tickets sold for that edition
FROM 
    ticket t -- Table containing ticket information
JOIN 
    festival f ON t.festival_name = f.name AND t.festival_edition = f.edition -- Join with festival table
GROUP BY 
    t.festival_name, t.festival_edition -- Group by festival name and edition
ORDER BY 
    t.festival_name ASC, t.festival_edition ASC; -- Sort by festival name and edition ascending

-- Count the total number of rows from the view SELECT COUNT(*) AS total_rows FROM query_05_extra;
-- Total: 54 rows




-- ------------------------------------------------------------------------------------------------- --


-- Query 6: 
-- Get a list of all the different preferred instruments and the count of how many musicians
-- play each instrument. Sort the result descending by the number of musicians playing each instrument.

-- Query 6 - TODO: List of preferred instruments and the count of musicians playing each
-- Drop the view if it already exists
DROP VIEW IF EXISTS query_06;

-- Create the view with the required result
CREATE VIEW query_06 AS
SELECT 
    prefered_instrument AS instrument, -- Preferred instrument
    COUNT(id_artist) AS musician_count -- Number of musicians playing the instrument
FROM 
    artist -- Table containing artist information
GROUP BY 
    prefered_instrument -- Group by preferred instrument
ORDER BY 
    musician_count DESC; -- Sort by number of musicians descending

-- Total: 6 rows




-- ------------------------------------------------------------------------------------------------- --ç


-- Query 7:
-- We want to audit the staff contracts. Is there any contract for less than 2 years? Please identify the 
-- staff members with a short contract and provide a list with their id, names, surnames, nationality, birthdate
-- and the duration of their contract in days ordered by this last one in ascending order to know which one 
-- had the shortest contract.

-- Query 7 - TODO : Select staff members with contracts shorter than 2 years
-- Drop the view if it already exists
DROP VIEW IF EXISTS query_07;

-- Create the view with the required result
CREATE VIEW query_07 AS
SELECT 
    s.id_staff, -- Staff ID
    p.name, -- Staff member's name
    p.surname, -- Staff member's surname
    p.nationality, -- Staff member's nationality
    p.birth_date, -- Staff member's birthdate
    DATEDIFF(s.contract_expiration_date, s.hire_date) AS contract_duration_days -- Contract duration in days
FROM 
    staff s -- Table containing staff contract details
JOIN 
    person p ON s.id_staff = p.id_person -- Join with person table to get personal details
WHERE 
    DATEDIFF(s.contract_expiration_date, s.hire_date) < 730 -- Filter contracts shorter than 2 years (730 days)
ORDER BY 
    contract_duration_days ASC; -- Order by contract duration in ascending order


-- Count the total number of rows in the view SELECT COUNT(*) AS total_rows FROM query_07;
-- Total: 47 rows




-- ------------------------------------------------------------------------------------------------- --


-- Query 7 (Extra):
-- We want to audit the staff contracts. Is there any contract for less than 2 years? Please
-- identify the staff members with a short contract and provide a list with their id, names,
-- surnames, nationality, birthdate and the duration of their contract in days ordered by this
-- last one in ascending order to know which one had the shortest contract.
-- EXTRA: Can you also add in the list the information of what kind of worker is each one?
-- ("beerman", "bartender", "security" or "community_manager"). Use SQL CASE expression.

-- Query 7 Extra - TODO: Staff members with short contracts and their worker type
-- Drop the view if it already exists
DROP VIEW IF EXISTS query_07_extra;

-- Create the view with the required result
CREATE VIEW query_07_extra AS
SELECT 
    s.id_staff, -- Staff ID
    p.name, -- Staff member's name
    p.surname, -- Staff member's surname
    p.nationality, -- Staff member's nationality
    p.birth_date, -- Staff member's birthdate
    DATEDIFF(s.contract_expiration_date, s.hire_date) AS contract_duration_days, -- Contract duration in days
    -- Determine the worker type using CASE
    CASE 
        WHEN s.id_staff IN (SELECT id_beerman FROM beerman) THEN 'beerman'
        WHEN s.id_staff IN (SELECT id_bartender FROM bartender) THEN 'bartender'
        WHEN s.id_staff IN (SELECT id_security FROM security) THEN 'security'
        WHEN s.id_staff IN (SELECT id_community_manager FROM community_manager) THEN 'community_manager'
        ELSE 'unknown'
    END AS worker_type -- Worker type based on specific table match
FROM 
    staff s
JOIN 
    person p ON s.id_staff = p.id_person -- Join with person table to get personal details
WHERE 
    DATEDIFF(s.contract_expiration_date, s.hire_date) < 730 -- Filter contracts shorter than 2 years (730 days)
ORDER BY 
    contract_duration_days ASC; -- Order by contract duration in ascending order

-- Count the total number of rows in the view SELECT COUNT(*) AS total_rows FROM query_07_extra;

-- Total rows: 47




-- ------------------------------------------------------------------------------------------------- --


-- Query 8: 
-- Show the name, surname, nationality and birthdate of all the artists of Coldplay. Is there
-- more than one Coldplay band in the world? If so, add the country of the band in the result.

-- Query 8 - TODO: List of all artists from Coldplay and differentiate bands by country if needed
-- Drop the view if it already exists
DROP VIEW IF EXISTS query_08;

-- Create the view with the required result
CREATE VIEW query_08 AS
SELECT 
    a.id_artist, -- Artist ID
    a.bio AS artist_bio, -- Artist's biography
    a.prefered_instrument AS prefered_instrument, -- Preferred instrument
    a.band_name AS band_name, -- Band name
    b.country AS band_country, -- Country of the band
    b.type_of_music AS music_genre -- Type of music the band plays
FROM 
    artist a
JOIN 
    band b ON a.band_name = b.name AND a.band_country = b.country -- Join artist with band by name and country
WHERE 
    a.band_name = 'Coldplay' -- Filter for bands named Coldplay
ORDER BY 
    b.country ASC, -- Sort by band country
    a.id_artist ASC; -- Then by artist ID for readability

-- Count the total number of rows in the view SELECT COUNT(*) AS total_rows FROM query_08;
-- Number of rows: 10




-- ------------------------------------------------------------------------------------------------- --


-- Query 9:
-- Get a unique list (without repeated data) with name and description of all the non-alcoholic
-- drinks provided by 'Spirits Source'.

-- Drop the view if it already exists
DROP VIEW IF EXISTS query_09;

-- Create the view with the required result
CREATE VIEW query_09 AS
SELECT DISTINCT
    p.name AS product_name, -- Name of the product (drink)
    p.description AS product_description -- Description of the product (drink)
FROM 
    beverage b
JOIN 
    product p ON b.id_beverage = p.id_product -- Join beverage with product
JOIN 
    product_provider_bar ppb ON p.id_product = ppb.id_product -- Join product with product_provider_bar
JOIN 
    provider pr ON ppb.id_provider = pr.id_provider -- Join product_provider_bar with provider
WHERE 
    b.is_alcoholic = 0 -- Filter for non-alcoholic drinks
    AND pr.name = 'Spirits Source' -- Filter for the provider 'Spirits Source'
ORDER BY 
    product_name ASC; -- Sort results by product name

-- Count the total number of rows in the view SELECT COUNT(*) AS total_rows FROM query_09;

-- Rows: 5




-- ------------------------------------------------------------------------------------------------- --ç


-- Query 10: 
-- As festival organisers, we are in trouble because there were some youngsters drinking
-- alcohol. Get a list of their names, surnames, nationality and birth date for the festivalgoers
-- who had been drinking being under 18 years of age.

-- Drop the view if it already exists
DROP VIEW IF EXISTS query_10;
CREATE VIEW `query_10` AS
    SELECT 
        `p`.`name` AS `name`,
        `p`.`surname` AS `surname`,
        `p`.`nationality` AS `nationality`,
        `p`.`birth_date` AS `birth_date`
    FROM
        `person` `p`
    WHERE
        `p`.`birth_date` > '2006-12-31';

-- Count the total number of rows in the view
-- Total rows: 10079


-- ------------------------------------------------------------------------------------------------- --


-- Query 10(Extra): 
-- As festival organisers, we are in trouble because there were some youngsters drinking
-- alcohol. Get a list of their names, surnames, nationality and birth date for the festivalgoers
-- who had been drinking being under 18 years of age.
-- EXTRA: Include their friends in that list in order to contact their family too.

-- Drop the view if it already exists
DROP VIEW IF EXISTS query_10_extra;

-- Create the view including friends of underage drinkers
CREATE VIEW query_10_extra AS
    SELECT 
        p.name AS festivalgoer_name,
        p.surname AS festivalgoer_surname,
        p.nationality AS festivalgoer_nationality,
        p.birth_date AS festivalgoer_birth_date,
        f.name AS friend_name,
        f.surname AS friend_surname,
        f.nationality AS friend_nationality,
        f.birth_date AS friend_birth_date
    FROM 
        person p
    -- Join with the friendship table to get friends of the festivalgoer
    LEFT JOIN festivalgoer_friends ff ON p.id_person = ff.id_festivalgoer
    -- Join with the person table to get details about the friends
    LEFT JOIN person f ON f.id_person = ff.id_festivalgoer_friend
    -- Filter to include only festivalgoers under 18 years of age
    WHERE 
        p.birth_date > '2006-12-31';

-- Count the total number of rows in the view  SELECT COUNT(*) AS total_rows FROM query_10;
-- Total number of rows: 10079




-- ------------------------------------------------------------------------------------------------- --


-- Query 11:
-- Who is the beerman who has sold the most among all 'The Beatles' concerts of all the
-- Hellfest festival editions? Provide the id, name, surname, nationality and birthdate and the
-- count of beers sold.

-- Drop the view if it already exists
DROP VIEW IF EXISTS query_11;
CREATE VIEW `query_11` AS
    SELECT 
        `p`.`name` AS `name`,
        `p`.`surname` AS `surname`,
        `p`.`nationality` AS `nationality`,
        `p`.`birth_date` AS `birth_date`,
        SUM(`bes`.`id_beerman_sells`) AS `total_beers_sold`
    FROM
        ((((((`person` `p`
        JOIN `staff` `st` ON (`st`.`id_staff` = `p`.`id_person`))
        JOIN `beerman` `be` ON (`be`.`id_beerman` = `st`.`id_staff`))
        JOIN `beerman_sells` `bes` ON (`bes`.`id_beerman` = `be`.`id_beerman`))
        JOIN `artist` `a` ON (`a`.`id_artist` = `p`.`id_person`))
        JOIN `show` `s` ON (`bes`.`festival_name` = `s`.`festival_name`))
        JOIN `band` `b` ON (`s`.`band_name` = `b`.`name`))
    WHERE
        `b`.`name` = 'The Beatles'
            AND `s`.`festival_name` = 'Hellfest';
		
	-- Total Rows: 1




-- ------------------------------------------------------------------------------------------------- --


-- Query 12: 
-- The band 'Ebri Knight' has 5 members. They, as a band, have collaborated with many other
-- bands during their career. We want to know the id, name, surname, nationality, band name
-- and band country for all the artists they collaborated with among all the 5 integrants of Ebri
-- Knight. Exclude the members of Ebri Knight in the result set. Sort ascending by the band
-- name and band country of the collaborator.

DROP VIEW IF EXISTS query_12;

CREATE VIEW `query_12` AS
    SELECT 
        `p`.`id_person` AS `id_person`,
        `p`.`name` AS `name`,
        `p`.`surname` AS `surname`,
        `p`.`nationality` AS `nationality`,
        `b`.`name` AS `band_name`,
        `b`.`country` AS `band_country`
    FROM
        (((`person` `p`
        JOIN `artist` `a` ON (`a`.`id_artist` = `p`.`id_person`))
        JOIN `band` `b` ON (`a`.`band_name` = `b`.`name`))
        JOIN `band_collab` `bc` ON (`b`.`name` = `bc`.`band_name`
            OR `b`.`name` = `bc`.`collaborator_name`))
    WHERE
        (`bc`.`band_name` = 'Ebri Knight'
            OR `bc`.`collaborator_name` = 'Ebri Knight')
            AND !( `p`.`id_person` IN (SELECT 
                `p2`.`id_person`
            FROM
                (`person` `p2`
                JOIN `artist` `a2` ON (`a2`.`id_artist` = `p2`.`id_person`))
            WHERE
                `a2`.`band_name` = 'Ebri Knight'))
    ORDER BY `b`.`name` , `b`.`country`;
    
-- Total Rows: 50




-- ------------------------------------------------------------------------------------------------- --


-- Query 13: 
-- Get a list of all the songs performed by Cordie Paucek. Include all the information in the
-- Song's table.

-- Drop the view if it already exists
DROP VIEW IF EXISTS query_13;

-- Create the view with the required result
CREATE VIEW query_13 AS
SELECT 
    s.title, -- Title of the song
    s.version, -- Version of the song
    s.written_by, -- Band that wrote the song
    s.duration, -- Duration in seconds
    s.release_date, -- Release date of the song
    s.type_of_music, -- Genre of the song
    s.album -- Album where the song appears
FROM 
    person p
JOIN 
    artist a ON p.id_person = a.id_artist -- Link person to artist
JOIN 
    show_song ss ON a.band_name = ss.written_by -- Link artist's band to show songs
JOIN 
    song s ON ss.title = s.title -- Link show songs to song information
WHERE 
    p.name = 'Cordie' -- Filter for Cordie's name
    AND p.surname = 'Paucek'; -- Filter for Cordie's surname

-- EXTRA: Calculate the total duration of all songs performed by Cordie Paucek
SELECT 
    SUM(s.duration) AS total_seconds_played -- Total duration in seconds
FROM 
    query_13 s;

-- Total rows: 0




-- ------------------------------------------------------------------------------------------------- --


-- Query 14:
-- Are there any staff members who had different roles among all the festivals? So a bartender
-- of a festival ‘A’ who also worked as a beerman in a festival ‘B’... ? If so, provide a list of their
-- id_staff, name and surname.

-- Drop the view if already exists:
DROP VIEW IF EXISTS query_14;

CREATE VIEW `query_14` AS
    SELECT 
        `st`.`id_staff` AS `id_staff`,
        `p`.`name` AS `name`,
        `p`.`surname` AS `surname`
    FROM
        (`person` `p`
        JOIN `staff` `st` ON (`st`.`id_staff` = `p`.`id_person`));
        
-- Total rows: 7000




-- ------------------------------------------------------------------------------------------------- --


-- Query 15: 
-- There were some offensive words in social media in Facebook posts related to the Primavera
-- Sound Festival edition 2023. There is an audit in course and the auditors want a list of all the
-- community managers involved in this festival. Retrieve a list with all their personal data: id,
-- name, surname, nationality, birthdate and the beginning and end of their contract.

-- Query 15 - TODO: List of community managers involved in Primavera Sound 2023
-- Drop the view if it already exists
DROP VIEW IF EXISTS query_15;

-- Create the view 
CREATE VIEW query_15 AS
SELECT 
    p.id_person AS id, -- Community manager's ID
    p.name, -- Community manager's name
    p.surname, -- Community manager's surname
    p.nationality, -- Community manager's nationality
    p.birth_date, -- Community manager's birth date
    s.hire_date AS contract_start_date, -- Beginning of the contract
    s.contract_expiration_date AS contract_end_date -- End of the contract
FROM 
    community_manager cm
JOIN 
    cm_account_festival caf ON cm.id_community_manager = caf.id_community_manager -- Link community managers to festivals
JOIN 
    staff s ON cm.id_community_manager = s.id_staff -- Link community managers to staff contracts
JOIN 
    person p ON s.id_staff = p.id_person -- Link staff to personal data
WHERE 
    caf.festival_name = 'Primavera Sound' -- Filter for Primavera Sound festival
    AND caf.festival_edition = 2023 -- Filter for the 2023 edition
    AND caf.platform_name = 'Facebook' -- Filter for posts on Facebook
ORDER BY 
    p.surname ASC, -- Sort by surname
    p.name ASC; -- Then by name

-- Count the total number of rows in the view SELECT COUNT(*) AS total_rows FROM query_15;
-- Total rows: 1




-- ------------------------------------------------------------------------------------------------- --


-- Query 16: 
-- Security guards are going mad because they have seen some festivalgoers walking around
-- without the bracelet on their wrists and they started to think some of them cheated to get
-- in. Is there any festivalgoer who attended a music festival without having purchased a ticket?
-- Show its complete personal information sorted by id_person in order to find them.

-- Drop the view if it already exists
DROP VIEW IF EXISTS query_16;

-- Create the view with the required result
CREATE VIEW query_16 AS
SELECT 
    p.id_person, -- Festivalgoer's ID
    p.name, -- Festivalgoer's name
    p.surname, -- Festivalgoer's surname
    p.nationality, -- Festivalgoer's nationality
    p.birth_date -- Festivalgoer's birth date
FROM 
    person p
JOIN 
    festivalgoer fg ON p.id_person = fg.id_festivalgoer -- Link person with festivalgoer
WHERE 
    fg.id_festivalgoer NOT IN ( -- Exclude festivalgoers who have tickets
        SELECT DISTINCT t.id_festivalgoer 
        FROM ticket t
    )
ORDER BY 
    p.id_person ASC; -- Sort by ID for readability


-- Count the total number of rows in the view SELECT COUNT(*) AS total_rows FROM query_16;
-- Total rows: 53958




-- ------------------------------------------------------------------------------------------------- --


-- Query 17: 
-- For a specific festivalgoer (filter in where clause a festivalgoer ID of your desire); return his or
-- her spendings on festivals including, price tickets, beers bought and consumptions in bars.
-- Consider that beers sold by beermans have a price of 3 US dollars.

-- Query 17 - TODO: Festivalgoer's total spendings on festivals
-- Drop the view if it already exists
DROP VIEW IF EXISTS query_17;

-- Create the view with the required result
CREATE VIEW query_17 AS
SELECT 
    fg.id_festivalgoer, -- Festivalgoer's ID
    SUM(t.price) AS total_ticket_spending, -- Total spent on tickets
    COUNT(bs.id_beerman_sells) * 3 AS total_beer_spending, -- Total spent on beers (3 USD each)
    IFNULL(SUM(fp.unit_price), 0) AS total_bar_spending, -- Total spent in bars
    SUM(t.price) + (COUNT(bs.id_beerman_sells) * 3) + IFNULL(SUM(fp.unit_price), 0) AS total_spending -- Total spending
FROM 
    festivalgoer fg
LEFT JOIN 
    ticket t ON fg.id_festivalgoer = t.id_festivalgoer -- Link tickets to festivalgoer
LEFT JOIN 
    beerman_sells bs ON fg.id_festivalgoer = bs.id_festivalgoer -- Link beer sales to festivalgoer
LEFT JOIN 
    festivalgoer_consumes fc ON fg.id_festivalgoer = fc.id_festivalgoer -- Link bar consumptions to festivalgoer
LEFT JOIN 
    product_provider_bar fp ON fc.id_product = fp.id_product -- Link bar consumptions to product prices
WHERE 
    fg.id_festivalgoer = 27671 -- Replace with the desired festivalgoer ID
GROUP BY 
    fg.id_festivalgoer;


-- Total rows: 1




-- ------------------------------------------------------------------------------------------------- --


-- Query 18: 
-- Is there any repeated band name? If so, show them including its complete information to be
-- able to differentiate them. First identify the repeated ones and after that, show its complete
-- information from the band table.

-- Step 1: Identify repeated band names
-- Drop the view if it already exists
DROP VIEW IF EXISTS repeated_band_names;

-- Create a temporary view with repeated band names
CREATE VIEW repeated_band_names AS
SELECT 
    name, -- Band name
    COUNT(*) AS occurrences -- Count occurrences of each band name
FROM 
    band
GROUP BY 
    name
HAVING 
    COUNT(*) > 1; -- Filter for names that appear more than once

-- Step 2: Retrieve complete information for repeated bands
-- Drop the view if it already exists
DROP VIEW IF EXISTS query_18;

-- Create the final view with the full information
CREATE VIEW query_18 AS
SELECT 
    b.* -- Retrieve all columns from the band table
FROM 
    band b
JOIN 
    repeated_band_names rbn ON b.name = rbn.name -- Join with repeated band names
ORDER BY 
    b.name ASC, -- Sort by band name
    b.country ASC; -- Then by country for differentiation

-- Count the total number of repeated bands SELECT COUNT(*) AS total_repeated_bands FROM query_18;
-- Total rows: 69




-- ------------------------------------------------------------------------------------------------- --


-- Query 19: 
-- Show the personal information of the community managers who work as a freelance and
-- manage the social media accounts for the Creamfields festival. Consider only the accounts
-- with at least 500k followers and under 700k.
-- Show also the platform name and the followers. Order the results by community manager id asc.

-- Query 19 - TODO: Freelance community managers for Creamfields with specific follower count
-- Drop the view if it already exists
DROP VIEW IF EXISTS query_19;

-- Create the view with the required result
CREATE VIEW query_19 AS
SELECT 
    p.id_person AS community_manager_id, -- Community manager ID
    p.name AS community_manager_name, -- Community manager's name
    p.surname AS community_manager_surname, -- Community manager's surname
    p.nationality AS community_manager_nationality, -- Community manager's nationality
    p.birth_date AS community_manager_birth_date, -- Community manager's birth date
    caf.platform_name AS platform_name, -- Platform name (e.g., Facebook)
    caf.account_name AS account_name, -- Account name on the platform
    a.followers AS followers -- Number of followers of the account
FROM 
    community_manager cm
JOIN 
    cm_account_festival caf ON cm.id_community_manager = caf.id_community_manager -- Link community managers to festival accounts
JOIN 
    account a ON caf.platform_name = a.platform_name AND caf.account_name = a.account_name -- Link festival accounts to follower data
JOIN 
    person p ON cm.id_community_manager = p.id_person -- Link community managers to personal info
WHERE 
    cm.is_freelance = 1 -- Filter for freelance community managers
    AND caf.festival_name = 'Creamfields' -- Filter for the Creamfields festival
    AND a.followers >= 500000 -- At least 500k followers
    AND a.followers < 700000 -- Less than 700k followers
ORDER BY 
    p.id_person ASC; -- Sort by community manager ID

-- Count the total number of rows in the view SELECT COUNT(*) AS total_rows FROM query_19;
-- Total rows: 6




-- ------------------------------------------------------------------------------------------------- --


-- Query 20:
-- Return a list of names and surnames of the festivalgoers who attended all the Primavera
-- Sound editions (hint: subquery should be necessary)

-- Step 1: Verify distinct editions of Primavera Sound in the festival table
SELECT 
    COUNT(DISTINCT edition) AS total_editions -- Count distinct editions
FROM 
    festival
WHERE 
    name = 'Primavera Sound';

-- Step 2: Find the festivalgoers who attended all those editions
DROP VIEW IF EXISTS query_20;

CREATE VIEW query_20 AS
SELECT 
    p.name AS festivalgoer_name, -- Festivalgoer's name
    p.surname AS festivalgoer_surname -- Festivalgoer's surname
FROM 
    person p
JOIN 
    ticket t ON p.id_person = t.id_festivalgoer -- Link person to ticket
WHERE 
    t.festival_name = 'Primavera Sound' -- Filter for Primavera Sound
GROUP BY 
    p.id_person, p.name, p.surname
HAVING 
    COUNT(DISTINCT t.festival_edition) = ( -- Compare the number of editions attended
        SELECT COUNT(DISTINCT f.edition) -- Total distinct editions of Primavera Sound
        FROM festival f
        WHERE f.name = 'Primavera Sound'
    )
ORDER BY 
    p.name ASC, p.surname ASC;

-- Step 3: Count the total number of rows in the view SELECT COUNT(*) AS total_rows FROM query_20;
-- Total rows: 0. 
-- There is no one who attend to all the Primavera Sound Editions. We also create another view called 
-- query_20_at_least_5 who show who attend to at least 5 PS editions.




-- ------------------------------------------------------------------------------------------------- --








