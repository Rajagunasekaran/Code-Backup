DROP PROCEDURE IF EXISTS SP_TS_MIG_EMAIL_TEMPLATE_INSERT;
CREATE PROCEDURE SP_TS_MIG_EMAIL_TEMPLATE_INSERT(
IN SOURCESCHEMA VARCHAR(50),
IN DESTINATIONSCHEMA VARCHAR(50),
IN MIGUSERSTAMP VARCHAR(50))
BEGIN
	DECLARE START_TIME TIME;
	DECLARE END_TIME TIME;
	DECLARE DURATION TIME;
	DECLARE MAX_ID INT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
	END;
	START TRANSACTION;
	SET FOREIGN_KEY_CHECKS=0;
	SET @LOGIN_ID=(SELECT CONCAT('SELECT ULD_ID INTO @ULDID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS WHERE ULD_LOGINID=','"',MIGUSERSTAMP,'"'));
	PREPARE LOGINID_STMT FROM @LOGIN_ID;
	EXECUTE LOGINID_STMT;
	SET START_TIME=(SELECT CURTIME());
	SET @TRUNCATE_EMAIL_TEMPLATE_DETAILS=(SELECT CONCAT('TRUNCATE ',DESTINATIONSCHEMA,'.EMAIL_TEMPLATE'));
	PREPARE TRUNCATE_EMAIL_TEMPLATE_STMT FROM @TRUNCATE_EMAIL_TEMPLATE_DETAILS;
	EXECUTE TRUNCATE_EMAIL_TEMPLATE_STMT;
	SET @INSERT_EMAIL_TEMPLATE=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.EMAIL_TEMPLATE (ET_EMAIL_SCRIPT) 
	(SELECT SCRIPT_NAME FROM ',SOURCESCHEMA,'.EMAIL_SQL_FORMAT WHERE SCRIPT_NAME IS NOT NULL)'));
	PREPARE INSERT_EMAIL_TEMPLATE_STMT FROM @INSERT_EMAIL_TEMPLATE;
	EXECUTE INSERT_EMAIL_TEMPLATE_STMT;
	SET @EMAIL_TEMPLATE_MAX_ID=(SELECT CONCAT('SELECT MAX(ET_ID) INTO @ET_MAXID FROM ',DESTINATIONSCHEMA,'.EMAIL_TEMPLATE'));
	PREPARE EMAIL_TEMPLATE_MAX_ID_STMT FROM @EMAIL_TEMPLATE_MAX_ID;
	EXECUTE EMAIL_TEMPLATE_MAX_ID_STMT;
	SET MAX_ID=@ET_MAXID;
	IF (MAX_ID IS NOT NULL) THEN    
		SET @ALTER_EMAIL_TEMPLATE=(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.EMAIL_TEMPLATE AUTO_INCREMENT=',MAX_ID));
		PREPARE ALTER_EMAIL_TEMPLATE FROM @ALTER_EMAIL_TEMPLATE;
		EXECUTE ALTER_EMAIL_TEMPLATE;
	END IF;
	SET END_TIME=(SELECT CURTIME());
	SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME));
	SET @COUNT_EMAILSQLFORMAT=(SELECT CONCAT('SELECT COUNT(SCRIPT_NAME) INTO @COUNT_EMAIL_SQL_FORMAT FROM ',SOURCESCHEMA,'.EMAIL_SQL_FORMAT WHERE SCRIPT_NAME IS NOT NULL'));
	PREPARE COUNT_EMAIL_SQL_FORMAT_STMT FROM @COUNT_EMAILSQLFORMAT;
	EXECUTE COUNT_EMAIL_SQL_FORMAT_STMT;
	SET @COUNT_SPLITING_EMAIL_TEMPLATE=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_EMAIL_TEMPLATE FROM ',DESTINATIONSCHEMA,'.EMAIL_TEMPLATE'));
	PREPARE COUNT_SPLITING_EMAIL_TEMPLATE_STMT FROM @COUNT_SPLITING_EMAIL_TEMPLATE;
	EXECUTE COUNT_SPLITING_EMAIL_TEMPLATE_STMT;
	SET @REJECTION_COUNT=(@COUNT_EMAIL_SQL_FORMAT-@COUNT_EMAIL_TEMPLATE);
	SET @POSTAPID=(SELECT POSTAP_ID FROM POST_AUDIT_PROFILE WHERE POSTAP_DATA='EMAIL_TEMPLATE');
	SET @PREASPID=(SELECT PREASP_ID FROM PRE_AUDIT_SUB_PROFILE WHERE PREASP_DATA='EMAIL_TEMPLATE');
	SET @PREAMPID=(SELECT PREAMP_ID FROM PRE_AUDIT_MAIN_PROFILE WHERE PREAMP_DATA='EMAIL');
	SET @DUR=DURATION;
	UPDATE PRE_AUDIT_SUB_PROFILE SET PREASP_NO_OF_REC=@COUNT_EMAIL_SQL_FORMAT WHERE PREASP_DATA='EMAIL_TEMPLATE';    
	INSERT INTO POST_AUDIT_HISTORY(POSTAP_ID,POSTAH_NO_OF_REC,PREASP_ID,PREAMP_ID,POSTAH_DURATION,POSTAH_NO_OF_REJ,ULD_ID) VALUES
	(@POSTAPID,@COUNT_EMAIL_TEMPLATE,@PREASPID,@PREAMPID,@DUR,@REJECTION_COUNT,@ULDID);
	SET START_TIME=(SELECT CURTIME());
	SET @TRUNCATE_EMAIL_TEMPLATE_DETAILS=(SELECT CONCAT('TRUNCATE ',DESTINATIONSCHEMA,'.EMAIL_TEMPLATE_DETAILS'));
	PREPARE TRUNCATE_EMAIL_TEMPLATE_DETAILS_STMT FROM @TRUNCATE_EMAIL_TEMPLATE_DETAILS;
	EXECUTE TRUNCATE_EMAIL_TEMPLATE_DETAILS_STMT;
	SET @INSERT_EMAIL_TEMPLATE_DTLS=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.EMAIL_TEMPLATE_DETAILS (ET_ID,ETD_EMAIL_SUBJECT,ETD_EMAIL_BODY,ULD_ID,ETD_TIMESTAMP) 
	(SELECT (SELECT ET_ID FROM ',DESTINATIONSCHEMA,'.EMAIL_TEMPLATE WHERE ET_EMAIL_SCRIPT=SCRIPT_NAME),SUBJECT,BODY,(SELECT ULD_ID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS WHERE ULD_LOGINID=USER_STAMP),TIMESTAMP
	FROM ',SOURCESCHEMA,'.EMAIL_SQL_FORMAT WHERE SUBJECT IS NOT NULL AND BODY IS NOT NULL)'));
	PREPARE INSERT_EMAIL_TEMPLATE_DTLS_STMT FROM @INSERT_EMAIL_TEMPLATE_DTLS;
	EXECUTE INSERT_EMAIL_TEMPLATE_DTLS_STMT;
	SET @EMAIL_TEMPLATE_DETAILS_MAX_ID=(SELECT CONCAT('SELECT MAX(ETD_ID) INTO @ETD_MAXID FROM ',DESTINATIONSCHEMA,'.EMAIL_TEMPLATE_DETAILS'));
	PREPARE EMAIL_TEMPLATE_DETAILS_MAX_ID_STMT FROM @EMAIL_TEMPLATE_DETAILS_MAX_ID;
	EXECUTE EMAIL_TEMPLATE_DETAILS_MAX_ID_STMT;
	SET MAX_ID=@ETD_MAXID;
	IF (MAX_ID IS NOT NULL) THEN    
		SET @ALTER_EMAIL_TEMPLATE_DETAILS=(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.EMAIL_TEMPLATE_DETAILS AUTO_INCREMENT=',MAX_ID));
		PREPARE ALTER_EMAIL_TEMPLATE_DETAILS_STMT FROM @ALTER_EMAIL_TEMPLATE_DETAILS;
		EXECUTE ALTER_EMAIL_TEMPLATE_DETAILS_STMT;
	END IF;
	SET END_TIME=(SELECT CURTIME());
	SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME));
	SET @COUNT_EMAILSQLFORMAT_DTLS=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_EMAIL_SQL_FORMAT_DTLS FROM ',SOURCESCHEMA,'.EMAIL_SQL_FORMAT WHERE SUBJECT IS NOT NULL AND BODY IS NOT NULL'));
	PREPARE COUNT_EMAIL_SQL_FORMAT_DTLS_STMT FROM @COUNT_EMAILSQLFORMAT_DTLS;
	EXECUTE COUNT_EMAIL_SQL_FORMAT_DTLS_STMT;
	SET @COUNT_SPLITING_EMAIL_TEMPLATE=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_EMAIL_TEMPLATE_DTLS FROM ',DESTINATIONSCHEMA,'.EMAIL_TEMPLATE_DETAILS'));
	PREPARE COUNT_SPLITING_EMAIL_TEMPLATE_DTLS_STMT FROM @COUNT_SPLITING_EMAIL_TEMPLATE;
	EXECUTE COUNT_SPLITING_EMAIL_TEMPLATE_DTLS_STMT;
	SET @REJECTION_COUNT=(@COUNT_EMAIL_SQL_FORMAT_DTLS-@COUNT_EMAIL_TEMPLATE_DTLS);
	SET @POSTAPID=(SELECT POSTAP_ID FROM POST_AUDIT_PROFILE WHERE POSTAP_DATA='EMAIL_TEMPLATE_DETAILS');
	SET @PREASPID=(SELECT PREASP_ID FROM PRE_AUDIT_SUB_PROFILE WHERE PREASP_DATA='EMAIL_TEMPLATE_DETAILS');
	SET @PREAMPID=(SELECT PREAMP_ID FROM PRE_AUDIT_MAIN_PROFILE WHERE PREAMP_DATA='EMAIL');
	SET @DUR=DURATION;
	UPDATE PRE_AUDIT_SUB_PROFILE SET PREASP_NO_OF_REC=@COUNT_EMAIL_SQL_FORMAT_DTLS WHERE PREASP_DATA='EMAIL_TEMPLATE_DETAILS';    
	INSERT INTO POST_AUDIT_HISTORY(POSTAP_ID,POSTAH_NO_OF_REC,PREASP_ID,PREAMP_ID,POSTAH_DURATION,POSTAH_NO_OF_REJ,ULD_ID) VALUES
	(@POSTAPID,@COUNT_EMAIL_TEMPLATE_DTLS,@PREASPID,@PREAMPID,@DUR,@REJECTION_COUNT,@ULDID);
	SET FOREIGN_KEY_CHECKS=1;
	COMMIT;
END;
