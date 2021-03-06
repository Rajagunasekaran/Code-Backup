-- VERSION :0.2 TRACKER NO:817 COMMENT #35 STARTDATE:08/05/2014 ENDDATE:08/05/2014 DESC: CHANGED TEMP TABLE FOR DYNAMIC PURPOSE DONE BY:RAJA 
-- VERSION :0.1 TRACKER NO: 595, COMMENT: #  STARTDATE: 30-01-2014  ENDDATE: 30-01-2014. DESC: CHART SINGLE EXPENSE PER UNIT. DONE BY: MANIKANDAN. S
DROP PROCEDURE IF EXISTS SP_CHARTS_SINGLE_EXPENSE_PERUNIT;
CREATE PROCEDURE SP_CHARTS_SINGLE_EXPENSE_PERUNIT
(IN INPUT_UNIT_NO INT,
IN FROM_DATE VARCHAR(20),
IN TO_DATE VARCHAR(20),
IN DETAILTABLE CHAR(100),
IN TABLENAME CHAR(100),
IN AMT TEXT,
IN INVOICE TEXT,
IN PR_ID TEXT,
IN USERSTAMP VARCHAR(50),
OUT TEMP_CHARTS_SINGLE_EXPENSE_PERUNIT TEXT)
BEGIN
DECLARE FINAL_FROM_DATE VARCHAR(20);
DECLARE FINAL_TO_DATE VARCHAR(20);
DECLARE l_sql VARCHAR(4000);
DECLARE SQ VARCHAR(2000);
DECLARE USERSTAMP_ID INT;
DECLARE CHARTS_SINGLE_EXPENSE_PERUNIT TEXT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  ROLLBACK;
END;
START TRANSACTION;

-- Format the input date into proper date format.
  CALL SP_FORMAT_DATE(FROM_DATE,TO_DATE,@fd,@td);
  SELECT @fd INTO FINAL_FROM_DATE;
  SELECT @td INTO FINAL_TO_DATE;
  
  --  TEMP TABLE NAME START
  CALL SP_CHANGE_USERSTAMP_AS_ULDID(USERSTAMP,@ULDID);
  SET USERSTAMP_ID=(SELECT @ULDID);
  SET CHARTS_SINGLE_EXPENSE_PERUNIT=(SELECT CONCAT('TEMP_CHARTS_SINGLE_EXPENSE_PERUNIT',SYSDATE()));
  --  TEMP TABLE NAME
  SET CHARTS_SINGLE_EXPENSE_PERUNIT=(SELECT REPLACE(CHARTS_SINGLE_EXPENSE_PERUNIT,' ',''));
  SET CHARTS_SINGLE_EXPENSE_PERUNIT=(SELECT REPLACE(CHARTS_SINGLE_EXPENSE_PERUNIT,'-',''));
  SET CHARTS_SINGLE_EXPENSE_PERUNIT=(SELECT REPLACE(CHARTS_SINGLE_EXPENSE_PERUNIT,':',''));
  SET TEMP_CHARTS_SINGLE_EXPENSE_PERUNIT=(SELECT CONCAT(CHARTS_SINGLE_EXPENSE_PERUNIT,'_',USERSTAMP_ID));   
 
  -- DROP TABLE IF EXISTS TEMP_CHARTS_SINGLE_EXPENSE_PERUNIT;
  SET @CREATE_TEMP_CHARTS_SINGLE_EXPENSE_PERUNIT=(SELECT CONCAT('CREATE TABLE ',TEMP_CHARTS_SINGLE_EXPENSE_PERUNIT,' (MONTH_YEAR VARCHAR(20),AMOUNT DECIMAL(10,2))'));
  PREPARE CREATE_TEMP_CHARTS_SINGLE_EXPENSE_PERUNIT_STMT FROM @CREATE_TEMP_CHARTS_SINGLE_EXPENSE_PERUNIT;
  EXECUTE CREATE_TEMP_CHARTS_SINGLE_EXPENSE_PERUNIT_STMT;
     
   IF ((TABLENAME='EXPENSE_ELECTRICITY') OR (TABLENAME= 'EXPENSE_STARHUB')) THEN
       
      SET l_sql= CONCAT_ws(' ','INSERT INTO ',TEMP_CHARTS_SINGLE_EXPENSE_PERUNIT,' (MONTH_YEAR,AMOUNT) SELECT ','DATE_FORMAT(',INVOICE,',',  '''%M-%Y''','),', 'SUM( ',AMT,' ) FROM ',DETAILTABLE,' EDE,',TABLENAME,' EE,UNIT U,UNIT_DETAILS UD where EDE.',PR_ID,'=EE.',PR_ID,' and EDE.UNIT_ID=U.UNIT_ID and UD.UD_OBSOLETE IS NULL AND UD.UD_END_DATE>CURDATE() AND UD.UNIT_ID=EDE.UNIT_ID AND UD.UD_NON_EI IS NULL AND ',INVOICE,' BETWEEN ''',FINAL_FROM_DATE,''' AND ''',FINAL_TO_DATE,''' AND U.UNIT_NO=',INPUT_UNIT_NO,' GROUP BY YEAR(',INVOICE,'), MONTH(',INVOICE,') ASC');
       
    ELSEIF(TABLENAME='EXPENSE_UNIT') THEN
       
      SET l_sql= CONCAT_ws(' ','INSERT INTO ',TEMP_CHARTS_SINGLE_EXPENSE_PERUNIT,' (MONTH_YEAR,AMOUNT) SELECT ','DATE_FORMAT(',INVOICE,',','''%M-%Y''','),', 'SUM( ',AMT,' ) FROM ',TABLENAME,' EXP,UNIT U,UNIT_DETAILS UD where EXP.UNIT_ID=U.UNIT_ID and UD.UD_OBSOLETE IS NULL AND UD.UD_END_DATE>CURDATE() AND UD.UNIT_ID=EXP.UNIT_ID AND UD.UD_NON_EI IS NULL AND U.UNIT_NO=',INPUT_UNIT_NO,' AND ',INVOICE,' BETWEEN ''',FINAL_FROM_DATE,''' AND ''',FINAL_TO_DATE,'''GROUP BY YEAR(',INVOICE,'), MONTH(',INVOICE,') ASC');
      
    END IF;
   
   SET @sql=l_sql;
   PREPARE s1 FROM @sql;
   EXECUTE s1;
   DEALLOCATE PREPARE s1;
COMMIT;
END;
/*
CALL SP_CHARTS_SINGLE_EXPENSE_PERUNIT(422,'January-2012','January-2014','EXPENSE_DETAIL_ELECTRICITY','EXPENSE_ELECTRICITY','EE.EE_AMOUNT','EE.EE_INVOICE_DATE','EDE_ID','admin@expatsint.com',@TEMP_CHARTS_SINGLE_EXPENSE_PERUNIT);
SELECT @TEMP_CHARTS_SINGLE_EXPENSE_PERUNIT;
select * from TEMP_CHARTS_SINGLE_EXPENSE_PERUNIT20140508125452_1;
*/