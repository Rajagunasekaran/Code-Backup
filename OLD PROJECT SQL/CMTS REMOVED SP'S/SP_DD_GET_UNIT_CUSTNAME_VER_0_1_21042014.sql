DROP PROCEDURE IF EXISTS SP_DD_GET_UNIT_CUSTNAME;
CREATE PROCEDURE SP_DD_GET_UNIT_CUSTNAME()
BEGIN
BEGIN 
	ROLLBACK; 
END;
START TRANSACTION;
DROP TABLE IF EXISTS TEMP_TABLE_DD_GET_UNIT_CUSTNAME;
CREATE TABLE TEMP_TABLE_DD_GET_UNIT_CUSTNAME(ID INTEGER AUTO_INCREMENT PRIMARY KEY,CUSTOMER_ID INTEGER,UNIT_NO SMALLINT(4) UNSIGNED ZEROFILL,CUSTOMER_NAME VARCHAR(200));
   INSERT INTO TEMP_TABLE_DD_GET_UNIT_CUSTNAME(UNIT_NO,CUSTOMER_ID,CUSTOMER_NAME) SELECT DISTINCT U.UNIT_NO,CED.CUSTOMER_ID,CONCAT(C.CUSTOMER_FIRST_NAME,' ',C.CUSTOMER_LAST_NAME) AS NAME FROM PAYMENT_DETAILS PD,UNIT U,CUSTOMER C,CUSTOMER_ENTRY_DETAILS CED WHERE U.UNIT_ID=PD.UNIT_ID AND  C.CUSTOMER_ID=PD.CUSTOMER_ID AND CED.CUSTOMER_ID=PD.CUSTOMER_ID AND CED.CED_REC_VER=PD.CED_REC_VER ORDER BY PD.CUSTOMER_ID,PD.UNIT_ID;
   INSERT INTO TEMP_TABLE_DD_GET_UNIT_CUSTNAME(UNIT_NO,CUSTOMER_ID,CUSTOMER_NAME) SELECT DISTINCT U.UNIT_NO,CED.CUSTOMER_ID,CONCAT(C.CUSTOMER_FIRST_NAME,' ',C.CUSTOMER_LAST_NAME) AS NAME FROM EXPENSE_UNIT EU,UNIT U,CUSTOMER C,CUSTOMER_ENTRY_DETAILS CED WHERE U.UNIT_ID=EU.UNIT_ID  AND C.CUSTOMER_ID=EU.CUSTOMER_ID AND CED.CUSTOMER_ID=EU.CUSTOMER_ID ORDER BY EU.CUSTOMER_ID,EU.UNIT_ID ;
   INSERT INTO TEMP_TABLE_DD_GET_UNIT_CUSTNAME(UNIT_NO,CUSTOMER_ID,CUSTOMER_NAME) SELECT DISTINCT U.UNIT_NO,CED.CUSTOMER_ID,CONCAT(C.CUSTOMER_FIRST_NAME,' ',C.CUSTOMER_LAST_NAME) AS NAME FROM CUSTOMER_ACCESS_CARD_DETAILS CACD,CUSTOMER_ENTRY_DETAILS CED,UNIT U,CUSTOMER C WHERE ACN_ID!=4 AND CACD.CUSTOMER_ID=CED.CUSTOMER_ID AND C.CUSTOMER_ID=CACD.CUSTOMER_ID AND U.UNIT_ID=CED.UNIT_ID;
COMMIT;
END;

