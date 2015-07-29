-- VERSION 0.7 STARTDATE:11/08/2014 ENDDATE:11/08/2014 ISSUE NO:835 COMMENTNO :66 DESC:IMPLEMENTED SET AUTOCOMMIT=0 BEFORE TRANSACTION. DONE BY :RAJA
-- version 0.6 startdate:10/06/2014 -- enddate:10/06/2014-- - issueno 566 commentno:12-- >desc: ADDED ROLLBACK AND COMMIT-SASIKALA
-- version 0.5 startdate:28/02/2014 -- enddate:28/02/2014-- - issueno 754 commentno:36-- >desc: APPLIED SUB_SP TO REPLACE USERSTAMP AS ID-SAFI
-- version 0.4 -- sdate:27/02/2014 -- edate:27/02/2014 -- issue:754 -- comment:22 -- doneby:RL	
-- VER 0.3 ISSUE NO:659 COMMENT #48 STARTDATE:13/01/2014 ENDDATE:13/01/2014 DESC:SP FOR USER RIGHTS BASIC PROFILE. FIXED THE ISSUE OF DELETE SCRIPT NOT WORKED PROPERLY IN SP BECAUSE OF IN CONDITION. SO USED 'EXECUTE' STATEMENT FOR EXECUTING THE SCRIPT. UPDATE DONE BY:MANIKANDAN.S
DROP PROCEDURE IF EXISTS SP_USER_RIGHTS_BASIC_PROFILE_UPDATE;
CREATE PROCEDURE SP_USER_RIGHTS_BASIC_PROFILE_UPDATE (IN USER_STAMP VARCHAR(50), IN ROLE VARCHAR(255),IN BASIC_ROLES VARCHAR(255), IN MENUS TEXT(255),OUT UR_FLAG INTEGER ) 
BEGIN
  DECLARE V_URC_ID    INT;
  DECLARE V_STRLEN1    INT DEFAULT 0;
  DECLARE V_STRLEN2    INT DEFAULT 0;
  DECLARE V_STRLEN3    INT DEFAULT 0;
  DECLARE V_SUBSTRLEN1 INT DEFAULT 0;
  DECLARE V_SUBSTRLEN2 INT DEFAULT 0;
  DECLARE V_SUBSTRLEN3 INT DEFAULT 0;
  DECLARE V_MENU_ID   INT;
  DECLARE V_COUNT_1   INT;
  DECLARE V_COUNT_2   INT;
  DECLARE V_BASIC_ROLES_ID2 INT;
  DECLARE V_BASIC_ROLES_ID1 INT;
  DECLARE V_BASIC_ROLE2 VARCHAR(255);  
  DECLARE V_BASIC_ROLE1 VARCHAR(255); 
  DECLARE V_BS_ID TEXT(100) DEFAULT '';
  DECLARE BASIC_ROLES1 VARCHAR(255);
  DECLARE BASIC_ROLES2 VARCHAR(255);
  DECLARE query1 VARCHAR(200);
  DECLARE query2 VARCHAR(300);
  DECLARE USERSTAMP_ID INTEGER(2);
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
   ROLLBACK;
  END;
  SET AUTOCOMMIT = 0;
  START TRANSACTION;
SET V_URC_ID = (SELECT URC_ID FROM USER_RIGHTS_CONFIGURATION WHERE URC_DATA = ROLE);
CALL SP_CHANGE_USERSTAMP_AS_ULDID(USER_STAMP,@ULDID);
SET USERSTAMP_ID = (SELECT @ULDID);
SET UR_FLAG=0;
--  checking whether basic role is empty
IF BASIC_ROLES IS NULL THEN
    SET BASIC_ROLES = '';
  END IF;
  SET BASIC_ROLES1 = BASIC_ROLES;
  DO_THIS_DELETE:
  LOOP
    SET V_STRLEN1 = CHAR_LENGTH(BASIC_ROLES1); 
    SET V_BASIC_ROLE1 = SUBSTRING_INDEX(BASIC_ROLES1, ',', 1); 
    SET V_BASIC_ROLES_ID1 = (SELECT URC_ID FROM USER_RIGHTS_CONFIGURATION WHERE URC_DATA = V_BASIC_ROLE1);
    SET V_BS_ID = CONCAT (V_BS_ID,"'",V_BASIC_ROLES_ID1,"',");
    SET V_SUBSTRLEN1 = CHAR_LENGTH(SUBSTRING_INDEX(BASIC_ROLES1, ',', 1)) + 2;
    SET BASIC_ROLES1 = MID(BASIC_ROLES1, V_SUBSTRLEN1, V_STRLEN1);
    IF BASIC_ROLES1 = '' THEN
      LEAVE DO_THIS_DELETE;
    END IF;
  END LOOP DO_THIS_DELETE;
  --  REMOVING COMMA(,) FROM END OF THE STRING(BASIC_ROLE ID'S)
  SET V_BS_ID = SUBSTRING(V_BS_ID,1,(CHAR_LENGTH(V_BS_ID)-1) );
  --  deleting basic roles which is not available in the input during updation
  SET @query1 = CONCAT('DELETE FROM BASIC_ROLE_PROFILE WHERE BRP_BR_ID NOT IN (', V_BS_ID ,') AND URC_ID =',V_URC_ID);
  PREPARE stmt1 FROM @query1;
  EXECUTE stmt1;
  DEALLOCATE PREPARE stmt1;
  SET UR_FLAG=1;
 DO_THIS_FIRST:
  LOOP
    SET V_STRLEN2 = CHAR_LENGTH(BASIC_ROLES); 
    SET V_BASIC_ROLE2 = SUBSTRING_INDEX(BASIC_ROLES, ',', 1); 
    SET V_BASIC_ROLES_ID2 = (SELECT URC_ID FROM USER_RIGHTS_CONFIGURATION WHERE URC_DATA = V_BASIC_ROLE2);
    SELECT COUNT(BRP_ID) INTO V_COUNT_1 FROM BASIC_ROLE_PROFILE WHERE BRP_BR_ID = V_BASIC_ROLES_ID2 AND URC_ID = V_URC_ID;
     IF (V_COUNT_1 = 0) THEN
     INSERT INTO BASIC_ROLE_PROFILE (URC_ID, BRP_BR_ID, ULD_ID) VALUES (V_URC_ID, V_BASIC_ROLES_ID2, USERSTAMP_ID);
     END IF;
     SET UR_FLAG=1;
    SET V_SUBSTRLEN2 = CHAR_LENGTH(SUBSTRING_INDEX(BASIC_ROLES, ',', 1)) + 2;
    SET BASIC_ROLES = MID(BASIC_ROLES, V_SUBSTRLEN2, V_STRLEN2);
    IF BASIC_ROLES = '' THEN
      LEAVE DO_THIS_FIRST;
    END IF;
  END LOOP DO_THIS_FIRST;
  IF MENUS IS NULL THEN
    SET MENUS = '';
  END IF;
   SET @query2 = CONCAT('DELETE FROM BASIC_MENU_PROFILE WHERE MP_ID NOT IN (',MENUS,') AND URC_ID =', V_URC_ID);
   PREPARE stmt2 FROM @query2;
   EXECUTE stmt2;
   DEALLOCATE PREPARE stmt2;
   SET UR_FLAG=1;
DO_THIS:
  LOOP
    SET V_STRLEN3 = CHAR_LENGTH(MENUS);
    SET V_MENU_ID = SUBSTRING_INDEX(MENUS, ',', 1);
    SELECT COUNT(BMP_ID) INTO V_COUNT_2 FROM BASIC_MENU_PROFILE WHERE MP_ID = V_MENU_ID AND URC_ID = V_URC_ID;
    IF (V_COUNT_2 = 0) THEN
    INSERT INTO BASIC_MENU_PROFILE (URC_ID, MP_ID, ULD_ID) VALUES (V_URC_ID, V_MENU_ID, USERSTAMP_ID);    
    END IF;
    SET UR_FLAG=1;
    SET V_SUBSTRLEN3 = CHAR_LENGTH(SUBSTRING_INDEX(MENUS, ',', 1)) + 2;
    SET MENUS = MID(MENUS, V_SUBSTRLEN3, V_STRLEN3);
    IF MENUS = '' THEN
      LEAVE DO_THIS;
    END IF;
  END LOOP DO_THIS;
  COMMIT;
END;
/*
CALL SP_USER_RIGHTS_BASIC_PROFILE_UPDATE('EXPATSINTEGRATED@GMAIL.COM','USER','USER','1,4,2,9,8',@UR_FLAG);
*/