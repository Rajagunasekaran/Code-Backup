DROP PROCEDURE IF EXISTS SP_MIG_EXP_PERSONAL_DOUBLE_SLASHN_INVOICE_ITEM_SPLIT_INSERT;
CREATE PROCEDURE SP_MIG_EXP_PERSONAL_DOUBLE_SLASHN_INVOICE_ITEM_SPLIT_INSERT()
BEGIN
DECLARE DONE INT DEFAULT FALSE;
DECLARE PEID INTEGER;
DECLARE PERSONALCOMMENTS TEXT;
DECLARE ITEMLOCATION INTEGER;
DECLARE INVOICEITEM TEXT;
DECLARE INVOICEFROM TEXT;
DECLARE INVITEM TEXT;
DECLARE FILTER_CURSOR CURSOR FOR 
SELECT PE_ID,PE_PERSONAL_COMMENTS,PE_PERSONAL_INVOICE_ITEMS,PE_PERSONAL_INVOICE_FROM FROM VW_MIG_TEMP_EXP_PERSONAL_SLASHN_REMAINING_COMMENTS;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET DONE = TRUE;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN 
ROLLBACK;
END;
START TRANSACTION;
DROP TABLE IF EXISTS TEMP_EXP_PERSONAL_DOUBLE_SLASHN_INVOICE_ITEM;
CREATE TABLE TEMP_EXP_PERSONAL_DOUBLE_SLASHN_INVOICE_ITEM(ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,PE_ID INT NOT NULL ,PE_PERSONAL_COMMENTS TEXT,PE_INVOICE_ITEM TEXT,PE_INVOICE_FROM TEXT);
OPEN FILTER_CURSOR;
read_loop: LOOP
FETCH FILTER_CURSOR INTO PEID,PERSONALCOMMENTS,INVOICEITEM,INVOICEFROM;
IF DONE THEN
      LEAVE read_loop;
END IF;
SET ITEMLOCATION=(SELECT LOCATE('\n\n',PERSONALCOMMENTS));
SET INVITEM=(SELECT SUBSTRING(PERSONALCOMMENTS,ITEMLOCATION+2));
IF (ITEMLOCATION!=0)THEN
		INSERT INTO TEMP_EXP_PERSONAL_DOUBLE_SLASHN_INVOICE_ITEM(PE_ID,PE_PERSONAL_COMMENTS,PE_INVOICE_ITEM,PE_INVOICE_FROM)VALUES(PEID,PERSONALCOMMENTS,INVITEM,(SELECT PE_PERSONAL_INVOICE_FROM FROM PERSONAL_SCDB_FORMAT WHERE PE_ID=PEID));
	END IF;
	END LOOP;
CLOSE FILTER_CURSOR;
COMMIT;
END;