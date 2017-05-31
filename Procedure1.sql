DROP PROCEDURE IF EXISTS Procedure1 ;

DELIMITER //

CREATE PROCEDURE Procedure1()
BEGIN
    DECLARE V_DONE INT DEFAULT 0;
    DECLARE V_CURRENT_DATE VARCHAR(8);
    DECLARE V_PROCESSDATE VARCHAR(8);
    DECLARE CUR1 CURSOR FOR
    select processdate from Jobs;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET V_DONE = 1;

    OPEN CUR1;
    LOOP_CUR1 : LOOP
        FETCH CUR1 INTO V_PROCESSDATE;

        IF V_DONE = 1 THEN
            LEAVE LOOP_CUR1;
        END IF;

        INNER_BL2: BEGIN
            DECLARE V_DONE2 INT DEFAULT 0;
            DECLARE V_ID INT;
            DECLARE CUR2 CURSOR FOR
             select ID from Store;
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET V_DONE2 = 1;

            OPEN CUR2;
            LOOP_CUR2: LOOP
                FETCH CUR2 INTO V_ID;

                IF V_DONE2 = 1 THEN
                    LEAVE LOOP_CUR2;
                END IF;

                INNER_BL3: BEGIN
                    DECLARE V_DONE3 INT DEFAULT 0;
                    DECLARE V_BILLSID INT;
                    DECLARE CUR3 CURSOR FOR
                    select ID from Bills where ID=V_ID and inputdate=V_PROCESSDATE;
                    DECLARE CONTINUE HANDLER FOR NOT FOUND SET V_DONE3 = 1;

                    OPEN CUR3;
                    LOOP_CUR3: LOOP
                        FETCH CUR3 INTO V_BILLSID;

                        IF V_DONE3 = 1 THEN
                            LEAVE LOOP_CUR3;
                        END IF;

                        call Procedure2(V_ID, V_PROCESSDATE, V_BILLSID);

                    END LOOP;
                    CLOSE CUR3;
                END INNER_BL3;
            END LOOP;
            CLOSE CUR2;
        END INNER_BL2;
    END LOOP;
    CLOSE CUR1;

    select 1 as result;
END
