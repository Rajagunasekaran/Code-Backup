DROP PROCEDURE IF EXISTS SP_POST_AUDIT;
CREATE PROCEDURE SP_POST_AUDIT(IN DESTINATIONSCHEMA VARCHAR(50))
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
  ROLLBACK;
  END;
  START TRANSACTION;
  SET @VIEW_POST_AUDIT=(SELECT CONCAT('CREATE OR REPLACE VIEW VW_POST_AUDIT AS
  SELECT PAMP.PREAMP_DATA AS DOMAIN_NAME,
  IF(PAH.PREAMP_ID=17,(select SUM(PREAMP_SQL_REC) FROM PRE_AUDIT_HISTORY WHERE PREAMP_ID=17),
  IF(PAH.PREAMP_ID=1,(select SUM(PREAMP_SQL_REC) FROM PRE_AUDIT_HISTORY WHERE PREAMP_ID IN(1,19)),
  IF(PAH.PREAMP_ID=2,(select SUM(PREAMP_SQL_REC) FROM PRE_AUDIT_HISTORY WHERE PREAMP_ID IN(2,18)),
  IF(PAH.PREAMP_ID=3,(select SUM(PREAMP_SQL_REC) FROM PRE_AUDIT_HISTORY WHERE PREAMP_ID IN(3,20)),PREAMP_SQL_REC)))) AS SCDB_NO_OF_RECORDS,PASP.PREASP_DATA AS PREAUDIT_SPLITTED_TABLE,PASP.PREASP_NO_OF_REC AS PRE_AUDIT_NO_OF_REC,PAP.POSTAP_DATA AS POSTAUDIT_SPLITTED_TABLE,
  PAH.POSTAH_NO_OF_REC AS POST_AUDIT_NO_OF_REC,PAH.POSTAH_NO_OF_REJ AS NO_OF_REJ,ULD.ULD_LOGINID AS USERSTAMP,PAH.POSTAH_TIMESTAMP AS TIMESTAMP FROM PRE_AUDIT_MAIN_PROFILE PAMP,PRE_AUDIT_HISTORY PAUH,
  PRE_AUDIT_SUB_PROFILE PASP,POST_AUDIT_PROFILE PAP,POST_AUDIT_HISTORY PAH,',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS ULD WHERE 
  PAMP.PREAMP_ID=PAUH.PREAMP_ID AND PAP.POSTAP_ID=PAH.POSTAP_ID AND PASP.PREASP_ID=PAH.PREASP_ID
  AND PAMP.PREAMP_ID=PAH.PREAMP_ID AND PASP.PREASP_DATA=PAP.POSTAP_DATA AND ULD.ULD_ID=PAH.ULD_ID GROUP BY PAP.POSTAP_DATA ORDER BY PAMP.PREAMP_DATA'));
  PREPARE VIEW_POST_AUDIT_STMT FROM @VIEW_POST_AUDIT;
  EXECUTE VIEW_POST_AUDIT_STMT;
  COMMIT;
END;
CALL SP_POST_AUDIT('EI_HTML');