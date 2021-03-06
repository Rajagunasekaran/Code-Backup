DROP PROCEDURE IF EXISTS SP_CONFIG_MONTH;
CREATE PROCEDURE SP_CONFIG_MONTH(
IN UNITID INTEGER,
OUT CONFIGDATE DATE)
BEGIN
DECLARE UNITMONTH INTEGER;
DECLARE UNIT_MONTH INTEGER;
DECLARE UNITEDATE DATE;
SET UNITEDATE=(SELECT UD_END_DATE FROM UNIT_DETAILS WHERE UNIT_ID=UNITID);
SET UNITMONTH=(SELECT ECN_DATA FROM EXPENSE_CONFIGURATION WHERE CGN_ID=(SELECT CGN_ID FROM CONFIGURATION WHERE CGN_TYPE='UNIT MONTH'));
SET UNIT_MONTH=1;
WHILE UNIT_MONTH<=UNITMONTH DO
SET CONFIGDATE=(SELECT DATE_ADD(UNITEDATE,INTERVAL 1 MONTH));
SET UNITEDATE=CONFIGDATE;
SET UNIT_MONTH=UNIT_MONTH+1;
END WHILE;
END;

CALL SP_CONFIG_MONTH(28,@CONFIGDATE);