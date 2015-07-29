-- VERSION 0.5 STARTDATE:25/09/2014 ENDDATE:25/09/2014 ISSUE NO:78 COMMENT NO:87 DESC:CREATED THE PROJECT STATUS TABLE. DONE BY :RAJA
-- VERSION 0.4 STARTDATE:16/09/2014 ENDDATE:16/09/2014 ISSUE NO:78 COMMENT NO:70 DESC:ALTERED EMPLOYEE DETAILS COLUMNS. DONE BY :RAJA
-- VERSION 0.3 STARTDATE:05/08/2014 ENDDATE:06/08/2014 ISSUE NO:78 COMMENT NO:45 DESC:ADDED NEW KEY WORDS FOR THE NEW MIG REPORT. DONE BY :RAJA
-- VERSION 0.2 STARTDATE:02/08/2014 ENDDATE:02/08/2014 ISSUE NO:78 COMMENT NO:45 DESC:CREATED ALL OTHER TABLES FOR THE REPORT DETAILS. DONE BY :RAJA
-- VERSION 0.1 STARTDATE:22/08/2014 ENDDATE:24/08/2014 ISSUE NO:78 COMMENT NO:33 DESC:SP FOR INSERT THE ONDUTY REPORTS. DONE BY :RAJA
DROP PROCEDURE IF EXISTS SP_TS_MIG_REPORT_DETAILS_ONDUTY_INSERT;
CREATE PROCEDURE SP_TS_MIG_REPORT_DETAILS_ONDUTY_INSERT(
IN DESTINATIONSCHEMA VARCHAR(40))
BEGIN
	DECLARE OD_TIMESTAMP TIMESTAMP; 
	DECLARE OD_USERSTAMP VARCHAR(50);
	DECLARE PDMAX_ID INT;
	DECLARE UARDMAX_ID INT;
	DECLARE OD_MIN_ID INT;
	DECLARE OD_MAX_ID INT;
	DECLARE START_TIME TIME;
	DECLARE END_TIME TIME;
	DECLARE DURATION TIME;  
	DECLARE AWRDMAX_ID INT;
	DECLARE OEDMAX_ID INT;
	DECLARE EMPMAX_ID INT;
  DECLARE PSMAX_ID INT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
	END;
	START TRANSACTION;  
	-- TABLE FOR ADMIN_WEEKLY_REPORT_DETAILS
	SET @DROP_ADMIN_WEEKLY_REPORT_DETAILS=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.ADMIN_WEEKLY_REPORT_DETAILS'));
	PREPARE DROP_ADMIN_WEEKLY_REPORT_DETAILS_STMT FROM @DROP_ADMIN_WEEKLY_REPORT_DETAILS;
	EXECUTE DROP_ADMIN_WEEKLY_REPORT_DETAILS_STMT;    
	SET @CREATE_ADMIN_WEEKLY_REPORT_DETAILS=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.ADMIN_WEEKLY_REPORT_DETAILS(
	AWRD_ID	INTEGER	NOT NULL AUTO_INCREMENT,
	AWRD_REPORT	TEXT NOT NULL,
	AWRD_DATE	DATE NOT NULL,
	ULD_ID INTEGER NOT NULL,
	AWRD_TIMESTAMP TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(AWRD_ID),
	FOREIGN KEY(ULD_ID) REFERENCES ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS (ULD_ID))'));
	PREPARE CREATE_ADMIN_WEEKLY_REPORT_DETAILS_STMT FROM @CREATE_ADMIN_WEEKLY_REPORT_DETAILS;
	EXECUTE CREATE_ADMIN_WEEKLY_REPORT_DETAILS_STMT;

	-- QUERY FOR ALTER AUTO_INCREMENT 
	SET @AWRDMAXID = (SELECT CONCAT('SELECT MAX(AWRD_ID) INTO @AWRD_MAX_ID FROM ',DESTINATIONSCHEMA,'.ADMIN_WEEKLY_REPORT_DETAILS'));
	PREPARE AWRD_MAX_ID_STMT FROM @AWRDMAXID;
	EXECUTE AWRD_MAX_ID_STMT;
	SET AWRDMAX_ID=@AWRD_MAX_ID;
	IF (AWRDMAX_ID IS NOT NULL) THEN    
		SET @ALTER_ADMIN_WEEKLY_REPORT_DETAILS =(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.ADMIN_WEEKLY_REPORT_DETAILS AUTO_INCREMENT=',AWRDMAX_ID));
		PREPARE ALTER_ADMIN_WEEKLY_REPORT_DETAILS_STMT FROM @ALTER_ADMIN_WEEKLY_REPORT_DETAILS;
		EXECUTE ALTER_ADMIN_WEEKLY_REPORT_DETAILS_STMT;
	END IF;

	-- TABLE FOR ONDUTY_ENTRY_DETAILS
	SET @DROP_ONDUTY_ENTRY_DETAILS=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.ONDUTY_ENTRY_DETAILS'));
	PREPARE DROP_ONDUTY_ENTRY_DETAILS_STMT FROM @DROP_ONDUTY_ENTRY_DETAILS;
	EXECUTE DROP_ONDUTY_ENTRY_DETAILS_STMT;    
	SET @CREATE_ONDUTY_ENTRY_DETAILS=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.ONDUTY_ENTRY_DETAILS(
	OED_ID INTEGER NOT NULL AUTO_INCREMENT,
	OED_DATE DATE	NOT NULL,
	OED_DESCRIPTION	TEXT NOT NULL,
	ULD_ID INTEGER NOT NULL,
	OED_TIMESTAMP	TIMESTAMP	NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(OED_ID),
	FOREIGN KEY(ULD_ID) REFERENCES ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS (ULD_ID))'));
	PREPARE CREATE_ONDUTY_ENTRY_DETAILS_STMT FROM @CREATE_ONDUTY_ENTRY_DETAILS;
	EXECUTE CREATE_ONDUTY_ENTRY_DETAILS_STMT;

	-- QUERY FOR ALTER AUTO_INCREMENT 
	SET @OEDMAXID = (SELECT CONCAT('SELECT MAX(OED_ID) INTO @OED_MAX_ID FROM ',DESTINATIONSCHEMA,'.ONDUTY_ENTRY_DETAILS'));
	PREPARE OED_MAX_ID_STMT FROM @OEDMAXID;
	EXECUTE OED_MAX_ID_STMT;
	SET OEDMAX_ID=@OED_MAX_ID;
	IF (OEDMAX_ID IS NOT NULL) THEN    
		SET @ALTER_ONDUTY_ENTRY_DETAILS =(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.ONDUTY_ENTRY_DETAILS AUTO_INCREMENT=',OEDMAX_ID));
		PREPARE ALTER_ONDUTY_ENTRY_DETAILS_STMT FROM @ALTER_ONDUTY_ENTRY_DETAILS;
		EXECUTE ALTER_ONDUTY_ENTRY_DETAILS_STMT;
	END IF;
  
	-- TABLE FOR EMPLOYEE_DETAILS
	SET @DROP_EMPLOYEE_DETAILS=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.EMPLOYEE_DETAILS'));
	PREPARE DROP_EMPLOYEE_DETAILS_STMT FROM @DROP_EMPLOYEE_DETAILS;
	EXECUTE DROP_EMPLOYEE_DETAILS_STMT;    
	SET @CREATE_EMPLOYEE_DETAILS=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.EMPLOYEE_DETAILS(
	EMP_ID INTEGER NOT NULL AUTO_INCREMENT,
	ULD_ID INTEGER NOT NULL,
	EMP_FIRST_NAME CHAR(30) NOT NULL,
	EMP_LAST_NAME	CHAR(30) NOT NULL,
	EMP_DOB	DATE NOT NULL,
	EMP_DESIGNATION	VARCHAR(20)	NOT NULL,
	EMP_MOBILE_NUMBER VARCHAR(10) NOT NULL,
	EMP_NEXT_KIN_NAME	CHAR(30) NOT NULL,
	EMP_RELATIONHOOD CHAR(30),
	EMP_ALT_MOBILE_NO	VARCHAR(10),
	EMP_USERSTAMP_ID INTEGER NOT NULL,
	EMP_TIMESTAMP	TIMESTAMP	NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(EMP_ID),
	FOREIGN KEY(ULD_ID) REFERENCES ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS (ULD_ID),
	FOREIGN KEY(EMP_USERSTAMP_ID) REFERENCES ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS (ULD_ID))'));
	PREPARE CREATE_EMPLOYEE_DETAILS_STMT FROM @CREATE_EMPLOYEE_DETAILS;
	EXECUTE CREATE_EMPLOYEE_DETAILS_STMT;

	-- QUERY FOR ALTER AUTO_INCREMENT 
	SET @EMPMAXID = (SELECT CONCAT('SELECT MAX(EMP_ID) INTO @EMP_MAX_ID FROM ',DESTINATIONSCHEMA,'.EMPLOYEE_DETAILS'));
	PREPARE EMP_MAX_ID_STMT FROM @EMPMAXID;
	EXECUTE EMP_MAX_ID_STMT;
	SET EMPMAX_ID=@EMP_MAX_ID;
	IF (EMPMAX_ID IS NOT NULL) THEN    
		SET @ALTER_EMPLOYEE_DETAILS =(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.EMPLOYEE_DETAILS AUTO_INCREMENT=',EMPMAX_ID));
		PREPARE ALTER_EMPLOYEE_DETAILS_STMT FROM @ALTER_EMPLOYEE_DETAILS;
		EXECUTE ALTER_EMPLOYEE_DETAILS_STMT;
	END IF;
  
  -- TABLE FOR PROJECT_STATUS
	SET @DROP_PROJECT_STATUS=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.PROJECT_STATUS'));
	PREPARE DROP_PROJECT_STATUS_STMT FROM @DROP_PROJECT_STATUS;
	EXECUTE DROP_PROJECT_STATUS_STMT;    
	SET @CREATE_PROJECT_STATUS=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.PROJECT_STATUS(
	PS_ID INTEGER NOT NULL AUTO_INCREMENT,
	PD_ID INTEGER NOT NULL,
	PC_ID INTEGER NOT NULL,
	PS_START_DATE	DATE NOT NULL,
  PS_END_DATE	DATE NULL,
	ULD_ID INTEGER(2) NOT NULL,
	PS_TIMESTAMP TIMESTAMP	NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(PS_ID),
  FOREIGN KEY(PD_ID) REFERENCES ',DESTINATIONSCHEMA,'.PROJECT_DETAILS (PD_ID),
	FOREIGN KEY(PC_ID) REFERENCES ',DESTINATIONSCHEMA,'.PROJECT_CONFIGURATION (PC_ID),
	FOREIGN KEY(ULD_ID) REFERENCES ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS (ULD_ID))'));
	PREPARE CREATE_PROJECT_STATUS_STMT FROM @CREATE_PROJECT_STATUS;
	EXECUTE CREATE_PROJECT_STATUS_STMT;

	-- QUERY FOR ALTER AUTO_INCREMENT 
	SET @PSMAXID = (SELECT CONCAT('SELECT MAX(PS_ID) INTO @PS_MAX_ID FROM ',DESTINATIONSCHEMA,'.PROJECT_STATUS'));
	PREPARE PS_MAX_ID_STMT FROM @PSMAXID;
	EXECUTE PS_MAX_ID_STMT;
	SET PSMAX_ID=@PS_MAX_ID;
	IF (PSMAX_ID IS NOT NULL) THEN    
		SET @ALTER_PROJECT_STATUS =(SELECT CONCAT('ALTER TABLE ',DESTINATIONSCHEMA,'.PROJECT_STATUS AUTO_INCREMENT=',PSMAX_ID));
		PREPARE ALTER_PROJECT_STATUS_STMT FROM @ALTER_PROJECT_STATUS;
		EXECUTE ALTER_PROJECT_STATUS_STMT;
	END IF;
  
	-- TEMP TABLE FOR ONDUTY          
	SET START_TIME = (SELECT CURTIME());
	SET @DROP_TEMP_ONDUTY=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TEMP_ONDUTY'));
	PREPARE DROP_DROP_TEMP_ONDUTY_STMT FROM @DROP_TEMP_ONDUTY;
	EXECUTE DROP_DROP_TEMP_ONDUTY_STMT;
	SET @CREATE_TEMP_ONDUTY=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.TEMP_ONDUTY(
	ID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	UID INT(11) NOT NULL ,
	UNAME VARCHAR(255) DEFAULT NULL,
	UDATE VARCHAR(255) DEFAULT NULL,
	UREPORT TEXT,
	USERSTAMP VARCHAR(255) DEFAULT NULL,
	TIMESTAMP VARCHAR(255) DEFAULT NULL)'));
	PREPARE CREATE_TEMP_ONDUTY_STMT FROM @CREATE_TEMP_ONDUTY;
	EXECUTE CREATE_TEMP_ONDUTY_STMT;
	SET @INSERT_TEMPONDUTY=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.TEMP_ONDUTY(UID,UNAME,UDATE,UREPORT,USERSTAMP,TIMESTAMP) 
	(SELECT UID,UNAME,UDATE,UREPORT,USERSTAMP,TIMESTAMP FROM ',DESTINATIONSCHEMA,'.TEMP_REPORTS_SCDB_FORMAT WHERE (UREPORT LIKE "%on-duty%" OR UREPORT LIKE "%onduty%" OR UREPORT LIKE "%on duty%" OR UREPORT LIKE "%worked in new year%" 
	OR UREPORT LIKE "%on_duty%" OR  UREPORT LIKE "OD" OR  UREPORT LIKE "%We went%" OR  UREPORT LIKE "Worked in Christmas%") AND UREPORT NOT LIKE "%ONDUTY%SEARCH%UPDATE%" AND UREPORT NOT LIKE "%testing onduty%absent%halfday%")'));
	PREPARE INSERT_TEMP_ONDUTY_STMT FROM @INSERT_TEMPONDUTY;
	EXECUTE INSERT_TEMP_ONDUTY_STMT; 
	SET @DELETE_TEMPONDUTY=(SELECT CONCAT('DELETE FROM ',DESTINATIONSCHEMA,'.TEMP_REPORTS_SCDB_FORMAT WHERE UID IN (SELECT UID FROM ',DESTINATIONSCHEMA,'.TEMP_ONDUTY)'));
	PREPARE DELETE_TEMPONDUTY_STMT FROM @DELETE_TEMPONDUTY;
	EXECUTE DELETE_TEMPONDUTY_STMT; 

	SET @ONDUTYMINID = (SELECT CONCAT('SELECT MIN(ID) INTO @ODMIN_ID FROM ',DESTINATIONSCHEMA,'.TEMP_ONDUTY'));
	PREPARE ONDUTYMIN_ID_STMT FROM @ONDUTYMINID;
	EXECUTE ONDUTYMIN_ID_STMT;
	SET @ONDUTYMAXID = (SELECT CONCAT('SELECT MAX(ID) INTO @ODMAX_ID FROM ',DESTINATIONSCHEMA,'.TEMP_ONDUTY'));
	PREPARE ONDUTYMAX_ID_STMT FROM @ONDUTYMAXID;
	EXECUTE ONDUTYMAX_ID_STMT;
	SET OD_MIN_ID = @ODMIN_ID;
	SET OD_MAX_ID = @ODMAX_ID;
	WHILE(OD_MIN_ID <= OD_MAX_ID)DO         
		SET @SELECT_ONDUTY_USERSTAMP_TIMESTAMP=(SELECT CONCAT('SELECT USERSTAMP, `TIMESTAMP` INTO @ODUSERSTAMP, @ODTIMESTAMP FROM ',DESTINATIONSCHEMA,'.TEMP_ONDUTY WHERE ID=',OD_MIN_ID));
		PREPARE SELECT_ONDUTY_USERSTAMP_TIMESTAMP_STMT FROM @SELECT_ONDUTY_USERSTAMP_TIMESTAMP;
		EXECUTE SELECT_ONDUTY_USERSTAMP_TIMESTAMP_STMT;
		SET OD_USERSTAMP=@ODUSERSTAMP;
		SET OD_TIMESTAMP=@ODTIMESTAMP;
		IF (OD_USERSTAMP IS NOT NULL OR OD_TIMESTAMP IS NOT NULL) THEN
			SET @INSERT_USERADMINREPORTDETAILS=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.TEMP_USER_ADMIN_REPORT_DETAILS(UARD_REASON,UARD_DATE,UARD_ATTENDANCE,UARD_AM_SESSION,UARD_PM_SESSION, URC_ID, ULD_ID, UARD_BANDWIDTH, UARD_USERSTAMP_ID, UARD_TIMESTAMP) VALUES 
			((SELECT DISTINCT UREPORT FROM ',DESTINATIONSCHEMA,'.TEMP_ONDUTY WHERE ID=',OD_MIN_ID,'),    
			(SELECT DISTINCT UDATE FROM ',DESTINATIONSCHEMA,'.TEMP_ONDUTY WHERE ID=',OD_MIN_ID,'),
			(SELECT DISTINCT AC_ID FROM ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION WHERE AC_DATA="OD" AND CGN_ID=5),
			(SELECT DISTINCT AC_ID FROM ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION WHERE AC_DATA="ONDUTY"),
			(SELECT DISTINCT AC_ID FROM ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION WHERE AC_DATA="ONDUTY"),
			(SELECT DISTINCT RC.URC_ID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS ULD,',DESTINATIONSCHEMA,'.ROLE_CREATION RC,',DESTINATIONSCHEMA,'.USER_ACCESS UA,',DESTINATIONSCHEMA,'.TEMP_ONDUTY RSF WHERE ULD.ULD_LOGINID= RSF.UNAME AND ULD.ULD_ID = UA.ULD_ID AND UA.RC_ID = RC.RC_ID AND RSF.ID=',OD_MIN_ID,'),
			(SELECT DISTINCT ULD_ID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS WHERE ULD_LOGINID=(SELECT UNAME FROM ',DESTINATIONSCHEMA,'.TEMP_ONDUTY WHERE ID=',OD_MIN_ID,')),
			(0),(SELECT DISTINCT ULD_ID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS WHERE ULD_LOGINID=(SELECT USERSTAMP FROM ',DESTINATIONSCHEMA,'.TEMP_ONDUTY WHERE ID=',OD_MIN_ID,')),
			(SELECT DISTINCT TIMESTAMP FROM ',DESTINATIONSCHEMA,'.TEMP_ONDUTY WHERE ID=',OD_MIN_ID,'))'));      
			PREPARE INSERT_TEMP_USER_ADMIN_REPORT_DETAILS_STMT FROM @INSERT_USERADMINREPORTDETAILS;
			EXECUTE INSERT_TEMP_USER_ADMIN_REPORT_DETAILS_STMT;     
			-- QUERY FOR ALTER AUTO_INCREMENT 
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
		IF (OD_USERSTAMP IS NULL OR OD_TIMESTAMP IS NULL) THEN
			SET @INSERT_USERADMINREPORTDETAILS=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.TEMP_USER_ADMIN_REPORT_DETAILS(UARD_REASON,UARD_DATE,UARD_ATTENDANCE,UARD_AM_SESSION,UARD_PM_SESSION, URC_ID, ULD_ID, UARD_BANDWIDTH, UARD_USERSTAMP_ID, UARD_TIMESTAMP) VALUES 
			((SELECT DISTINCT UREPORT FROM ',DESTINATIONSCHEMA,'.TEMP_ONDUTY WHERE ID=',OD_MIN_ID,'),    
			(SELECT DISTINCT UDATE FROM ',DESTINATIONSCHEMA,'.TEMP_ONDUTY WHERE ID=',OD_MIN_ID,'),
			(SELECT DISTINCT AC_ID FROM ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION WHERE AC_DATA="OD" AND CGN_ID=5),
			(SELECT DISTINCT AC_ID FROM ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION WHERE AC_DATA="ONDUTY"),
			(SELECT DISTINCT AC_ID FROM ',DESTINATIONSCHEMA,'.ATTENDANCE_CONFIGURATION WHERE AC_DATA="ONDUTY"),
			(SELECT DISTINCT RC.URC_ID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS ULD,',DESTINATIONSCHEMA,'.ROLE_CREATION RC,',DESTINATIONSCHEMA,'.USER_ACCESS UA,',DESTINATIONSCHEMA,'.TEMP_ONDUTY RSF WHERE ULD.ULD_LOGINID= RSF.UNAME AND ULD.ULD_ID = UA.ULD_ID AND UA.RC_ID = RC.RC_ID AND RSF.ID=',OD_MIN_ID,'),
			(SELECT DISTINCT ULD_ID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS WHERE ULD_LOGINID=(SELECT UNAME FROM ',DESTINATIONSCHEMA,'.TEMP_ONDUTY WHERE ID=',OD_MIN_ID,')),
			(0),(SELECT DISTINCT ULD_ID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS WHERE ULD_LOGINID=(SELECT UNAME FROM ',DESTINATIONSCHEMA,'.TEMP_ONDUTY WHERE ID=',OD_MIN_ID,')),
			(SELECT DISTINCT UDATE FROM ',DESTINATIONSCHEMA,'.TEMP_ONDUTY WHERE ID=',OD_MIN_ID,'))'));      
			PREPARE INSERT_TEMP_USER_ADMIN_REPORT_DETAILS_STMT FROM @INSERT_USERADMINREPORTDETAILS;
			EXECUTE INSERT_TEMP_USER_ADMIN_REPORT_DETAILS_STMT;   
			-- QUERY FOR ALTER AUTO_INCREMENT 
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
	SET OD_MIN_ID=OD_MIN_ID+1;
	END WHILE;
	SET @DROP_TEMPONDUTY=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TEMP_ONDUTY'));
	PREPARE DROP_TEMPONDUTY_STMT FROM @DROP_TEMPONDUTY;
	EXECUTE DROP_TEMPONDUTY_STMT;
	SET END_TIME = (SELECT CURTIME());
	SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME));
	SET @INSERT_TEMP_DURATION=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.TEMP_DURATION(DURATION)VALUES(','"',DURATION,'"',')'));
	PREPARE INSERT_TEMP_DURATION_STMT FROM @INSERT_TEMP_DURATION;
	EXECUTE INSERT_TEMP_DURATION_STMT;
	COMMIT;
END;
/*
CALL SP_TS_MIG_REPORT_DETAILS_ONDUTY_INSERT('dest_04092014');
*/