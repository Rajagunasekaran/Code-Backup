DROP PROCEDURE IF EXISTS SP_EXPENSE_PERSONAL_INSERT;
CREATE PROCEDURE SP_EXPENSE_PERSONAL_INSERT(IN DESTINATIONSCHEMA VARCHAR(50),IN MIGUSERSTAMP VARCHAR(50))
BEGIN
DECLARE PERSONALPART1 TIME;
DECLARE PERSONALPART2 TIME;
DECLARE START_TIME TIME;
DECLARE END_TIME TIME;
DECLARE DURATION TIME;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
END;
START TRANSACTION;
SET @LOGIN_ID=(SELECT CONCAT('SELECT ULD_ID INTO @USERSTAMPID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS WHERE ULD_LOGINID=','"',MIGUSERSTAMP,'"'));
PREPARE LOGINID FROM @LOGIN_ID;
EXECUTE LOGINID;
SET PERSONALPART1=(SELECT SPLITTING_DURATION FROM TEMP_DURATION_PERSONAL_INVOICE_ITEM_FROM);
SET PERSONALPART2=(SELECT SPLITTING_DURATION2 FROM TEMP_DURATION_PERSONAL_PART2);
SET DURATION=(SELECT ADDTIME(PERSONALPART1,PERSONALPART2));
SET @COUNT_SCDB_PERSONAL=(SELECT COUNT(*) FROM PERSONAL_SCDB_FORMAT WHERE PE_TYPE_OF_EXPENSE='PERSONAL');
SET @COUNT_SPLITTED_PERSONAL=(SELECT CONCAT('SELECT COUNT(*) INTO @SPLITEDPERSONAL FROM ',DESTINATIONSCHEMA,'.EXPENSE_PERSONAL'));
PREPARE COUNT_SPLITTED_PERSONALSTMT FROM @COUNT_SPLITTED_PERSONAL;
EXECUTE COUNT_SPLITTED_PERSONALSTMT;
SET @REJECTION_COUNT=(@COUNT_SCDB_PERSONAL-@SPLITEDPERSONAL);
SET FOREIGN_KEY_CHECKS = 0;
UPDATE PRE_AUDIT_SUB_PROFILE SET PREASP_NO_OF_REC=@COUNT_SCDB_PERSONAL WHERE PREASP_DATA='EXPENSE_PERSONAL';
INSERT INTO POST_AUDIT_HISTORY(POSTAP_ID,POSTAH_NO_OF_REC,PREASP_ID,PREAMP_ID,POSTAH_DURATION,POSTAH_NO_OF_REJ,ULD_ID)
VALUES((SELECT POSTAP_ID FROM POST_AUDIT_PROFILE WHERE POSTAP_DATA='EXPENSE_PERSONAL'),@SPLITEDPERSONAL,(SELECT PREASP_ID FROM PRE_AUDIT_SUB_PROFILE WHERE PREASP_DATA='EXPENSE_PERSONAL'),
(SELECT PREAMP_ID FROM PRE_AUDIT_MAIN_PROFILE WHERE PREAMP_DATA='PERSONAL'),DURATION,@REJECTION_COUNT,@USERSTAMPID);
DROP TABLE IF EXISTS TEMP_PERSONAL_INVOICE_ITEM_FROM_SPLITTED_TABLE;
DROP TABLE IF EXISTS TEMP_PERSONAL_SCDB_FORMAT;
DROP TABLE IF EXISTS TEMP_DURATION_PERSONAL_INVOICE_ITEM_FROM;
DROP TABLE IF EXISTS TEMP_DURATION_PERSONAL_PART1;
DROP TABLE IF EXISTS TEMP_DURATION_PERSONAL_PART2;
COMMIT;
END;