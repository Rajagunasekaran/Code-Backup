<?php
error_reporting(0);
include "../../LMC_LIB/CONNECTION.php";
include "../../LMC_LIB/GET_USERSTAMP.php";
include "../../LMC_LIB/COMMON.php";
$USERSTAMP=$UserStamp;
global $con;
if($_REQUEST['option']=="active_emp")
{
    $TH_active_emp=get_active_emp_id();
    $TH_active_empname=array();
    $TH_query=mysqli_query($con,"SELECT ULD_WORKER_NAME FROM LMC_USER_LOGIN_DETAILS where ULD_TERMINATE_FLAG IS NULL ORDER BY ULD_WORKER_NAME ASC");
    while($row=mysqli_fetch_array($TH_query)){
        $TH_active_empname[]=$row["ULD_WORKER_NAME"];
    }
    $errormessage=array();
    $errormsg=mysqli_query($con,"SELECT DISTINCT EMC_DATA FROM LMC_ERROR_MESSAGE_CONFIGURATION WHERE EMC_ID IN (73,74,75)");
    while($row=mysqli_fetch_array($errormsg)){
        $errormessage[]=$row["EMC_DATA"];
    }
    $TH_array_values=array($TH_active_empname,$errormessage);
    echo JSON_ENCODE($TH_array_values);
}
if($_REQUEST['option']=="search")
{
    $loginid=$_REQUEST['empid'];
    $uld_id=mysqli_query($con,"SELECT ULD_ID FROM LMC_USER_LOGIN_DETAILS WHERE ULD_WORKER_NAME='$loginid'");
    while($row=mysqli_fetch_array($uld_id)){
        $TH_uld_id=$row["ULD_ID"];
    }
    $result = $con->query("CALL SP_TS_AUDIT_HISTORY('$TH_uld_id','$USERSTAMP',@TEMP_UARD_TICKLER_HISTORY)");
    if(!$result) die("CALL failed: (" . $con->errno . ") " . $con->error);
    $select = $con->query('SELECT @TEMP_UARD_TICKLER_HISTORY');
    $result = $select->fetch_assoc();
    $temp_tickler_history= $result['@TEMP_UARD_TICKLER_HISTORY'];
    $TH_values=array();
    $sqlquery=mysqli_query($con,"SELECT EVENT_TYPE,TABLE_NAME,TH_OLD_VALUE,TH_NEW_VALUE,TH_USERSTAMP,DATE_FORMAT(TH_TIMESTAMP,'%d-%m-%Y %T') AS T_TIMESTAMP FROM $temp_tickler_history ORDER BY TH_TIMESTAMP DESC ");
    while($row=mysqli_fetch_array($sqlquery)){
        $TH_eventtype=$row["EVENT_TYPE"];
        $TH_tblename=$row["TABLE_NAME"];
        $TH_oldvalue=$row['TH_OLD_VALUE'];
        $TH_oldvalue=htmlspecialchars($TH_oldvalue);
        $TH_newvalue=$row['TH_NEW_VALUE'];
        $TH_newvalue=htmlspecialchars($TH_newvalue);
        $TH_userstamp=$row['TH_USERSTAMP'];
        $TH_timestamp=$row['T_TIMESTAMP'];
        $TH_values[]=(object)['tptype'=>$TH_eventtype,'ttipdata'=>$TH_tblename,'oldvalue'=>$TH_oldvalue,'newvalue'=>$TH_newvalue,'userstamp'=>$TH_userstamp,'timestamp'=>$TH_timestamp];
    }
    $drop_query="DROP TABLE $temp_tickler_history ";
    mysqli_query($con,$drop_query);
//    $flag=0;
//    echo $flag;
    echo JSON_ENCODE($TH_values);
}
?>