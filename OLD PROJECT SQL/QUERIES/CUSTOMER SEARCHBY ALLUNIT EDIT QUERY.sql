(SELECT UNITID FROM ',TEMP_UNITNO,' WHERE ID=',UNITNO_COUNT,')

SELECT *FROM customer_access_card_details WHERE UASD_ID=191

SELECT ID INTO @ACCESS_ACTIVE_ID FROM TEMP_ACCESS_CARD_SINGLE_UNIT_20140528181037_10 WHERE ACTIVE_CARD IS NOT NULL ORDER BY ID DESC LIMIT 1

IF ACTIVE_CARD_COUNT>1  THEN
SET @CUST_ID=CUSTOMER_NO;
SET @TEMP_CUSTOMER_NAME=(SELECT CONCAT(CUSTOMER_FIRST_NAME,' ',CUSTOMER_LAST_NAME)AS CUSTOMERNAME FROM CUSTOMER WHERE CUSTOMER_ID=@CUST_ID);
SET FLAG_MESSAGE=(SELECT CONCAT('DUPLICATE CARD (',CARDNO,') FOR ',@TEMP_CUSTOMER_NAME));
END IF;

SET @CUSTOMER_ID=(SELECT CONCAT('SELECT CUSTOMER_ID INTO @CUSTID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID));
PREPARE CREATE_CUSTOMER_ID_STMT FROM @CUSTOMER_ID;
EXECUTE CREATE_CUSTOMER_ID_STMT;
SET CUSTID=@CUSTID;


SET @INSERT_CUST=(SELECT CONCAT('INSERT INTO ',TEMP_CUST,' (CUST_ID,CUST_NAME)(SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID,'),SELECT CONCAT(CUSTOMER_FIRST_NAME,CUSTOMER_LAST_NAME) FROM CUSTOMER WHERE CUSTOMER_ID=',CUSTID));
PREPARE INSERT_CUST_STMT FROM @INSERT_CUST;
EXECUTE INSERT_CUST_STMT;

 SET @INSERT_TEMP_ACCESS=(SELECT CONCAT('INSERT INTO temp_access_20140528185626_10 (UNITID,UNITNO,UASDID,ACCESS_CARD) SELECT U1.UNITID,U1.UNITNO,UASD.UASD_ID,UASD.UASD_ACCESS_CARD FROM UNIT_ACCESS_STAMP_DETAILS UASD,UNIT_DETAILS U, temp_unitno_20140528185626_10 U1 WHERE UASD.UNIT_ID=U.UNIT_ID AND U.UD_OBSOLETE IS NULL AND U1.UNITID=UASD.UNIT_ID AND U.UNIT_ID=U1.UNITID AND UASD.UNIT_ID=6 AND UASD.UASD_ACCESS_CARD IS NOT NULL ORDER BY UASD.UASD_ACCESS_ACTIVE,UASD.UASD_ACCESS_LOST,UASD.UASD_ACCESS_INVENTORY'));
PREPARE INSERT_TEMP_ACCESS_STMT FROM @INSERT_TEMP_ACCESS;
EXECUTE INSERT_TEMP_ACCESS_STMT;

SELECT COUNT(CUSTOMER_ID) FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=12>1

SELECT UASD_ACCESS_CARD FROM UNIT_ACCESS_STAMP_DETAILS WHERE UASD_ACCESS_CARD=13663 AND UASD_ACCESS_ACTIVE IS NOT NULL

SELECT CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID !=4 AND CACD_VALID_TILL IS NOT NULL AND UASD_ID=201

-- IF(SELECT COUNT(CUSTOMER_ID) FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=CARD_ID!=1)THEN
SET @CUSTOMER_ID=(SELECT CONCAT('SELECT CUSTOMER_ID INTO @CUSTID FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=',CARD_ID));
PREPARE CREATE_CUSTOMER_ID_STMT FROM @CUSTOMER_ID;
EXECUTE CREATE_CUSTOMER_ID_STMT;
SET CUSTID=@CUSTID;
SET @INSERT_CUST=(SELECT CONCAT('INSERT INTO ',TEMP_CUST,' (CUST_NAME)(SELECT CONCAT(CUSTOMER_FIRST_NAME,CUSTOMER_LAST_NAME) FROM CUSTOMER WHERE CUSTOMER_ID=',CUSTID,')'));
PREPARE INSERT_CUST_STMT FROM @INSERT_CUST;
EXECUTE INSERT_CUST_STMT;
-- END IF;

CREATE TABLE temp_cust_20140529153418_10 (ID INTEGER AUTO_INCREMENT PRIMARY KEY, CUST_ID INTEGER, CUST_NAME VARCHAR(50))

INSERT INTO temp_cust_20140529153418_10(CUST_ID,CUST_NAME)(SELECT CUSTOMER_ID  FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=191,SELECT CONCAT(CI.CUSTOMER_FIRST_NAME,CI.CUSTOMER_LAST_NAME)FROM CUSTOMER CI INNER JOIN CUSTOMER_ACCESS_CARD_DETAILS CA ON CI.CUSTOMER_ID=CA.CUSTOMER_ID WHERE CA.ACN_ID IS NULL AND CA.CACD_VALID_TILL IS NULL AND CA.UASD_ID=191)

SELECT CONCAT(C.CUSTOMER_FIRST_NAME,' ',C.CUSTOMER_LAST_NAME)FROM CUSTOMER C INNER JOIN CUSTOMER_ACCESS_CARD_DETAILS CACD ON C.CUSTOMER_ID=CACD.CUSTOMER_ID WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=191

 WHILE (MAX_ID>=MIN_ID) DO 


      SET @TEMP_CUSTOMER_NAME=(SELECT CONCAT('SELECT CONCAT (CUSTOMER_FIRST_NAME,'' '',CUSTOMER_LAST_NAME)AS CUSTOMERNAME INTO @TEMP_CUSTOMERNAME FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT CUSTOMERID FROM ',TEMP_CUSTOMER_UNIT,' WHERE ID=',MIN_ID,')'));
     PREPARE TEMP_CUSTOMER_NAME_STMT FROM @TEMP_CUSTOMER_NAME;
     EXECUTE TEMP_CUSTOMER_NAME_STMT;

      IF(MIN_ID=1) THEN
       SET CUSTOMER_NAME=(SELECT CONCAT('',CUSTOMER_NAME,'',@TEMP_CUSTOMERNAME));
       ELSEIF (MIN_ID!=1)THEN
        SET CUSTOMER_NAME=(SELECT CONCAT('',CUSTOMER_NAME,',',@TEMP_CUSTOMERNAME));
        END IF;


        SET FLAG=8;
       SET MIN_ID=MIN_ID+1;
       END WHILE;
       
       SET ACCESS_SEARCH_SUCCESSMSG=(SELECT CONCAT(' DUPLICATE (',CARD_NO,') CARDNO FOR ',CUSTOMER_NAME,' CUSTOMERS'));
       
       
 INSERT INTO TEMP_ACCESS_20140529180349_10 (UNITID,UNITNO,UASDID,ACCESS_CARD) SELECT U1.UNITID,U1.UNITNO,UASD.UASD_ID,UASD.UASD_ACCESS_CARD FROM UNIT_ACCESS_STAMP_DETAILS UASD,UNIT_DETAILS U, TEMP_UNITNO_20140529180349_10 U1 WHERE UASD.UNIT_ID=U.UNIT_ID AND U.UD_OBSOLETE IS NULL AND U1.UNITID=UASD.UNIT_ID AND U.UNIT_ID=U1.UNITID AND UASD.UNIT_ID=(SELECT UNITID FROM TEMP_UNITNO_20140529180349_10 WHERE ID=1) AND UASD.UASD_ACCESS_CARD IS NOT NULL ORDER BY UASD.UASD_ACCESS_ACTIVE,UASD.UASD_ACCESS_LOST,UASD.UASD_ACCESS_INVENTORY
 
  SET @CUSTOMER_COUNT=(SELECT CONCAT('SELECT COUNT(*) INTO @CUSTOMERVALUE FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=(SELECT UASDID FROM ',TEMP_ACCESS,' WHERE ID=',ACCESS_CARD_COUNT,')'));
       PREPARE CUSTOMER_COUNT_STMT FROM @CUSTOMER_COUNT;
       EXECUTE CUSTOMER_COUNT_STMT;
       
       SET CUSTOMER_VALUE= @CUSTOMERVALUE;
       IF CUSTOMER_VALUE>1 THEN
       
SELECT COUNT(*)  FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID IS NULL AND CACD_VALID_TILL IS NULL AND UASD_ID=(SELECT UASDID FROM temp_access_20140530113836_10 WHERE ID=2)

SELECT COUNT(*)  FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE ACN_ID !=4 AND CACD_VALID_TILL IS NOT NULL AND UASD_ID=(SELECT UASDID FROM temp_access_20140530125405_10 WHERE ID=2)

INSERT INTO CUSTOMER_ACCESS_CARD_DETAILS VALUES(NULL,172	,201,	1	,'12-06-2012',	'02-07-2012',NULL	,	2,	'2014-03-2917:02:09')
