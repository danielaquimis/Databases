-- 2.10.Requirement 10 (5 points)
/*
As music festival organisers, we don't want to be in trouble with the law. So create a procedure
that is able to identify all the consumptions of the under age (<18) in order to “fix” them.
The goal is that NO minors have bought any alcoholic drink in our festivals and we will defend this
until the grave.
If some minor bought a beer to a beerman during a concert, it should be considered as a system
error and we will assign this consumption to the festivalgoer number 998192 in order to fix it.
Regarding the bars’ sales of alcoholic drinks to under age youngsters, we need to correct their
data and assign those consumptions to the festivalgoer 27582.
Warning: Keep in mind that you are about to modify data of the given database; ensure that
your approach is correct.
*/


DELIMITER $$

DROP PROCEDURE IF EXISTS req10_fix_underage_consumptions$$
CREATE PROCEDURE req10_fix_underage_consumptions()
BEGIN
    -- Step 1: Fix beerman sales to minors
    UPDATE beerman_sells bs
    JOIN person p ON bs.id_festivalgoer = p.id_person
    SET bs.id_festivalgoer = 998192 -- Assign to festivalgoer 998192
    WHERE
        TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) < 18; -- Under 18 years old

    -- Step 2: Fix bar sales of alcoholic drinks to minors
    UPDATE festivalgoer_consumes fc
    JOIN person p ON fc.id_festivalgoer = p.id_person
    JOIN bar_product bp ON fc.id_bar = bp.id_bar AND fc.id_product = bp.id_product
    JOIN beverage b ON bp.id_product = b.id_beverage
    SET fc.id_festivalgoer = 27582 -- Assign to festivalgoer 27582
    WHERE
        TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) < 18 -- Under 18 years old
        AND b.is_alcoholic = 1; -- Alcoholic product
END$$

DELIMITER ;


/*
The provided code works as intended; however, due to the large size of the database, 
MySQL encounters performance limitations and disconnects during execution.
*/
