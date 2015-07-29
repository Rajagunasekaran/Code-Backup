DROP PROCEDURE IF EXISTS SP_TS_MIG_CONFIGURATION_INSERT;
CREATE PROCEDURE SP_TS_MIG_CONFIGURATION_INSERT(
IN SOURCESCHEMA VARCHAR(40),
IN DESTINATIONSCHEMA VARCHAR(40),
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
    SET START_TIME = (SELECT CURTIME());
  	SET @DROP_TICKLER_PROFILE=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TICKLER_PROFILE'));
  	PREPARE DROP_TICKLER_PROFILE_STMT FROM @DROP_TICKLER_PROFILE;
    EXECUTE DROP_TICKLER_PROFILE_STMT;
  	SET @CREATE_TICKLER_PROFILE=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.TICKLER_PROFILE(
  	TP_ID INTEGER NOT NULL AUTO_INCREMENT,
  	TP_TYPE	CHAR(10) NOT NULL,
  	PRIMARY KEY(TP_ID))'));
  	PREPARE CREATE_TICKLER_PROFILE_STMT FROM @CREATE_TICKLER_PROFILE;
    EXECUTE CREATE_TICKLER_PROFILE_STMT;
  	SET @INSERT_TICKLER_PROFILE=(SELECT CONCAT('INSERT INTO  ',DESTINATIONSCHEMA,'.TICKLER_PROFILE (TP_TYPE) (SELECT TP_TYPE FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT WHERE TP_TYPE IS NOT NULL)'));
  	PREPARE INSERT_TICKLER_PROFILE_STMT FROM @INSERT_TICKLER_PROFILE;
    EXECUTE INSERT_TICKLER_PROFILE_STMT;
    SET @TICKLERPROFILE_MAX_ID = (SELECT CONCAT('SELECT MAX(TP_ID) INTO @TICKLER_PROFILE_MAX_ID FROM ',DESTINATIONSCHEMA,'.TICKLER_PROFILE'));
    PREPARE TICKLER_PROFILE_MAX_ID_STMT FROM @TICKLERPROFILE_MAX_ID;
    EXECUTE TICKLER_PROFILE_MAX_ID_STMT;
    SET MAX_ID=@TICKLER_PROFILE_MAX_ID;
    IF (MAX_ID IS NOT NULL) THEN    
		SET @ALTER_TICKLER_PROFILE=(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.TICKLER_PROFILE AUTO_INCREMENT=',MAX_ID));
		PREPARE ALTER_TICKLER_PROFILE_STMT FROM @ALTER_TICKLER_PROFILE;
		EXECUTE ALTER_TICKLER_PROFILE_STMT;
    END IF;
  	SET END_TIME = (SELECT CURTIME());
  	SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME));
    SET @COUNT_TICKLERCONFIGURATIONSQLFORMAT=(SELECT CONCAT('SELECT COUNT(TP_TYPE) INTO @COUNT_TICKLER_CONFIGURATION_SQL_FORMAT FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT WHERE TP_TYPE IS NOT NULL'));
    PREPARE COUNT_TICKLERCONFIGURATIONSQLFORMAT_STMT FROM @COUNT_TICKLERCONFIGURATIONSQLFORMAT;
    EXECUTE COUNT_TICKLERCONFIGURATIONSQLFORMAT_STMT;
    SET @COUNT_SPLITINGTICKLER_PROFILE=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_SPLITING_TICKLER_PROFILE FROM ',DESTINATIONSCHEMA,'.TICKLER_PROFILE'));
    PREPARE COUNT_SPLITINGCOUNT_TICKLER_PROFILE_STMT FROM @COUNT_SPLITINGTICKLER_PROFILE;
    EXECUTE COUNT_SPLITINGCOUNT_TICKLER_PROFILE_STMT;
    SET @REJECTION_COUNT=(@COUNT_TICKLER_CONFIGURATION_SQL_FORMAT-@COUNT_SPLITING_TICKLER_PROFILE);
    SET @POSTAPID= (SELECT POSTAP_ID FROM POST_AUDIT_PROFILE WHERE POSTAP_DATA='TICKLER_PROFILE');
    SET @PREASPID = (SELECT PREASP_ID FROM PRE_AUDIT_SUB_PROFILE WHERE PREASP_DATA='TICKLER_PROFILE');
    SET @PREAMPID = (SELECT PREAMP_ID FROM PRE_AUDIT_MAIN_PROFILE WHERE PREAMP_DATA='CONFIGURATION');
    SET @DUR=DURATION;
    UPDATE PRE_AUDIT_SUB_PROFILE SET PREASP_NO_OF_REC=@COUNT_TICKLER_CONFIGURATION_SQL_FORMAT WHERE PREASP_DATA='TICKLER_PROFILE';    
    INSERT INTO POST_AUDIT_HISTORY(POSTAP_ID,POSTAH_NO_OF_REC,PREASP_ID,PREAMP_ID,POSTAH_DURATION,POSTAH_NO_OF_REJ,ULD_ID) VALUES
    (@POSTAPID,@COUNT_SPLITING_TICKLER_PROFILE,@PREASPID,@PREAMPID,@DUR,@REJECTION_COUNT,@ULDID);
    SET START_TIME = (SELECT CURTIME());	
    SET @DROP_TICKLER_TABLE_PROFILE=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TICKLER_TABID_PROFILE'));
    PREPARE DROP_TICKLER_TABLE_PROFILE_STMT FROM @DROP_TICKLER_TABLE_PROFILE;
    EXECUTE DROP_TICKLER_TABLE_PROFILE_STMT;
    SET @CREATE_TICKLER_TABLE_PROFILE=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.TICKLER_TABID_PROFILE(
    TTIP_ID INTEGER NOT NULL AUTO_INCREMENT,
    TTIP_DATA	VARCHAR(50) NOT NULL,
    PRIMARY KEY(TTIP_ID))'));
    PREPARE CREATE_TICKLER_TABLE_PROFILE_STMT FROM @CREATE_TICKLER_TABLE_PROFILE;
    EXECUTE CREATE_TICKLER_TABLE_PROFILE_STMT;
    SET @INSERT_TICKLER_TABLE_PROFILE=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'. TICKLER_TABID_PROFILE(TTIP_DATA) (SELECT TTIP_DATA FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT WHERE TTIP_DATA IS NOT NULL)'));
    PREPARE INSERT_TICKLER_TABLE_PROFILE_STMT FROM @INSERT_TICKLER_TABLE_PROFILE;
    EXECUTE INSERT_TICKLER_TABLE_PROFILE_STMT;
    SET @TICKLERTABIDPROFILE_MAX_ID = (SELECT CONCAT('SELECT MAX(TTIP_ID) INTO @TICKLER_TABID_PROFILE_MAX_ID FROM ',DESTINATIONSCHEMA,'.TICKLER_TABID_PROFILE'));
    PREPARE TICKLER_TABID_PROFILE_MAX_ID_STMT FROM @TICKLERTABIDPROFILE_MAX_ID;
    EXECUTE TICKLER_TABID_PROFILE_MAX_ID_STMT;
    SET MAX_ID=@TICKLER_TABID_PROFILE_MAX_ID;
    IF (MAX_ID IS NOT NULL) THEN    
		SET @ALTER_TICKLER_TABID_PROFILE =(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.TICKLER_TABID_PROFILE AUTO_INCREMENT=',MAX_ID));
		PREPARE ALTER_TICKLER_TABID_PROFILE_STMT FROM @ALTER_TICKLER_TABID_PROFILE;
		EXECUTE ALTER_TICKLER_TABID_PROFILE_STMT;
    END IF;
    SET END_TIME = (SELECT CURTIME());
    SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME));    
    SET @COUNT_TICKLERTABIDCONFIGURATIONSQLFORMAT=(SELECT CONCAT('SELECT COUNT(TTIP_DATA) INTO @COUNT_TICKLER_TABID_CONFIGURATION_SQL_FORMAT FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT WHERE TTIP_DATA IS NOT NULL'));
    PREPARE COUNT_TICKLERTABIDCONFIGURATIONSQLFORMAT_STMT FROM @COUNT_TICKLERTABIDCONFIGURATIONSQLFORMAT;
    EXECUTE COUNT_TICKLERTABIDCONFIGURATIONSQLFORMAT_STMT;
    SET @COUNT_SPLITINGTICKLER_TABID=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_SPLITING_TICKLER_TABID FROM ',DESTINATIONSCHEMA,'.TICKLER_TABID_PROFILE'));
    PREPARE COUNT_SPLITINGTICKLER_TABID_STMT FROM @COUNT_SPLITINGTICKLER_TABID;
    EXECUTE COUNT_SPLITINGTICKLER_TABID_STMT;
    SET @REJECTION_COUNT=(@COUNT_TICKLER_TABID_CONFIGURATION_SQL_FORMAT-@COUNT_SPLITING_TICKLER_TABID);
    SET @POSTAPID= (SELECT POSTAP_ID FROM POST_AUDIT_PROFILE WHERE POSTAP_DATA='TICKLER_TABID_PROFILE');
    SET @PREASPID = (SELECT PREASP_ID FROM PRE_AUDIT_SUB_PROFILE WHERE PREASP_DATA='TICKLER_TABID_PROFILE');
    SET @PREAMPID = (SELECT PREAMP_ID FROM PRE_AUDIT_MAIN_PROFILE WHERE PREAMP_DATA='CONFIGURATION');
    SET @DUR=DURATION;
    UPDATE PRE_AUDIT_SUB_PROFILE SET PREASP_NO_OF_REC=@COUNT_TICKLER_TABID_CONFIGURATION_SQL_FORMAT WHERE PREASP_DATA='TICKLER_TABID_PROFILE';    
    INSERT INTO POST_AUDIT_HISTORY(POSTAP_ID,POSTAH_NO_OF_REC,PREASP_ID,PREAMP_ID,POSTAH_DURATION,POSTAH_NO_OF_REJ,ULD_ID)VALUES
    (@POSTAPID,@COUNT_SPLITING_TICKLER_TABID,@PREASPID,@PREAMPID,@DUR,@REJECTION_COUNT,@ULDID);
    SET START_TIME = (SELECT CURTIME());
    SET @DROP_TICKLER_HISTORY=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TICKLER_HISTORY'));
    PREPARE DROP_TICKLER_HISTORY_STMT FROM @DROP_TICKLER_HISTORY;
    EXECUTE DROP_TICKLER_HISTORY_STMT;
    SET @CREATE_TICKLER_HISTORY=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.TICKLER_HISTORY(
    TH_ID INTEGER NOT NULL AUTO_INCREMENT,
    TP_ID INTEGER NOT NULL,
    ULD_ID INTEGER NULL,
    TTIP_ID INTEGER NOT NULL,
    TH_OLD_VALUE TEXT NOT NULL,    
    TH_NEW_VALUE TEXT NULL,    
    TH_USERSTAMP_ID	INTEGER(2) NOT NULL,
    TH_TIMESTAMP  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(TH_ID),
    FOREIGN KEY(TP_ID) REFERENCES ',DESTINATIONSCHEMA,'.TICKLER_PROFILE(TP_ID),
    FOREIGN KEY(TTIP_ID) REFERENCES ',DESTINATIONSCHEMA,'.TICKLER_TABID_PROFILE(TTIP_ID),
    FOREIGN KEY(TH_USERSTAMP_ID) REFERENCES ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS (ULD_ID))'));
    PREPARE CREATE_TICKLER_HISTORY_STMT FROM @CREATE_TICKLER_HISTORY;
    EXECUTE CREATE_TICKLER_HISTORY_STMT;
    SET @TICKLERHISTORY_MAX_ID = (SELECT CONCAT('SELECT MAX(TH_ID) INTO @TICKLER_HISTORY_MAX_ID FROM ',DESTINATIONSCHEMA,'.TICKLER_HISTORY'));
    PREPARE TICKLER_HISTORY_MAX_ID_STMT FROM @TICKLERHISTORY_MAX_ID;
    EXECUTE TICKLER_HISTORY_MAX_ID_STMT;
    SET MAX_ID=@TICKLER_HISTORY_MAX_ID;
    IF (MAX_ID IS NOT NULL) THEN    
		SET @ALTER_TICKLER_HISTORY=(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.TICKLER_HISTORY AUTO_INCREMENT=',MAX_ID));
		PREPARE ALTER_TICKLER_HISTORY_STMT FROM @ALTER_TICKLER_HISTORY;
		EXECUTE ALTER_TICKLER_HISTORY_STMT;
    END IF;
    SET END_TIME = (SELECT CURTIME());
    SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME)); 
	SET START_TIME = (SELECT CURTIME());	
    SET @DROP_CONFIGURATION_PROFILE=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.CONFIGURATION_PROFILE'));
    PREPARE DROP_CONFIGURATION_PROFILE_STMT FROM @DROP_CONFIGURATION_PROFILE;
    EXECUTE DROP_CONFIGURATION_PROFILE_STMT;	
    SET @CREATE_CONFIGURATION_PROFILE=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.CONFIGURATION_PROFILE(		
    CNP_ID INTEGER NOT NULL	AUTO_INCREMENT,
    CNP_DATA VARCHAR(25) UNIQUE	NOT NULL,
    PRIMARY KEY(CNP_ID))'));	
    PREPARE CREATE_CONFIGURATION_PROFILE_STMT FROM @CREATE_CONFIGURATION_PROFILE;
    EXECUTE CREATE_CONFIGURATION_PROFILE_STMT;
    SET @INSERT_CONFIGURATION_PROFILE=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.CONFIGURATION_PROFILE(CNP_DATA) SELECT CNP_DATA FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT WHERE CNP_DATA IS NOT NULL AND CNP_ID IN (1,2,3,4) ORDER BY ID'));
    PREPARE INSERT_CONFIGURATION_PROFILE_STMT FROM @INSERT_CONFIGURATION_PROFILE;
    EXECUTE INSERT_CONFIGURATION_PROFILE_STMT;
    SET @CONFIGPROFILE_MAX_ID = (SELECT CONCAT('SELECT MAX(CNP_ID) INTO @CONFIG_PROFILE_MAX_ID FROM ',DESTINATIONSCHEMA,'.CONFIGURATION_PROFILE'));
    PREPARE CONFIG_PROFILE_MAX_ID_STMT FROM @CONFIGPROFILE_MAX_ID;
    EXECUTE CONFIG_PROFILE_MAX_ID_STMT;
    SET MAX_ID=@CONFIG_PROFILE_MAX_ID;
    IF (MAX_ID IS NOT NULL) THEN    
		SET @ALTER_CONFIGURATION_PROFILE =(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.CONFIGURATION_PROFILE AUTO_INCREMENT=',MAX_ID));
		PREPARE ALTER_CONFIGURATION_PROFILE_STMT FROM @ALTER_CONFIGURATION_PROFILE;
		EXECUTE ALTER_CONFIGURATION_PROFILE_STMT;
    END IF;
    SET END_TIME = (SELECT CURTIME());
    SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME)); 
    SET @COUNT_CONFIGURATION_PROFILESQLFORMAT=(SELECT CONCAT('SELECT COUNT(CNP_DATA) INTO @COUNT_CONFIGURATION_PROFILE_SQL_FORMAT FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT WHERE CNP_DATA IS NOT NULL AND CNP_ID IN (1,2,3,4)'));
    PREPARE COUNT_CONFIGURATION_PROFILESQLFORMAT_STMT FROM @COUNT_CONFIGURATION_PROFILESQLFORMAT;
    EXECUTE COUNT_CONFIGURATION_PROFILESQLFORMAT_STMT;
    SET @COUNT_SPLITINGCONFIGURATION_PROFILE=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_SPLITING_CONFIGURATION_PROFILE FROM ',DESTINATIONSCHEMA,'.CONFIGURATION_PROFILE'));
    PREPARE COUNT_SPLITINGCONFIGURATION_PROFILE_STMT FROM @COUNT_SPLITINGCONFIGURATION_PROFILE;
    EXECUTE COUNT_SPLITINGCONFIGURATION_PROFILE_STMT;
    SET @REJECTION_COUNT=(@COUNT_CONFIGURATION_PROFILE_SQL_FORMAT-@COUNT_SPLITING_CONFIGURATION_PROFILE);
    SET @POSTAPID= (SELECT POSTAP_ID FROM POST_AUDIT_PROFILE WHERE POSTAP_DATA='CONFIGURATION_PROFILE');
    SET @PREASPID = (SELECT PREASP_ID FROM PRE_AUDIT_SUB_PROFILE WHERE PREASP_DATA='CONFIGURATION_PROFILE');
    SET @PREAMPID = (SELECT PREAMP_ID FROM PRE_AUDIT_MAIN_PROFILE WHERE PREAMP_DATA='CONFIGURATION');
    SET @DUR=DURATION;
    UPDATE PRE_AUDIT_SUB_PROFILE SET PREASP_NO_OF_REC=@COUNT_CONFIGURATION_PROFILE_SQL_FORMAT WHERE PREASP_DATA='CONFIGURATION_PROFILE';    
    INSERT INTO POST_AUDIT_HISTORY(POSTAP_ID,POSTAH_NO_OF_REC,PREASP_ID,PREAMP_ID,POSTAH_DURATION,POSTAH_NO_OF_REJ,ULD_ID)VALUES
    (@POSTAPID,@COUNT_SPLITING_CONFIGURATION_PROFILE,@PREASPID,@PREAMPID,@DUR,@REJECTION_COUNT,@ULDID);  
    SET START_TIME = (SELECT CURTIME());
  	SET @DROP_CONFIGURATION=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.CONFIGURATION'));
  	PREPARE DROP_CONFIGURATION_STMT FROM @DROP_CONFIGURATION;
    EXECUTE DROP_CONFIGURATION_STMT;
    SET @CREATE_CONFIGURATION=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.CONFIGURATION( 
    CGN_ID INTEGER NOT NULL AUTO_INCREMENT,
    CNP_ID INTEGER NOT NULL, 
    CGN_TYPE VARCHAR(50) NOT NULL, 
    PRIMARY KEY(CGN_ID),
    FOREIGN KEY(CNP_ID) REFERENCES ',DESTINATIONSCHEMA,'.CONFIGURATION_PROFILE (CNP_ID),
    UNIQUE (CGN_TYPE))'));
    PREPARE CREATE_CONFIGURATION_STMT FROM @CREATE_CONFIGURATION;
    EXECUTE CREATE_CONFIGURATION_STMT;
    SET @INSERT_CONFIGURATION=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.CONFIGURATION (CNP_ID,CGN_TYPE) (SELECT CNP_ID,CGN_DATA FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT WHERE CGN_ID IN (1,2,3,4,5,6) AND CGN_DATA IS NOT NULL ORDER BY ID)'));
  	PREPARE INSERT_CONFIGURATION_STMT FROM @INSERT_CONFIGURATION;
  	EXECUTE INSERT_CONFIGURATION_STMT;
    SET @CONFIGURATION_MAX_ID = (SELECT CONCAT('SELECT MAX(CGN_ID) INTO @CONFIG_MAX_ID FROM ',DESTINATIONSCHEMA,'.CONFIGURATION'));
    PREPARE CONFIGURATION_MAX_ID_STMT FROM @CONFIGURATION_MAX_ID;
    EXECUTE CONFIGURATION_MAX_ID_STMT;
    SET MAX_ID=@CONFIG_MAX_ID;
    IF (MAX_ID IS NOT NULL) THEN    
		SET @ALTER_CONFIGURATION =(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.CONFIGURATION AUTO_INCREMENT=',MAX_ID));
		PREPARE ALTER_CONFIGURATION_STMT FROM @ALTER_CONFIGURATION;
		EXECUTE ALTER_CONFIGURATION_STMT;
    END IF;
    SET END_TIME = (SELECT CURTIME());
  	SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME));    
    SET @COUNT_CONFIGURATIONSQLFORMAT=(SELECT CONCAT('SELECT COUNT(CGN_DATA) INTO @COUNT_CONFIGURATION_SQL_FORMAT FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT WHERE CGN_DATA IS NOT NULL AND CGN_ID IN (1,2,3,4,5,6)'));
    PREPARE COUNT_CONFIGURATIONSQLFORMAT_STMT FROM @COUNT_CONFIGURATIONSQLFORMAT;
    EXECUTE COUNT_CONFIGURATIONSQLFORMAT_STMT;
    SET @COUNT_SPLITINGCONFIGURATION=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_SPLITING_CONFIGURATION FROM ',DESTINATIONSCHEMA,'.CONFIGURATION'));
    PREPARE COUNT_SPLITINGCONFIGURATION_STMT FROM @COUNT_SPLITINGCONFIGURATION;
    EXECUTE COUNT_SPLITINGCONFIGURATION_STMT;
    SET @REJECTION_COUNT=(@COUNT_CONFIGURATION_SQL_FORMAT-@COUNT_SPLITING_CONFIGURATION);
    SET @POSTAPID= (SELECT POSTAP_ID FROM POST_AUDIT_PROFILE WHERE POSTAP_DATA='CONFIGURATION');
    SET @PREASPID = (SELECT PREASP_ID FROM PRE_AUDIT_SUB_PROFILE WHERE PREASP_DATA='CONFIGURATION');
    SET @PREAMPID = (SELECT PREAMP_ID FROM PRE_AUDIT_MAIN_PROFILE WHERE PREAMP_DATA='CONFIGURATION');
    SET @DUR=DURATION;
    UPDATE PRE_AUDIT_SUB_PROFILE SET PREASP_NO_OF_REC=@COUNT_CONFIGURATION_SQL_FORMAT WHERE PREASP_DATA='CONFIGURATION';    
    INSERT INTO POST_AUDIT_HISTORY(POSTAP_ID,POSTAH_NO_OF_REC,PREASP_ID,PREAMP_ID,POSTAH_DURATION,POSTAH_NO_OF_REJ,ULD_ID)VALUES
    (@POSTAPID,@COUNT_SPLITING_CONFIGURATION,@PREASPID,@PREAMPID,@DUR,@REJECTION_COUNT,@ULDID); 
    SET START_TIME = (SELECT CURTIME());
  	SET @DROP_ERROR_MESSAGE_CONFIGURATION=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.ERROR_MESSAGE_CONFIGURATION'));
  	PREPARE DROP_ERROR_MESSAGE_CONFIGURATION_STMT FROM @DROP_ERROR_MESSAGE_CONFIGURATION;
    EXECUTE DROP_ERROR_MESSAGE_CONFIGURATION_STMT;
    SET @CREATE_ERROR_MESSAGE_CONFIGURATION=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.ERROR_MESSAGE_CONFIGURATION( 
    EMC_ID INTEGER NOT NULL AUTO_INCREMENT,
    CNP_ID INTEGER NOT NULL,
    EMC_CODE INTEGER NOT NULL, 
    EMC_DATA TEXT NOT NULL, 
    ULD_ID INTEGER(2) NOT NULL,
    EMC_TIMESTAMP TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(EMC_ID),
    FOREIGN KEY(CNP_ID) REFERENCES ',DESTINATIONSCHEMA,'.CONFIGURATION_PROFILE (CNP_ID), 
    FOREIGN KEY(ULD_ID) REFERENCES ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS (ULD_ID))'));
    PREPARE CREATE_ERROR_MESSAGE_CONFIGURATION_STMT FROM @CREATE_ERROR_MESSAGE_CONFIGURATION;
    EXECUTE CREATE_ERROR_MESSAGE_CONFIGURATION_STMT;
    SET @ERRORMESSAGECONFIGURATION_MAX_ID = (SELECT CONCAT('SELECT MAX(EMC_ID) INTO @ERROR_MESSAGE_CONFIGURATION_MAX_ID FROM ',DESTINATIONSCHEMA,'.ERROR_MESSAGE_CONFIGURATION'));
    PREPARE ERROR_MESSAGE_CONFIGURATION_MAX_ID_STMT FROM @ERRORMESSAGECONFIGURATION_MAX_ID;
    EXECUTE ERROR_MESSAGE_CONFIGURATION_MAX_ID_STMT;
    SET MAX_ID=@ERROR_MESSAGE_CONFIGURATION_MAX_ID;
    IF (MAX_ID IS NOT NULL) THEN    
		SET @ALTER_ERROR_MESSAGE_CONFIGURATION =(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.ERROR_MESSAGE_CONFIGURATION AUTO_INCREMENT=',MAX_ID));
		PREPARE ALTER_ERROR_MESSAGE_CONFIGURATION_STMT FROM @ALTER_ERROR_MESSAGE_CONFIGURATION;
		EXECUTE ALTER_ERROR_MESSAGE_CONFIGURATION_STMT;
    END IF;
    SET END_TIME = (SELECT CURTIME());
  	SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME));
    SET START_TIME = (SELECT CURTIME());
  	SET @DROP_USER_RIGHTS_CONFIGURATION=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.USER_RIGHTS_CONFIGURATION'));
  	PREPARE DROP_USER_RIGHTS_CONFIGURATION_STMT FROM @DROP_USER_RIGHTS_CONFIGURATION;
    EXECUTE DROP_USER_RIGHTS_CONFIGURATION_STMT;
    SET @CREATE_USER_RIGHTS_CONFIGURATION=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.USER_RIGHTS_CONFIGURATION(
    URC_ID INTEGER(2) NOT NULL AUTO_INCREMENT, 
    CGN_ID INTEGER NOT NULL, 
    URC_DATA TEXT NOT NULL, 
    URC_USERSTAMP VARCHAR(50) NOT NULL,
    URC_TIMESTAMP TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(URC_ID), 
    FOREIGN KEY(CGN_ID) REFERENCES ',DESTINATIONSCHEMA,'.CONFIGURATION (CGN_ID))'));
    PREPARE CREATE_USER_RIGHTS_CONFIGURATION_STMT FROM @CREATE_USER_RIGHTS_CONFIGURATION;
    EXECUTE CREATE_USER_RIGHTS_CONFIGURATION_STMT;
    SET @INSERT_USER_RIGHTS_CONFIGURATION=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.USER_RIGHTS_CONFIGURATION(CGN_ID,URC_DATA,URC_USERSTAMP,URC_TIMESTAMP)
    SELECT CGN_ID,DATA,USER_STAMP,TIMESTAMP FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT WHERE CGN_ID=3 AND DATA IS NOT NULL'));
  	PREPARE INSERT_USER_RIGHTS_CONFIGURATION_STMT FROM @INSERT_USER_RIGHTS_CONFIGURATION;
  	EXECUTE INSERT_USER_RIGHTS_CONFIGURATION_STMT;
    SET @USERRIGHTSCONFIGURATION_MAX_ID = (SELECT CONCAT('SELECT MAX(URC_ID) INTO @USER_RIGHTS_CONFIGURATION_MAX_ID FROM ',DESTINATIONSCHEMA,'.USER_RIGHTS_CONFIGURATION'));
    PREPARE USER_RIGHTS_CONFIGURATION_MAX_ID_STMT FROM @USERRIGHTSCONFIGURATION_MAX_ID;
    EXECUTE USER_RIGHTS_CONFIGURATION_MAX_ID_STMT;
    SET MAX_ID=@USER_RIGHTS_CONFIGURATION_MAX_ID;
    IF (MAX_ID IS NOT NULL) THEN    
		SET @ALTER_USER_RIGHTS_CONFIGURATION =(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.USER_RIGHTS_CONFIGURATION AUTO_INCREMENT=',MAX_ID));
		PREPARE ALTER_USER_RIGHTS_CONFIGURATION_STMT FROM @ALTER_USER_RIGHTS_CONFIGURATION;
		EXECUTE ALTER_USER_RIGHTS_CONFIGURATION_STMT;
    END IF;
    SET END_TIME = (SELECT CURTIME());
  	SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME));    
    SET @COUNT_USERRIGHTSCONFIGURATIONSQLFORMAT=(SELECT CONCAT('SELECT COUNT(DATA) INTO @COUNT_USER_RIGHTS_CONFIGURATION_SQL_FORMAT FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT WHERE DATA IS NOT NULL AND CGN_ID=3'));
    PREPARE COUNT_USERRIGHTSCONFIGURATIONSQLFORMAT_STMT FROM @COUNT_USERRIGHTSCONFIGURATIONSQLFORMAT;
    EXECUTE COUNT_USERRIGHTSCONFIGURATIONSQLFORMAT_STMT;
    SET @COUNT_SPLITING_USERRIGHTSCONFIGURATION=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_SPLITING_USER_RIGHTS_CONFIGURATION FROM ',DESTINATIONSCHEMA,'.USER_RIGHTS_CONFIGURATION'));
    PREPARE COUNT_SPLITING_USERRIGHTSCONFIGURATION_STMT FROM @COUNT_SPLITING_USERRIGHTSCONFIGURATION;
    EXECUTE COUNT_SPLITING_USERRIGHTSCONFIGURATION_STMT;
    SET @REJECTION_COUNT=(@COUNT_USER_RIGHTS_CONFIGURATION_SQL_FORMAT-@COUNT_SPLITING_USER_RIGHTS_CONFIGURATION);
    SET @POSTAPID= (SELECT POSTAP_ID FROM POST_AUDIT_PROFILE WHERE POSTAP_DATA='USER_RIGHTS_CONFIGURATION');
    SET @PREASPID = (SELECT PREASP_ID FROM PRE_AUDIT_SUB_PROFILE WHERE PREASP_DATA='USER_RIGHTS_CONFIGURATION');
    SET @PREAMPID = (SELECT PREAMP_ID FROM PRE_AUDIT_MAIN_PROFILE WHERE PREAMP_DATA='CONFIGURATION');
    SET @DUR=DURATION;
    UPDATE PRE_AUDIT_SUB_PROFILE SET PREASP_NO_OF_REC=@COUNT_USER_RIGHTS_CONFIGURATION_SQL_FORMAT WHERE PREASP_DATA='USER_RIGHTS_CONFIGURATION';	
    INSERT INTO POST_AUDIT_HISTORY(POSTAP_ID,POSTAH_NO_OF_REC,PREASP_ID,PREAMP_ID,POSTAH_DURATION,POSTAH_NO_OF_REJ,ULD_ID) VALUES
    (@POSTAPID,@COUNT_SPLITING_USER_RIGHTS_CONFIGURATION,@PREASPID,@PREAMPID,@DUR,@REJECTION_COUNT,@ULDID);
    SET START_TIME = (SELECT CURTIME());
  	SET @DROP_REPORT_CONFIGURATION=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.REPORT_CONFIGURATION'));
  	PREPARE DROP_REPORT_CONFIGURATION_STMT FROM @DROP_REPORT_CONFIGURATION;
    EXECUTE DROP_REPORT_CONFIGURATION_STMT;
    SET @CREATE_REPORT_CONFIGURATION=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.REPORT_CONFIGURATION( 
    RC_ID INTEGER(2) NOT NULL AUTO_INCREMENT,
    CGN_ID INTEGER NOT NULL, 
    RC_DATA TEXT NOT NULL,
    ULD_ID INTEGER(2) NOT NULL, 
    RC_TIMESTAMP TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    PRIMARY KEY(RC_ID), 
    FOREIGN KEY(CGN_ID) REFERENCES ',DESTINATIONSCHEMA,'.CONFIGURATION (CGN_ID), 
    FOREIGN KEY(ULD_ID) REFERENCES ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS (ULD_ID))'));
    PREPARE CREATE_REPORTCONFIGURATION_STMT FROM @CREATE_REPORT_CONFIGURATION;
    EXECUTE CREATE_REPORTCONFIGURATION_STMT;    
    SET @INSERT_REPORT_CONFIGURATION=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.REPORT_CONFIGURATION(CGN_ID,RC_DATA,ULD_ID,RC_TIMESTAMP) 
  	(SELECT CSQL.CGN_ID,CSQL.DATA,ULD.ULD_ID,CSQL.TIMESTAMP FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT CSQL, ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS ULD WHERE CSQL.CGN_ID IN (1,2) AND CSQL.DATA IS NOT NULL AND ULD.ULD_LOGINID=CSQL.USER_STAMP)'));
  	PREPARE INSERT_REPORT_CONFIGURATION_STMT FROM @INSERT_REPORT_CONFIGURATION;
    EXECUTE INSERT_REPORT_CONFIGURATION_STMT;
    SET @REPORTCONFIGURATION_MAX_ID = (SELECT CONCAT('SELECT MAX(RC_ID) INTO @REPORT_CONFIGURATION_MAX_ID FROM ',DESTINATIONSCHEMA,'.REPORT_CONFIGURATION'));
    PREPARE REPORT_CONFIGURATION_MAX_ID_STMT FROM @REPORTCONFIGURATION_MAX_ID;
    EXECUTE REPORT_CONFIGURATION_MAX_ID_STMT;
    SET MAX_ID=@REPORT_CONFIGURATION_MAX_ID;
    IF (MAX_ID IS NOT NULL) THEN    
		SET @ALTER_REPORT_CONFIGURATION =(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.REPORT_CONFIGURATION AUTO_INCREMENT=',MAX_ID));
		PREPARE ALTER_REPORT_CONFIGURATION_STMT FROM @ALTER_REPORT_CONFIGURATION;
		EXECUTE ALTER_REPORT_CONFIGURATION_STMT;
    END IF;
    SET END_TIME = (SELECT CURTIME());
  	SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME));    
    SET @COUNT_REPORTCONFIGURATIONSQLFORMAT=(SELECT CONCAT('SELECT COUNT(DATA) INTO @COUNT_REPORT_CONFIGURATION_SQL_FORMAT FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT WHERE DATA IS NOT NULL AND CGN_ID IN (1,2)'));
    PREPARE COUNT_REPORTCONFIGURATIONSQLFORMAT_STMT FROM @COUNT_REPORTCONFIGURATIONSQLFORMAT;
    EXECUTE COUNT_REPORTCONFIGURATIONSQLFORMAT_STMT;
    SET @COUNT_SPLITING_REPORTCONFIGURATION=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_SPLITING_REPORT_CONFIGURATION FROM ',DESTINATIONSCHEMA,'.REPORT_CONFIGURATION'));
    PREPARE COUNT_SPLITING_REPORTCONFIGURATION_STMT FROM @COUNT_SPLITING_REPORTCONFIGURATION;
    EXECUTE COUNT_SPLITING_REPORTCONFIGURATION_STMT;
    SET @REJECTION_COUNT=(@COUNT_REPORT_CONFIGURATION_SQL_FORMAT-@COUNT_SPLITING_REPORT_CONFIGURATION);
    SET @POSTAPID= (SELECT POSTAP_ID FROM POST_AUDIT_PROFILE WHERE POSTAP_DATA='REPORT_CONFIGURATION');
    SET @PREASPID = (SELECT PREASP_ID FROM PRE_AUDIT_SUB_PROFILE WHERE PREASP_DATA='REPORT_CONFIGURATION');
    SET @PREAMPID = (SELECT PREAMP_ID FROM PRE_AUDIT_MAIN_PROFILE WHERE PREAMP_DATA='CONFIGURATION');
    SET @DUR=DURATION;
    UPDATE PRE_AUDIT_SUB_PROFILE SET PREASP_NO_OF_REC=@COUNT_REPORT_CONFIGURATION_SQL_FORMAT WHERE PREASP_DATA='REPORT_CONFIGURATION';	
    INSERT INTO POST_AUDIT_HISTORY(POSTAP_ID,POSTAH_NO_OF_REC,PREASP_ID,PREAMP_ID,POSTAH_DURATION,POSTAH_NO_OF_REJ,ULD_ID) VALUES
    (@POSTAPID,@COUNT_SPLITING_REPORT_CONFIGURATION,@PREASPID,@PREAMPID,@DUR,@REJECTION_COUNT,@ULDID);
    SET START_TIME = (SELECT CURTIME());
  	SET @DROP_PUBLIC_HOLIDAY=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION'));
  	PREPARE DROP_PUBLICHOLIDAY FROM @DROP_PUBLIC_HOLIDAY;
    EXECUTE DROP_PUBLICHOLIDAY;
    SET @CREATE_ATTENDANCE_CONFIGURATION=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION(
    AC_ID INTEGER(2) NOT NULL AUTO_INCREMENT,
    CGN_ID INTEGER NOT NULL,
    AC_DATA TEXT NOT NULL, 
    ULD_ID INTEGER(2) NOT NULL, 
    AC_TIMESTAMP TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(AC_ID),
    FOREIGN KEY(CGN_ID) REFERENCES ',DESTINATIONSCHEMA,'.CONFIGURATION (CGN_ID),
    FOREIGN KEY(ULD_ID) REFERENCES ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS (ULD_ID))'));
    PREPARE CREATE_CREATE_ATTENDANCE_CONFIGURATION_STMT FROM @CREATE_ATTENDANCE_CONFIGURATION;
    EXECUTE CREATE_CREATE_ATTENDANCE_CONFIGURATION_STMT;
    SET @INSERT_ATTENDANCE_CONFIGURATION=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION(CGN_ID,AC_DATA,ULD_ID,AC_TIMESTAMP) 
  	(SELECT CSQL.CGN_ID,CSQL.DATA,ULD.ULD_ID,CSQL.TIMESTAMP FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT CSQL, ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS ULD WHERE CSQL.CGN_ID IN (4,5,6) AND CSQL.DATA IS NOT NULL AND ULD.ULD_LOGINID=CSQL.USER_STAMP)'));
  	PREPARE INSERT_ATTENDANCE_CONFIGURATION_STMT FROM @INSERT_ATTENDANCE_CONFIGURATION;
    EXECUTE INSERT_ATTENDANCE_CONFIGURATION_STMT;
    SET @ATTENDANCECONFIGURATION_MAX_ID = (SELECT CONCAT('SELECT MAX(AC_ID) INTO @ATTENDANCE_CONFIGURATION_MAX_ID FROM ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION'));
    PREPARE ATTENDANCE_CONFIGURATION_MAX_ID_STMT FROM @ATTENDANCECONFIGURATION_MAX_ID;
    EXECUTE ATTENDANCE_CONFIGURATION_MAX_ID_STMT;
    SET MAX_ID=@ATTENDANCE_CONFIGURATION_MAX_ID;
    IF (MAX_ID IS NOT NULL) THEN    
		SET @ALTER_ATTENDANCE_CONFIGURATION =(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION AUTO_INCREMENT=',MAX_ID));
		PREPARE ALTER_ATTENDANCE_CONFIGURATION_STMT FROM @ALTER_ATTENDANCE_CONFIGURATION;
		EXECUTE ALTER_ATTENDANCE_CONFIGURATION_STMT;
    END IF;
    SET END_TIME = (SELECT CURTIME());
  	SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME));    
    SET @COUNT_ATTENDANCECONFIGURATIONSQLFORMAT=(SELECT CONCAT('SELECT COUNT(DATA) INTO @COUNT_ATTENDANCE_CONFIGURATION_SQL_FORMAT FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT WHERE DATA IS NOT NULL AND CGN_ID IN (4,5,6)'));
    PREPARE COUNT_ATTENDANCECONFIGURATIONSQLFORMAT_STMT FROM @COUNT_ATTENDANCECONFIGURATIONSQLFORMAT;
    EXECUTE COUNT_ATTENDANCECONFIGURATIONSQLFORMAT_STMT;
    SET @COUNT_SPLITING_ATTENDANCECONFIGURATION=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_SPLITING_ATTENDANCE_CONFIGURATION FROM ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION'));
    PREPARE COUNT_SPLITING_ATTENDANCECONFIGURATION_STMT FROM @COUNT_SPLITING_ATTENDANCECONFIGURATION;
    EXECUTE COUNT_SPLITING_ATTENDANCECONFIGURATION_STMT;
    SET @REJECTION_COUNT=(@COUNT_ATTENDANCE_CONFIGURATION_SQL_FORMAT-@COUNT_SPLITING_ATTENDANCE_CONFIGURATION);
    SET @POSTAPID= (SELECT POSTAP_ID FROM POST_AUDIT_PROFILE WHERE POSTAP_DATA='ATTENDANCE_CONFIGURATION');
    SET @PREASPID = (SELECT PREASP_ID FROM PRE_AUDIT_SUB_PROFILE WHERE PREASP_DATA='ATTENDANCE_CONFIGURATION');
    SET @PREAMPID = (SELECT PREAMP_ID FROM PRE_AUDIT_MAIN_PROFILE WHERE PREAMP_DATA='CONFIGURATION');
    SET @DUR=DURATION;
    UPDATE PRE_AUDIT_SUB_PROFILE SET PREASP_NO_OF_REC=@COUNT_ATTENDANCE_CONFIGURATION_SQL_FORMAT WHERE PREASP_DATA='ATTENDANCE_CONFIGURATION';	
    INSERT INTO POST_AUDIT_HISTORY(POSTAP_ID,POSTAH_NO_OF_REC,PREASP_ID,PREAMP_ID,POSTAH_DURATION,POSTAH_NO_OF_REJ,ULD_ID) VALUES
    (@POSTAPID,@COUNT_SPLITING_ATTENDANCE_CONFIGURATION,@PREASPID,@PREAMPID,@DUR,@REJECTION_COUNT,@ULDID);
    SET FOREIGN_KEY_CHECKS=1;
  COMMIT;
END;
CALL SP_TS_MIG_CONFIGURATION_INSERT(SOURCESCHEMA, DESTINATIONSCHEMA ,MIGUSERSTAMP);