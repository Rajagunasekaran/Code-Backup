DROP PROCEDURE IF EXISTS SP_ACCESS_CARD_SEARCH_BY_UNIT;
CREATE PROCEDURE SP_ACCESS_CARD_SEARCH_BY_UNIT( IN UNIT_NUMBER INTEGER(4),USERSTAMP VARCHAR(50),OUT TEMP_ACCESS_UNIT TEXT)
BEGIN
DECLARE NUMBER_OF_ACCESS INT;
DECLARE ACCESS_CARD_COUNT INT DEFAULT 1;
DECLARE ACCESS_CARD_INCREMENT INT;
DECLARE D_TEMP_ACCESS TEXT;
DECLARE D_TEMP_ACCESS_UNIT TEXT;
DECLARE USERSTAMP_ID INTEGER;
DECLARE CARD_ID INTEGER;
DECLARE CARD_NO INTEGER;
DECLARE ACTIVE_ID INTEGER;
DECLARE LOST_ID INTEGER;
DECLARE INVENTORY_ID INTEGER;
DECLARE EMP_ID INTEGER;
DECLARE ACCESSID INTEGER;
DECLARE ACCESS_ACTIVE_INCREMENT_ID INTEGER;
DECLARE ACCESS_INV_INCREMENT_ID INTEGER;
DECLARE ACCESS_LOST_INCREMENT_ID INTEGER;
DECLARE ACCESS_EMP_INCREMENT_ID INTEGER;
DECLARE TEMP_ACCESS TEXT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
END;
START TRANSACTION;
CALL SP_CHANGE_USERSTAMP_AS_ULDID(USERSTAMP,@ULDID);
SET USERSTAMP_ID=(SELECT @ULDID);
SET D_TEMP_ACCESS=(SELECT CONCAT('TEMP_ACCESS','_',SYSDATE()));
SET D_TEMP_ACCESS=(SELECT REPLACE(D_TEMP_ACCESS,' ',''));
SET D_TEMP_ACCESS=(SELECT REPLACE(D_TEMP_ACCESS,'-',''));
SET D_TEMP_ACCESS=(SELECT REPLACE(D_TEMP_ACCESS,':',''));
SET TEMP_ACCESS=(SELECT CONCAT(D_TEMP_ACCESS,'_',USERSTAMP_ID));
SET @CREATE_TEMP_ACCESS=(SELECT CONCAT('CREATE TABLE ',TEMP_ACCESS,'
(ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,UASDID INTEGER,ACCESS_CARD INTEGER(7))'));
PREPARE CREATE_TEMP_ACCESS_STMT FROM @CREATE_TEMP_ACCESS;
EXECUTE CREATE_TEMP_ACCESS_STMT;
SET @INSERT_TEMP_ACCESS=(SELECT CONCAT('INSERT INTO ',TEMP_ACCESS,'(UASDID,ACCESS_CARD) SELECT UASD_ID,UASD_ACCESS_CARD FROM UNIT_ACCESS_STAMP_DETAILS WHERE UNIT_ID=(SELECT UNIT_ID FROM UNIT WHERE UNIT_NO=',UNIT_NUMBER,')'));
PREPARE INSERT_TEMP_ACCESS_STMT FROM @INSERT_TEMP_ACCESS;
EXECUTE INSERT_TEMP_ACCESS_STMT;
SET D_TEMP_ACCESS_UNIT=(SELECT CONCAT('TEMP_ACCESS_UNIT','_',SYSDATE()));
SET D_TEMP_ACCESS_UNIT=(SELECT REPLACE(D_TEMP_ACCESS_UNIT,' ',''));
SET D_TEMP_ACCESS_UNIT=(SELECT REPLACE(D_TEMP_ACCESS_UNIT,'-',''));
SET D_TEMP_ACCESS_UNIT=(SELECT REPLACE(D_TEMP_ACCESS_UNIT,':',''));
SET TEMP_ACCESS_UNIT=(SELECT CONCAT(D_TEMP_ACCESS_UNIT,'_',USERSTAMP_ID));
SET @CREATE_TEMP_ACCESS_UNIT=(SELECT CONCAT('CREATE TABLE ',TEMP_ACCESS_UNIT,
'(
   ID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
   ACTIVE_CARD TEXT,
   INVENTORY_CARD INTEGER(7),
   EMPLOYEE_LOST_CARD INTEGER(7),
   CUSTOMER_LOST_CARD TEXT,
   REASON VARCHAR(20)
)'));
PREPARE CREATE_TEMP_ACCESS_UNIT_STMT FROM @CREATE_TEMP_ACCESS_UNIT;
EXECUTE CREATE_TEMP_ACCESS_UNIT_STMT;
SET @CREATE_NUMBER_OF_ACCESS=(SELECT CONCAT('SELECT MAX(ID)INTO @NOOFACCESS FROM ',TEMP_ACCESS));
PREPARE CREATE_NUMBER_OF_ACCESS_STMT FROM @CREATE_NUMBER_OF_ACCESS;
EXECUTE CREATE_NUMBER_OF_ACCESS_STMT;
SET NUMBER_OF_ACCESS=@NOOFACCESS;
WHILE (NUMBER_OF_ACCESS>=ACCESS_CARD_COUNT) DO
SET @INSERT_ACCESS_LOST_ORG=NULL;
SET @ACCESS_ID=NULL;
SET @ACCESS_ACTIVE_ID=NULL;
SET @CREATE_CARD_ID=(SELECT CONCAT('SELECT UASDID INTO @ACCESS_CARD_ID FROM ',TEMP_ACCESS,' WHERE ID=',ACCESS_CARD_COUNT));
PREPARE CREATE_CARD_ID_STMT FROM @CREATE_CARD_ID;
EXECUTE CREATE_CARD_ID_STMT;
SET CARD_ID=@ACCESS_CARD_ID;
SET @CREATE_CARD_NO=(SELECT CONCAT('SELECT ACCESS_CARD INTO @ACCESS_CARD_NO FROM ',TEMP_ACCESS,' WHERE ID=',ACCESS_CARD_COUNT));
PREPARE CREATE_CARD_NO_STMT FROM @CREATE_CARD_NO;
EXECUTE CREATE_CARD_NO_STMT;
SET CARD_NO=@ACCESS_CARD_NO;
SET @CREATE_ACTIVE_ID=(SELECT CONCAT('SELECT ID INTO @ACCESS_ACTIVE_ID FROM ',TEMP_ACCESS_UNIT,' WHERE ACTIVE_CARD IS NOT NULL ORDER BY ID DESC LIMIT 1'));
PREPARE CREATE_ACTIVE_ID_STMT FROM @CREATE_ACTIVE_ID;
EXECUTE CREATE_ACTIVE_ID_STMT;
SET ACTIVE_ID=@ACCESS_ACTIVE_ID;
SET @CREATE_INVENTORY_ID=(SELECT CONCAT('SELECT ID INTO @ACCESS_INVENTORY_ID FROM ',TEMP_ACCESS_UNIT,' WHERE INVENTORY_CARD IS NOT NULL ORDER BY ID DESC LIMIT 1'));
PREPARE CREATE_INVENTORY_ID_STMT FROM @CREATE_INVENTORY_ID;
EXECUTE CREATE_INVENTORY_ID_STMT;
SET INVENTORY_ID=@ACCESS_INVENTORY_ID;
SET @CREATE_LOST_ID=(SELECT CONCAT('SELECT ID INTO @ACCESS_LOST_ID FROM ',TEMP_ACCESS_UNIT,' WHERE CUSTOMER_LOST_CARD IS NOT NULL ORDER BY ID DESC LIMIT 1'));
PREPARE CREATE_LOST_ID_STMT FROM @CREATE_LOST_ID;
EXECUTE CREATE_LOST_ID_STMT;
SET LOST_ID=@ACCESS_LOST_ID;
SET @CREATE_EMP_ID=(SELECT CONCAT('SELECT ID INTO @ACCESS_EMPLOYEE_ID FROM ',TEMP_ACCESS_UNIT,' WHERE EMPLOYEE_LOST_CARD IS NOT NULL ORDER BY ID DESC LIMIT 1'));
PREPARE CREATE_EMP_ID_STMT FROM @CREATE_EMP_ID;
EXECUTE CREATE_EMP_ID_STMT;
SET EMP_ID=@ACCESS_EMPLOYEE_ID;
SET @CREATE_ID=(SELECT CONCAT('SELECT ID INTO @ACCESS_ID FROM ',TEMP_ACCESS_UNIT,' WHERE ID =1'));
PREPARE CREATE_ID_STMT FROM @CREATE_ID;
EXECUTE CREATE_ID_STMT;
SET ACCESSID=@ACCESS_ID ;
IF EXISTS (SELECT UASD_ACCESS_CARD FROM UNIT_ACCESS_STAMP_DETAILS WHERE UASD_ACCESS_CARD=CARD_NO AND UASD_ACCESS_ACTIVE IS NOT NULL) THEN
IF ACTIVE_ID IS NULL THEN
    IF ACCESSID IS NULL THEN
            IF EXISTS(SELECT * FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE UASD_ID=CARD_ID AND ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND CACD_GUEST_CARD IS NOT NULL)THEN
                SET @INSERT_TEMP_ACCESS_ACTIVE_GUEST=(SELECT CONCAT('INSERT INTO ',TEMP_ACCESS_UNIT,'(ACTIVE_CARD)VALUES ((SELECT CONCAT((SELECT ACCESS_CARD FROM ',TEMP_ACCESS,' WHERE ID=',ACCESS_CARD_COUNT,'),
                "  ",(SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ","GUEST","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,'),")")))'));
                PREPARE INSERT_TEMP_ACCESS_ACTIVE_GUEST_STMT FROM @INSERT_TEMP_ACCESS_ACTIVE_GUEST;
                EXECUTE INSERT_TEMP_ACCESS_ACTIVE_GUEST_STMT;
            ELSE
                SET @INSERT_TEMP_ACCESS_ACTIVE_ORGINAL=(SELECT CONCAT('INSERT INTO ',TEMP_ACCESS_UNIT,'(ACTIVE_CARD)VALUES ((SELECT CONCAT((SELECT ACCESS_CARD FROM ',TEMP_ACCESS,' WHERE ID=',ACCESS_CARD_COUNT,'),
                "  ",(SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,'),")")))'));
                PREPARE INSERT_TEMP_ACCESS_ACTIVE_ORGINAL_STMT FROM  @INSERT_TEMP_ACCESS_ACTIVE_ORGINAL;
                EXECUTE INSERT_TEMP_ACCESS_ACTIVE_ORGINAL_STMT;
            END IF;
        END IF;
        IF ACCESSID IS NOT NULL THEN
            IF EXISTS(SELECT * FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE UASD_ID=CARD_ID AND ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND CACD_GUEST_CARD IS NOT NULL)THEN
                SET @UPDATE_TEMP_ACCESS_UNIT_ACTIVE_GUEST=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET ACTIVE_CARD = (SELECT CONCAT(',CARD_NO,',"  ",(SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ","GUEST","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,'),")"))WHERE ID=1'));
                PREPARE UPDATE_TEMP_ACCESS_UNIT_ACTIVE_GUEST_STMT FROM @UPDATE_TEMP_ACCESS_UNIT_ACTIVE_GUEST;
                EXECUTE UPDATE_TEMP_ACCESS_UNIT_ACTIVE_GUEST_STMT;
            ELSE
                SET @UPDATE_TEMP_ACCESS_UNIT_ACTIVE_GUEST=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET ACTIVE_CARD = (SELECT CONCAT(',CARD_NO,',"  ",(SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,'),")")) WHERE ID=1'));
                PREPARE UPDATE_TEMP_ACCESS_UNIT_ACTIVE_GUEST_STMT FROM @UPDATE_TEMP_ACCESS_UNIT_ACTIVE_GUEST;
                EXECUTE UPDATE_TEMP_ACCESS_UNIT_ACTIVE_GUEST_STMT;
            END IF;
        END IF;
    ELSE
        SET @CREATE_ACCESS_CARD_INCREMENT= (SELECT CONCAT('(SELECT ID INTO @ACCESS_INCREMENT FROM ',TEMP_ACCESS_UNIT,' WHERE ACTIVE_CARD IS NOT NULL ORDER BY ID DESC LIMIT 1)'));
        PREPARE CREATE_ACCESS_CARD_INCREMENT_STMT FROM @CREATE_ACCESS_CARD_INCREMENT;
        EXECUTE CREATE_ACCESS_CARD_INCREMENT_STMT;
        SET ACCESS_CARD_INCREMENT=@ACCESS_INCREMENT+1;
        SET @CREATE_ACTIVE_ACCESS_INCREMENT_ID= (SELECT CONCAT('SELECT ID INTO @ACTIVE_INC_ID FROM ',TEMP_ACCESS_UNIT,' WHERE ID=',ACCESS_CARD_INCREMENT));
        PREPARE CREATE_ACTIVE_ACCESS_INCREMENT_ID_STMT FROM @CREATE_ACTIVE_ACCESS_INCREMENT_ID;
        EXECUTE CREATE_ACTIVE_ACCESS_INCREMENT_ID_STMT;
        SET ACCESS_ACTIVE_INCREMENT_ID=@ACTIVE_INC_ID;
            IF ACCESS_ACTIVE_INCREMENT_ID IS NOT NULL THEN
                IF EXISTS(SELECT * FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE UASD_ID=CARD_ID AND ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND CACD_GUEST_CARD IS NOT NULL)THEN
                    SET @UPDATE_TEMP_ACCESS_INCREMENT_GUEST=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET ACTIVE_CARD =(SELECT CONCAT(',CARD_NO,
                    ',"  ",(SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ","GUEST","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,'),")")) WHERE ID=',ACCESS_CARD_INCREMENT));
                    PREPARE UPDATE_TEMP_ACCESS_INCREMENT_GUEST_STMT FROM @UPDATE_TEMP_ACCESS_INCREMENT_GUEST;
                    EXECUTE UPDATE_TEMP_ACCESS_INCREMENT_GUEST_STMT;
                ELSE
                    SET @UPDATE_TEMP_ACCESS_INCREMENT_ORG=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET ACTIVE_CARD = (SELECT CONCAT(',CARD_NO,',"  ",(SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,'),")")) WHERE ID=',ACCESS_CARD_INCREMENT));
                    PREPARE UPDATE_TEMP_ACCESS_INCREMENT_ORG_STMT FROM @UPDATE_TEMP_ACCESS_INCREMENT_ORG;
                    EXECUTE UPDATE_TEMP_ACCESS_INCREMENT_ORG_STMT;
                END IF;
            ELSE
                IF EXISTS(SELECT * FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE UASD_ID=CARD_ID AND ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND CACD_GUEST_CARD IS NOT NULL)THEN
                    SET @INSERT_ACCESS_INC_ACTIVE_GUEST=(SELECT CONCAT('INSERT INTO ',TEMP_ACCESS_UNIT,'(ACTIVE_CARD)VALUES ((SELECT CONCAT(',CARD_NO,
                    ',"  ",(SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ","GUEST","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,'),")")))'));
                    PREPARE INSERT_ACCESS_INC_ACTIVE_GUEST_STMT FROM @INSERT_ACCESS_INC_ACTIVE_GUEST;
                    EXECUTE INSERT_ACCESS_INC_ACTIVE_GUEST_STMT;
                ELSE
                    SET @INSERT_ACCESS_INC_ACTIVE_ORG=(SELECT CONCAT('INSERT INTO ',TEMP_ACCESS_UNIT,'(ACTIVE_CARD)VALUES((SELECT CONCAT(',CARD_NO,',"  ",(SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,')),"  ","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,'),")")))'));
                    PREPARE INSERT_ACCESS_INC_ACTIVE_ORG_STMT FROM @INSERT_ACCESS_INC_ACTIVE_ORG;
                    EXECUTE INSERT_ACCESS_INC_ACTIVE_ORG_STMT;
                END IF;
            END IF;
    END IF;
END IF;
IF EXISTS (SELECT UASD_ACCESS_CARD FROM UNIT_ACCESS_STAMP_DETAILS WHERE UASD_ACCESS_CARD=CARD_NO AND UASD_ACCESS_INVENTORY IS NOT NULL) THEN
    IF INVENTORY_ID IS NULL THEN
        IF ACCESSID IS NULL THEN
            SET @INSERT_TEMP_ACCESS_INVEN=(SELECT CONCAT('INSERT INTO ',TEMP_ACCESS_UNIT,'(INVENTORY_CARD)VALUES(',CARD_NO,')'));
            PREPARE INSERT_TEMP_ACCESS_INVEN_STMT FROM @INSERT_TEMP_ACCESS_INVEN;
            EXECUTE INSERT_TEMP_ACCESS_INVEN_STMT;
        END IF;
        IF ACCESSID IS NOT NULL THEN
            SET @UPDATE_TEMP_ACCESS_INVEN=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET INVENTORY_CARD = ',CARD_NO,' WHERE ID=1'));
            PREPARE UPDATE_TEMP_ACCESS_INVEN_STMT FROM @UPDATE_TEMP_ACCESS_INVEN;
            EXECUTE UPDATE_TEMP_ACCESS_INVEN_STMT;
        END IF;
    ELSE
        SET @CREATE_ACCESS_INVEN_CARD_INCREMENT= (SELECT CONCAT('(SELECT ID INTO @ACCESS_INVEN_INCREMENT FROM ',TEMP_ACCESS_UNIT,' WHERE INVENTORY_CARD IS NOT NULL ORDER BY ID DESC LIMIT 1)'));
        PREPARE CREATE_ACCESS_INVEN_CARD_INCREMENT_STMT FROM @CREATE_ACCESS_INVEN_CARD_INCREMENT;
        EXECUTE CREATE_ACCESS_INVEN_CARD_INCREMENT_STMT;
        SET ACCESS_CARD_INCREMENT=@ACCESS_INVEN_INCREMENT+1;
        SET @CREATE_ACCESS_INV_INCREMENT_ID= (SELECT CONCAT('SELECT ID INTO @INV_INC_ID FROM ',TEMP_ACCESS_UNIT,' WHERE ID=',ACCESS_CARD_INCREMENT));
        PREPARE CREATE_ACCESS_INV_INCREMENT_ID_STMT FROM @CREATE_ACCESS_INV_INCREMENT_ID;
        EXECUTE CREATE_ACCESS_INV_INCREMENT_ID_STMT;
        SET ACCESS_INV_INCREMENT_ID=@INV_INC_ID;
            IF  ACCESS_INV_INCREMENT_ID IS NOT NULL THEN
                SET @UPDATE_TEMP_ACCESS_INVENTORY=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET INVENTORY_CARD =',CARD_NO,' WHERE ID=',ACCESS_CARD_INCREMENT));
                PREPARE UPDATE_TEMP_ACCESS_INVENTORY_STMT FROM @UPDATE_TEMP_ACCESS_INVENTORY;
                EXECUTE UPDATE_TEMP_ACCESS_INVENTORY_STMT;
            ELSE
                SET @INSERT_TEMP_ACCESS_INVENTORY=(SELECT CONCAT('INSERT INTO ',TEMP_ACCESS_UNIT,'(INVENTORY_CARD)VALUES(',CARD_NO,')'));
                PREPARE INSERT_TEMP_ACCESS_INVENTORY_STMT FROM @INSERT_TEMP_ACCESS_INVENTORY;
                EXECUTE INSERT_TEMP_ACCESS_INVENTORY_STMT;
            END IF;
    END IF;
END IF;
IF EXISTS (SELECT UASD_ACCESS_CARD FROM UNIT_ACCESS_STAMP_DETAILS WHERE UASD_ACCESS_CARD=CARD_NO AND UASD_ACCESS_LOST IS NOT NULL) THEN
    IF LOST_ID IS NULL THEN
        IF ACCESSID IS NULL THEN
            IF EXISTS (SELECT * FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!='TERMINATED') AND UASD_ID=CARD_ID AND CACD_GUEST_CARD IS NOT NULL)THEN
                SET @INSERT_TEMP_ACCESS_LOST_GUEST=(SELECT CONCAT('INSERT INTO ',TEMP_ACCESS_UNIT,'(CUSTOMER_LOST_CARD)VALUES((SELECT CONCAT(',CARD_NO,',"  ",
                (SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED")  AND UASD_ID=',CARD_ID,')),"  ","GUEST","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,'),")")))'));
                PREPARE INSERT_TEMP_ACCESS_LOST_GUEST_STMT FROM @INSERT_TEMP_ACCESS_LOST_GUEST;
                EXECUTE INSERT_TEMP_ACCESS_LOST_GUEST_STMT;
                SET @UPDATE_TEMP_ACESS_REASON=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET REASON=(SELECT ACN_DATA FROM ACCESS_CONFIGURATION WHERE ACN_ID =(SELECT ACN_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE
                UASD_ID=(SELECT UASD_ID FROM UNIT_ACCESS_STAMP_DETAILS WHERE UASD_ACCESS_CARD=',CARD_NO,' AND UNIT_ID =(SELECT UNIT_ID FROM UNIT WHERE UNIT_NO=',UNIT_NUMBER,')) AND ACN_ID!=4))WHERE ID=',ACCESS_CARD_COUNT));
                PREPARE UPDATE_TEMP_ACESS_REASON_STMT FROM @UPDATE_TEMP_ACESS_REASON;
                EXECUTE UPDATE_TEMP_ACESS_REASON_STMT;
            ELSE
                SET @INSERT_TEMP_ACCESS_LOST_ORIGINAL=(SELECT CONCAT('INSERT INTO ',TEMP_ACCESS_UNIT,'(CUSTOMER_LOST_CARD)VALUES((SELECT CONCAT(',CARD_NO,',"  ",
                (SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED")  AND UASD_ID=',CARD_ID,')),"  ","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,'),")")))'));
                PREPARE INSERT_TEMP_ACCESS_LOST_ORIGINAL_STMT FROM @INSERT_TEMP_ACCESS_LOST_ORIGINAL;
                EXECUTE INSERT_TEMP_ACCESS_LOST_ORIGINAL_STMT;
                SET @UPDATE_TEMP_ACCESS_LOST_REASON=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET REASON=(SELECT ACN_DATA FROM ACCESS_CONFIGURATION WHERE ACN_ID =(SELECT ACN_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE
                UASD_ID=(SELECT UASD_ID FROM UNIT_ACCESS_STAMP_DETAILS WHERE UASD_ACCESS_CARD=',CARD_NO, ' AND UNIT_ID =(SELECT UNIT_ID FROM UNIT WHERE UNIT_NO=',UNIT_NUMBER,')) AND ACN_ID!=4))WHERE ID=',ACCESS_CARD_COUNT));
                PREPARE UPDATE_TEMP_ACCESS_LOST_REASON_STMT FROM @UPDATE_TEMP_ACCESS_LOST_REASON;
                EXECUTE UPDATE_TEMP_ACCESS_LOST_REASON_STMT;
            END IF;
        END IF;
    IF ACCESSID IS NOT NULL  THEN
    IF EXISTS (SELECT * FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!='TERMINATED') AND UASD_ID=CARD_ID AND CACD_GUEST_CARD IS NOT NULL)THEN
        SET @UPDATE_TEMP_ACCESS_LOST_GUEST=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET CUSTOMER_LOST_CARD =(SELECT CONCAT(',CARD_NO,',"  ",
        (SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED")  AND UASD_ID=',CARD_ID,')),"  ","GUEST","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,'),")"))WHERE ID=1'));
		PREPARE UPDATE_TEMP_ACCESS_LOST_GUEST_STMT FROM @UPDATE_TEMP_ACCESS_LOST_GUEST;
		EXECUTE UPDATE_TEMP_ACCESS_LOST_GUEST_STMT;
        SET @UPDATE_TEMP_ACCESS_LOST_GUEST_REASON=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET REASON=(SELECT ACN_DATA FROM ACCESS_CONFIGURATION WHERE ACN_ID =(SELECT ACN_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE
        UASD_ID=(SELECT UASD_ID FROM UNIT_ACCESS_STAMP_DETAILS WHERE UASD_ACCESS_CARD=',CARD_NO,' AND UNIT_ID =(SELECT UNIT_ID FROM UNIT WHERE UNIT_NO=',UNIT_NUMBER,')) AND ACN_ID!=4))WHERE ID=1'));
		PREPARE UPDATE_TEMP_ACCESS_LOST_GUEST_REASON_STMT FROM @UPDATE_TEMP_ACCESS_LOST_GUEST_REASON;
		EXECUTE UPDATE_TEMP_ACCESS_LOST_GUEST_REASON_STMT;
    ELSE
        SET @UPDATE_ACCESS_LOST_ORIGINAL=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET CUSTOMER_LOST_CARD = (SELECT CONCAT(',CARD_NO,',"  ",
        (SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED")  AND UASD_ID=',CARD_ID,')),"  ","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,'),")"))
        WHERE ID=1'));
		PREPARE UPDATE_ACCESS_LOST_ORIGINAL_STMT FROM @UPDATE_ACCESS_LOST_ORIGINAL;
		EXECUTE UPDATE_ACCESS_LOST_ORIGINAL_STMT;
        SET @UPDATE_ACCESS_LOST_ORG_REASON=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET REASON=(SELECT ACN_DATA FROM ACCESS_CONFIGURATION WHERE ACN_ID =(SELECT ACN_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE
        UASD_ID=(SELECT UASD_ID FROM UNIT_ACCESS_STAMP_DETAILS WHERE UASD_ACCESS_CARD=',CARD_NO,' AND UNIT_ID =(SELECT UNIT_ID FROM UNIT WHERE UNIT_NO=',UNIT_NUMBER,')) AND ACN_ID!=4))WHERE ID=1'));
		PREPARE UPDATE_ACCESS_LOST_ORG_REASON_STMT FROM @UPDATE_ACCESS_LOST_ORG_REASON;
		EXECUTE UPDATE_ACCESS_LOST_ORG_REASON_STMT;
    END IF;
END IF;
ELSE
		SET @CREATE_ACCESS_LOST_CARD_INCREMENT= (SELECT CONCAT('(SELECT ID INTO @ACCESS_LOST_INCREMENT FROM ',TEMP_ACCESS_UNIT,' WHERE CUSTOMER_LOST_CARD IS NOT NULL ORDER BY ID DESC LIMIT 1)'));
        PREPARE CREATE_ACCESS_LOST_CARD_INCREMENT_STMT FROM @CREATE_ACCESS_LOST_CARD_INCREMENT;
        EXECUTE CREATE_ACCESS_LOST_CARD_INCREMENT_STMT;
        SET ACCESS_CARD_INCREMENT=@ACCESS_LOST_INCREMENT+1;
        SET @CREATE_ACCESS_LOST_INCREMENT_ID= (SELECT CONCAT('SELECT ID INTO @LOST_INC_ID FROM ',TEMP_ACCESS_UNIT,' WHERE ID=',ACCESS_CARD_INCREMENT));
        PREPARE CREATE_ACCESS_LOST_INCREMENT_ID_STMT FROM @CREATE_ACCESS_LOST_INCREMENT_ID;
        EXECUTE CREATE_ACCESS_LOST_INCREMENT_ID_STMT;
        SET ACCESS_LOST_INCREMENT_ID=@LOST_INC_ID;
        IF ACCESS_LOST_INCREMENT_ID IS NOT NULL THEN
            IF EXISTS (SELECT * FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!='TERMINATED') AND UASD_ID=CARD_ID AND CACD_GUEST_CARD IS NOT NULL)THEN
                SET @UPDATE_ACESS_LOST_GUEST=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET CUSTOMER_LOST_CARD =(SELECT CONCAT(',CARD_NO,',"  ",
                (SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED")  AND UASD_ID=',CARD_ID,')),"  ","GUEST","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,'),")"))WHERE ID=',ACCESS_CARD_INCREMENT));
				PREPARE UPDATE_ACESS_LOST_GUEST_STMT FROM @UPDATE_ACESS_LOST_GUEST;
				EXECUTE UPDATE_ACESS_LOST_GUEST_STMT;
                SET @UPDATE_ACCESS_LOST_GUEST_REASON=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET REASON=(SELECT ACN_DATA FROM ACCESS_CONFIGURATION WHERE ACN_ID =(SELECT ACN_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE
                UASD_ID=(SELECT UASD_ID FROM UNIT_ACCESS_STAMP_DETAILS WHERE UASD_ACCESS_CARD=',CARD_NO,' AND UNIT_ID =(SELECT UNIT_ID FROM UNIT WHERE UNIT_NO=',UNIT_NUMBER,')) AND ACN_ID!=4))WHERE ID=',ACCESS_CARD_INCREMENT));
				PREPARE UPDATE_ACCESS_LOST_GUEST_REASON_STMT FROM @UPDATE_ACCESS_LOST_GUEST_REASON;
				EXECUTE UPDATE_ACCESS_LOST_GUEST_REASON_STMT;
            ELSE
                SET @UPDATE_ACCESS_LOST_ORG=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET CUSTOMER_LOST_CARD = (SELECT CONCAT(',CARD_NO,',"  ",
                (SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED")  AND UASD_ID=',CARD_ID,'))," ","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,'),")"))
                WHERE ID=',ACCESS_CARD_INCREMENT));
				PREPARE UPDATE_ACCESS_LOST_ORG_STMT FROM @UPDATE_ACCESS_LOST_ORG;
				EXECUTE UPDATE_ACCESS_LOST_ORG_STMT;
                SET @UPDATE_ACCESS_LOST_ORG_REASON=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET REASON=(SELECT ACN_DATA FROM ACCESS_CONFIGURATION WHERE ACN_ID =(SELECT ACN_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE
                UASD_ID=(SELECT UASD_ID FROM UNIT_ACCESS_STAMP_DETAILS WHERE UASD_ACCESS_CARD=',CARD_NO,' AND UNIT_ID =(SELECT UNIT_ID FROM UNIT WHERE UNIT_NO=',UNIT_NUMBER,')) AND ACN_ID!=4))WHERE ID=',ACCESS_CARD_INCREMENT));
				PREPARE UPDATE_ACCESS_LOST_ORG_REASON_STMT FROM @UPDATE_ACCESS_LOST_ORG_REASON;
				EXECUTE UPDATE_ACCESS_LOST_ORG_REASON_STMT;
            END IF;
        ELSE
            IF EXISTS (SELECT * FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!='TERMINATED') AND UASD_ID=CARD_ID AND CACD_GUEST_CARD IS NOT NULL)THEN
                SET @INSERT_ACCESS_LOST_GUEST=(SELECT CONCAT('INSERT INTO ',TEMP_ACCESS_UNIT,'(CUSTOMER_LOST_CARD)VALUES((SELECT CONCAT(',CARD_NO,',"  ",
                (SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED")  AND UASD_ID=',CARD_ID,')),"  ","GUEST","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,'),")")))'));
				PREPARE INSERT_ACCESS_LOST_GUEST_STMT FROM @INSERT_ACCESS_LOST_GUEST;
				EXECUTE INSERT_ACCESS_LOST_GUEST_STMT;
                SET @UPDATE_ACCESS_LOST_GUEST_REASON=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET REASON=(SELECT ACN_DATA FROM ACCESS_CONFIGURATION WHERE ACN_ID =(SELECT ACN_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE
                UASD_ID=(SELECT UASD_ID FROM UNIT_ACCESS_STAMP_DETAILS WHERE UASD_ACCESS_CARD=',CARD_NO,' AND UNIT_ID =(SELECT UNIT_ID FROM UNIT WHERE UNIT_NO=',UNIT_NUMBER,')) AND ACN_ID!=4))WHERE ID=',ACCESS_CARD_INCREMENT));
				PREPARE UPDATE_ACCESS_LOST_GUEST_REASON_STMT FROM @UPDATE_ACCESS_LOST_GUEST_REASON;
				EXECUTE UPDATE_ACCESS_LOST_GUEST_REASON_STMT;
            ELSE
                SET @INSERT_ACCESS_LOST_ORG=(SELECT CONCAT('INSERT INTO ',TEMP_ACCESS_UNIT,'(CUSTOMER_LOST_CARD)VALUES((SELECT CONCAT(',CARD_NO,',"  ",
                (SELECT CUSTOMER_FIRST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,')),"  ",(SELECT CUSTOMER_LAST_NAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED")  AND UASD_ID=',CARD_ID,')),"  ","(",(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!="TERMINATED") AND UASD_ID=',CARD_ID,'),")")))'));
				PREPARE INSERT_ACCESS_LOST_ORG_STMT FROM @INSERT_ACCESS_LOST_ORG;
				EXECUTE INSERT_ACCESS_LOST_ORG_STMT;
                SET @UPDATE_ACCESS_LOST_ORG_REASON=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET REASON=(SELECT ACN_DATA FROM ACCESS_CONFIGURATION WHERE ACN_ID =(SELECT ACN_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE UASD_ID=(SELECT UASD_ID FROM UNIT_ACCESS_STAMP_DETAILS WHERE UASD_ACCESS_CARD=',CARD_NO,' AND UNIT_ID =(SELECT UNIT_ID FROM UNIT WHERE UNIT_NO=',UNIT_NUMBER,')) AND ACN_ID!=4))WHERE ID=',ACCESS_CARD_INCREMENT));
				PREPARE UPDATE_ACCESS_LOST_ORG_REASON_STMT FROM @UPDATE_ACCESS_LOST_ORG_REASON;
				EXECUTE UPDATE_ACCESS_LOST_ORG_REASON_STMT;
            END IF;
        END IF;
    END IF;
END IF;
IF EXISTS (SELECT UASD_ACCESS_CARD FROM UNIT_ACCESS_STAMP_DETAILS WHERE UASD_ACCESS_CARD=CARD_NO AND UASD_ACCESS_LOST IS NOT NULL) THEN
	IF EMP_ID IS NULL THEN
		IF ACCESSID IS NULL THEN 
			IF NOT EXISTS(SELECT UASD_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!='TERMINATED') AND UASD_ID=CARD_ID)THEN
				SET @INSERT_EMP_ORG=(SELECT CONCAT('INSERT INTO ',TEMP_ACCESS_UNIT,'(EMPLOYEE_LOST_CARD)VALUES(',CARD_NO,')'));
				PREPARE INSERT_EMP_ORG_STMT FROM @INSERT_EMP_ORG;
				EXECUTE INSERT_EMP_ORG_STMT;
			END IF;
		END IF;
		IF ACCESSID IS NOT NULL THEN 
			IF NOT EXISTS(SELECT UASD_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!='TERMINATED') AND UASD_ID=CARD_ID)THEN
				SET @UPDATE_EMP_ORG=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET EMPLOYEE_LOST_CARD =',CARD_NO,' WHERE ID=1'));
				PREPARE UPDATE_EMP_ORG_STMT FROM @UPDATE_EMP_ORG;
				EXECUTE UPDATE_EMP_ORG_STMT;
			END IF;
		END IF;
ELSE
		SET @CREATE_ACCESS_EMP_CARD_INCREMENT= (SELECT CONCAT('(SELECT ID INTO @ACCESS_EMP_INCREMENT FROM ',TEMP_ACCESS_UNIT,' WHERE EMPLOYEE_LOST_CARD IS NOT NULL ORDER BY ID DESC LIMIT 1)'));
        PREPARE CREATE_ACCESS_EMP_CARD_INCREMENT_STMT FROM @CREATE_ACCESS_EMP_CARD_INCREMENT;
        EXECUTE CREATE_ACCESS_EMP_CARD_INCREMENT_STMT;
        SET ACCESS_CARD_INCREMENT=@ACCESS_EMP_INCREMENT+1;
        SET @CREATE_ACCESS_EMP_INCREMENT_ID= (SELECT CONCAT('SELECT ID INTO @ACC_EMP_ID FROM ',TEMP_ACCESS_UNIT,' WHERE ID=',ACCESS_CARD_INCREMENT));
        PREPARE CREATE_ACCESS_EMP_INCREMENT_ID_STMT FROM @CREATE_ACCESS_EMP_INCREMENT_ID;
        EXECUTE CREATE_ACCESS_EMP_INCREMENT_ID_STMT;
        SET ACCESS_EMP_INCREMENT_ID=@ACC_EMP_ID;
		IF ACCESS_EMP_INCREMENT_ID IS NOT NULL THEN
			IF NOT EXISTS(SELECT UASD_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!='TERMINATED') AND UASD_ID=CARD_ID)THEN
				SET @UPDATE_ACCESS_EMP=(SELECT CONCAT('UPDATE ',TEMP_ACCESS_UNIT,' SET EMPLOYEE_LOST_CARD = ',CARD_NO,' WHERE ID=',ACCESS_CARD_INCREMENT));
				PREPARE UPDATE_ACCESS_EMP_STMT FROM @UPDATE_ACCESS_EMP;
				EXECUTE UPDATE_ACCESS_EMP_STMT;
			END IF;
		ELSE
		IF NOT EXISTS(SELECT UASD_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IN (SELECT ACN_ID FROM ACCESS_CONFIGURATION WHERE ACN_DATA!='TERMINATED') AND UASD_ID=CARD_ID)THEN
			SET @IN_ACCESS_EMP=(SELECT CONCAT('INSERT INTO ',TEMP_ACCESS_UNIT,'(EMPLOYEE_LOST_CARD)VALUES(',CARD_NO,')'));
			PREPARE IN_ACCESS_EMP_STMT FROM @IN_ACCESS_EMP;
			EXECUTE IN_ACCESS_EMP_STMT;
		END IF;
END IF;
END IF;
END IF;
SET @ACCESS_CARD_ID=NULL;
SET @ACCESS_CARD_NO=NULL;
SET @ACCESS_ACTIVE_ID=NULL;
SET @ACCESS_INVENTORY_ID=NULL;
SET @ACCESS_LOST_ID=NULL;
SET @ACCESS_EMPLOYEE_ID=NULL;
SET @ACCESS_ID=NULL;
SET @INV_INC_ID=NULL;
SET @ACC_EMP_ID=NULL;
SET @LOST_INC_ID=NULL;
SET @ACTIVE_INC_ID=NULL;
SET @ACCESS_EMP_INCREMENT=NULL;
SET ACCESS_CARD_COUNT=ACCESS_CARD_COUNT+1;
END WHILE;
SET @DROPQUERY=(SELECT CONCAT('DROP TABLE IF EXISTS ',TEMP_ACCESS));
PREPARE  STMT2 from @DROPQUERY;
EXECUTE STMT2 ;COMMIT;
END;