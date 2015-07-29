DROP PROCEDURE IF EXISTS SP_CUSTOMER_ACCESS_CARD_TICKLER_OLDVALUE;
CREATE PROCEDURE SP_CUSTOMER_ACCESS_CARD_TICKLER_OLDVALUE (IN CUSTOMERID INTEGER,IN CACDID INTEGER,IN USERSTAMP VARCHAR(50),OUT OLDVALUE_ACCESS TEXT)
BEGIN
-- DECLARING VARIABLES
DECLARE OLDUASDID INTEGER;
DECLARE OLDTIMESTAMP TIMESTAMP;
DECLARE OLDULDID INTEGER;
DECLARE NEWULDID INTEGER;
--  QUERY FOR ROLLBACK COMMAND
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN 
		ROLLBACK;
	END;
	START TRANSACTION;
	SET OLDVALUE_ACCESS='';
	SET NEWULDID = (SELECT ULD_ID FROM USER_LOGIN_DETAILS WHERE ULD_LOGINID=USERSTAMP);
	SET OLDUASDID = (SELECT UASD_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE CUSTOMER_ID = CUSTOMERID AND CACD_ID = CACDID);
	SET OLDTIMESTAMP = (SELECT CACD_TIMESTAMP FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE CUSTOMER_ID = CUSTOMERID AND CACD_ID = CACDID);
	SET OLDULDID = (SELECT ULD_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE CUSTOMER_ID = CUSTOMERID AND CACD_ID = CACDID);
	SET OLDVALUE_ACCESS = (SELECT CONCAT (OLDVALUE_ACCESS,'CUSTOMER_ID = ',CUSTOMERID,',CACD_ID = ',CACDID,', UASD_ID =',OLDUASDID));
	IF (OLDULDID != NEWULDID) THEN
	SET OLDVALUE_ACCESS =  (SELECT CONCAT (OLDVALUE_ACCESS,',ULD_ID = ',OLDULDID,','));
	END IF;
	SET OLDVALUE_ACCESS = (SELECT CONCAT (OLDVALUE_ACCESS,',CLP_TIMESTAMP = ',OLDTIMESTAMP));
	COMMIT;
END;
CALL SP_CUSTOMER_ACCESS_CARD_TICKLER_OLDVALUE(402,2,USERSTAMP,@OLDVALUE_ACCESS);
select @OLDVALUE_ACCESS;