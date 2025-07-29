-- 2.6. Requirement 6 (2 points)
/*
Executing every day the currency conversions for the next day by hand is hard, easy to forget and prone to errors.
Schedule the execution of the procedure in requirement 5 every day until the end of the year using this timetable:
	Class-Group Hour Minute
	P101 20h Group number
	P102 21h Group number
	P201 22h Group number
	P202 23h Group number
For example, group P201_07 should do the execution at 22:07h, as 22h is their specified hour,
and minute 7 is their group number.
*/

DELIMITER $$

-- Create a scheduled event to execute the req05_populate_conversion_data procedure daily
DROP EVENT IF EXISTS event_req05_populate_conversion_data;
CREATE EVENT IF NOT EXISTS event_req05_populate_conversion_data
ON SCHEDULE EVERY 1 DAY
STARTS '2024-12-02 21:08:00' -- Start time: December 1, 2024, at 21:08 (9:08 PM)
ENDS '2024-12-31 23:59:59'   -- End time: December 31, 2024, at 11:59 PM
DO
BEGIN
    -- Call the procedure to populate conversion data for the next day
    CALL req05_populate_conversion_data();
END$$

DELIMITER ;
