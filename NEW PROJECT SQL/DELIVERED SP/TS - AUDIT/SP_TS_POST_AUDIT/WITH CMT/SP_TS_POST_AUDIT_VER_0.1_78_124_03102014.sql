-- VERSION 0.2 STARTDATE:15/10/2014 ENDDATE:15/10/2014 ISSUE NO:75 COMMENT NO:32  DESC:ADDED TEM EMP SCDB RECORD WITH REPORTS,USER ACCESS,LOGIN DETAILS. DONE BY :RAJA
-- VERSION 0.1 STARTDATE:06/10/2014 ENDDATE:06/10/2014 ISSUE NO:78 COMMENT NO:124  DESC:SP TO CREATE VIEW FOR AUDIT HISTORY. DONE BY :RAJA
DROP PROCEDURE IF EXISTS SP_TS_POST_AUDIT;
CREATE PROCEDURE SP_TS_POST_AUDIT(IN DESTINATIONSCHEMA VARCHAR(50))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
	END;
	START TRANSACTION;
	SET @TS_VIEW_POST_AUDIT=(SELECT CONCAT('CREATE OR REPLACE VIEW VW_TS_POST_AUDIT AS SELECT PAMP.PREAMP_DATA AS DOMAIN_NAME,
  IF(PAH.PREAMP_ID=3 AND PASP.PREASP_DATA="USER_ADMIN_REPORT_DETAILS",(SELECT SUM(PREAMP_SQL_REC) FROM PRE_AUDIT_HISTORY WHERE PREAMP_DATA IN ("REPORTS","TEMP EMP REPORTS")),
  IF(PAH.PREAMP_ID=3,(SELECT SUM(PREAMP_SQL_REC) FROM PRE_AUDIT_HISTORY WHERE PREAMP_DATA="REPORTS"),IF(PAH.PREAMP_ID=2 AND PASP.PREASP_DATA IN ("USER_ACCESS","USER_LOGIN_DETAILS"),
  (SELECT SUM(PREAMP_SQL_REC) FROM PRE_AUDIT_HISTORY WHERE PREAMP_DATA IN ("USER RIGHTS","TEMP EMP USER RIGHTS")),PREAMP_SQL_REC))) AS SCDB_NO_OF_RECORDS,
	PASP.PREASP_DATA AS PREAUDIT_SPLITTED_TABLE,PASP.PREASP_NO_OF_REC AS PRE_AUDIT_NO_OF_REC,PAP.POSTAP_DATA AS POSTAUDIT_SPLITTED_TABLE,
	PAH.POSTAH_NO_OF_REC AS POST_AUDIT_NO_OF_REC,PAH.POSTAH_NO_OF_REJ AS NO_OF_REJ,ULD.ULD_LOGINID AS USERSTAMP,PAH.POSTAH_TIMESTAMP AS TIMESTAMP 
	FROM PRE_AUDIT_MAIN_PROFILE PAMP,PRE_AUDIT_HISTORY PAUH,PRE_AUDIT_SUB_PROFILE PASP,POST_AUDIT_PROFILE PAP,POST_AUDIT_HISTORY PAH,',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS ULD
	WHERE PAMP.PREAMP_DATA=PAUH.PREAMP_DATA AND PAP.POSTAP_ID=PAH.POSTAP_ID AND PASP.PREASP_ID=PAH.PREASP_ID AND PAMP.PREAMP_ID=PAH.PREAMP_ID AND PASP.PREASP_DATA=PAP.POSTAP_DATA 
	AND ULD.ULD_ID=PAH.ULD_ID GROUP BY PAP.POSTAP_DATA ORDER BY PAMP.PREAMP_DATA'));
	PREPARE TS_VIEW_POST_AUDIT_STMT FROM @TS_VIEW_POST_AUDIT;
	EXECUTE TS_VIEW_POST_AUDIT_STMT;
	COMMIT;
END;
/*
DROP VIEW VW_TS_POST_AUDIT;
CALL SP_TS_POST_AUDIT('TS_DEST');
SELECT * FROM VW_TS_POST_AUDIT;
*/