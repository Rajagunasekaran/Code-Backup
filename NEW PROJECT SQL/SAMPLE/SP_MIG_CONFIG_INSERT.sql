-- version:1.5 -- sdate:18/06/2014 -- edate:18/06/2014 -- issue:805 --commentno#26,28 --desc:added cgn_id in ocbc_configuration(78,79,80)  --done by:RL
-- version:1.4 -- sdate:12/06/2014 -- edate:12/06/2014 -- issue:598 --commentno#63 --desc:removed left join queries  --done by:RL & dhivya
-- version:1.3 -- sdate:09/06/2014 -- edate:09/06/2014 -- issue:566 --comment no#12 --desc:IMPLEMENTED ROLLBACK AND COMMIT --done by:DHIVYA
-- version:1.2 -- sdate:23/05/2014 -- edate:23/05/2014 -- issue:765 --comment no#157 --desc:ADDED CGN_ID 76 IN CUSTOMER CONFIGURATION TABLE --done by:RL
-- version:1.1 -- sdate:12/05/2014 -- edate:12/05/2014 -- issue:765 --desc:changed insert query order for expense_configuration --COMMENTNO#110 --done by:RL
-- version:1.0 -- sdate:08/05/2014 -- edate:08/05/2014 -- issue:765 --desc:added 1 insert query for insert values in expense configuration table --COMMENTNO#110 --done by:RL
-- version:0.9 -- sdate:10/04/2014 -- edate:10/04/2014 -- issue:765 --desc:added SCDB  1/4/2014 TIME STAMP FOR ALL SS RECORDS --done by:RL
-- version:0.8 --sdate:01/04/2014 --edate:01/04/2014 --issue:765 --commentno#53 --desc:SPLIT THE CONFIG MIG  SP INTO 4 PART. --dONEBY:RL
-- version:0.7 --sdate:28/03/2013 --edate:28/03/2014 --issue:783 --desc:changed ALL FOREIGN KEY REFERENCES TABLE SHOULD IN DESTINATION SCHEMA --doneby:RL
-- VER:0.6 STARTDATE:28/03/2014 ENDDATE:28/03/2014 ISSUENO:783 DESC:CHANGED THE SP:SP_MIG_CONFIG_INSERT  REMOVED THE DESTINATION SCHEMA IN POST_AUDIT_HISTORY DONE BY:LALITHA
-- VER:0.5 STARTDATE:25/03/2014 ENDDATE:25/03/2014 ISSUENO:765 COMMENTNO:#8 DESC:CHANGED THE SP:SP_MIG_CONFIG_INSERT CHANGED THE SCHEMA FOR INSERTION IN POST AUDIT HISTORY AND UPDATION IN PRE AUDIT SUB PROFILE  DONE BY:LALITHA
-- version:0.4 -- sdate:20/03/2014 -- edate:22/03/2014 -- issue:765 -- desc:Changed the SP:SP_MIG_CONFIG_INSERT As prepared stmt for dynamic running purpose --Doneby:Lalitha
-- version:0.3 -- sdate:17/03/2014 -- edate:17/03/2014 -- issue:765 -- desc:droped temp table -- doneby:RL
-- version:0.2 -- sdate:25/02/2014 -- edate:25/02/2014 -- issue:750 -- desc:getting userstamp n time stamp from db & userstamp changed as uld_id -- doneby:RL
-- version:0.1 -- sdate:20/02/2014 -- edate:21/02/2014 -- issue:750 -- desc:Implementing audit table insert -- doneby:RL
DROP PROCEDURE IF EXISTS SP_MIG_CONFIG_INSERT1;
CREATE PROCEDURE SP_MIG_CONFIG_INSERT1(IN SOURCESCHEMA  VARCHAR(40),IN DESTINATIONSCHEMA  VARCHAR(40),IN MIGUSERSTAMP VARCHAR(50))
BEGIN
	DECLARE START_TIME TIME;
	DECLARE END_TIME TIME;
	DECLARE DURATION TIME;
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
		SET @DROP_CUSTOMER_CONFIGURATION=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.CUSTOMER_CONFIGURATION'));
	  PREPARE DROP_CUSTOMER_CONFIGURATIONSTMT FROM @DROP_CUSTOMER_CONFIGURATION;
    EXECUTE DROP_CUSTOMER_CONFIGURATIONSTMT;
	SET @CREATE_CUSTOMER_CONFIGURATION=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.CUSTOMER_CONFIGURATION(
	CCN_ID INTEGER NOT NULL AUTO_INCREMENT,
	CGN_ID INTEGER NOT NULL,
	CCN_DATA TEXT NOT NULL,
	CCN_INITIALIZE_FLAG    CHAR(1) NULL,
	ULD_ID INTEGER(2) NOT NULL,
	CCN_TIMESTAMP TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(CCN_ID),FOREIGN KEY(CGN_ID) REFERENCES ',DESTINATIONSCHEMA,'.CONFIGURATION(CGN_ID),
	FOREIGN KEY(ULD_ID) REFERENCES ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS(ULD_ID))'));
	PREPARE CREATE_CUSTOMER_CONFIGURATION_STMT FROM @CREATE_CUSTOMER_CONFIGURATION;
	EXECUTE CREATE_CUSTOMER_CONFIGURATION_STMT;
	SET @INSERT_CUSTOMER_CONFIGURATION=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.CUSTOMER_CONFIGURATION(CCN_DATA,CGN_ID,CCN_INITIALIZE_FLAG,ULD_ID,CCN_TIMESTAMP)
	SELECT CSQL.DATA,CSQL.CGN_ID,CSQL.INITIALIZE_FLAG,ULD.ULD_ID,CSQL.TIMESTAMP FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT CSQL, ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS ULD WHERE ULD.ULD_LOGINID = CSQL.USER_STAMP AND CGN_ID IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,33,39,47,50,53,54,75,76) AND CSQL.DATA IS NOT NULL ORDER BY CSQL.ID'));
	PREPARE INSERT_CUSTOMER_CONFIGURATION_STMT FROM @INSERT_CUSTOMER_CONFIGURATION;
	EXECUTE INSERT_CUSTOMER_CONFIGURATION_STMT;
	SET END_TIME = (SELECT CURTIME());
	SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME));
	SET @COUNTCUSTOMERCONFIGURATIONSQLFORMAT=(SELECT CONCAT('SELECT COUNT(DATA) INTO @COUNT_CUSTOMER_CONFIGURATION_SQL_FORMAT FROM ',SOURCESCHEMA,'.CONFIG_SQL_FORMAT   WHERE DATA IS NOT NULL AND CGN_ID IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,33,39,47,50,53,54,75,76)'));
	PREPARE COUNTCUSTOMERCONFIGURATIONSQLFORMATSTMT FROM @COUNTCUSTOMERCONFIGURATIONSQLFORMAT;
    EXECUTE COUNTCUSTOMERCONFIGURATIONSQLFORMATSTMT;
	SET @COUNTSPLITINGCUSTOMERCONFIGURATION=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_SPLITING_CUSTOMER_CONFIGURATION FROM ',DESTINATIONSCHEMA,'.CUSTOMER_CONFIGURATION'));
	PREPARE COUNTSPLITINGCUSTOMERCONFIGURATIONSTMT FROM @COUNTSPLITINGCUSTOMERCONFIGURATION;
    EXECUTE COUNTSPLITINGCUSTOMERCONFIGURATIONSTMT;
	SET @REJECTION_COUNT=(@COUNT_CUSTOMER_CONFIGURATION_SQL_FORMAT-@COUNT_SPLITING_CUSTOMER_CONFIGURATION);
	SET @POSTAPID= (SELECT POSTAP_ID FROM POST_AUDIT_PROFILE WHERE POSTAP_DATA='CUSTOMER_CONFIGURATION');
	SET @PREASPID = (SELECT PREASP_ID FROM PRE_AUDIT_SUB_PROFILE WHERE PREASP_DATA='CUSTOMER_CONFIGURATION');
	SET @PREAMPID = (SELECT PREAMP_ID FROM PRE_AUDIT_MAIN_PROFILE WHERE PREAMP_DATA='CONFIGURATION');
	SET @DUR=DURATION;
	UPDATE PRE_AUDIT_SUB_PROFILE SET PREASP_NO_OF_REC=@COUNT_CUSTOMER_CONFIGURATION_SQL_FORMAT WHERE PREASP_DATA='CUSTOMER_CONFIGURATION';    
	INSERT INTO POST_AUDIT_HISTORY(POSTAP_ID,POSTAH_NO_OF_REC,PREASP_ID,PREAMP_ID,POSTAH_DURATION,POSTAH_NO_OF_REJ,ULD_ID)VALUES
	(@POSTAPID,@COUNT_SPLITING_CUSTOMER_CONFIGURATION,@PREASPID,@PREAMPID,@DUR,@REJECTION_COUNT,@ULDID);  
	SET FOREIGN_KEY_CHECKS = 1;
COMMIT;
END;
CALL SP_MIG_CONFIG_INSERT1(SOURCESCHEMA,DESTINATIONSCHEMA,MIGUSERSTAMP);