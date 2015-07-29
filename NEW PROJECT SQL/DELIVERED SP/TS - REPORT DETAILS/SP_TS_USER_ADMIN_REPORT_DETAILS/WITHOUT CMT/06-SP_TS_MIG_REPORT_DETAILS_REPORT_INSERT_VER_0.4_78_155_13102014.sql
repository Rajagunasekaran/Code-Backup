DROP PROCEDURE IF EXISTS SP_TS_MIG_REPORT_DETAILS_REPORT_INSERT;
CREATE PROCEDURE SP_TS_MIG_REPORT_DETAILS_REPORT_INSERT(
IN SOURCESCHEMA VARCHAR(40),
IN DESTINATIONSCHEMA VARCHAR(40),
IN PART_NO INT,
IN MINIMUM_ID INT,
IN MAXIMUM_ID INT,
IN MIGUSERSTAMP VARCHAR(50))
BEGIN
	DECLARE TRSF_TIMESTAMP TIMESTAMP;
	DECLARE TRSF_USERSTAMP VARCHAR(50);
	DECLARE UARDMAX_ID INT;
	DECLARE TRSF_MIN_ID INT;
	DECLARE TRSF_MAX_ID INT;
	DECLARE START_TIME TIME;
	DECLARE END_TIME TIME;
	DECLARE DURATION TIME;
	DECLARE PARTNO INT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
	END;
	START TRANSACTION;
	SET START_TIME = (SELECT CURTIME());
	SET PARTNO=PART_NO;
	IF(PARTNO=1)THEN
		SET @DROP_TEMP_REPORTS=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TEMP_REPORTS'));
		PREPARE DROP_TEMP_REPORTS_STMT FROM @DROP_TEMP_REPORTS;
		EXECUTE DROP_TEMP_REPORTS_STMT;
		SET @CREATE_TEMP_REPORTS=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.TEMP_REPORTS(
		ID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
		UID INT(11) NOT NULL ,
		UNAME VARCHAR(255) DEFAULT NULL,
		UDATE VARCHAR(255) DEFAULT NULL,
		UREPORT TEXT,
		USERSTAMP VARCHAR(255) DEFAULT NULL,
		TIMESTAMP VARCHAR(255) DEFAULT NULL)'));
		PREPARE CREATE_TEMP_REPORTS_STMT FROM @CREATE_TEMP_REPORTS;
		EXECUTE CREATE_TEMP_REPORTS_STMT;
		SET @INSERT_TEMP_REPORTS=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.TEMP_REPORTS(UID,UNAME,UDATE,UREPORT,USERSTAMP,TIMESTAMP)
		(SELECT UID,UNAME,UDATE,UREPORT,USERSTAMP,TIMESTAMP FROM ',DESTINATIONSCHEMA,'.TEMP_REPORTS_SCDB_FORMAT)'));
		PREPARE INSERT_TEMP_REPORTS_SCDB_FORMAT_STMT FROM @INSERT_TEMP_REPORTS;
		EXECUTE INSERT_TEMP_REPORTS_SCDB_FORMAT_STMT;    
		SET @DROP_TEMP_REPORTS_SCDB_FORMAT=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TEMP_REPORTS_SCDB_FORMAT'));
		PREPARE DROP_TEMP_REPORTS_SCDB_FORMAT_STMT FROM @DROP_TEMP_REPORTS_SCDB_FORMAT;
		EXECUTE DROP_TEMP_REPORTS_SCDB_FORMAT_STMT;
	END IF;
	IF(PARTNO=6 AND MAXIMUM_ID IS NULL)THEN
		SET @SELECT_TEMP_REPORT_MAXID=(SELECT CONCAT('SELECT MAX(ID) INTO @MAXIMUMID FROM ',DESTINATIONSCHEMA,'.TEMP_REPORTS'));
		PREPARE SELECT_TEMP_REPORT_MAXID_STMT FROM @SELECT_TEMP_REPORT_MAXID;
		EXECUTE SELECT_TEMP_REPORT_MAXID_STMT;
		SET TRSF_MIN_ID = MINIMUM_ID;
		SET TRSF_MAX_ID = @MAXIMUMID;
	ELSE
		SET TRSF_MIN_ID = MINIMUM_ID;
		SET TRSF_MAX_ID = MAXIMUM_ID;
	END IF;
	WHILE(TRSF_MIN_ID <= TRSF_MAX_ID)DO         
		SET @SELECT_TRSF_USERSTAMP_TIMESTAMP=(SELECT CONCAT('SELECT USERSTAMP, `TIMESTAMP` INTO @TRSFUSERSTAMP, @TRSFTIMESTAMP FROM ',DESTINATIONSCHEMA,'.TEMP_REPORTS WHERE ID=',TRSF_MIN_ID));
		PREPARE SELECT_TRSF_USERSTAMP_TIMESTAMP_STMT FROM @SELECT_TRSF_USERSTAMP_TIMESTAMP;
		EXECUTE SELECT_TRSF_USERSTAMP_TIMESTAMP_STMT;
		SET TRSF_USERSTAMP=@TRSFUSERSTAMP;
		SET TRSF_TIMESTAMP=@TRSFTIMESTAMP;          
		IF (TRSF_USERSTAMP IS NOT NULL OR TRSF_TIMESTAMP IS NOT NULL) THEN
			SET @INSERT_USERADMINREPORTDETAILS=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.TEMP_USER_ADMIN_REPORT_DETAILS(UARD_REPORT,UARD_PDID,UARD_DATE,UARD_ATTENDANCE,UARD_AM_SESSION,UARD_PM_SESSION, URC_ID, ULD_ID, UARD_BANDWIDTH, UARD_USERSTAMP_ID, UARD_TIMESTAMP) VALUES 
			((SELECT DISTINCT UREPORT FROM ',DESTINATIONSCHEMA,'.TEMP_REPORTS WHERE ID=',TRSF_MIN_ID,'),    
			(SELECT DISTINCT PD_ID FROM ',DESTINATIONSCHEMA,'.PROJECT_DETAILS WHERE PD_PROJECT_NAME="EI"),
			(SELECT DISTINCT UDATE FROM ',DESTINATIONSCHEMA,'.TEMP_REPORTS WHERE ID=',TRSF_MIN_ID,'),
			(SELECT DISTINCT AC_ID FROM ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION WHERE AC_DATA="1" AND CGN_ID=5),
			(SELECT DISTINCT AC_ID FROM ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION WHERE AC_DATA="PRESENT"),
			(SELECT DISTINCT AC_ID FROM ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION WHERE AC_DATA="PRESENT"),
			(SELECT DISTINCT RC.URC_ID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS ULD,',DESTINATIONSCHEMA,'.ROLE_CREATION RC,',DESTINATIONSCHEMA,'.USER_ACCESS UA,',DESTINATIONSCHEMA,'.TEMP_REPORTS RSF WHERE ULD.ULD_LOGINID= RSF.UNAME AND ULD.ULD_ID = UA.ULD_ID AND UA.RC_ID = RC.RC_ID AND RSF.ID=',TRSF_MIN_ID,'),
			(SELECT DISTINCT ULD_ID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS WHERE ULD_LOGINID=(SELECT UNAME FROM ',DESTINATIONSCHEMA,'.TEMP_REPORTS WHERE ID=',TRSF_MIN_ID,')),
			(0),(SELECT DISTINCT ULD_ID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS WHERE ULD_LOGINID=(SELECT USERSTAMP FROM ',DESTINATIONSCHEMA,'.TEMP_REPORTS WHERE ID=',TRSF_MIN_ID,')),
			(SELECT DISTINCT TIMESTAMP FROM ',DESTINATIONSCHEMA,'.TEMP_REPORTS WHERE ID=',TRSF_MIN_ID,'))'));      
			PREPARE INSERT_TEMP_USER_ADMIN_REPORT_DETAILS_STMT FROM @INSERT_USERADMINREPORTDETAILS;
			EXECUTE INSERT_TEMP_USER_ADMIN_REPORT_DETAILS_STMT;      
			SET @UARDMAXID = (SELECT CONCAT('SELECT MAX(UARD_ID) INTO @UARD_MAX_ID FROM ',DESTINATIONSCHEMA,'.TEMP_USER_ADMIN_REPORT_DETAILS'));
			PREPARE UARD_MAX_ID_STMT FROM @UARDMAXID;
			EXECUTE UARD_MAX_ID_STMT;
			SET UARDMAX_ID=@UARD_MAX_ID;
			IF (UARDMAX_ID IS NOT NULL) THEN    
				SET @ALTER_USER_ADMIN_REPORT_DETAILS =(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.TEMP_USER_ADMIN_REPORT_DETAILS AUTO_INCREMENT=',UARDMAX_ID));
				PREPARE ALTER_USER_ADMIN_REPORT_DETAILS_STMT FROM @ALTER_USER_ADMIN_REPORT_DETAILS;
				EXECUTE ALTER_USER_ADMIN_REPORT_DETAILS_STMT;
			END IF;
		END IF;   
		IF (TRSF_USERSTAMP IS NULL OR TRSF_TIMESTAMP IS NULL) THEN
			SET @INSERT_USERADMINREPORTDETAILS=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.TEMP_USER_ADMIN_REPORT_DETAILS(UARD_REPORT,UARD_PDID,UARD_DATE,UARD_ATTENDANCE,UARD_AM_SESSION,UARD_PM_SESSION, URC_ID, ULD_ID, UARD_BANDWIDTH, UARD_USERSTAMP_ID, UARD_TIMESTAMP) VALUES 
			((SELECT DISTINCT UREPORT FROM ',DESTINATIONSCHEMA,'.TEMP_REPORTS WHERE ID=',TRSF_MIN_ID,'),    
			(SELECT DISTINCT PD_ID FROM ',DESTINATIONSCHEMA,'.PROJECT_DETAILS WHERE PD_PROJECT_NAME="EI"),
			(SELECT DISTINCT UDATE FROM ',DESTINATIONSCHEMA,'.TEMP_REPORTS WHERE ID=',TRSF_MIN_ID,'),
			(SELECT DISTINCT AC_ID FROM ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION WHERE AC_DATA="1" AND CGN_ID=5),
			(SELECT DISTINCT AC_ID FROM ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION WHERE AC_DATA="PRESENT"),
			(SELECT DISTINCT AC_ID FROM ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION WHERE AC_DATA="PRESENT"),
			(SELECT DISTINCT RC.URC_ID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS ULD,',DESTINATIONSCHEMA,'.ROLE_CREATION RC,',DESTINATIONSCHEMA,'.USER_ACCESS UA,',DESTINATIONSCHEMA,'.TEMP_REPORTS RSF WHERE ULD.ULD_LOGINID= RSF.UNAME AND ULD.ULD_ID = UA.ULD_ID AND UA.RC_ID = RC.RC_ID AND RSF.ID=',TRSF_MIN_ID,'),
			(SELECT DISTINCT ULD_ID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS WHERE ULD_LOGINID=(SELECT UNAME FROM ',DESTINATIONSCHEMA,'.TEMP_REPORTS WHERE ID=',TRSF_MIN_ID,')),
			(0),(SELECT DISTINCT ULD_ID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS WHERE ULD_LOGINID=(SELECT UNAME FROM ',DESTINATIONSCHEMA,'.TEMP_REPORTS WHERE ID=',TRSF_MIN_ID,')),
			(SELECT DISTINCT UDATE FROM ',DESTINATIONSCHEMA,'.TEMP_REPORTS WHERE ID=',TRSF_MIN_ID,'))'));      
			PREPARE INSERT_TEMP_USER_ADMIN_REPORT_DETAILS_STMT FROM @INSERT_USERADMINREPORTDETAILS;
			EXECUTE INSERT_TEMP_USER_ADMIN_REPORT_DETAILS_STMT; 
			SET @UARDMAXID = (SELECT CONCAT('SELECT MAX(UARD_ID) INTO @UARD_MAX_ID FROM ',DESTINATIONSCHEMA,'.TEMP_USER_ADMIN_REPORT_DETAILS'));
			PREPARE UARD_MAX_ID_STMT FROM @UARDMAXID;
			EXECUTE UARD_MAX_ID_STMT;
			SET UARDMAX_ID=@UARD_MAX_ID;
			IF (UARDMAX_ID IS NOT NULL) THEN    
				SET @ALTER_USER_ADMIN_REPORT_DETAILS =(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.TEMP_USER_ADMIN_REPORT_DETAILS AUTO_INCREMENT=',UARDMAX_ID));
				PREPARE ALTER_USER_ADMIN_REPORT_DETAILS_STMT FROM @ALTER_USER_ADMIN_REPORT_DETAILS;
				EXECUTE ALTER_USER_ADMIN_REPORT_DETAILS_STMT;
			END IF;
		END IF;
		SET TRSF_MIN_ID = TRSF_MIN_ID+1;
	END WHILE;
	IF (PARTNO=1 OR PARTNO=2 OR PARTNO=3 OR PARTNO=4 OR PARTNO=5)THEN
		SET END_TIME = (SELECT CURTIME());
		SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME));
		SET @INSERT_TEMP_DURATION=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.TEMP_DURATION(DURATION)VALUES(','"',DURATION,'"',')'));
		PREPARE INSERT_TEMP_DURATION_STMT FROM @INSERT_TEMP_DURATION;
		EXECUTE INSERT_TEMP_DURATION_STMT;
	END IF;
	IF (PARTNO=6) THEN
		SET @LOGIN_ID=(SELECT CONCAT('SELECT ULD_ID INTO @ULDID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS WHERE ULD_LOGINID=','"',MIGUSERSTAMP,'"'));
		PREPARE LOGINID_STMT FROM @LOGIN_ID;
		EXECUTE LOGINID_STMT;			
		SET @INSERT_USERADMINREPORTDETAILS=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.USER_ADMIN_REPORT_DETAILS (UARD_REPORT,UARD_REASON,UARD_DATE,URC_ID,ULD_ID,UARD_PERMISSION,UARD_ATTENDANCE,UARD_PDID,UARD_AM_SESSION,UARD_PM_SESSION,UARD_BANDWIDTH,UARD_USERSTAMP_ID,UARD_TIMESTAMP,ABSENT_FLAG)
		SELECT UARD_REPORT,UARD_REASON,UARD_DATE,URC_ID,ULD_ID,UARD_PERMISSION,UARD_ATTENDANCE,UARD_PDID,UARD_AM_SESSION,UARD_PM_SESSION,UARD_BANDWIDTH,UARD_USERSTAMP_ID,UARD_TIMESTAMP,ABSENT_FLAG FROM ',DESTINATIONSCHEMA,'.TEMP_USER_ADMIN_REPORT_DETAILS ORDER BY UARD_DATE'));      
		PREPARE INSERT_TEMP_USER_ADMIN_REPORT_DETAILS_STMT FROM @INSERT_USERADMINREPORTDETAILS;
		EXECUTE INSERT_TEMP_USER_ADMIN_REPORT_DETAILS_STMT;
		SET @DROP_TEMP_REPORT=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TEMP_REPORTS'));
		PREPARE DROP_TEMP_REPORT_STMT FROM @DROP_TEMP_REPORT;
		EXECUTE DROP_TEMP_REPORT_STMT;
		SET @DROP_TEMP_USER_ADMIN_REPORT_DETAILS=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TEMP_USER_ADMIN_REPORT_DETAILS'));
		PREPARE DROP_TEMP_USER_ADMIN_REPORT_DETAILS_STMT FROM @DROP_TEMP_USER_ADMIN_REPORT_DETAILS;
		EXECUTE DROP_TEMP_USER_ADMIN_REPORT_DETAILS_STMT;
		SET @UARDMAXID = (SELECT CONCAT('SELECT MAX(UARD_ID) INTO @UARD_MAX_ID FROM ',DESTINATIONSCHEMA,'.USER_ADMIN_REPORT_DETAILS'));
		PREPARE UARD_MAX_ID_STMT FROM @UARDMAXID;
		EXECUTE UARD_MAX_ID_STMT;
		SET UARDMAX_ID=@UARD_MAX_ID;
		IF (UARDMAX_ID IS NOT NULL) THEN    
			SET @ALTER_USER_ADMIN_REPORT_DETAILS =(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.USER_ADMIN_REPORT_DETAILS AUTO_INCREMENT=',UARDMAX_ID));
			PREPARE ALTER_USER_ADMIN_REPORT_DETAILS_STMT FROM @ALTER_USER_ADMIN_REPORT_DETAILS;
			EXECUTE ALTER_USER_ADMIN_REPORT_DETAILS_STMT;
		END IF;
		SET END_TIME = (SELECT CURTIME());
		SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME));
		SET @INSERT_TEMP_DURATION=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.TEMP_DURATION(DURATION)VALUES(','"',DURATION,'"',')'));
		PREPARE INSERT_TEMP_DURATION_STMT FROM @INSERT_TEMP_DURATION;
		EXECUTE INSERT_TEMP_DURATION_STMT;
		SET @ADDDURATIONTIME=(SELECT CONCAT('SELECT SEC_TO_TIME(SUM(TIME_TO_SEC(DURATION))) INTO @TOTAL_DURATION FROM ',DESTINATIONSCHEMA,'.TEMP_DURATION'));
		PREPARE ADDDURATIONTIME_STMT FROM @ADDDURATIONTIME;
		EXECUTE ADDDURATIONTIME_STMT;
		SET @COUNT_REPORTSCDBFORMAT=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_REPORTS_SCDB_FORMAT1 FROM ',SOURCESCHEMA,'.REPORTS_SCDB_FORMAT'));
		PREPARE COUNT_REPORTSCDBFORMAT_STMT FROM @COUNT_REPORTSCDBFORMAT;
		EXECUTE COUNT_REPORTSCDBFORMAT_STMT;
		SET @COUNTTEMP_EMP_REPORTS_SCDB_FORMAT =(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_TEMP_REPORTS_SCDB_FORMAT2 FROM ',SOURCESCHEMA,'.TEMP_EMP_REPORT_SCDB_FORMAT'));
		PREPARE COUNT_TEMP_EMP_REPORTS_SCDB_FORMAT_STMT FROM @COUNTTEMP_EMP_REPORTS_SCDB_FORMAT;
		EXECUTE COUNT_TEMP_EMP_REPORTS_SCDB_FORMAT_STMT;
		SET @COUNT_REPORTS_SCDB_FORMAT=(@COUNT_REPORTS_SCDB_FORMAT1+@COUNT_TEMP_REPORTS_SCDB_FORMAT2);
		SET @COUNT_SPLITING_REPORTSCDBFORMAT=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_SPLITING_USER_ADMIN FROM ',DESTINATIONSCHEMA,'.USER_ADMIN_REPORT_DETAILS'));
		PREPARE COUNT_SPLITING_REPORTSCDBFORMAT_STMT FROM @COUNT_SPLITING_REPORTSCDBFORMAT;
		EXECUTE COUNT_SPLITING_REPORTSCDBFORMAT_STMT;
		SET @REJECTION_COUNT=(@COUNT_REPORTS_SCDB_FORMAT-@COUNT_SPLITING_USER_ADMIN);
		SET @POSTAPID= (SELECT POSTAP_ID FROM POST_AUDIT_PROFILE WHERE POSTAP_DATA='USER_ADMIN_REPORT_DETAILS');
		SET @PREASPID = (SELECT PREASP_ID FROM PRE_AUDIT_SUB_PROFILE WHERE PREASP_DATA='USER_ADMIN_REPORT_DETAILS');
		SET @PREAMPID = (SELECT PREAMP_ID FROM PRE_AUDIT_MAIN_PROFILE WHERE PREAMP_DATA='REPORT');
		UPDATE PRE_AUDIT_SUB_PROFILE SET PREASP_NO_OF_REC=@COUNT_REPORTS_SCDB_FORMAT WHERE PREASP_DATA='USER_ADMIN_REPORT_DETAILS';	
		INSERT INTO POST_AUDIT_HISTORY(POSTAP_ID,POSTAH_NO_OF_REC,PREASP_ID,PREAMP_ID,POSTAH_DURATION,POSTAH_NO_OF_REJ,ULD_ID) VALUES
		(@POSTAPID,@COUNT_SPLITING_USER_ADMIN,@PREASPID,@PREAMPID,@TOTAL_DURATION,@REJECTION_COUNT,@ULDID);
		SET @DROP_TEMP_DURATION=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TEMP_DURATION'));
		PREPARE DROP_TEMP_DURATION_STMT FROM @DROP_TEMP_DURATION;
		EXECUTE DROP_TEMP_DURATION_STMT;
	END IF;
	COMMIT;
END;
