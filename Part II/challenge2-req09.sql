-- 2.9. Requirement 9 (3 points)
/*
Eventhough we already provided all music festivals with food dishes that include rice and
vegetables, the artist Lew Sid is now angry because Hanumandkind and Kalmi are generating
more Youtube views with their new song ‘Big Dawgs’.
So he hired a hacker in order to manipulate the played songs in the festivals. The hacker inserted
the data of Lew Sid’s song called ‘Fried rice’ in the database and he also created a programmed
virus that, for each song played in a show, it will create fake data inserting a new row for Lew’s
song as if it were also played in the same show.
The goal of Lew Sid is to make his song the most played one and it seems that you are the hacker.
Help him or pay the consequences.
*/



USE P102_08_challange2_music_festival;

DELIMITER //

DROP PROCEDURE IF EXISTS req09_fried_rice;

CREATE PROCEDURE req09_fried_rice()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE show_id INT;

    -- Cursor to fetch shows missing "Fried Rice"
    DECLARE cur_shows CURSOR FOR(
        SELECT DISTINCT id_show
        FROM show
        WHERE id_show NOT IN (
            SELECT id_show
            FROM show_song
            WHERE title = 'Fried Rice'
        ));

    -- Handler to signal when the cursor is done
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open the cursor
    OPEN cur_shows;

    -- Loop through shows and insert "Fried Rice" into show_song
    show_loop: LOOP
        FETCH cur_shows INTO show_id;
        IF done = 1 THEN 
            LEAVE show_loop; 
        END IF;

        INSERT INTO show_song (id_show, title, version, written_by, ordinality)
        VALUES (show_id, 'Fried Rice', 1, 'Lew Sid', 1);
    END LOOP show_loop;

    -- Close the cursor
    CLOSE cur_shows;
END 

DELIMITER ;