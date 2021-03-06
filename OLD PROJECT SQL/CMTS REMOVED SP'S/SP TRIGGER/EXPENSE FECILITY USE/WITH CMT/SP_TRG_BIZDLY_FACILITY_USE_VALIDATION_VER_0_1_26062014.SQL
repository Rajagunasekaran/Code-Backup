-- VERSION 0.1 STARTDATE:26/06/2014 ENDDATE:26/06/2014 ISSUE NO: 593 DESC:THROWING ERROR MSG FOR THE CHECK CONSTRAINS. DONE BY :RAJA

DROP PROCEDURE IF EXISTS SP_TRG_BIZDLY_FACILITY_USE_VALIDATION;
CREATE PROCEDURE SP_TRG_BIZDLY_FACILITY_USE_VALIDATION(
IN NEWUNITID INTEGER,
IN NEWINVOICEDATE DATE,
IN NEWDEPOSIT DECIMAL(7,2),
IN NEWAMOUNT DECIMAL(5,2),
IN PROCESS TEXT)
BEGIN
DECLARE UNITSTARTDATE DATE;
DECLARE UNITENDDATE DATE;
DECLARE CONFIGENDDATE DATE;
DECLARE MESSAGE_TEXT VARCHAR(50);

-- CALL THE SP_CONFIG_MONTH FOR CONFIG MONTH
CALL SP_CONFIG_MONTH(NEWUNITID,@CONFIGDATE);
SET CONFIGENDDATE=@CONFIGDATE;

-- SELECT UNIT ENDDATE FROM UNIT DETAILS
SET UNITSTARTDATE=(SELECT UD_START_DATE FROM UNIT_DETAILS WHERE UNIT_ID=NEWUNITID);

-- THROWING ERROR MSG 
IF(PROCESS = 'INSERT') OR (PROCESS='UPDATE') THEN  
  IF (NEWINVOICEDATE > SYSDATE())THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT= 'EFU_INVOICE_DATE SHOULD BE LESSER THAN OR EQUEL TO TODAY DATE';
  END IF;    
  
  IF(CONFIGENDDATE<=SYSDATE())THEN
		SET UNITENDDATE=CONFIGENDDATE;
	ELSE
		SET UNITENDDATE=SYSDATE();
	END IF;    
  IF(NEWINVOICEDATE NOT BETWEEN UNITSTARTDATE AND UNITENDDATE)THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT= 'EFU_INVOICE_DATE SHOULD BE BETWEEN THE UNIT START DATE AND UNIT END DATE';
  END IF; 
  IF(NEWDEPOSIT IS NULL AND NEWAMOUNT IS NULL)THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT= 'EFU_DEPOSIT AND EFU_AMOUNT BOTH SHOULD NOT BE NULL ENTER ANY ONE';
  END IF;
  IF(NEWDEPOSIT IS NOT NULL AND NEWAMOUNT IS NOT NULL)THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT= 'EFU_DEPOSIT AND EFU_AMOUNT BOTH SHOULD NOT BE NOTNULL ENTER ANY ONE';
  END IF;
END IF;
END;