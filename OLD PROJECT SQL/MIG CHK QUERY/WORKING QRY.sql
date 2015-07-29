-- EXPENSE DAILY TABLE

 -- ALL VALUES ARE MATCHED WITH UNIT EXPENSE

SELECT *FROM EXPENSE_UNIT

SELECT DISTINCT EUT.EU_INVOICE_DATE,SCB.EXP_UNIT_INVOICE_DATE 
FROM  SASI_TEST_SOURCE.BIZ_DAILY_SCDB_FORMAT SCB, EXPENSE_UNIT EUT
WHERE EUT.EU_INVOICE_DATE=SCB.EXP_UNIT_INVOICE_DATE ;

SELECT DISTINCT EUT.EU_AMOUNT,SCB.EXP_UNIT_AMOUNT
FROM  SASI_TEST_SOURCE.BIZ_DAILY_SCDB_FORMAT SCB, EXPENSE_UNIT EUT
WHERE EUT.EU_AMOUNT=SCB.EXP_UNIT_AMOUNT;

SELECT DISTINCT EXP_UNIT_AMOUNT FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT WHERE EXP_UNIT_AMOUNT IS NOT NULL;

SELECT DISTINCT EXP_UNIT_INVOICE_DATE FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT WHERE EXP_UNIT_INVOICE_DATE IS NOT NULL;

-- IN THE EXPENSE ELECTRICITY DATAS FROM PERIOD DATA AND INVOICE DATA ARE SAME IN BIZ DAILY TABLE

SELECT DISTINCT EE.EE_INVOICE_DATE,BLSF.EXP_ELC_INVOICE_DATE , EE.EE_FROM_PERIOD, BLSF.EXP_ELC_FROM_PERIOD -- ,EE.EE_COMMENTS,BLSF.EXP_ELC_COMMENTS
FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT BLSF, EXPENSE_ELECTRICITY EE
WHERE EE.EE_INVOICE_DATE=BLSF.EXP_ELC_INVOICE_DATE OR EE.EE_FROM_PERIOD= BLSF.EXP_ELC_FROM_PERIOD -- OR EE.EE_COMMENTS=BLSF.EXP_ELC_COMMENTS

SELECT DISTINCT EE.EE_COMMENTS,BLSF.EXP_ELC_COMMENTS
FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT BLSF, EXPENSE_ELECTRICITY EE
WHERE  EE.EE_COMMENTS=BLSF.EXP_ELC_COMMENTS

-- ALL THE VALUES ARE MATCHED WITH BIZ DAILY AND EXPENCE DIGITAL VOICE

SELECT DISTINCT  EDV.EDV_INVOICE_DATE,BLSF.EXP_DIGITAL_INVOICE_DATE , EDV.EDV_FROM_PERIOD,BLSF.EXP_DIGITAL_FROM_PERIOD ,EDV.EDV_AMOUNT,BLSF.EXP_DIGITAL_AMOUNT
FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT BLSF, EXPENSE_DIGITAL_VOICE EDV 
WHERE EDV.EDV_INVOICE_DATE=BLSF.EXP_DIGITAL_INVOICE_DATE AND EDV.EDV_FROM_PERIOD=BLSF.EXP_DIGITAL_FROM_PERIOD OR EDV.EDV_AMOUNT=BLSF.EXP_DIGITAL_AMOUNT

-- ALL THE VALUES ARE MATCHED WITH BIZ DAILY AND EXPENSE FACULTY USE

SELECT DISTINCT  BLSF.EXP_FACILITY_INVOICE_DATE,EFU.EFU_INVOICE_DATE , BLSF.EXP_FACILITY_AMOUNT,EFU.EFU_AMOUNT , BLSF.`TIMESTAMP` , EFU.EFU_TIMESTAMP 
FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT BLSF, EXPENSE_FACILITY_USE EFU 
WHERE BLSF.EXP_FACILITY_INVOICE_DATE=EFU.EFU_INVOICE_DATE AND BLSF.EXP_FACILITY_AMOUNT=EFU.EFU_AMOUNT AND BLSF.`TIMESTAMP` = EFU.EFU_TIMESTAMP

-- ALL THE VALUES ARE MATCHED WITH BIZ DAILY AND EXPENSE CARPARK

SELECT DISTINCT ECP.ECP_INVOICE_DATE,BLSF.EXP_CAR_INVOICE_DATE , ECP.ECP_AMOUNT,BLSF.EXP_CAR_AMOUNT
FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT BLSF, EXPENSE_CARPARK ECP 
WHERE ECP.ECP_INVOICE_DATE=BLSF.EXP_CAR_INVOICE_DATE AND ECP.ECP_AMOUNT=BLSF.EXP_CAR_AMOUNT

-- RECORD MATCHED WITH EXPENSE HOUSEKEEPING WITH SOURCE TABLE BIZ DAILY

SELECT DISTINCT EHK.EHK_WORK_DATE,BLSF.EXP_HK_WORK_DATE , EHK.EHK_DURATION,BLSF.EXP_HK_DURATION  
FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT BLSF, EXPENSE_HOUSEKEEPING EHK 
WHERE EHK.EHK_WORK_DATE=BLSF.EXP_HK_WORK_DATE AND EHK.EHK_DURATION=BLSF.EXP_HK_DURATION

SELECT DISTINCT  EHK_DURATION FROM EXPENSE_HOUSEKEEPING

-- RECORDS ARE MATCHED WITH THE EXPENSE HOUSEKEEPING PAYMENT AND DAILY BIZ

SELECT DISTINCT  EHKP.EHKP_PAID_DATE,BLSF.EXP_HKP_PAID_DATE 
FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT BLSF, EXPENSE_HOUSEKEEPING_PAYMENT EHKP
WHERE EHKP.EHKP_PAID_DATE=BLSF.EXP_HKP_PAID_DATE

SELECT DISTINCT EHKP_PAID_DATE,EHKP_FOR_PERIOD FROM EXPENSE_HOUSEKEEPING_PAYMENT 

-- ALL THE RECORDS ARE MATCHED WITH THE EXENSE HOUSEKEEPING UNIT AND BIZ DAILY

SELECT DISTINCT BLSF.EXP_HKP_UNIT_NO, EHKU.EHKU_UNIT_NO , BLSF.`TIMESTAMP`,EHKU.EHKU_TIMESTAMP 
FROM EXPENSE_HOUSEKEEPING_UNIT EHKU ,SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT BLSF 
WHERE BLSF.EXP_HKP_UNIT_NO = EHKU.EHKU_UNIT_NO AND BLSF.`TIMESTAMP`=EHKU.EHKU_TIMESTAMP

-- EXPENCE PETTY CASH
-- ALL RECORDS ARE MATCHED ON BIZ DAILY AND EXPENCE PETTY CASH

SELECT DISTINCT BDS.EXP_PETTY_DATE , PC.EPC_DATE 
FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT BDS, EXPENSE_PETTY_CASH PC
WHERE BDS.EXP_PETTY_DATE = PC.EPC_DATE

-- ALL ARE MATCHED

SELECT DISTINCT BDS.EXP_PETTY_INVOICE_ITEMS , PC.EPC_INVOICE_ITEMS 
FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT BDS, EXPENSE_PETTY_CASH PC
WHERE BDS.EXP_PETTY_INVOICE_ITEMS = PC.EPC_INVOICE_ITEMS

-- ALL ARE MATCHED

SELECT DISTINCT BDS.EXP_PETTY_CURRENT_BAL  , PC.EPC_BALANCE
FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT BDS, EXPENSE_PETTY_CASH PC 
WHERE  BDS.EXP_PETTY_CURRENT_BAL = PC.EPC_BALANCE

SELECT*FROM EXPENSE_PETTY_CASH

SELECT DISTINCT BLSF.EXP_PETTY_DATE,EPC.EPC_DATE , EPC.EPC_BALANCE,BLSF.EXP_PETTY_CURRENT_BAL
FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT BLSF, EXPENSE_PETTY_CASH EPC 
WHERE BLSF.EXP_PETTY_DATE=EPC.EPC_DATE AND EPC.EPC_BALANCE=BLSF.EXP_PETTY_CURRENT_BAL

-- ALL RECORDS ARE MATCHED WITH BIZ DAILY AND EXPENSE PURCHASE NEW CARD

SELECT DISTINCT EPNC.EPNC_NUMBER,SRCC.EXP_CARD_NUMBER ,  EPNC.EPNC_AMOUNT ,SRCC.EXP_CARD_AMOUNT
FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT SRCC, EXPENSE_PURCHASE_NEW_CARD EPNC 
WHERE EPNC.EPNC_NUMBER=SRCC.EXP_CARD_NUMBER AND EPNC.EPNC_AMOUNT =SRCC.EXP_CARD_AMOUNT

-- ALL VALUES ARE MATCHED WITH BIZ DAILY AND EXPENSE MOVING IN AND OUT

SELECT DISTINCT EMIO.EMIO_AMOUNT,STC.EXP_MOVI_IN_OUT_AMOUNT, EMIO.EMIO_INVOICE_DATE,STC.EXP_MOVI_IN_OUT_INVOICE_DATE
FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT STC, EXPENSE_MOVING_IN_AND_OUT EMIO 
WHERE EMIO.EMIO_AMOUNT=STC.EXP_MOVI_IN_OUT_AMOUNT
AND EMIO.EMIO_INVOICE_DATE=STC.EXP_MOVI_IN_OUT_INVOICE_DATE

-- ALL VALUES ARE MATCHED WITH BIZ DAILY AND EXPENSE STARHUB

SELECT DISTINCT ESH.ESH_AMOUNT,STCB.EXP_SHB_AMOUNT ,ESH.ESH_INVOICE_DATE,STCB.EXP_SHB_INVOICE_DATE 
FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT STCB, EXPENSE_STARHUB ESH 
WHERE ESH.ESH_AMOUNT=STCB.EXP_SHB_AMOUNT AND ESH.ESH_INVOICE_DATE=STCB.EXP_SHB_INVOICE_DATE

SELECT DISTINCT ESH_AMOUNT, ESH_INVOICE_DATE FROM EXPENSE_STARHUB

-- ALL VALUES ARE MATCHED EXPENSE_AIRCON_SERVICE

SELECT DISTINCT BLSF.EXP_AIRCON_SERVICED_DATE , EASE.EAS_DATE 
FROM SASI_SOURCE_SCHEMA.BIZ_DAILY_SCDB_FORMAT BLSF, EXPENSE_AIRCON_SERVICE EASE 
WHERE BLSF.EXP_AIRCON_SERVPOST_MIGRATION_MODULE_HISTORYICED_DATE = EASE.EAS_DATE 

SELECT DISTINCT EAS_TIMESTAMP FROM EXPENSE_AIRCON_SERVICE
SELECT *FROM EXPENSE_AIRCON_SERVICE_BY

-- ALL VALUE MATCHED THE EXPENCE AIRCON SERVICE BY AND THE SOURCE TABLE BIZ DAILY SCDB FORMAT

SELECT DISTINCT EXP_AIRCON_SERVICED_BY FROM BIZ_DAILY_SCDB_FORMAT WHERE EXP_AIRCON_SERVICED_BY IS NOT NULL

-- ALL VALUES ARE MATCHED WITH EXPENSE AIRCON SERVICE AND BIZ DAILY 

SELECT *FROM EXPENSE_AIRCON_SERVICE

SELECT  * FROM BIZ_DAILY_SCDB_FORMAT WHERE EXP_TYPE_OF_EXPENSE ='AIRCON SERVICES'

-- UNIT

-- ALL THE VALUES ARE MATCHED IN ACCESS STAM DETAILS AND UNIT SCDB

SELECT*FROM UNIT_ACCESS_STAMP_DETAILS

SELECT DISTINCT UASD_ACCESS_CARD FROM UNIT_ACCESS_STAMP_DETAILS

SELECT DISTINCT SCU.UNIT_ACCESS_CARD,UAS.UASD_ACCESS_CARD 
FROM UNIT_ACCESS_STAMP_DETAILS UAS ,SASI_SOURCE_SCHEMA.UNIT_SCDB_FORMAT SCU 
WHERE UAS.UASD_ACCESS_CARD=SCU.UNIT_ACCESS_CARD

-- ALL THE VALUES ARE MATCHED IN UNIT ACCOUT DETAIL AND UNIT SCDB

SELECT DISTINCT UACD_ACC_NO FROM UNIT_ACCOUNT_DETAILS

SELECT DISTINCT  UAD.UACD_ACC_NO,SCU.UNIT_ACC_NO 
FROM UNIT_ACCOUNT_DETAILS UAD, SASI_SOURCE_SCHEMA.UNIT_SCDB_FORMAT SCU WHERE UAD.UACD_ACC_NO=SCU.UNIT_ACC_NO

-- ALL THE VALUES ARE MATCHED IN UNIT DETAILS AND UNIT SCDB

SELECT *FROM UNIT_DETAILS

SELECT DISTINCT UD_START_DATE FROM UNIT_DETAILS

SELECT DISTINCT UD.UD_START_DATE,UD.UD_END_DATE FROM UNIT_DETAILS UD

SELECT  DISTINCT UD.UD_START_DATE,SCU.UNIT_START_DATE , UD.UD_END_DATE,SCU.UNIT_END_DATE 
FROM UNIT_DETAILS UD , SASI_SOURCE_SCHEMA.UNIT_SCDB_FORMAT SCU
WHERE UD.UD_START_DATE=SCU.UNIT_START_DATE AND UD.UD_END_DATE=SCU.UNIT_END_DATE

-- ALL THE THREE VALUES ARE MATCHED WITH UNIT DUTY DETAILS AND UNIT SCDB

SELECT*FROM UNIT_STAMP_DUTY_TYPE

SELECT SCU.`TIMESTAMP`,USD.USDT_TIMESTAMP 
FROM SASI_SOURCE_SCHEMA.UNIT_SCDB_FORMAT SCU, UNIT_STAMP_DUTY_TYPE USD WHERE SCU.`TIMESTAMP`=USD.USDT_TIMESTAMP

-- ALL THE VALUES ARE MATCHED IN UNIT LOGIN DETAIL, UNIT SCDB

SELECT DISTINCT ULDTL_WEBPWD FROM UNIT_LOGIN_DETAILS WHERE ULDTL_WEBPWD IS NOT NULL
SELECT DISTINCT ULDTL_WEBLOGIN FROM UNIT_LOGIN_DETAILS WHERE ULDTL_WEBLOGIN IS NOT NULL

SELECT DISTINCT SCU.UNIT_WEBLOGIN, LD.ULDTL_WEBLOGIN 
FROM SASI_SOURCE_SCHEMA.UNIT_SCDB_FORMAT SCU, UNIT_LOGIN_DETAILS LD WHERE SCU.UNIT_WEBLOGIN=LD.ULDTL_WEBLOGIN

SELECT DISTINCT SCU.UNIT_WEBPWD, LD.ULDTL_WEBPWD 
FROM SASI_SOURCE_SCHEMA.UNIT_SCDB_FORMAT SCU, UNIT_LOGIN_DETAILS LD WHERE SCU.UNIT_WEBPWD=LD.ULDTL_WEBPWD

SELECT DISTINCT SCU.`TIMESTAMP`,ULD.ULDTL_TIMESTAMP
FROM SASI_SOURCE_SCHEMA.UNIT_SCDB_FORMAT SCU, UNIT_LOGIN_DETAILS ULD WHERE SCU.`TIMESTAMP`=ULD.ULDTL_TIMESTAMP

--  ALL THE VALUES ARE MATCHED WITH UNIT SCDB AND UNIT ROOM TYPE 

SELECT DISTINCT URTD_ROOM_TYPE FROM UNIT_ROOM_TYPE_DETAILS WHERE URTD_ROOM_TYPE IS NOT NULL 

SELECT DISTINCT SCU.UNIT_ROOM_TYPE , RM.URTD_ROOM_TYPE 
FROM SASI_SOURCE_SCHEMA.UNIT_SCDB_FORMAT SCU, UNIT_ROOM_TYPE_DETAILS RM WHERE SCU.UNIT_ROOM_TYPE = RM.URTD_ROOM_TYPE

-- STAFF EXPENCE

-- ALL THE VALUES ARE MATCHED IN EXPENSE_DETAIL_STAFF_SALARY AND STAFF DIALY

SELECT * FROM EXPENSE_DETAIL_STAFF_SALARY

SELECT DISTINCT EDSS.EDSS_SALARY_AMOUNT ,SFSF.SED_SALARY_AMOUNT 
FROM SASI_SOURCE_SCHEMA.STAFF_DETAIL_SCDB_FORMAT SFSF, EXPENSE_DETAIL_STAFF_SALARY EDSS 
WHERE EDSS.EDSS_SALARY_AMOUNT = SFSF.SED_SALARY_AMOUNT

-- VALUES ARE MATCHED IN EXPENSE STAFF SALARY AND STAFF DIALY

SELECT* FROM EXPENSE_STAFF_SALARY

SELECT DISTINCT ESS_SALARY_AMOUNT FROM EXPENSE_STAFF_SALARY

SELECT DISTINCT ESS.ESS_SALARY_AMOUNT,SASF.SE_SALARY_AMOUNT 
FROM SASI_SOURCE_SCHEMA.STAFF_DAILY_SCDB_FORMAT SASF , EXPENSE_STAFF_SALARY ESS
WHERE ESS.ESS_SALARY_AMOUNT=SASF.SE_SALARY_AMOUNT 

SELECT DISTINCT ESS.ESS_INVOICE_DATE , SASF.SE_STAFF_INVOICE_DATE
FROM SASI_SOURCE_SCHEMA.STAFF_DAILY_SCDB_FORMAT SASF , EXPENSE_STAFF_SALARY ESS
WHERE ESS.ESS_INVOICE_DATE = SASF.SE_STAFF_INVOICE_DATE

-- ALL THE VALUES ARE MATCHED IN EXPENCE STAFF AND STAFF DAILY SCDB

SELECT  * FROM EXPENSE_STAFF

SELECT DISTINCT ES_INVOICE_AMOUNT FROM EXPENSE_STAFF

SELECT DISTINCT   SFF.ES_INVOICE_AMOUNT,SCAI.SE_STAFF_INVOICE_AMOUNT
FROM SASI_SOURCE_SCHEMA.STAFF_DAILY_SCDB_FORMAT SCAI, EXPENSE_STAFF SFF
WHERE  SFF.ES_INVOICE_AMOUNT=SCAI.SE_STAFF_INVOICE_AMOUNT 

SELECT DISTINCT   SFF.ES_INVOICE_DATE,SCAI.SE_STAFF_INVOICE_DATE
FROM SASI_SOURCE_SCHEMA.STAFF_DAILY_SCDB_FORMAT SCAI, EXPENSE_STAFF SFF
WHERE  SFF.ES_INVOICE_DATE=SCAI.SE_STAFF_INVOICE_DATE 

-- ALL THE VALUES ARE MATCHED IN EXPENCSE STAFF AGENT AND STAFF DAILY SCDB

SELECT DISTINCT EA_COMM_AMOUNT FROM EXPENSE_AGENT 

SELECT * FROM EXPENSE_AGENT

SELECT DISTINCT SDSF.SE_AGENT_COMM_AMOUNT,EA.EA_COMM_AMOUNT 
FROM SASI_SOURCE_SCHEMA.STAFF_DAILY_SCDB_FORMAT SDSF, EXPENSE_AGENT EA 
WHERE SDSF.SE_AGENT_COMM_AMOUNT=EA.EA_COMM_AMOUNT

SELECT DISTINCT SDSF.SE_AGENT_DATE,EA.EA_DATE 
FROM SASI_SOURCE_SCHEMA.STAFF_DAILY_SCDB_FORMAT SDSF, EXPENSE_AGENT EA 
WHERE SDSF.SE_AGENT_DATE=EA.EA_DATE

-- BANK 

SELECT *FROM BANK_TRANSFER_MODELS

-- ALL ARE MATCH IN BANK MODELS.

SELECT MBTM.BTM_DATA,BTM.BTM_DATA FROM SASI_SOURCE_SCHEMA.MIG_BANK_TRANSFER_MODELS MBTM, BANK_TRANSFER_MODELS BTM WHERE MBTM.BTM_DATA=BTM.BTM_DATA

SELECT DISTINCT BTM_TIMESTAMP FROM BANK_TRANSFER_MODELS

SELECT * FROM BANK_TRANSFER_STATUS_DETAILS

SELECT DISTINCT BT_DATE FROM BANK_TRANSFER

SELECT DISTINCT MBT.BT_DATE,BT.BT_DATE FROM SASI_SOURCE_SCHEMA.MIG_BANK_TRANSFER MBT, BANK_TRANSFER BT WHERE MBT.BT_DATE=BT.BT_DATE

SELECT DISTINCT BT_AMOUNT FROM BANK_TRANSFER

-- 3(RECORDS)-> 6300,7200,764 RECORDS ARE NOT AVAILABLE AND 127 RECORD PRESENT IN DESTIONATION SOURCE HAVE 130 RECORD

SELECT DISTINCT MBT.BT_AMOUNT,BT.BT_AMOUNT FROM SASI_SOURCE_SCHEMA.MIG_BANK_TRANSFER MBT, BANK_TRANSFER BT WHERE MBT.BT_AMOUNT=BT.BT_AMOUNT

SELECT DISTINCT BT_AMOUNT FROM BANK_TRANSFER

SELECT DISTINCT  BT_DATE FROM BANK_TRANSFER

SELECT DISTINCT MBT.BT_AMOUNT , BT.BT_AMOUNT FROM SASI_SOURCE_SCHEMA.MIG_BANK_TRANSFER MBT LEFT JOIN  BANK_TRANSFER BT ON MBT.BT_AMOUNT = BT.BT_AMOUNT

-- ALL THE VALUE ARE MATCHED IN BANKTT_CONFIGURATION

SELECT *FROM BANKTT_CONFIGURATION

SELECT DISTINCT CGN_ID FROM BANKTT_CONFIGURATION

SELECT * FROM SASI_SOURCE_SCHEMA.CONFIG_SQL_FORMAT WHERE CGN_ID=56;

SELECT * FROM SASI_SOURCE_SCHEMA.CONFIG_SQL_FORMAT WHERE CGN_ID=69;

SELECT * FROM SASI_SOURCE_SCHEMA.CONFIG_SQL_FORMAT WHERE CGN_ID=70;

SELECT * FROM SASI_SOURCE_SCHEMA.CONFIG_SQL_FORMAT WHERE CGN_ID=72;

SELECT *FROM BANK_TRANSFER_STATUS_DETAILS

-- BANK TRANSFER STATUS DETAIL ARE MATCHED

SELECT DISTINCT AA.BT_ID , BT.BT_ID,BB.BT_ID,AA.BT_ID FROM BANK_TRANSFER_STATUS_DETAILS AA 
INNER JOIN BANK_TRANSFER BT ON AA.BT_ID = BT.BT_ID
INNER JOIN BANK_TRANSFER_DETAIL BB ON BB.BT_ID=AA.BT_ID 

-- CHEQUE

-- ALL THE VALUES ARE MATCHED IN CHEQUE_ENTRY_DETAILS

SELECT*FROM CHEQUE_ENTRY_DETAILS

SELECT DISTINCT CHEQUE_AMOUNT FROM CHEQUE_ENTRY_DETAILS

SELECT DISTINCT MCED.CHEQUE_AMOUNT,CED.CHEQUE_AMOUNT 
 FROM SASI_SOURCE_SCHEMA.MIG_CHEQUE_ENTRY_DETAILS MCED, CHEQUE_ENTRY_DETAILS CED 
 WHERE MCED.CHEQUE_AMOUNT=CED.CHEQUE_AMOUNT

SELECT DISTINCT MCED.CHEQUE_NO,CED.CHEQUE_NO
 FROM SASI_SOURCE_SCHEMA.MIG_CHEQUE_ENTRY_DETAILS MCED, CHEQUE_ENTRY_DETAILS CED 
 WHERE MCED.CHEQUE_NO=CED.CHEQUE_NO

SELECT DISTINCT MCED.CHEQUE_TO,CED.CHEQUE_TO
 FROM SASI_SOURCE_SCHEMA.MIG_CHEQUE_ENTRY_DETAILS MCED, CHEQUE_ENTRY_DETAILS CED 
 WHERE MCED.CHEQUE_TO=CED.CHEQUE_TO ;

SELECT DISTINCT MCED.CHEQUE_FOR,CED.CHEQUE_FOR
 FROM SASI_SOURCE_SCHEMA.MIG_CHEQUE_ENTRY_DETAILS MCED, CHEQUE_ENTRY_DETAILS CED 
 WHERE MCED.CHEQUE_FOR=CED.CHEQUE_FOR;

-- SELECT * COUNT(CHEQUE_NO) CNT FROM CHEQUE_ENTRY_DETAILS GROUP BY SOUNDEX(CHEQUE_NO) HAVING COUNT(SOUNDEX(CHEQUE_NO)) > 1;

SELECT *  
FROM CHEQUE_ENTRY_DETAILS  
GROUP BY CHEQUE_NO  
HAVING COUNT(CHEQUE_NO) >1

SELECT * FROM CHEQUE_ENTRY_DETAILS WHERE CHEQUE_NO=957526

SELECT * FROM CHEQUE_ENTRY_DETAILS WHERE CHEQUE_NO=957552

-- ALL THE VALUE ARE MATCHED
-- CHEQUE_CONFIGURATION

SELECT* FROM CHEQUE_CONFIGURATION

SELECT * FROM SASI_SOURCE_SCHEMA.CONFIG_SQL_FORMAT WHERE CGN_ID=56;

SELECT * FROM SASI_SOURCE_SCHEMA.CONFIG_SQL_FORMAT WHERE CGN_ID=69;

SELECT * FROM SASI_SOURCE_SCHEMA.CONFIG_SQL_FORMAT WHERE CGN_ID=70;

SELECT * FROM SASI_SOURCE_SCHEMA.CONFIG_SQL_FORMAT WHERE CGN_ID=72;

SELECT * FROM EMAIL_TEMPLATE_DETAILS

-- PERSONAL TABLE

-- ALL THE VALUES ARE MATCHED WITH THE SOURCE PERSONAL SCDB FORMAT AND PERSONAL EXPENC

SELECT * FROM EXPENSE_PERSONAL
SELECT DISTINCT EP.EP_INVOICE_ITEMS,PSF.PE_PERSONAL_INVOICE_ITEMS FROM SASI_SOURCE_SCHEMA.PERSONAL_SCDB_FORMAT PSF, EXPENSE_PERSONAL EP WHERE  EP.EP_INVOICE_ITEMS=PSF.PE_PERSONAL_INVOICE_ITEMS

SELECT DISTINCT EP.EP_INVOICE_DATE,PSF.PE_PERSONAL_INVOICE_DATE FROM SASI_SOURCE_SCHEMA.PERSONAL_SCDB_FORMAT PSF, EXPENSE_PERSONAL EP WHERE EP.EP_INVOICE_DATE=PSF.PE_PERSONAL_INVOICE_DATE 

SELECT DISTINCT EP.EP_AMOUNT,PSF.PE_PERSONAL_AMOUNT FROM SASI_SOURCE_SCHEMA.PERSONAL_SCDB_FORMAT PSF, EXPENSE_PERSONAL EP WHERE  EP.EP_AMOUNT=PSF.PE_PERSONAL_AMOUNT 

SELECT DISTINCT EP_AMOUNT FROM EXPENSE_PERSONAL WHERE EP_AMOUNT = 7.35

SELECT DISTINCT  EP. EP_INVOICE_FROM,PSF.PE_PERSONAL_INVOICE_FROM  FROM SASI_SOURCE_SCHEMA.PERSONAL_SCDB_FORMAT PSF LEFT JOIN EXPENSE_PERSONAL EP ON  EP. EP_INVOICE_FROM=PSF.PE_PERSONAL_INVOICE_FROM

-- BABY

-- ALL ARE MATCH

SELECT DISTINCT EB.EB_AMOUNT,PSF.PE_BABY_AMOUNT FROM SASI_SOURCE_SCHEMA.PERSONAL_SCDB_FORMAT PSF, EXPENSE_BABY EB  WHERE EB.EB_AMOUNT=PSF.PE_BABY_AMOUNT  

SELECT DISTINCT EB.EB_AMOUNT,PSF.PE_BABY_AMOUNT FROM SASI_SOURCE_SCHEMA.PERSONAL_SCDB_FORMAT PSF LEFT JOIN EXPENSE_BABY EB  ON EB.EB_AMOUNT=PSF.PE_BABY_AMOUNT  

-- ALL ARE MATCH

SELECT DISTINCT EB.EB_INVOICE_ITEMS,PSF.PE_BABY_INVOICE_ITEMS FROM SASI_SOURCE_SCHEMA.PERSONAL_SCDB_FORMAT PSF, EXPENSE_BABY EB  WHERE EB.EB_INVOICE_ITEMS=PSF.PE_BABY_INVOICE_ITEMS  

-- ALL ARE MATCHED

SELECT DISTINCT PSF.PE_BABY_INVOICE_FROM,EB.EB_INVOICE_FROM  FROM SASI_SOURCE_SCHEMA.PERSONAL_SCDB_FORMAT PSF, EXPENSE_BABY EB  WHERE PSF.PE_BABY_INVOICE_FROM=EB.EB_INVOICE_FROM 

-- ALL ARE MATCHED

SELECT DISTINCT PSF.PE_BABY_INVOICE_DATE,EB.EB_INVOICE_DATE  FROM SASI_SOURCE_SCHEMA.PERSONAL_SCDB_FORMAT PSF, EXPENSE_BABY EB  WHERE PSF.PE_BABY_INVOICE_DATE=EB.EB_INVOICE_DATE 

-- CAR 

-- ALL ARE MATCHED

SELECT DISTINCT  PSF.PE_CAR_EXP_AMOUNT ,EC.EC_AMOUNT  FROM SASI_SOURCE_SCHEMA.PERSONAL_SCDB_FORMAT PSF, EXPENSE_CAR EC  WHERE PSF.PE_CAR_EXP_AMOUNT = EC.EC_AMOUNT

-- ALL ARE MATCHED

SELECT DISTINCT  PSF.PE_CAR_EXP_INVOICE_DATE ,EC.EC_INVOICE_DATE  FROM SASI_SOURCE_SCHEMA.PERSONAL_SCDB_FORMAT PSF, EXPENSE_CAR EC  WHERE PSF.PE_CAR_EXP_INVOICE_DATE =EC.EC_INVOICE_DATE

-- ALL ARE MATCHED

SELECT DISTINCT  PSF.PE_CAR_EXP_INVOICE_ITEMS ,EC.EC_INVOICE_ITEMS  FROM SASI_SOURCE_SCHEMA.PERSONAL_SCDB_FORMAT PSF, EXPENSE_CAR EC  WHERE PSF.PE_CAR_EXP_INVOICE_ITEMS =EC.EC_INVOICE_ITEMS 

-- 1 RECORD MISSSING TAT IS COLD STORAGE

SELECT DISTINCT  PSF.PE_CAR_EXP_INVOICE_FROM ,EC.EC_INVOICE_FROM  FROM SASI_SOURCE_SCHEMA.PERSONAL_SCDB_FORMAT PSF, EXPENSE_CAR EC  WHERE PSF.PE_CAR_EXP_INVOICE_FROM =EC.EC_INVOICE_FROM 

-- OCBC
-- OCBC_CONFIGURATION
SELECT DISTINCT OSF.TIMESTAMP FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF;
SELECT DISTINCT CSF.TIMESTAMP,OCN.OCN_TIMESTAMP FROM SASI_SOURCE_SCHEMA.CONFIG_SCDB_FORMAT CSF,OCBC_CONFIGURATION OCN WHERE CSF.TIMESTAMP=OCN.OCN_TIMESTAMP;
-- OCBC_BANK_RECORDS
SELECT  OSF.ACCOUNT_NUMBER FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF;
SELECT OBR.OBR_ACCOUNT_NUMBER FROM OCBC_BANK_RECORDS OBR;
SELECT DISTINCT OSF.ACCOUNT_NUMBER,OBR.OBR_ACCOUNT_NUMBER FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF,OCBC_BANK_RECORDS OBR WHERE OSF.ACCOUNT_NUMBER=OBR.OBR_ACCOUNT_NUMBER;
SELECT DISTINCT OSF.OPENING_BALANCE FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF
SELECT DISTINCT OBR.OBR_OPENING_BALANCE FROM OCBC_BANK_RECORDS OBR;
SELECT DISTINCT OSF.OPENING_BALANCE,OBR.OBR_OPENING_BALANCE FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF,OCBC_BANK_RECORDS OBR WHERE OSF.OPENING_BALANCE=OBR.OBR_OPENING_BALANCE
SELECT DISTINCT OSF.AMOUNT FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF
SELECT DISTINCT OBR.OBR_CLOSING_BALANCE FROM OCBC_BANK_RECORDS OBR;
SELECT DISTINCT OSF.AMOUNT,OBR.OBR_CLOSING_BALANCE FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF,OCBC_BANK_RECORDS OBR WHERE OSF.AMOUNT=OBR.OBR_CLOSING_BALANCE
SELECT DISTINCT OSF.AMOUNT1 FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF
SELECT DISTINCT OBR.OBR_PREVIOUS_BALANCE FROM OCBC_BANK_RECORDS OBR;
SELECT DISTINCT OSF.AMOUNT1,OBR.OBR_PREVIOUS_BALANCE FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF,OCBC_BANK_RECORDS OBR WHERE OSF.AMOUNT1=OBR.OBR_PREVIOUS_BALANCE
SELECT DISTINCT OSF.AMOUNT2 FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF WHERE AMOUNT2!=0
SELECT DISTINCT OBR_DAY_TTL_CREDIT FROM OCBC_BANK_RECORDS OBR WHERE OBR_DAY_TTL_CREDIT!=0
SELECT DISTINCT OSF.AMOUNT2 , OBR.OBR_DAY_TTL_CREDIT FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF LEFT JOIN  OCBC_BANK_RECORDS OBR ON OSF.AMOUNT2 = OBR.OBR_DAY_TTL_CREDIT
SELECT DISTINCT OSF.AMOUNT3 FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF
SELECT DISTINCT OBR.OBR_DAY_TTL_DEBIT FROM OCBC_BANK_RECORDS OBR;
SELECT DISTINCT OSF.AMOUNT3,OBR.OBR_DAY_TTL_DEBIT FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF,OCBC_BANK_RECORDS OBR WHERE OSF.AMOUNT3=OBR.OBR_DAY_TTL_DEBIT
SELECT DISTINCT OSF.DATE FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF
SELECT DISTINCT OBR.OBR_POST_DATE FROM OCBC_BANK_RECORDS OBR;
SELECT DISTINCT OSF.DATE,OBR.OBR_POST_DATE FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF,OCBC_BANK_RECORDS OBR WHERE OSF.DATE=OBR.OBR_POST_DATE
SELECT DISTINCT OSF.DATE2 FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF
SELECT DISTINCT OBR.OBR_TRANS_DATE FROM OCBC_BANK_RECORDS OBR;
SELECT DISTINCT OSF.DATE2,OBR.OBR_TRANS_DATE FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF,OCBC_BANK_RECORDS OBR WHERE OSF.DATE2=OBR.OBR_TRANS_DATE
SELECT DISTINCT OSF.DATE3 FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF
SELECT DISTINCT OBR.OBR_VALUE_DATE FROM OCBC_BANK_RECORDS OBR;
SELECT DISTINCT OSF.DATE3,OBR.OBR_VALUE_DATE FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF,OCBC_BANK_RECORDS OBR WHERE OSF.DATE3=OBR.OBR_VALUE_DATE
SELECT DISTINCT OSF.DEBITS FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF
SELECT DISTINCT OBR.OBR_NET_DAY_BALANCE FROM OCBC_BANK_RECORDS OBR;
SELECT DISTINCT OSF.DEBITS,OBR.OBR_NET_DAY_BALANCE FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF,OCBC_BANK_RECORDS OBR WHERE OSF.DEBITS=OBR.OBR_NET_DAY_BALANCE
SELECT DISTINCT OSF.DATA FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF
SELECT DISTINCT OBR.OBR_TRX_CODE FROM OCBC_BANK_RECORDS OBR;
SELECT DISTINCT OSF.DATA,OBR.OBR_TRX_CODE FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF,OCBC_BANK_RECORDS OBR WHERE OSF.DATA=OBR.OBR_TRX_CODE
SELECT DISTINCT OSF.TRANSACTION_DESC_DETAILS FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF
SELECT DISTINCT OBR.OBR_TRANSACTION_DESC_DETAILS FROM OCBC_BANK_RECORDS OBR;
SELECT DISTINCT OSF.TRANSACTION_DESC_DETAILS,OBR_TRANSACTION_DESC_DETAILS FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF,OCBC_BANK_RECORDS OBR WHERE OSF.TRANSACTION_DESC_DETAILS=OBR_TRANSACTION_DESC_DETAILS
SELECT DISTINCT OSF.TIMESTAMP FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF
SELECT DISTINCT OBR.OBR_TIMESTAMP FROM OCBC_BANK_RECORDS OBR;
SELECT DISTINCT OSF.TIMESTAMP,OBR.OBR_TIMESTAMP FROM SASI_SOURCE_SCHEMA.OCBC_SCDB_FORMAT OSF,OCBC_BANK_RECORDS OBR WHERE OSF.TIMESTAMP=OBR.OBR_TIMESTAMP

-- ERM
-- ERM ENTRY DETAILS
SELECT DISTINCT MERM.ERM_SNO FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM;
SELECT DISTINCT MERM.ERM_SNO,ERM.ERM_ID FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM,ERM_ENTRY_DETAILS ERM WHERE MERM.ERM_SNO=ERM.ERM_ID
SELECT DISTINCT  MERM.ERM_CUST_NAME FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM;
SELECT DISTINCT MERM.ERM_CUST_NAME,ERM.ERM_CUST_NAME FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM,ERM_ENTRY_DETAILS ERM WHERE MERM.ERM_CUST_NAME=ERM.ERM_CUST_NAME
SELECT DISTINCT  MERM.ERM_RENT FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM;
SELECT DISTINCT ERM.ERM_RENT FROM ERM_ENTRY_DETAILS ERM;
SELECT DISTINCT MERM.ERM_RENT,ERM.ERM_RENT FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM,ERM_ENTRY_DETAILS ERM WHERE MERM.ERM_RENT=ERM.ERM_RENT
SELECT DISTINCT  MERM.ERM_MOVING_DATE FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM;
SELECT DISTINCT ERM.ERM_MOVING_DATE FROM ERM_ENTRY_DETAILS ERM;
SELECT DISTINCT MERM.ERM_MOVING_DATE,ERM.ERM_MOVING_DATE FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM,ERM_ENTRY_DETAILS ERM WHERE MERM.ERM_MOVING_DATE=ERM.ERM_MOVING_DATE
SELECT DISTINCT  MERM.ERM_MIN_STAY FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM;
SELECT DISTINCT ERM.ERM_MIN_STAY FROM ERM_ENTRY_DETAILS ERM;
SELECT DISTINCT MERM.ERM_MIN_STAY,ERM.ERM_MIN_STAY FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM,ERM_ENTRY_DETAILS ERM WHERE MERM.ERM_MIN_STAY=ERM.ERM_MIN_STAY
SELECT DISTINCT  MERM.ERMO_ID FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM;
SELECT DISTINCT ERM.ERMO_ID FROM ERM_ENTRY_DETAILS ERM;
SELECT DISTINCT MERM.ERMO_ID,ERM.ERMO_ID FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM,ERM_ENTRY_DETAILS ERM WHERE MERM.ERMO_ID=ERM.ERMO_ID
select distinct  MERM.ERMO_ID,ERM.ERMO_ID from SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM left join  ERM_ENTRY_DETAILS ERM on  MERM.ERMO_ID=ERM.ERMO_ID
SELECT DISTINCT  MERM.NC_SNO FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM;
SELECT DISTINCT ERM.NC_ID FROM ERM_ENTRY_DETAILS ERM;
SELECT DISTINCT MERM.NC_SNO,ERM.NC_ID FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM,ERM_ENTRY_DETAILS ERM WHERE MERM.NC_SNO=ERM.NC_ID
SELECT DISTINCT MERM.ERM_NO_OF_GUESTS FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM;
SELECT DISTINCT ERM.ERM_NO_OF_GUESTS FROM ERM_ENTRY_DETAILS ERM;
SELECT DISTINCT MERM.ERM_NO_OF_GUESTS,ERM.ERM_NO_OF_GUESTS FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM,ERM_ENTRY_DETAILS ERM WHERE MERM.ERM_NO_OF_GUESTS=ERM.ERM_NO_OF_GUESTS
SELECT DISTINCT MERM.ERM_AGE FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM;
SELECT DISTINCT ERM.ERM_AGE FROM ERM_ENTRY_DETAILS ERM;
SELECT DISTINCT MERM.ERM_AGE,ERM.ERM_AGE FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM,ERM_ENTRY_DETAILS ERM WHERE MERM.ERM_AGE=ERM.ERM_AGE
SELECT DISTINCT MERM.ERM_CONTACT_NO FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM;
SELECT DISTINCT ERM.ERM_CONTACT_NO FROM ERM_ENTRY_DETAILS ERM;
SELECT DISTINCT MERM.ERM_CONTACT_NO,ERM.ERM_CONTACT_NO FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM,ERM_ENTRY_DETAILS ERM WHERE MERM.ERM_CONTACT_NO=ERM.ERM_CONTACT_NO
SELECT DISTINCT MERM.ERM_EMAIL_ID FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM;
SELECT DISTINCT ERM.ERM_EMAIL_ID FROM ERM_ENTRY_DETAILS ERM;
SELECT DISTINCT MERM.ERM_EMAIL_ID,ERM.ERM_EMAIL_ID FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM,ERM_ENTRY_DETAILS ERM WHERE MERM.ERM_EMAIL_ID=ERM.ERM_EMAIL_ID
SELECT DISTINCT MERM.ERM_COMMENTS FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM;
SELECT DISTINCT ERM.ERM_COMMENTS FROM ERM_ENTRY_DETAILS ERM;
SELECT DISTINCT MERM.ERM_COMMENTS,ERM.ERM_COMMENTS FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM,ERM_ENTRY_DETAILS ERM WHERE MERM.ERM_COMMENTS=ERM.ERM_COMMENTS
SELECT DISTINCT MERM.ERM_CUST_NAME,MERM.ERM_TIMESTAMP FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM;
SELECT DISTINCT ERM.ERM_CUST_NAME,ERM.ERM_TIMESTAMP FROM ERM_ENTRY_DETAILS ERM;
SELECT DISTINCT MERM.ERM_CUST_NAME,MERM.ERM_CUST_NAME, MERM.ERM_TIMESTAMP,ERM.ERM_TIMESTAMP FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM,ERM_ENTRY_DETAILS ERM WHERE MERM.ERM_TIMESTAMP=ERM.ERM_TIMESTAMP AND MERM.ERM_CUST_NAME=ERM.ERM_CUST_NAME;
SELECT DISTINCT ERM.ULD_ID FROM ERM_ENTRY_DETAILS ERM;
SELECT DISTINCT MERM.ERM_USERSTAMP FROM SASI_SOURCE_SCHEMA.MIG_ERM_ENTRY_DETAILS MERM;
-- ERM OCCUPATION DETAILS
SELECT DISTINCT ERMO_ID FROM SASI_SOURCE_SCHEMA.MIG_ERM_OCCUPATION_DETAILS;
SELECT DISTINCT ERMO_ID FROM ERM_OCCUPATION_DETAILS;
select distinct MERM.ERMO_ID , ERM.ERMO_ID from ERM_OCCUPATION_DETAILS ERM left join sasi_source_schema.mig_ERM_OCCUPATION_DETAILS MERM  on  ERM.ERMO_ID = MERM.ERMO_ID 
SELECT DISTINCT MEOD.ERMO_ID,EOD.ERMO_ID FROM SASI_SOURCE_SCHEMA.MIG_ERM_OCCUPATION_DETAILS MEOD,ERM_OCCUPATION_DETAILS EOD WHERE MEOD.ERMO_ID=EOD.ERMO_ID
SELECT DISTINCT ERMO_DATA FROM SASI_SOURCE_SCHEMA.MIG_ERM_OCCUPATION_DETAILS;
SELECT DISTINCT ERMO_DATA FROM ERM_OCCUPATION_DETAILS;
SELECT DISTINCT MEOD.ERMO_DATA,EOD.ERMO_DATA FROM SASI_SOURCE_SCHEMA.MIG_ERM_OCCUPATION_DETAILS MEOD,ERM_OCCUPATION_DETAILS EOD WHERE MEOD.ERMO_DATA=EOD.ERMO_DATA
SELECT EOD.ULD_ID FROM ERM_OCCUPATION_DETAILS EOD;
SELECT MEOD.ERMO_USERSTAMP FROM SASI_SOURCE_SCHEMA.MIG_ERM_OCCUPATION_DETAILS MEOD;
SELECT DISTINCT EOD.ERMO_TIMESTAMP FROM ERM_OCCUPATION_DETAILS EOD;
SELECT DISTINCT MEOD.ERMO_TIMESTAMP FROM SASI_SOURCE_SCHEMA.MIG_ERM_OCCUPATION_DETAILS MEOD;

-- ERM CONFIGURATION
SELECT * FROM ERM_CONFIGURATION;
SELECT * FROM SASI_SOURCE_SCHEMA.CONFIG_SQL_FORMAT WHERE CGN_ID=55
select ec.ULD_ID, uld.ULD_USERSTAMP from erm_configuration ec inner join user_login_details uld on ec.ULD_ID = uld.ULD_ID
SELECT DISTINCT EC.CGN_ID,EC.ERMCN_DATA,EC.ERMCN_INITIALIZE_FLAG,EC.ULD_ID,EC.ERMCN_TIMESTAMP FROM ERM_CONFIGURATION EC INNER JOIN SASI_SOURCE_SCHEMA.CONFIG_SQL_FORMAT  CSF ON CSF. CGN_ID=EC.CGN_ID

SELECT DISTINCT CSF.CC_CUST_ID,CSF.CC_REC_VER,CSF.CC_STARTDATE,CSF.CC_ENDDATE,CSF.CC_GUEST_CARD_NO,CTD.CUSTOMER_ID,CTD.CED_REC_VER,CTD.CLP_STARTDATE,CTD.CLP_ENDDATE,CTD.CLP_GUEST_CARD FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF,CUSTOMER_LP_DETAILS CTD WHERE CTD.CUSTOMER_ID =1 AND CSF.CC_CUST_ID=1
SELECT DISTINCT CSF.CC_CUST_ID,CSF.CC_REC_VER,CSF.CC_STARTDATE,CSF.CC_ENDDATE,CSF.CC_GUEST_CARD_NO,CTD.CUSTOMER_ID,CTD.CED_REC_VER,CTD.CLP_STARTDATE,CTD.CLP_ENDDATE,CTD.CLP_GUEST_CARD FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF,CUSTOMER_LP_DETAILS CTD WHERE CTD.CUSTOMER_ID = CSF.CC_CUST_ID

-- CUSTOMER
SELECT * FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT;
-- CUSTOMER_ACCESS_CARD_DETAILS
SELECT * FROM CUSTOMER_ACCESS_CARD_DETAILS;
SELECT DISTINCT CSF.CC_CUST_ID,CACD.CUSTOMER_ID , CSF.TIMESTAMP,CACD.CACD_TIMESTAMP FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF,CUSTOMER_ACCESS_CARD_DETAILS CACD WHERE CSF.CC_CUST_ID=CACD.CUSTOMER_ID AND CSF.TIMESTAMP=CACD.CACD_TIMESTAMP;
SELECT DISTINCT AC_CARD FROM SASI_SOURCE_SCHEMA.ACCESS_SCDB_FORMAT;
SELECT DISTINCT CSF.CC_CUST_ID FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF;
SELECT DISTINCT CACD.CUSTOMER_ID FROM CUSTOMER_ACCESS_CARD_DETAILS CACD;
SELECT DISTINCT CUSTOMER_ID FROM CUSTOMER;
SELECT DISTINCT CSF.CC_CUST_ID,CACD.CUSTOMER_ID FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF,CUSTOMER_ACCESS_CARD_DETAILS CACD WHERE CSF.CC_CUST_ID=CACD.CUSTOMER_ID;
SELECT DISTINCT CSF.TIMESTAMP FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF;
SELECT DISTINCT CACD.CACD_TIMESTAMP FROM CUSTOMER_ACCESS_CARD_DETAILS CACD;
SELECT DISTINCT ASF.TIMESTAMP,CACD.CACD_TIMESTAMP FROM SASI_SOURCE_SCHEMA.ACCESS_SCDB_FORMAT ASF,CUSTOMER_ACCESS_CARD_DETAILS CACD WHERE ASF.TIMESTAMP=CACD.CACD_TIMESTAMP;
SELECT DISTINCT CSF.TIMESTAMP,CACD.CACD_TIMESTAMP FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF,CUSTOMER_ACCESS_CARD_DETAILS CACD WHERE  CSF.TIMESTAMP!=CACD.CACD_TIMESTAMP;
SELECT * FROM SASI_SOURCE_SCHEMA.ACCESS_SCDB_FORMAT;
SELECT * FROM CUSTOMER_ACCESS_CARD_DETAILS;
SELECT * FROM CUSTOMER;
SELECT DISTINCT AC_FIRST_NAME FROM SASI_SOURCE_SCHEMA.ACCESS_SCDB_FORMAT;
SELECT DISTINCT CUSTOMER_FIRST_NAME FROM CUSTOMER;
SELECT DISTINCT C.CUSTOMER_ID,CACD.CUSTOMER_ID FROM CUSTOMER C,CUSTOMER_ACCESS_CARD_DETAILS CACD WHERE C.CUSTOMER_ID=CACD.CUSTOMER_ID
SELECT AC_VALID_TILL FROM SASI_SOURCE_SCHEMA.ACCESS_SCDB_FORMAT WHERE AC_VALID_TILL IS NOT NULL;
SELECT CACD_VALID_TILL FROM CUSTOMER_ACCESS_CARD_DETAILS WHERE CACD_VALID_TILL IS NOT NULL;
SELECT DISTINCT ASF.AC_VALID_TILL,CACD.CACD_VALID_TILL FROM SASI_SOURCE_SCHEMA.ACCESS_SCDB_FORMAT ASF,CUSTOMER_ACCESS_CARD_DETAILS CACD WHERE ASF.AC_VALID_TILL=CACD.CACD_VALID_TILL

-- CUSTOMER_COMPANY_DETAILS
SELECT DISTINCT CSF.CC_CUST_ID FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF WHERE CSF.CC_COMPANY_NAME IS NOT NULL;
SELECT DISTINCT CCD.CUSTOMER_ID FROM CUSTOMER_COMPANY_DETAILS CCD WHERE CCD.CCD_COMPANY_NAME IS NOT NULL;
SELECT DISTINCT  CSF.CC_COMPANY_NAME FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF;
SELECT DISTINCT CCD.CCD_COMPANY_NAME  FROM CUSTOMER_COMPANY_DETAILS CCD;
SELECT DISTINCT CSF.CC_COMPANY_NAME,CCD.CCD_COMPANY_NAME FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF,CUSTOMER_COMPANY_DETAILS CCD WHERE CSF.CC_COMPANY_NAME=CCD.CCD_COMPANY_NAME
SELECT DISTINCT CSF.CC_COMPANY_ADDR FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF
SELECT DISTINCT CCD.CCD_COMPANY_ADDR FROM CUSTOMER_COMPANY_DETAILS CCD
SELECT DISTINCT CSF.CC_COMPANY_ADDR,CCD.CCD_COMPANY_ADDR FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF,CUSTOMER_COMPANY_DETAILS CCD WHERE CSF.CC_COMPANY_ADDR=CCD.CCD_COMPANY_ADDR;

-- CUSTOMER_ENTRY_DETAILS
SELECT DISTINCT CSF.CC_REC_VER FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF;
SELECT DISTINCT CED.CED_REC_VER FROM CUSTOMER_ENTRY_DETAILS CED;
SELECT DISTINCT CSF.CC_REC_VER,CED.CED_REC_VER FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF,CUSTOMER_ENTRY_DETAILS CED WHERE CSF.CC_REC_VER=CED.CED_REC_VER
SELECT  CSF.CC_PRETERMINATE FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF WHERE CSF.CC_PRETERMINATE IS NOT NULL
SELECT CED.CED_PRETERMINATE FROM CUSTOMER_ENTRY_DETAILS CED WHERE CED.CED_PRETERMINATE IS NOT NULL
SELECT  CSF.CC_PRETERMINATE,CED.CED_PRETERMINATE FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF,CUSTOMER_ENTRY_DETAILS CED WHERE CSF.CC_PRETERMINATE=CED.CED_PRETERMINATE

-- CUSTOMER_FEE_DETAILS
SELECT DISTINCT CSF.CC_REC_VER FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF
SELECT DISTINCT CFD.CED_REC_VER FROM CUSTOMER_FEE_DETAILS CFD ;
SELECT DISTINCT CSF.CC_REC_VER, CFD.CED_REC_VER FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF,CUSTOMER_FEE_DETAILS CFD WHERE  CSF.CC_REC_VER= CFD.CED_REC_VER

-- CUSTOMER PAYMENT PROFILE
SELECT DISTINCT CPP.CPP_TIMESTAMP FROM CUSTOMER_PAYMENT_PROFILE CPP;
SELECT DISTINCT CSF.TIMESTAMP FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF
SELECT DISTINCT CSF.TIMESTAMP,CPP.CPP_TIMESTAMP FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF,CUSTOMER_PAYMENT_PROFILE CPP WHERE CSF.TIMESTAMP=CPP.CPP_TIMESTAMP

-- CUSTOMER_PERSONAL_DETAILS
SELECT DISTINCT CSF.CC_CUST_ID,CSF.CC_EMAIL  FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF WHERE CSF.CC_EMAIL IS NOT NULL;
SELECT DISTINCT CPD.CUSTOMER_ID,CPD.CPD_EMAIL FROM CUSTOMER_PERSONAL_DETAILS CPD

-- CUSTOMER _TERMINATION_DETAILS
SELECT DISTINCT CLP_ENDDATE FROM CUSTOMER_LP_DETAILS;
SELECT DISTINCT CLP_STARTDATE FROM CUSTOMER_LP_DETAILS;
SELECT DISTINCT CTD.CLP_ENDDATE,CSF.CC_ENDDATE FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF,CUSTOMER_LP_DETAILS CTD WHERE CSF.CC_ENDDATE=CTD.CLP_ENDDATE;
SELECT DISTINCT CUSTOMER_ID,CLP_STARTDATE,CLP_ENDDATE FROM CUSTOMER_LP_DETAILS WHERE CLP_STARTDATE=CLP_ENDDATE;
SELECT DISTINCT CSF.CC_STARTDATE FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF;
SELECT DISTINCT CSF.CC_ENDDATE FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF;

-- CUSTOMER_CONFIGURATION
SELECT DISTINCT CCN_TIMESTAMP FROM CUSTOMER_CONFIGURATION;
SELECT DISTINCT CSF.TIMESTAMP FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF;
SELECT DISTINCT CCN.CCN_TIMESTAMP,CSF.TIMESTAMP FROM SASI_SOURCE_SCHEMA.CUSTOMER_SCDB_FORMAT CSF,CUSTOMER_CONFIGURATION CCN WHERE CCN.CCN_TIMESTAMP=CSF.TIMESTAMP


-- PAYMENT 
SELECT * FROM PAYMENT_PROFILE
SELECT * FROM CUSTOMER
SELECT * FROM PAYMENT_DETAILS

SELECT * FROM SASI_SOURCE_SCHEMA.RENTAL_SCDB_FORMAT;
-- PAYMENT CONFIGURATION
SELECT RSF.TIMESTAMP,PCN.PCN_TIMESTAMP FROM SASI_SOURCE_SCHEMA.RENTAL_SCDB_FORMAT RSF,PAYMENT_CONFIGURATION PCN WHERE RSF.TIMESTAMP=PCN.PCN_TIMESTAMP;
-- PAYMENT_DETAILS
SELECT DISTINCT CED_REC_VER FROM PAYMENT_DETAILS
SELECT DISTINCT CTD.CED_REC_VER,PD.CED_REC_VER FROM CUSTOMER_LP_DETAILS CTD, PAYMENT_DETAILS PD WHERE CTD.CED_REC_VER=PD.CED_REC_VER
SELECT DISTINCT PD.PD_TIMESTAMP FROM PAYMENT_DETAILS PD;
SELECT DISTINCT RSF.TIMESTAMP FROM SASI_SOURCE_SCHEMA.RENTAL_SCDB_FORMAT RSF;
SELECT DISTINCT PD.PD_TIMESTAMP,RSF.TIMESTAMP FROM PAYMENT_DETAILS PD,SASI_SOURCE_SCHEMA.RENTAL_SCDB_FORMAT RSF WHERE PD.PD_TIMESTAMP=RSF.TIMESTAMP
SELECT DISTINCT PD.PD_AMOUNT FROM PAYMENT_DETAILS PD;
SELECT DISTINCT RSF.RENTAL_AMOUNT FROM SASI_SOURCE_SCHEMA.RENTAL_SCDB_FORMAT RSF WHERE RSF.RENTAL_AMOUNT IS NOT NULL;
SELECT DISTINCT PD.PD_AMOUNT,RSF.RENTAL_AMOUNT FROM SASI_SOURCE_SCHEMA.RENTAL_SCDB_FORMAT RSF,PAYMENT_DETAILS PD WHERE PD.PD_AMOUNT=RSF.RENTAL_AMOUNT
SELECT DISTINCT RSF.RENTAL_PAID_DATE FROM SASI_SOURCE_SCHEMA.RENTAL_SCDB_FORMAT RSF
SELECT DISTINCT PD.PD_PAID_DATE FROM PAYMENT_DETAILS PD
SELECT DISTINCT RSF.RENTAL_PAID_DATE,PD.PD_PAID_DATE FROM SASI_SOURCE_SCHEMA.RENTAL_SCDB_FORMAT RSF,PAYMENT_DETAILS PD WHERE  RSF.RENTAL_PAID_DATE=PD.PD_PAID_DATE







