DROP PROCEDURE IF EXISTS SP_TS_LOGIN_CREATION_INSERT;
CREATE PROCEDURE SP_TS_LOGIN_CREATION_INSERT (
IN LOGINID VARCHAR(40),
IN ROLENAME VARCHAR(15),
IN JOINDATE DATE,
IN USERSTAMP VARCHAR(50),
OUT SUCCESS_FLAG INTEGER)
BEGIN
	DECLARE RECVER INTEGER;
	DECLARE ULDID INTEGER;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN 
	ROLLBACK; 
		SET SUCCESS_FLAG=0;
	END;
	SET AUTOCOMMIT = 0;
	START TRANSACTION;
	SET RECVER=(SELECT MAX(UA_REC_VER) FROM USER_ACCESS WHERE ULD_ID=(SELECT ULD_ID FROM USER_LOGIN_DETAILS WHERE ULD_LOGINID=LOGINID));
	SET ULDID=(SELECT DISTINCT ULD_ID FROM USER_ACCESS WHERE ULD_ID=(SELECT ULD_ID FROM USER_LOGIN_DETAILS WHERE ULD_LOGINID=LOGINID));
	IF NOT EXISTS(SELECT ULD_LOGINID FROM USER_LOGIN_DETAILS WHERE ULD_LOGINID=LOGINID) THEN
		IF (LOGINID IS NOT NULL) THEN
			INSERT INTO USER_LOGIN_DETAILS(ULD_LOGINID,ULD_USERSTAMP)VALUES(LOGINID,USERSTAMP);
			SET SUCCESS_FLAG=1;
		END IF;
	END IF;	
	IF (LOGINID IS NOT NULL AND ROLENAME IS NOT NULL AND JOINDATE IS NOT NULL AND USERSTAMP IS NOT NULL)THEN
		IF (ULDID IS NOT NULL) THEN
			INSERT INTO USER_ACCESS(RC_ID,ULD_ID,UA_REC_VER,UA_JOIN_DATE,UA_JOIN,UA_USERSTAMP)VALUES((SELECT RC_ID FROM ROLE_CREATION WHERE RC_NAME=ROLENAME),
			(SELECT ULD_ID FROM USER_LOGIN_DETAILS WHERE ULD_LOGINID=LOGINID),(RECVER+1),JOINDATE,'X',USERSTAMP);
			SET SUCCESS_FLAG=1;
		ELSE
			INSERT INTO USER_ACCESS(RC_ID,ULD_ID,UA_REC_VER,UA_JOIN_DATE,UA_JOIN,UA_USERSTAMP)VALUES((SELECT RC_ID FROM ROLE_CREATION WHERE RC_NAME=ROLENAME),
			(SELECT ULD_ID FROM USER_LOGIN_DETAILS WHERE ULD_LOGINID=LOGINID),1,JOINDATE,'X',USERSTAMP);
			SET SUCCESS_FLAG=1;
		END IF;   
	END IF;	
	COMMIT;
END;
CALL SP_TS_LOGIN_CREATION_INSERT(LOGINID,ROLENAME,JOINDATE,USERSTAMP,SUCCESS_FLAG);