<?php
require_once('mpdf571/mpdf571/mpdf.php');
include "CONNECTION.php";
include "GET_USERSTAMP.php";
$USERSTAMP=$UserStamp;
//FLAG VALUE
$flag= $_GET['flag'];
$inputValOne=$_GET['inputValOne'];
$inputValTwo=$_GET['inputValTwo'];
$inputValThree=$_GET['inputValThree'];
$inputValFour=$_GET['inputValFour'];
$inputValFive=$_GET['inputValFive'];
$REV_startdate="null";
$REV_enddate="null";
$REP_BND_loginid="null";
//$flag=24;
//$_GET['title']='test';
$arrcall=array(3=>"CALL SP_TS_USER_ADMIN_REPORT_DETAILS_TICKLER_DATA((select ULD_ID from VW_TS_ALL_EMPLOYEE_DETAILS where EMPLOYEE_NAME='$inputValOne'),'$USERSTAMP',@TEMP_TABLE)",
    5=>"CALL SP_REVENUE_BY_PROJECT_NAME('1','$inputValOne','$inputValTwo',$REV_startdate,$REV_enddate,'$USERSTAMP',@TEMP_TABLE,@NO_OF_DAYS_WORKED,@NO_OF_HOURS)",
    6=>"CALL SP_PROJECT_REVENUE_BY_EMPLOYEE('1','$inputValOne','$inputValTwo','$inputValThree',$REV_startdate,$REV_enddate,'$USERSTAMP',@TEMP_TABLE,@NO_OF_DAYS_WORKED,@T_DAYS,@T_HRS,@T_MIN)",
    7=>"CALL SP_ALL_PROJECT_REVENUE_BY_EMPLOYEE('1','$inputValOne',$REV_startdate,$REV_enddate,'$USERSTAMP',@TEMP_TABLE)",
    8=>"CALL SP_PROJECT_REVENUE_BY_EMPLOYEE('2','$inputValOne','$inputValTwo','$inputValThree','$inputValFour','$inputValFive','$USERSTAMP',@TEMP_TABLE,@NO_OF_DAYS_WORKED,@T_DAYS,@T_HRS,@T_MIN)",
    9=>"CALL SP_ALL_PROJECT_REVENUE_BY_EMPLOYEE('2','$inputValOne','$inputValFour','$inputValFive','$USERSTAMP',@TEMP_TABLE)",
    10=>"CALL SP_REVENUE_BY_PROJECT_NAME('2','$inputValOne','$inputValTwo','$inputValThree','$inputValFour','$USERSTAMP',@TEMP_TABLE,@NO_OF_DAYS_WORKED,@NO_OF_HOURS)",
    11=>"CALL SP_TS_ATTENDANCE_CALCULATION ('$inputValOne','$inputValTwo','$USERSTAMP',@TEMP_TABLE,@TOTAL_DAYS,@WORKING_DAYS)",
    12=>"CALL SP_TS_ATTENDANCE_CALCULATION ('$inputValOne','','$USERSTAMP',@TEMP_TABLE,@TOTAL_DAYS,@WORKING_DAYS)",
    13=>"CALL SP_TS_REPORT_COUNT_ABSENT_FLAG('$inputValOne','$USERSTAMP',@TEMP_TABLE)",
    14=>"CALL SP_TS_REPORT_BANDWIDTH_CALCULATION('$inputValOne',$REP_BND_loginid,'$USERSTAMP',@TEMP_TABLE)",
    15=>"CALL SP_TS_REPORT_BANDWIDTH_CALCULATION('$inputValOne','$inputValTwo','$USERSTAMP',@TEMP_TABLE)");
//APPEND TABLE HEADER
$arrHeader=array(1=>array('EMPLOYEE NAME','ROLE','REC VER','REASON OF TERMINATION','JOIN DATE','TERMINATION DATE','EMP TYPE','USERSTAMP','TIMESTAMP'),
    3=>array('HISTORY','USERSTAMP','TIMESTAMP'),
    4=>array('EMPLOYEE NAME','DOOR ACCESS'),
    5=>array('EMPLOYEE NAME','NUMBER OF DAYS','NUMBER OF HRS','NUMBER OF MINUTES'),
    6=>array('PROJECT DATE','DAYS','HOURS','MINUTES'),
    7=>array('PROJECT NAME','DAYS','HOURS','MINUTES'),8=>array('PROJECT DATE','DAYS','HOURS','MINUTES'),9=>array('PROJECT NAME','DAYS','HOURS','MINUTES'),10=>array('EMPLOYEE NAME','NUMBER OF DAYS','NUMBER OF HRS','NUMBER OF MINUTES'),
    11=>array('DATE','PRESENT','ABSENT','ONDUTY','PERMISSION HOUR(S)'),12=>array('EMPLOYEE NAME','NO OF PRESENT','NO OF ABSENT','NO OF ONDUTY','TOTAL HOUR(S) OF PERMISSION'),
    13=>array('EMPLOYEE NAME','REPORT ENTRY MISSED'),14=>array('EMPLOYEE NAME','BANDWIDTH'),15=>array('REPORT DATE','BANDWIDTH'),16=>array('DATE','DESCRIPTION','USERSTAMP','TIMESTAMP'),
    17=>array('PROJECT NAME','PROJECT DESCRIPTION','REC VER','STATUS','START DATE','END DATE','USERSTAMP','TIMESTAMP'),
    18=>array('DATE','REPORT','TIMESTAMP'),19=>array('WEEK','WEEKLY REPORT','USERSTAMP','TIMESTAMP'),
    20=>array('DATE','DESCRIPTION','USERSTAMP','TIMESTAMP'),21=>array('EMPLOYEE NAME','REPORT','USERSTAMP','TIMESTAMP'),
    22=>array('DATE','REPORT','USERSTAMP','TIMESTAMP'),23=>array('EMPLOYEE NAME','CLOCK IN','CLOCK IN LOCATION','CLOCK OUT','CLOCK OUT LOCATION'),24=>array('DATE','CLOCK IN','CLOCK IN LOCATION','CLOCK OUT','CLOCK OUT LOCATION'));
//TABLE HEADER WIDTH
$arrHeaderWidth=array(1=>array(20,20,20,150,20,20,20,20,20),
    3=>array(400,180,180),
    4=>array(300,100),
    5=>array(200,60,60,60),
    6=>array(100,60,60,60),7=>array(100,60,60,60),8=>array(100,60,60,60),9=>array(100,60,60,60),9=>array(100,60,60,60),10=>array(100,60,60,60)
,11=>array(100,100,100,100,100),12=>array(200,100,100,100,100),13=>array(200,60),14=>array(200,60),15=>array(200,60),16=>array(60,160,160,160),
    17=>array(180,200,60,80,80,80,180,130),18=>array(80,300,180),19=>array(100,200,180,180),20=>array(80,300,180,180),21=>array(180,300,280,180),22=>array(80,300,180,180),
    23=>array(200,100,200,100,200),24=>array(80,100,200,100,200));
//TABLE WIDTH
$arrTableWidth=array(1=>1500,3=>1800,4=>600,5=>700,6=>700,7=>700,8=>700,9=>700,9=>700,10=>700,11=>800,12=>800,13=>700,14=>700,15=>700,16=>1000,17=>1400,18=>1200,19=>800,20=>800,21=>1500,22=>1500,23=>1500,24=>1500);
//script to execute call query
if(($flag==3)||($flag==5)||($flag==6)||($flag==7)||($flag==8)||($flag==9)||($flag==10)||($flag==11)||($flag==12)||($flag==13)||($flag==14)||($flag==15)){
    $result = $con->query($arrcall[$flag]);
    if(!$result) die("CALL failed: (" . $con->errno . ") " . $con->error);
    $select = $con->query("SELECT @TEMP_TABLE");
    $result = $select->fetch_assoc();
    $temp_table= $result['@TEMP_TABLE'];
}
//DATE FORMAT CONVERTION
if($flag==19){
    $inputValOne = $con->real_escape_string($inputValOne);
    $inputValOne = date("Y-m-d",strtotime($inputValOne));
    $inputValTwo = $con->real_escape_string($inputValTwo);
    $inputValTwo = date("Y-m-d",strtotime($inputValTwo));
}
//APPEND QUERY
$arrQuery=array( 1=>"SELECT AE.EMPLOYEE_NAME,RC.RC_NAME,UA.UA_REC_VER,UA.UA_REASON,DATE_FORMAT(UA.UA_JOIN_DATE,'%d-%m-%Y') AS UA_JOIN_DATE,DATE_FORMAT(UA.UA_END_DATE,'%d-%m-%Y') AS UA_END_DATE,URC1.URC_DATA,UA.UA_USERSTAMP,DATE_FORMAT(UA.UA_TIMESTAMP , '%d-%m-%Y %h:%m:%s') AS UA_TIMESTAMP FROM USER_LOGIN_DETAILS ULD,ROLE_CREATION RC,USER_ACCESS UA,USER_RIGHTS_CONFIGURATION URC,USER_RIGHTS_CONFIGURATION URC1,VW_TS_ALL_EMPLOYEE_DETAILS AE WHERE UA.UA_EMP_TYPE=URC1.URC_ID AND URC.URC_ID=RC.URC_ID AND ULD.ULD_ID=UA.ULD_ID AND UA.RC_ID=RC.RC_ID AND ULD.ULD_ID=AE.ULD_ID ORDER BY EMPLOYEE_NAME",
    2=>"SELECT DATE_FORMAT(ETD.ETD_TIMESTAMP, '%d-%m-%Y %h:%m:%s') AS TIMESTAMP,ETD.ETD_EMAIL_SUBJECT,ETD.ETD_EMAIL_BODY,ULD.ULD_LOGINID,ETD.ETD_ID FROM EMAIL_TEMPLATE_DETAILS ETD,USER_LOGIN_DETAILS ULD WHERE ETD.ULD_ID=ULD.ULD_ID AND ETD.ET_ID=$inputValOne",
    3=>"SELECT EVENT_TYPE,TABLE_NAME,TH_OLD_VALUE,TH_NEW_VALUE,TH_USERSTAMP,DATE_FORMAT(TH_TIMESTAMP, '%d-%m-%Y %h:%m:%s') AS T_TIMESTAMP FROM $temp_table WHERE  TABLE_NAME='USER_ADMIN_REPORT_DETAILS'  ORDER BY TH_TIMESTAMP DESC ",
    4=>"SELECT VW.EMPLOYEE_NAME,CPD.CPD_DOOR_ACCESS from VW_TS_ALL_ACTIVE_EMPLOYEE_DETAILS VW,COMPANY_PROPERTIES_DETAILS CPD,EMPLOYEE_DETAILS ED,USER_LOGIN_DETAILS ULD WHERE ED.ULD_ID=ULD.ULD_ID AND CPD.EMP_ID=ED.EMP_ID AND ULD.ULD_LOGINID=VW.ULD_LOGINID order by VW.EMPLOYEE_NAME",
    5=>"SELECT USER_NAME,TOTAL_DAYS,TOTAL_HRS,TOTAL_MINUTES FROM $temp_table",
    6=>"SELECT DATE_FORMAT(PROJECT_DATE,'%d-%m-%Y') AS PROJECT_DATE,DAYS,HRS,MINUTES from $temp_table",
    7=>"SELECT PROJECT_NAME,DAYS,HRS,MINUTES from $temp_table",
    8=>"SELECT DATE_FORMAT(PROJECT_DATE,'%d-%m-%Y') AS PROJECT_DATE,DAYS,HRS,MINUTES from $temp_table",
    9=>"SELECT PROJECT_NAME,DAYS,HRS,MINUTES from $temp_table", 10=>"SELECT USER_NAME,TOTAL_DAYS,TOTAL_HRS,TOTAL_MINUTES from $temp_table ORDER BY USER_NAME ASC",
    11=>"SELECT REPORT_DATE,PRESENT,ABSENT,ONDUTY,PERMISSION_HRS from $temp_table",
    12=>"SELECT LOGINID,NO_OF_PRESENT,NO_OF_ABSENT,NO_OF_ONDUTY,PERMISSION_HRS from $temp_table order by LOGINID asc",
    13=>"SELECT UNAME,ABSENT_COUNT from $temp_table order by UNAME",
    14=>"SELECT LOGINID,BANDWIDTH_MB from $temp_table ",
    15=>"SELECT REPORT_DATE,BANDWIDTH_MB from $temp_table ",
    16=>"SELECT DATE_FORMAT(PH.PH_DATE,'%d-%m-%Y') AS PH_DATE,PH.PH_DESCRIPTION,ULD.ULD_LOGINID,DATE_FORMAT(PH.PH_TIMESTAMP , '%d-%m-%Y %h:%m:%s') AS PH_TIMESTAMP FROM PUBLIC_HOLIDAY PH ,USER_LOGIN_DETAILS ULD WHERE PH.ULD_ID=ULD.ULD_ID AND YEAR(PH.PH_DATE)='$inputValOne'",
    17=>"SELECT PD.PD_PROJECT_NAME,PS.PS_PROJECT_DESCRIPTION,PS.PS_REC_VER,PC.PC_DATA,DATE_FORMAT(PS.PS_START_DATE,'%d-%m-%Y') as PS_START_DATE,DATE_FORMAT(PS.PS_END_DATE,'%d-%m-%Y')as PS_END_DATE,ULD.ULD_LOGINID as  ULD_USERSTAMP,DATE_FORMAT(CONVERT_TZ(PD.PD_TIMESTAMP,'+00:00','+05:30'), '%d-%m-%Y %T') as TIMESTAMP FROM PROJECT_DETAILS PD JOIN PROJECT_STATUS PS on PD.PD_ID = PS.PD_ID JOIN PROJECT_CONFIGURATION PC on PS.PC_ID = PC.PC_ID JOIN USER_LOGIN_DETAILS ULD on PD.ULD_ID=ULD.ULD_ID ORDER BY PD.PD_PROJECT_NAME ASC",
    18=>"SELECT DATE_FORMAT(UARD_DATE,'%d-%m-%Y') AS UARD_DATE,UARD_REPORT,UARD_REASON,b.AC_DATA as UARD_PERMISSION, c.AC_DATA as UARD_ATTENDANCE,G.AC_DATA AS UARD_AM_SESSION,H.AC_DATA AS UARD_PM_SESSION,I.ULD_LOGINID AS ULD_ID,DATE_FORMAT(CONVERT_TZ(UARD.UARD_TIMESTAMP,'+00:00','+05:30'), '%d-%m-%Y %T') AS UARD_TIMESTAMP,UARD_BANDWIDTH FROM USER_ADMIN_REPORT_DETAILS UARD LEFT JOIN ATTENDANCE_CONFIGURATION b ON b.AC_ID=UARD.UARD_PERMISSION left JOIN ATTENDANCE_CONFIGURATION c on c.AC_ID=UARD.UARD_ATTENDANCE LEFT JOIN ATTENDANCE_CONFIGURATION G ON G.AC_ID=UARD.UARD_AM_SESSION LEFT JOIN ATTENDANCE_CONFIGURATION H ON H.AC_ID=UARD.UARD_PM_SESSION
         LEFT JOIN USER_LOGIN_DETAILS I ON I.ULD_ID=UARD.ULD_ID where UARD_DATE BETWEEN '$inputValOne' AND '$inputValTwo' AND UARD.ULD_ID=(SELECT ULD_ID FROM USER_LOGIN_DETAILS where ULD_LOGINID='$USERSTAMP') ORDER BY UARD.UARD_DATE",
    19=>"SELECT DATE_FORMAT(AW.AWRD_DATE,'%d-%m-%Y') AS  AWRD_DATE,AW.AWRD_REPORT,ULD.ULD_LOGINID as ULD_USERSTAMP,DATE_FORMAT(CONVERT_TZ(AW.AWRD_TIMESTAMP,'+00:00','+05:30'), '%d-%m-%Y %T') AS AWRD_TIMESTAMP FROM ADMIN_WEEKLY_REPORT_DETAILS AW JOIN USER_LOGIN_DETAILS ULD on AW.ULD_ID=ULD.ULD_ID  where AW.AWRD_DATE BETWEEN '$inputValOne' AND '$inputValTwo' ORDER BY AWRD_DATE DESC",
    20=>"SELECT DISTINCT DATE_FORMAT(A.OED_DATE,'%d-%m-%Y') AS OED_DATE,A.OED_DESCRIPTION,B.ULD_LOGINID,DATE_FORMAT(CONVERT_TZ(A.OED_TIMESTAMP,'+00:00','+05:30'), '%d-%m-%Y %T')as OED_TIMESTAMP FROM ONDUTY_ENTRY_DETAILS A
         INNER JOIN USER_LOGIN_DETAILS B on A.ULD_ID=B.ULD_ID INNER JOIN USER_ACCESS C where A.OED_DATE between '$inputValOne' and '$inputValTwo' and C.UA_TERMINATE IS null",
    21=>"SELECT DISTINCT AED.EMPLOYEE_NAME,A.UARD_REPORT,A.UARD_REASON,AC.AC_DATA as PERMISSION,AT.AC_DATA,G.AC_DATA AS UARD_AM_SESSION,H.AC_DATA AS UARD_PM_SESSION,C.ULD_LOGINID as USERSTAMP,DATE_FORMAT(CONVERT_TZ(A.UARD_TIMESTAMP,'+00:00','+05:30'), '%d-%m-%Y %T') as UARD_TIMESTAMP FROM USER_ADMIN_REPORT_DETAILS A INNER JOIN USER_LOGIN_DETAILS B on A.ULD_ID=B.ULD_ID INNER JOIN USER_LOGIN_DETAILS C on A.UARD_USERSTAMP_ID=C.ULD_ID INNER JOIN VW_TS_ALL_EMPLOYEE_DETAILS AED ON A.ULD_ID=AED.ULD_ID
        INNER JOIN USER_ACCESS D LEFT JOIN ATTENDANCE_CONFIGURATION G ON G.AC_ID=A.UARD_AM_SESSION LEFT JOIN ATTENDANCE_CONFIGURATION H ON H.AC_ID=A.UARD_PM_SESSION LEFT join ATTENDANCE_CONFIGURATION AC ON A.UARD_PERMISSION=AC.AC_ID left JOIN ATTENDANCE_CONFIGURATION AT on AT.AC_ID=A.UARD_ATTENDANCE INNER JOIN EMPLOYEE_DETAILS ED ON A.ULD_ID=ED.ULD_ID where A.UARD_DATE='$inputValFour' and D.UA_TERMINATE IS null order by EMPLOYEE_NAME",
    22=>"SELECT DATE_FORMAT(UARD_DATE,'%d-%m-%Y') AS UARD_DATE ,UARD_REPORT,UARD_REASON,b.AC_DATA as UARD_PERMISSION, c.AC_DATA as UARD_ATTENDANCE,G.AC_DATA AS UARD_AM_SESSION,H.AC_DATA AS UARD_PM_SESSION,ULD.ULD_LOGINID as UARD_USERSTAMP_ID,DATE_FORMAT(CONVERT_TZ(UARD.UARD_TIMESTAMP,'+00:00','+05:30'), '%d-%m-%Y %T') AS UARD_TIMESTAMP FROM USER_ADMIN_REPORT_DETAILS UARD LEFT JOIN ATTENDANCE_CONFIGURATION b ON b.AC_ID=UARD.UARD_PERMISSION left JOIN ATTENDANCE_CONFIGURATION c on c.AC_ID=UARD.UARD_ATTENDANCE LEFT JOIN ATTENDANCE_CONFIGURATION G ON G.AC_ID=UARD.UARD_AM_SESSION
        LEFT JOIN ATTENDANCE_CONFIGURATION H ON H.AC_ID=UARD.UARD_PM_SESSION LEFT JOIN USER_LOGIN_DETAILS ULD ON ULD.ULD_ID=UARD.UARD_USERSTAMP_ID LEFT JOIN USER_LOGIN_DETAILS I ON I.ULD_ID=UARD.ULD_ID where UARD_DATE BETWEEN '$inputValTwo' AND '$inputValThree' AND UARD.ULD_ID=$inputValOne ORDER BY UARD.UARD_DATE",
    23=>"SELECT CONCAT(EMP.EMP_FIRST_NAME,' ',EMP.EMP_LAST_NAME) AS EMPLOYEE_NAME,ECIOD.ECIOD_CHECK_IN_TIME,CIORL_IN.CIORL_LOCATION AS ECIOD_CHECK_IN_LOCATION,ECIOD.ECIOD_CHECK_OUT_TIME,CIORL_OUT.CIORL_LOCATION AS ECIOD_CHECK_OUT_LOCATION FROM EMPLOYEE_CHECK_IN_OUT_DETAILS ECIOD LEFT JOIN EMPLOYEE_DETAILS EMP on EMP.ULD_ID=ECIOD.ULD_ID LEFT JOIN CLOCK_IN_OUT_REPORT_LOCATION CIORL_IN ON  ECIOD.ECIOD_CHECK_IN_LOCATION=CIORL_IN.CIORL_ID LEFT JOIN CLOCK_IN_OUT_REPORT_LOCATION CIORL_OUT ON ECIOD.ECIOD_CHECK_OUT_LOCATION=CIORL_OUT.CIORL_ID  WHERE ECIOD.ECIOD_DATE='2014-01-01'",
    24=>"SELECT DATE_FORMAT(ECIOD.ECIOD_DATE,'%d-%m-%Y') AS ECIOD_DATE,ECIOD.ECIOD_CHECK_IN_TIME,CIORL_IN.CIORL_LOCATION AS ECIOD_CHECK_IN_LOCATION ,ECIOD.ECIOD_CHECK_OUT_TIME,CIORL_OUT.CIORL_LOCATION AS ECIOD_CHECK_OUT_LOCATION FROM EMPLOYEE_CHECK_IN_OUT_DETAILS ECIOD LEFT JOIN CLOCK_IN_OUT_REPORT_LOCATION CIORL_IN ON  ECIOD.ECIOD_CHECK_IN_LOCATION=CIORL_IN.CIORL_ID LEFT JOIN CLOCK_IN_OUT_REPORT_LOCATION CIORL_OUT ON ECIOD.ECIOD_CHECK_OUT_LOCATION=CIORL_OUT.CIORL_ID  WHERE ECIOD.ECIOD_DATE BETWEEN '2014-12-01' AND '2014-12-30' AND ECIOD.ULD_ID='36'"
);
echo $arrQuery[$flag];
//start to fetch select query
$stmtExecute= mysqli_query($con,$arrQuery[$flag]);
$ure_values=array();
$final_values=array();
$appendTable="<table border=1 style='border-collapse: collapse' width='".$arrTableWidth[$flag]."px'><thead><tr>";
$arrHeaderLength = count($arrHeader[$flag]);
for($h = 0; $h < $arrHeaderLength; $h++) {
    $appendTable .="<td align='center' color='white' bgcolor='#6495ed' width='".$arrHeaderWidth[$flag][$h]."px'>".$arrHeader[$flag][$h]."</td >";
}
$appendTable .='</thead></tr>';

//CALCULATION FOR BANDWIDTH
if($flag==3)
    $arrHeaderLength=6;
$counter = 0;
$total_rows = mysqli_num_rows($stmtExecute);
while($row=mysqli_fetch_array($stmtExecute)){
//BANDWIDTH FOOTER FOR TOTAL
    if($flag==18 || $flag==21 || $flag==22){
        $appendTable .='<tr>';
        $x=0;
        $appendTable .="<td>".$row[$x]."</td>";
        if($row[$x+4]==1){
            if($row[$x+3]!=null)
                $appendTable .="<td>".str_replace("\n", "<br/>", $row[$x+1])."<br><br>PERMISSION :".$row[$x+3]."</td>";
            else if($row[$x+3]==null)
                $appendTable .="<td>".str_replace("\n", "<br/>", $row[$x+1])."</td>";
        }
        else if($row[$x+4]=='OD'){
            $appendTable .="<td>ONDUTY - REASON:".$row[$x+2]."</td>";
        }
        else if($row[$x+4]=='0.5'){
            if($row[$x+5]=='ABSENT')
                $appendTable .="<td>".str_replace("\n", "<br/>", $row[$x+1])."<br><br>ABSENT (AM)- REASON:".$row[$x+2]."</td>";
            else if($row[$x+6]=='ABSENT')
                $appendTable .="<td>".str_replace("\n", "<br/>", $row[$x+1])."<br><br>ABSENT (PM)- REASON:".$row[$x+2]."</td>";
        }
        else if($row[$x+4]=='0'){
            $appendTable .="<td>ABSENT - REASON:".$row[$x+2]."</td>";
        }
        else if($row[$x+4]=='0.5OD'){
            if($row[$x+5]=='ONDUTY')
                $appendTable .="<td>".str_replace("\n", "<br/>", $row[$x+1])."<br><br>ONDUTY (AM)- REASON:".$row[$x+2]."</td>";
            else if($row[$x+6]=='ONDUTY')
                $appendTable .="<td>".str_replace("\n", "<br/>", $row[$x+1])."<br><br>ONDUTY (PM)- REASON:".$row[$x+2]."</td>";
        }
        if($flag==21 || $flag==22)
            $appendTable .="<td>".$row[7]."</td>";
        $appendTable .="<td>".$row[8]."</td>";
    }
    else{
        if(++$counter == $total_rows){
            if($flag==14 || $flag==15){
                $appendTable .="<tr><td align='center' color='white' bgcolor='#6495ed'>".$row[0]."</td><td color='white' bgcolor='#6495ed'>".$row[1]."</td></tr>";
                break;}}
        $appendTable .='<tr>';
        for($x = 0; $x < $arrHeaderLength; $x++) {
            if(($flag == 3) &&($x == 0)){
                $appendTable .="<td >UPDATION/DELETION: ".$row[$x]."<br><br>TABLE NAME: ".$row[$x+1]."<br><br>OLD VALUE :".htmlspecialchars(str_replace(',', ' , ', $row[$x+2]))."<br><br>NEW VALUE :".htmlspecialchars($row[$x+3])."</td>";
            }else if((($flag == 3) && ($x == 4))||(($flag == 3) && ($x ==5))){
                echo $row[$x];
                $appendTable .="<td>".$row[$x]."</td>";}
            else if($flag != 3){
                $appendTable .="<td>".$row[$x]."</td>";
            }}
    }
    $appendTable .='</tr>';
}
$appendTable .='</tbody></table>';
//DROP TEMP TABLE
$drop_query="DROP TABLE $temp_table ";
if(($flag==3)||($flag==5)||($flag==6)||($flag==7)||($flag==8)||($flag==9)||($flag==10)||($flag==11)||($flag==12)||($flag==13)||($flag==14)||($flag==15))
    mysqli_query($con,$drop_query);
//GENERATE PDF
$pageWidth=$arrTableWidth[$flag]/4;
$mpdf=new mPDF('utf-8', array($pageWidth,236));
$mpdf->SetHeader($_GET['title']);
$mpdf->WriteHTML($appendTable);
$outputpdf=$mpdf->Output($_GET['title'].'.pdf','d');
echo $outputpdf;
?>
<!--
1*******USER DETAIL SEARCH
2*******
3*******TICKLER HISTORY
4*******DOOR CODE ACCES
5,6,7,8,9*******REVENUE
10******PROJECT REVENUE DATE RANGE
11******ATTENDANCE PRE ABS COUNT
12******ATTENDANCE PR ABS CNT BY MONTH
13******ATTENDANCE REPORT ENTRY MISSED
14******BANDWIDTH
15******BANDWIDTH
16******PUBLIC HOLIDAY
17******PROJECT S/U
18******REPORT S/U
19******WEEKLY S/U
20******ADMIN REPORT S/U-- ONDUTY
21******ADMIN REPORT S/U-- DATE RANGE WITH ULD
22******ADMIN REPORT S/U-- ALL EMPLOYEE
23******CLOCK IN FOR EMPLOYEE DATE RANGE
24******CLOCK IN FOR ALL EMPLOYEEFDGFDG
-->