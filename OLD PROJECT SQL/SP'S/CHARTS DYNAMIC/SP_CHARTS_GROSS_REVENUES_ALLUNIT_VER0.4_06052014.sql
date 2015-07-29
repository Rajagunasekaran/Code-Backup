-- VER 0.4 TRACKER NO:817 COMMENT #35 STARTDATE:06/05/2014 ENDDATE:06/05/2014 DESC: CHANGED TEMP TABLE FOR DYNAMIC PURPOSE DONE BY:RAJA
-- VER 0.3 TRACKER NO:595 COMMENT #43 STARTDATE:22/01/2014 ENDDATE:22/01/2014 DESC:CHANGED UNIT NO DATA TYPE AS SMALLINT(4) UNSIGNED ZEROFILL. DONE BY:MANIKANDAN.S
-- VER 0.2 TRACKER NO:595 COMMENT #43 STARTDATE:21/01/2014 ENDDATE:21/01/2014 DESC:FILTERED ACTIVE UNIT  FOR ALL UNIT. DONE BY:MANIKANDAN.S
-- VER 0.1 TRACKER NO:595 COMMENT #39 STARTDATE:17/01/2014 ENDDATE:17/01/2014 DESC:SP FOR CHARTS GROSS REVENUES FOR ALL UNIT. DONE BY:MANIKANDAN.S
DROP PROCEDURE IF EXISTS SP_CHARTS_GROSS_REVENUE_ALLUNIT;
CREATE PROCEDURE SP_CHARTS_GROSS_REVENUE_ALLUNIT(IN FROM_DATE VARCHAR(20), IN TO_DATE VARCHAR(20),IN USERSTAMP VARCHAR(50),OUT TEMP_CHARTS_GROSS_REVENUE_ALLUNIT TEXT)
BEGIN
DECLARE FROM_PERIOD_YEAR VARCHAR(20);
DECLARE FROM_PERIOD_MONTH VARCHAR(20);
DECLARE FROM_PERIOD_MONTHNO INTEGER;
DECLARE FINAL_FROM_DATE VARCHAR(20);

DECLARE TO_PERIOD_YEAR VARCHAR(20);
DECLARE TO_PERIOD_MONTH VARCHAR(20);
DECLARE TO_PERIOD_MONTHNO INTEGER;
DECLARE FINAL_TO_DATE VARCHAR(20);

DECLARE USERSTAMP_ID INT;
DECLARE CHARTS_GROSS_REVENUE_ALLUNIT TEXT;
DECLARE INTERMEDIATE_GROSS_REVENUE_ALLUNIT TEXT;
DECLARE INTERMEDIATE_GROSS_REVENUE TEXT;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
 ROLLBACK;
END;     
  
  IF (FROM_DATE IS NOT NULL) THEN
    
    SET FROM_PERIOD_YEAR    =(SELECT SUBSTRING_INDEX(FROM_DATE,'-',-1));-- SPLIT YEAR FOR PASSING FOR PERIOD
    SET FROM_PERIOD_MONTH   =(SELECT SUBSTRING(FROM_DATE,1,3));
    
    SET FROM_PERIOD_MONTHNO =(select month(str_to_date(FROM_PERIOD_MONTH,'%b')));-- GET MONTHNO FOR PASSING FOR PERIOD

    SET FINAL_FROM_DATE = CONCAT(FROM_PERIOD_YEAR,'-',FROM_PERIOD_MONTHNO,'-','01');
  ELSE
    SET FINAL_FROM_DATE   = CURDATE();
    SET FROM_PERIOD_YEAR  = YEAR(CURDATE());
    SET FROM_PERIOD_MONTHNO = MONTH(CURDATE());
  END IF;
  
  IF (TO_DATE IS NOT NULL) THEN
    
    SET TO_PERIOD_YEAR=(SELECT SUBSTRING_INDEX(TO_DATE,'-',-1));-- SPLIT YEAR FOR PASSING FOR PERIOD
    SET TO_PERIOD_MONTH=(SELECT SUBSTRING(TO_DATE,1,3));
    
    SET TO_PERIOD_MONTHNO=(select month(str_to_date(TO_PERIOD_MONTH,'%b')));-- GET MONTHNO FOR PASSING FOR PERIOD

    SET FINAL_TO_DATE = CONCAT(TO_PERIOD_YEAR,'-',TO_PERIOD_MONTHNO,'-','31');
  ELSE
    SET FINAL_TO_DATE = CONCAT(FROM_PERIOD_YEAR,'-',FROM_PERIOD_MONTHNO,'-','31');
  END IF;
  
  --  TEMP TABLE NAME START
CALL SP_CHANGE_USERSTAMP_AS_ULDID(USERSTAMP,@ULDID);
SET USERSTAMP_ID=(SELECT @ULDID);
SET CHARTS_GROSS_REVENUE_ALLUNIT=(SELECT CONCAT('TEMP_CHARTS_GROSS_REVENUE_ALLUNIT',SYSDATE()));
--  temp table name
SET CHARTS_GROSS_REVENUE_ALLUNIT=(SELECT REPLACE(CHARTS_GROSS_REVENUE_ALLUNIT,' ',''));
SET CHARTS_GROSS_REVENUE_ALLUNIT=(SELECT REPLACE(CHARTS_GROSS_REVENUE_ALLUNIT,'-',''));
SET CHARTS_GROSS_REVENUE_ALLUNIT=(SELECT REPLACE(CHARTS_GROSS_REVENUE_ALLUNIT,':',''));
SET TEMP_CHARTS_GROSS_REVENUE_ALLUNIT=(SELECT CONCAT(CHARTS_GROSS_REVENUE_ALLUNIT,'_',USERSTAMP_ID));   
  
  -- CREATING MAIN TEMP TABLE FOR FINAL OUTPUT
  -- DROP TABLE IF EXISTS TEMP_CHARTS_GROSS_REVEUE_ALLUNIT;
  SET @CREATE_TEMP_CHARTS_GROSS_REVENUE_ALLUNIT=(SELECT CONCAT ('CREATE TABLE ',TEMP_CHARTS_GROSS_REVENUE_ALLUNIT,'(UNIT_NUMBER SMALLINT(4) UNSIGNED ZEROFILL,GROSS_REVENUE DECIMAL(20,2))'));
  PREPARE CREATE_TEMP_CHARTS_GROSS_REVENUE_ALLUNIT_STMT FROM @CREATE_TEMP_CHARTS_GROSS_REVENUE_ALLUNIT;
	EXECUTE CREATE_TEMP_CHARTS_GROSS_REVENUE_ALLUNIT_STMT;

  --  TEMP TABLE NAME START
SET INTERMEDIATE_GROSS_REVENUE=(SELECT CONCAT('INTERMEDIATE_GROSS_REVENUE_ALLUNIT',SYSDATE()));
--  temp table name
SET INTERMEDIATE_GROSS_REVENUE=(SELECT REPLACE(INTERMEDIATE_GROSS_REVENUE,' ',''));
SET INTERMEDIATE_GROSS_REVENUE=(SELECT REPLACE(INTERMEDIATE_GROSS_REVENUE,'-',''));
SET INTERMEDIATE_GROSS_REVENUE=(SELECT REPLACE(INTERMEDIATE_GROSS_REVENUE,':',''));
SET INTERMEDIATE_GROSS_REVENUE_ALLUNIT=(SELECT CONCAT(INTERMEDIATE_GROSS_REVENUE,'_',USERSTAMP_ID));   
    
  -- CREATING INTERMEDIATE TEMP TABLE 
  -- DROP TABLE IF EXISTS TEMP_INTERMEDIATE_CHARTS_GROSS_REVEUE_ALLUNIT;
  SET @CREATE_INTERMEDIATE_GROSS_REVENUE_ALLUNIT=(SELECT CONCAT ('CREATE TABLE ',INTERMEDIATE_GROSS_REVENUE_ALLUNIT,'(UNIT_NUMBER SMALLINT(4) UNSIGNED ZEROFILL,GROSS_REVENUE DECIMAL(7,2))'));
  PREPARE CREATE_INTERMEDIATE_GROSS_REVENUE_ALLUNIT_STMT FROM @CREATE_INTERMEDIATE_GROSS_REVENUE_ALLUNIT;
	EXECUTE CREATE_INTERMEDIATE_GROSS_REVENUE_ALLUNIT_STMT;
  
  SET @INSERT_INTERMEDIATE_GROSS_REVENUE_ALLUNIT =(SELECT CONCAT ('INSERT INTO ',INTERMEDIATE_GROSS_REVENUE_ALLUNIT,'(UNIT_NUMBER, GROSS_REVENUE) SELECT UN.UNIT_NO,PD.PD_AMOUNT FROM PAYMENT_DETAILS PD,UNIT UN,UNIT_DETAILS UD WHERE UD.UD_OBSOLETE IS NULL AND UD.UD_NON_EI IS NULL AND UD.UD_END_DATE>CURDATE() AND UD.UNIT_ID=UN.UNIT_ID AND UN.UNIT_ID = PD.UNIT_ID AND PD.PD_FOR_PERIOD BETWEEN ','"',FINAL_FROM_DATE,'"',' AND ','"',FINAL_TO_DATE,'"',''));
  PREPARE INSERT_INSERT_INTERMEDIATE_GROSS_REVENUE_ALLUNIT_STMT FROM @INSERT_INTERMEDIATE_GROSS_REVENUE_ALLUNIT;
	EXECUTE INSERT_INSERT_INTERMEDIATE_GROSS_REVENUE_ALLUNIT_STMT;
  
  -- INSERTING INTO FINAL TEMP TABLE GROUPING BY UNIT NUMBER
  SET @INSERT_TEMP_CHARTS_GROSS_REVENUE_ALLUNIT =(SELECT CONCAT ('INSERT INTO ',TEMP_CHARTS_GROSS_REVENUE_ALLUNIT,' (UNIT_NUMBER , GROSS_REVENUE ) (SELECT UNIT_NUMBER,SUM(COALESCE(GROSS_REVENUE,"0")) FROM ',INTERMEDIATE_GROSS_REVENUE_ALLUNIT,' GROUP BY UNIT_NUMBER ORDER BY UNIT_NUMBER ASC)'));
  PREPARE INSERT_TEMP_CHARTS_GROSS_REVENUE_ALLUNIT_STMT FROM @INSERT_TEMP_CHARTS_GROSS_REVENUE_ALLUNIT;
	EXECUTE INSERT_TEMP_CHARTS_GROSS_REVENUE_ALLUNIT_STMT;
  
  SET @DROP_INTERMEDIATE_GROSS_REVENUE_ALLUNIT=(SELECT CONCAT('DROP TABLE IF EXISTS ',INTERMEDIATE_GROSS_REVENUE_ALLUNIT));
	PREPARE DROP_INTERMEDIATE_GROSS_REVENUE_ALLUNIT_STMT FROM @DROP_INTERMEDIATE_GROSS_REVENUE_ALLUNIT;
	EXECUTE DROP_INTERMEDIATE_GROSS_REVENUE_ALLUNIT_STMT;
  
  -- DROP TABLE IF EXISTS TEMP_INTERMEDIATE_CHARTS_GROSS_REVEUE_ALLUNIT;
 COMMIT;
END;
/*
CALL SP_CHARTS_GROSS_REVENUE_ALLUNIT('November-2013','January-2014','admin@expatsint.com',@TEMP_CHARTS_GROSS_REVENUE_ALLUNIT);
SELECT @TEMP_CHARTS_GROSS_REVENUE_ALLUNIT;
SELECT * FROM TEMP_CHARTS_GROSS_REVENUE_ALLUNIT20140506165050_1;
*/