DROP PROCEDURE IF EXISTS SP_GET_SPECIAL_CHARACTER_SEPERATED_VALUES;
CREATE PROCEDURE SP_GET_SPECIAL_CHARACTER_SEPERATED_VALUES(IN SPECIAL_CHARACTER VARCHAR(30), IN INPUT_STRING_WITH_COMMAS TEXT, OUT VALUE TEXT, OUT REMAINING_STRING TEXT)
BEGIN
SET @LENGTH = 1;
SET @TEMP = INPUT_STRING_WITH_COMMAS;
SET @SPECIAL_CHAR_LENGTH = LENGTH(SPECIAL_CHARACTER);

    	SET @POSITION=(SELECT LOCATE(SPECIAL_CHARACTER, @TEMP,@LENGTH));
		IF @POSITION<=0 THEN
			SET VALUE = @TEMP;
		ELSE
			SELECT SUBSTRING(@TEMP,@LENGTH,@POSITION-1) INTO VALUE;
			SET REMAINING_STRING =(SELECT SUBSTRING(@TEMP,@POSITION+ @SPECIAL_CHAR_LENGTH ));
		END IF;
 COMMIT;   
END;
DROP PROCEDURE IF EXISTS SP_INSERT_USER_RIGHTS_SCDB_FORMAT;
CREATE PROCEDURE SP_INSERT_USER_RIGHTS_SCDB_FORMAT(IN SOURCESCHEMA VARCHAR(50),IN DESTINATIONSCHEMA VARCHAR(50),IN MIGUSERSTAMP VARCHAR(50))
BEGIN
DECLARE START_TIME TIME;
DECLARE END_TIME TIME;
DECLARE DURATION TIME;
DECLARE MIN_FPID INTEGER;
DECLARE MAX_FPID INTEGER;
DECLARE MIN_MID INTEGER;
DECLARE MAX_MID INTEGER;
DECLARE MIN_RCID INTEGER;
DECLARE MAX_RCID INTEGER;
DECLARE MPMINID INTEGER;
DECLARE MPMAXID INTEGER;
SET FOREIGN_KEY_CHECKS=0;
	SET @LOGIN_ID=(SELECT CONCAT('SELECT ULD_ID INTO @ULDID FROM ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS WHERE ULD_LOGINID=','"',MIGUSERSTAMP,'"'));
	PREPARE LOGINID FROM @LOGIN_ID;
	EXECUTE LOGINID;
	SET START_TIME = (SELECT CURTIME());
	SET START_TIME = (SELECT CURTIME());
	SET @DROP_USER_MENU_DETAILS=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.USER_MENU_DETAILS'));
	PREPARE DUSERMENUDETAILS FROM @DROP_USER_MENU_DETAILS;
    EXECUTE DUSERMENUDETAILS;
    SET @CREATE_USER_MENU_DETAILS=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.USER_MENU_DETAILS( MD_ID INTEGER NOT NULL AUTO_INCREMENT, MP_ID INTEGER(2) NOT NULL, RC_ID INTEGER(2) NOT NULL, ULD_ID INT(2) NOT NULL, MD_TIMESTAMP TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY(MD_ID), FOREIGN KEY(MP_ID) REFERENCES ',DESTINATIONSCHEMA,'.MENU_PROFILE (MP_ID), FOREIGN KEY(RC_ID) REFERENCES ',DESTINATIONSCHEMA,'.ROLE_CREATION (RC_ID), FOREIGN KEY(ULD_ID) REFERENCES ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS (ULD_ID))'));
    PREPARE CUSERMENUDETAILS FROM @CREATE_USER_MENU_DETAILS;
    EXECUTE CUSERMENUDETAILS;
	SET @DROP_TEMP_MENU_DETAILS=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS'));
	PREPARE DTEMPMENUDETAILS FROM @DROP_TEMP_MENU_DETAILS;
    EXECUTE DTEMPMENUDETAILS;
    SET @CREATE_TEMP_MENU_DETAILS=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS(ID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,`Mroles` varchar(255) DEFAULT NULL,`Mname` varchar(255) DEFAULT NULL,`Msubmenu` varchar(255) DEFAULT NULL,`Msub` varchar(255) DEFAULT NULL,`ULD_ID` INT(2) DEFAULT NULL,timestamp TIMESTAMP not null)'));
    PREPARE CTEMPMENUDETAILS FROM @CREATE_TEMP_MENU_DETAILS;
    EXECUTE CTEMPMENUDETAILS;
    SET @INSERT_TEMP_MENU_DETAILS=( SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS (Mroles,Mname,Msub,Msubmenu,ULD_ID,timeStamp) SELECT URSF.Mroles, URSF.Mname, URSF.Msub, URSF.Msubmenu, ULD.ULD_ID , URSF.timeStamp FROM ',SOURCESCHEMA,'.USER_RIGHTS_SCDB_FORMAT URSF,',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS ULD WHERE ULD.ULD_LOGINID=URSF.USERSTAMP AND Mroles IS NOT NULL ORDER BY Mroles'));
    PREPARE INSERTTEMPMENUDETAILS FROM @INSERT_TEMP_MENU_DETAILS; 
    EXECUTE INSERTTEMPMENUDETAILS;
    SET @UPDATETIMESTAMP=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS SET TIMESTAMP=(SELECT CONVERT_TZ(TIMESTAMP, "+08:00","+0:00"))'));
PREPARE UPDATETIMESTAMPSTMT FROM @UPDATETIMESTAMP;
EXECUTE UPDATETIMESTAMPSTMT;
    SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu=null, Msub='"'ACCESS RIGHTS-SEARCH/UPDATE'" 'where Msubmenu='"'ACCESS RIGHTS-SEARCH/UPDATE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
    SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu=null, Msub='"'TERMINATE-SEARCH/UPDATE'"' where Msubmenu='"'TERMINATE-SEARCH/UPDATE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu=null, Msub='"'ACCESS RIGHTS-SEARCH/UPDATE'"' where Msubmenu='"'USER-SEARCH/UPDATE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu=null, Msub='"'USER SEARCH DETAILS'"' where Msubmenu='"'USER SEARCH DETAILS'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu=null, Msub='"'CHARTS'"',Mname='"'REPORT'"' where Mname='"'CHARTS'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'ENTRY'"', Msub='"'CONFIGURATION'"' where Msubmenu='"'ENTRY'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'SEARCH/UPDATE/DELETE'"', Msub='"'CONFIGURATION'"' where Msubmenu='"'CF-SEARCH/UPDATE/DELETE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'ENTRY'"', Msub='"'EMAIL TEMPLATE'"' where Msubmenu='"'TEMPLATE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'SEARCH/UPDATE'"', Msub='"'EMAIL TEMPLATE'"' where Msubmenu='"'EMAIL-SEARCH/UPDATE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu=null,Msub='"'TRIGGER'"',Mname='"'REPORT'"' where Msubmenu='"'TRIGGER'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'EXPIRY LIST'"',Msub='"'CUSTOMER'"'where Msubmenu='"'EXPIRY IN '","'X'","' WEEK'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'ERM SEARCH/UPDATE'"',Msub='"'CUSTOMER'"' where Msubmenu='"'ERM SEARCH/UPDATE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'EXTENSION'"',Msub='"'CUSTOMER'"' where Msubmenu='"'EXTENSION'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'RE CHECKIN'"',Msub='"'CUSTOMER'"' where Msubmenu='"'RE-CHECK IN'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;	
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'SEARCH/UPDATE/DELETE'"',Msub='"'CUSTOMER'"' where Msubmenu='"'CC-SEARCH/UPDATE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;	
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'CREATION'"',Msub='"'CUSTOMER'"' where Msubmenu='"'CREATION'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;	
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'ERM ENTRY'"',Msub='"'CUSTOMER'"' where Msubmenu='"'ERM ENTRY'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'CANCEL'"',Msub='"'CUSTOMER'"' where Msubmenu='"'CANCEL'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'EXPIRY LIST'"',Msub='"'CUSTOMER'"' where Msubmenu='"'EXPIRY'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'TERMINATION'"',Msub='"'CUSTOMER'"' where Msubmenu='"'TERMINATION'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'CARD ASSIGN'"',Msub='"'ACCESS CARD'"' where Msubmenu='"'CARD ASSIGN'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'SEARCH/UPDATE'"',Msub='"'ACCESS CARD'"' where Msub='"'ACCESS'"' and Msubmenu='"'SEARCH/UPDATE/DELETE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'REPLACE'"',Msub='"'ACCESS CARD'"' where Msubmenu='"'REPLACE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'VIEW'"',Msub='"'ACCESS CARD'"' where Msubmenu='"'VIEW'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu=null,Msub='"'EXISTING UNIT'"' where Mname='"'UNIT'"' and Msubmenu='"'EXISTING UNIT'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu=null,Msub='"'UNIT CREATION'"' where  Mname='"'UNIT'"' and Msubmenu='"'UNIT CREATION'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu=null,Msub='"'SEARCH/UPDATE'" 'where  Mname='"'UNIT'"' and Msubmenu='"'SEARCH/UPDATE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;	
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu=null,Msub='"'DOOR CODE SEARCH/UPDATE '"' where Mname='"'UNIT'"' and Msubmenu='"'SEARCH/UPDATE DOOR CODE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu=null,Msub='"'UNIT TERMINATION'"' where  Mname='"'UNIT'"' and Msubmenu='"'UNIT TERMINATION'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'PAYMENTS ENTRY-ACTIVE CUSTOMER'"',Msub='"'FINANCE'"' where Msubmenu='"'PAYMENT'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'PAYMENTS-SEARCH/UPDATE'"',Msub='"'FINANCE'"' where Msubmenu='"'PAYMENT-SEARCH/UPDATE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'DAILY SEARCH/UPDATE/DELETE'"',Msub='"'BIZ EXPENSE'"' where Msubmenu='"'BIZ-DAILY-SEARCH/UPDATE/DELETE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'DAILY ENTRY'"',Msub='"'BIZ EXPENSE'"' where Msubmenu='"'BIZ-DAILY ENTRY'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'DETAIL SEARCH/UPDATE/DELETE'"',Msub='"'BIZ EXPENSE'"' where Msubmenu='"'BIZ-DETAIL-SEARCH/UPDATE/DELETE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'DETAIL ENTRY'"',Msub='"'BIZ EXPENSE'"' where Msubmenu='"'BIZ-DETAIL ENTRY'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'DAILY SEARCH/UPDATE/DELETE'"' where Msub='"'STAFF'"' and Msubmenu='"'DAILY-SEARCH/UPDATE/DELETE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'DAILY ENTRY'"' where Msub='"'STAFF'"' and Msubmenu='"'DAILY ENTRY'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'DETAIL SEARCH/UPDATE/DELETE'"' where Msub='"'STAFF'"' and Msubmenu='"'DETAIL-SEARCH/UPDATE/DELETE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'DETAIL ENTRY'"' where Msub='"'STAFF'"' and Msubmenu='"'DAILY ENTRY'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'DAILY SEARCH/UPDATE/DELETE'"',Msub='"'PERSONAL'"' where Msubmenu='"'PERSONAL-DAILY-SEARCH/UPDATE/DELETE'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msubmenu='"'DAILY ENTRY'"',Msub='"'PERSONAL'"' where Msubmenu='"'PERSONAL-DAILY ENTRY'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @UPDATE_TEMP_MENU_DETAILS=(SELECT CONCAT('UPDATE ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS set Msub='"'FINANCE'"' where Msub='"'FINAC'"));
    PREPARE UPTEMP_MENU_DETAILS FROM @UPDATE_TEMP_MENU_DETAILS;
    EXECUTE UPTEMP_MENU_DETAILS;
	SET @MMAX_ID=(SELECT CONCAT('SELECT MAX(ID) INTO @MAXID FROM ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS'));
	PREPARE MAXIMUMMENU FROM @MMAX_ID;
	EXECUTE MAXIMUMMENU;
	SET @MMIN_ID=(SELECT CONCAT('SELECT MIN(ID) INTO @MINID FROM ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS'));
	PREPARE MINIMUMMENU FROM @MMIN_ID;
	EXECUTE MINIMUMMENU;
	SET MIN_MID=@MINID;
	SET MAX_MID=@MAXID;
	WHILE(MIN_MID<=MAX_MID)DO
		SET @INSERTUSER_MENU_DETAILS=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.USER_MENU_DETAILS(MP_ID,RC_ID,ULD_ID,MD_TIMESTAMP)VALUES((SELECT MP_ID FROM ',DESTINATIONSCHEMA,'.MENU_PROFILE WHERE IFNULL(MP_MSUBMENU, ',"' " " '",' )=IFNULL((SELECT Msubmenu FROM ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS WHERE ID=',MIN_MID,'), ',"' " " '",' ) AND IFNULL(MP_MSUB, ',"' " " '",' )=IFNULL((select Msub from ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS WHERE ID=',MIN_MID,'), ',"' " " '",' )),(SELECT RC_ID FROM ',DESTINATIONSCHEMA,'.ROLE_CREATION WHERE RC_NAME=(SELECT Mroles FROM ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS WHERE ID=',MIN_MID,')),(SELECT ULD_ID FROM ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS WHERE ID=',MIN_MID,'),(SELECT timeStamp FROM ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS WHERE ID=',MIN_MID,'))'));
		PREPARE INSERTUSER_STMT FROM @INSERTUSER_MENU_DETAILS;
		EXECUTE INSERTUSER_STMT;		
		SET MIN_MID=MIN_MID+1;
		END WHILE;
		SET END_TIME = (SELECT CURTIME());
		SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME));
       SET @DROP_TEMP_SA_DETAILS=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TEMP_SA_DETAILS'));
	   PREPARE DDROP_TEMP_SA_DETAILS FROM @DROP_TEMP_SA_DETAILS;
       EXECUTE DDROP_TEMP_SA_DETAILS;
       SET @CREATE_TEMP_SA_DETAILS=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.TEMP_SA_DETAILS(ID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,MP_ID varchar(255) DEFAULT NULL,timestamp VARCHAR(50))'));	   
        PREPARE CREATETEMPSA_DETAILS FROM @CREATE_TEMP_SA_DETAILS;
        EXECUTE CREATETEMPSA_DETAILS;
		SET @INSERT_TEMP_SA_DETAILS=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.TEMP_SA_DETAILS(MP_ID,timestamp) SELECT MP_ID,"2014-04-01 00:00:00" FROM  ',DESTINATIONSCHEMA,'.MENU_PROFILE WHERE MP_ID NOT IN(SELECT MP_ID FROM ',DESTINATIONSCHEMA,'.USER_MENU_DETAILS WHERE RC_ID=2)'));
		PREPARE INSERTTEMPSA_DETAILS FROM @INSERT_TEMP_SA_DETAILS;
        EXECUTE INSERTTEMPSA_DETAILS;
		SET @MAX_MPID=(SELECT CONCAT('SELECT MAX(ID) INTO @MAXMPID FROM ',DESTINATIONSCHEMA,'.TEMP_SA_DETAILS'));
		PREPARE MAXMP_ID FROM @MAX_MPID;
	    EXECUTE MAXMP_ID;
		SET @MIN_MPID=(SELECT CONCAT('SELECT MIN(ID) INTO @MINMPID FROM ',DESTINATIONSCHEMA,'.TEMP_SA_DETAILS'));
		PREPARE MINMP_ID FROM @MIN_MPID;
	    EXECUTE MINMP_ID;
		SET MPMINID=@MINMPID;
		SET MPMAXID=@MAXMPID;
		WHILE(MPMINID<=MPMAXID)DO
		SET @INSERTUSERMENUDETAILS=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.USER_MENU_DETAILS(MP_ID,RC_ID,ULD_ID,MD_TIMESTAMP)VALUES((SELECT MP_ID FROM ',DESTINATIONSCHEMA,'.TEMP_SA_DETAILS WHERE ID=',MPMINID,'),2,2,(SELECT timestamp FROM ',DESTINATIONSCHEMA,'.TEMP_SA_DETAILS WHERE ID=',MPMINID,'))'));
		PREPARE INSERT_USERMENUDETAILS FROM @INSERTUSERMENUDETAILS;
	    EXECUTE INSERT_USERMENUDETAILS;	
		SET MPMINID=MPMINID+1;
        END WHILE;		
   SET @COUNT_USER_MENU_DETAILS_SCDB_FORMAT=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_USER_MENU_DETAILS_SCDB_FORMAT FROM ',SOURCESCHEMA,'.USER_RIGHTS_SCDB_FORMAT WHERE Mroles IS NOT NULL'));
	PREPARE COUNTUSERMENUDETAILSSCDBFORMAT FROM @COUNT_USER_MENU_DETAILS_SCDB_FORMAT;
	EXECUTE COUNTUSERMENUDETAILSSCDBFORMAT;
	SET @COUNT_EXTRA_MENU=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_EXTRAMENU FROM ',DESTINATIONSCHEMA,'.TEMP_SA_DETAILS '));
	PREPARE COUNT_EXTRAMENU FROM @COUNT_EXTRA_MENU;
	EXECUTE COUNT_EXTRAMENU;	
	SET @COUNT_SPLITING_USER_MENU_DETAILS=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_SPLITING_USER_MENU_DETAILS FROM ',DESTINATIONSCHEMA,'.USER_MENU_DETAILS'));
	PREPARE COUNTSPLITINGUSERMENUDETAILS FROM @COUNT_SPLITING_USER_MENU_DETAILS;
	EXECUTE COUNTSPLITINGUSERMENUDETAILS;	
	SET @REJECTION_COUNT=((@COUNT_USER_MENU_DETAILS_SCDB_FORMAT+@COUNT_EXTRAMENU)-@COUNT_SPLITING_USER_MENU_DETAILS);
    UPDATE PRE_AUDIT_SUB_PROFILE SET PREASP_NO_OF_REC=@COUNT_USER_MENU_DETAILS_SCDB_FORMAT WHERE PREASP_DATA='USER_MENU_DETAILS';
    SET @POSTAPIDSTMT=(SELECT CONCAT('SELECT POSTAP_ID INTO @POSTAPID FROM POST_AUDIT_PROFILE WHERE POSTAP_DATA=',"'USER_MENU_DETAILS'"));
    PREPARE POSTAPSTMT FROM @POSTAPIDSTMT;
    EXECUTE POSTAPSTMT;
    SET @PREASPSTMT=(SELECT CONCAT('SELECT PREASP_ID INTO @PREASPID FROM PRE_AUDIT_SUB_PROFILE WHERE PREASP_DATA=',"'USER_MENU_DETAILS'"));
    PREPARE PREASPIDSTMT FROM @PREASPSTMT;
    EXECUTE PREASPIDSTMT;
    SET @PREAMPSTMT=(SELECT CONCAT('SELECT PREAMP_ID INTO @PREAMPID FROM PRE_AUDIT_MAIN_PROFILE WHERE PREAMP_DATA=',"'USER RIGHTS'"));
    PREPARE PREAMPIDSTMT FROM @PREAMPSTMT;
    EXECUTE PREAMPIDSTMT;
    SET @DUR=DURATION;
	INSERT INTO POST_AUDIT_HISTORY(POSTAP_ID,POSTAH_NO_OF_REC,PREASP_ID,PREAMP_ID,POSTAH_DURATION,POSTAH_NO_OF_REJ,ULD_ID)VALUES(@POSTAPID,@COUNT_SPLITING_USER_MENU_DETAILS,@PREASPID,@PREAMPID,@DUR,@REJECTION_COUNT,@ULDID);
	SET START_TIME = (SELECT CURTIME());
	SET @DROP_USER_FILE_DETAILS=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.USER_FILE_DETAILS'));
	PREPARE DUSERFILEDETAILS FROM @DROP_USER_FILE_DETAILS;
    EXECUTE DUSERFILEDETAILS;
    SET @CREATE_USER_FILE_DETAILS=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.USER_FILE_DETAILS(UFD_ID INTEGER NOT NULL	AUTO_INCREMENT, RC_ID INTEGER(2) NOT NULL, FP_ID INTEGER(2) NOT NULL,	ULD_ID INT(2) NOT NULL,	UFD_TIMESTAMP TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY(UFD_ID), FOREIGN KEY(RC_ID) REFERENCES ',DESTINATIONSCHEMA,'.ROLE_CREATION (RC_ID), FOREIGN KEY(FP_ID) REFERENCES ',DESTINATIONSCHEMA,'.FILE_PROFILE (FP_ID), FOREIGN KEY(ULD_ID) REFERENCES ',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS (ULD_ID))'));
    PREPARE CUSERFILEDETAILS FROM @CREATE_USER_FILE_DETAILS;
    EXECUTE CUSERFILEDETAILS;
	SET @FINAL_COUNT=0;
	SET @RC_MINID=(SELECT CONCAT('SELECT MIN(RC_ID) INTO @MIN_RC FROM ',DESTINATIONSCHEMA,'.ROLE_CREATION'));
	PREPARE MINIMUMID FROM @RC_MINID;
	EXECUTE MINIMUMID;
	SET @RC_MAXID=(SELECT CONCAT('SELECT MAX(RC_ID) INTO @MAX_RC FROM ',DESTINATIONSCHEMA,'.ROLE_CREATION'));
	PREPARE MAXIMUMID FROM @RC_MAXID;
	EXECUTE MAXIMUMID;
	SET MIN_RCID=@MIN_RC;
	SET MAX_RCID=@MAX_RC;
WHILE(MIN_RCID<=MAX_RCID)DO
SET @C=0;
	SET @DROP_TEMP_USER_FILE_DETAILS=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TEMP_USER_FILE_DETAILS'));
	PREPARE DTEMPUSERFILEDETAILS FROM @DROP_TEMP_USER_FILE_DETAILS;
    EXECUTE DTEMPUSERFILEDETAILS;
    SET @CREATE_TEMP_USER_FILE_DETAILS=(SELECT CONCAT('CREATE TABLE ',DESTINATIONSCHEMA,'.TEMP_USER_FILE_DETAILS(ID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,RC_ID INTEGER,FP_ID TEXT,ULD_ID INT(2) DEFAULT NULL,TIMESTAMP VARCHAR(50) NOT NULL)'));
    PREPARE CTEMPUSERFILEDETAILS FROM @CREATE_TEMP_USER_FILE_DETAILS;
    EXECUTE CTEMPUSERFILEDETAILS;
    SET @INSERT_TEMP_USER_FILE_DETAILS=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.TEMP_USER_FILE_DETAILS (FP_ID,ULD_ID,TIMESTAMP)SELECT DISTINCT FP_ID,ULD.ULD_ID,"2014-04-01 00:00:00" FROM ',DESTINATIONSCHEMA,'.MENU_PROFILE MP,',DESTINATIONSCHEMA,'.ROLE_CREATION RC,',DESTINATIONSCHEMA,'.USER_MENU_DETAILS UMD,',DESTINATIONSCHEMA,'.USER_LOGIN_DETAILS ULD WHERE ULD.ULD_LOGINID=RC.RC_USERSTAMP AND RC.RC_ID=UMD.RC_ID AND UMD.MP_ID=MP.MP_ID AND RC.RC_ID=',MIN_RCID,' AND MP.FP_ID IS NOT NULL'));
    PREPARE INSERTTEMPUSERFILEDETAILS FROM @INSERT_TEMP_USER_FILE_DETAILS;
    EXECUTE INSERTTEMPUSERFILEDETAILS;
	SET @FPMIN_ID=(SELECT CONCAT('SELECT MIN(ID) INTO @MINFPID FROM ',DESTINATIONSCHEMA,'.TEMP_USER_FILE_DETAILS'));
	PREPARE MINIMUMFPID FROM @FPMIN_ID;
	EXECUTE MINIMUMFPID;
	SET @FPMAX_ID=(SELECT CONCAT('SELECT MAX(ID) INTO @MAXFPID FROM ',DESTINATIONSCHEMA,'.TEMP_USER_FILE_DETAILS'));
	PREPARE MAXIMUMFPID FROM @FPMAX_ID;
	EXECUTE MAXIMUMFPID;
	SET MIN_FPID=@MINFPID;
	SET MAX_FPID=@MAXFPID;
	WHILE(MIN_FPID<=MAX_FPID)DO
  SET @FP_ID=NULL;
		SET @FPIDSTMT=(SELECT CONCAT('SELECT FP_ID INTO @FP_ID FROM ',DESTINATIONSCHEMA,'.TEMP_USER_FILE_DETAILS WHERE ID=',MIN_FPID));
    PREPARE FPID_STMT FROM @FPIDSTMT;
    EXECUTE FPID_STMT;
		SET @FP_LENGTH=(select length(@FP_ID)- length(replace(@FP_ID,',','')));
		IF(@FP_LENGTH>0)THEN
		SET @remaining_string=@FP_ID;
		loop_label : LOOP
		CALL SP_GET_SPECIAL_CHARACTER_SEPERATED_VALUES(',',@remaining_string,@value,@remaining_string);
		SET @C=@C+1;		
		SET @INSERT_USER_FILE_DETAILS=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.USER_FILE_DETAILS (RC_ID,FP_ID,ULD_ID,UFD_TIMESTAMP)VALUES(',MIN_RCID,',@value,(SELECT ULD_ID FROM ',DESTINATIONSCHEMA,'.TEMP_USER_FILE_DETAILS WHERE ID=',MIN_FPID,'),(SELECT TIMESTAMP FROM ',DESTINATIONSCHEMA,'.TEMP_USER_FILE_DETAILS WHERE ID=',MIN_FPID,'))'));
		PREPARE INSERTUSERFILEDETAILS FROM @INSERT_USER_FILE_DETAILS;
		EXECUTE INSERTUSERFILEDETAILS;
		SET @FP_LENGTH=@FP_LENGTH-1;
		IF @remaining_string IS NULL THEN
			LEAVE  loop_label;
		END IF;
	END loop;
	ELSE
		SET @C=@C+1;
		SET @INSERT_USER_FILE_DETAILS=(SELECT CONCAT('INSERT INTO ',DESTINATIONSCHEMA,'.USER_FILE_DETAILS (RC_ID,FP_ID,ULD_ID,UFD_TIMESTAMP)VALUES(',MIN_RCID,',@FP_ID,(SELECT ULD_ID FROM ',DESTINATIONSCHEMA,'.TEMP_USER_FILE_DETAILS WHERE ID=',MIN_FPID,'),(SELECT TIMESTAMP FROM ',DESTINATIONSCHEMA,'.TEMP_USER_FILE_DETAILS WHERE ID=',MIN_FPID,'))'));
		PREPARE INSERTUSERFILEDETAILS FROM @INSERT_USER_FILE_DETAILS;
		EXECUTE INSERTUSERFILEDETAILS;
		END IF;
		SET  MIN_FPID=MIN_FPID+1;
	END WHILE;
		SET @FINAL_COUNT=@FINAL_COUNT+@C;
		SET MIN_RCID=MIN_RCID+1;
	END WHILE;
		SET END_TIME = (SELECT CURTIME());
		SET DURATION=(SELECT TIMEDIFF(END_TIME,START_TIME));
	SET @COUNT_USER_FILE_DETAILS_SCDB_FORMAT =@FINAL_COUNT;
	SET @COUNT_SPLITING_USER_FILE_DETAILS=(SELECT CONCAT('SELECT COUNT(*) INTO @COUNT_SPLITING_USER_FILE_DETAILS FROM ',DESTINATIONSCHEMA,'.USER_FILE_DETAILS'));
	PREPARE COUNTSPLITINGUSERFILEDETAILS FROM @COUNT_SPLITING_USER_FILE_DETAILS;
	EXECUTE COUNTSPLITINGUSERFILEDETAILS;
	SET @REJECTION_COUNT=(@COUNT_USER_FILE_DETAILS_SCDB_FORMAT-@COUNT_SPLITING_USER_FILE_DETAILS);
    UPDATE PRE_AUDIT_SUB_PROFILE SET PREASP_NO_OF_REC=@COUNT_USER_FILE_DETAILS_SCDB_FORMAT WHERE PREASP_DATA='USER_FILE_DETAILS';
    SET @POSTAPIDSTMT=(SELECT CONCAT('SELECT POSTAP_ID INTO @POSTAPID FROM POST_AUDIT_PROFILE WHERE POSTAP_DATA=',"'USER_FILE_DETAILS'"));
    PREPARE POSTAPSTMT FROM @POSTAPIDSTMT;
    EXECUTE POSTAPSTMT;
    SET @PREASPSTMT=(SELECT CONCAT('SELECT PREASP_ID INTO @PREASPID FROM PRE_AUDIT_SUB_PROFILE WHERE PREASP_DATA=',"'USER_FILE_DETAILS'"));
    PREPARE PREASPIDSTMT FROM @PREASPSTMT;
    EXECUTE PREASPIDSTMT;
    SET @PREAMPSTMT=(SELECT CONCAT('SELECT PREAMP_ID INTO @PREAMPID FROM PRE_AUDIT_MAIN_PROFILE WHERE PREAMP_DATA=',"'USER RIGHTS'"));
    PREPARE PREAMPIDSTMT FROM @PREAMPSTMT;
    EXECUTE PREAMPIDSTMT;
    SET @DUR=DURATION;
	INSERT INTO POST_AUDIT_HISTORY(POSTAP_ID,POSTAH_NO_OF_REC,PREASP_ID,PREAMP_ID,POSTAH_DURATION,POSTAH_NO_OF_REJ,ULD_ID)VALUES(@POSTAPID,@COUNT_SPLITING_USER_FILE_DETAILS,@PREASPID,@PREAMPID,@DUR,@REJECTION_COUNT,@ULDID);
    SET @DROP_TMD=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TEMP_MENU_DETAILS'));
PREPARE DROP_TMD_STMT FROM @DROP_TMD;
EXECUTE DROP_TMD_STMT; 
 SET @DROP_TUFD=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TEMP_USER_FILE_DETAILS'));
PREPARE DROP_TUFD_STMT FROM @DROP_TUFD;
EXECUTE DROP_TUFD_STMT; 
SET @DROP_TSAD=(SELECT CONCAT('DROP TABLE IF EXISTS ',DESTINATIONSCHEMA,'.TEMP_SA_DETAILS'));
PREPARE DROP_TSAD_STMT FROM @DROP_TSAD;
EXECUTE DROP_TSAD_STMT;
SET FOREIGN_KEY_CHECKS=1;
END;
call SP_INSERT_USER_RIGHTS_SCDB_FORMAT('safi_source','safi_dest','expatsintegrated@gmail.com');