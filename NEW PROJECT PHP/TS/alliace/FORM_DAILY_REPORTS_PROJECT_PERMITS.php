<!--//*******************************************FILE DESCRIPTION*********************************************//
//*********************************DAILY REPORTS PROJECT PERMITS *************************************//
//VER 0.01-INITIAL VERSION, SD:18/02/2015 ED:01/10/2015,TRACKER NO:1
//*********************************************************************************************************//-->
<?php
include "HEADER.php";
?>
<script>
//READY FUNCTION START
var upload_count=0;
$(document).ready(function(){
    ARE_paint();
    $('#wPaint').wPaint({menuOffsetLeft: -2,menuOffsetTop: -45});
    $('#wPaint').wPaint('clear');
    $('.preloader', window.parent.document).show();
    $('#ARE_tble_attendence').hide();
    $('#ARE_tbl_attendence').hide();
    $('#ARE_btn_save').hide();
    $('#ARE_tble_paint').hide();
    $("#ARE_btn_odsubmit").hide();
    $("#ARE_tble_attachment").hide();
    $("#filetableuploads tr").remove();
    $('#attachafile').text('Attach a file');
    //reomve file upload row
    $(document).on('click', 'button.removebutton', function () {

        $(this).closest('tr').remove();
        var rowCount = $('#filetableuploads tr').length;
        if(rowCount!=0)
        {
            $('#attachafile').text('Attach another file');
        }
        else
        {
            $('#attachafile').text('Attach a file');
        }
        return false;
    });
    //file extension validation
    $(document).on("change",'.fileextensionchk', function (){
        for(var i=0;i<25;i++)
        {
            var data= $('#upload_filename'+i).val();
            var datasplit=data.split('.');
            var old_loginid=$('#URSRC_lb_selectloginid').val();
            var ext=datasplit[1].toUpperCase();
            if(ext!='PDF' && ext!='JPG' && ext!='PNG' && ext!='JPEG' && ext!='XLS' && ext!='XLSX' && data!=undefined && data!="")
            {
                $(document).doValidation({rule:'messagebox',prop:{msgtitle:"PROJECT PERMITS",msgcontent:err_msg[12],position:{top:150,left:500}}});
                reset_field($('#upload_filename'+i));
            }
        }
    });
    //file upload reset
    function reset_field(e) {
        e.wrap('<form>').parent('form').trigger('reset');
        e.unwrap();
    }
    //add file upload row
    $(document).on("click",'#attachprompt', function (){
        var tablerowCount = $('#filetableuploads tr').length;
        var uploadfileid="upload_filename"+tablerowCount;
        var appendfile='<tr><td ><div><input type="file" class="fileextensionchk" name="'+uploadfileid+'" id="'+uploadfileid+'"></div></td><td><div><button type="button" class="removebutton" title="Remove this row" style="background-color:red;color:white;font-size:10;font-weight: bold;">-</button><label id="attach_error" hidden></label></div></td></tr></br>';
        $('#filetableuploads').append(appendfile);
        var rowCount = $('#filetableuploads tr').length;
        upload_count++;
        if(rowCount!=0)
        {
            $('#attachafile').text('Attach another file');
        }
        else
        {
            $('#attachafile').text('Attach a file');
        }
    });
    var permission_array=[];
    var project_array=[];
    var min_date;
    var err_msg=[];
    var login_id=[];
    var xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function() {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            $('.preloader', window.parent.document).hide();
            var value_array=JSON.parse(xmlhttp.responseText);
            permission_array=value_array[0];
//            project_array=value_array[1];
            min_date=value_array[2];
            err_msg=value_array[3];
            login_id=value_array[4];
            var maxdate=new Date();
            var month=maxdate.getMonth()+1;
            var year=maxdate.getFullYear();
            var date=maxdate.getDate();
            var max_date = new Date(year,month,date);
            var datepicker_maxdate=new Date(Date.parse(max_date));
            $('#ARE_tb_date').datepicker("option","maxDate",datepicker_maxdate);
            $('#ARE_tb_date').datepicker("option","minDate",min_date);
            var login_list='<option>SELECT</option>';
            for (var i=0;i<login_id.length;i++) {
                login_list += '<option value="' + login_id[i][1] + '">' + login_id[i][0] + '</option>';
            }
            $('#ARE_lb_loginid').html(login_list);
            var login_list='<option>SELECT</option>';
            for (var i=0;i<login_id.length;i++) {
                login_list += '<option value="' + login_id[i][1] + '">' + login_id[i][0] + '</option>';
            }
            $('#ARE_lb_lgnid').html(login_list);
        }
    }
    var option="admin_report_entry";
    xmlhttp.open("GET","COMMON.php?option="+option);
    xmlhttp.send();
    $('textarea').autogrow({onInitialize: true});
    $("#ARE_tb_date").html('')
//    $('#ARE_tb_band').hide();
    $('#ARE_btn_submit').hide();
    //DATE PICKER FUNCTION
    $('#ARE_tb_date').datepicker({
        dateFormat:"dd-mm-yy",
        changeYear: true,
        changeMonth: true
    });
    $('#ARE_tb_dte').datepicker({
        dateFormat:"dd-mm-yy",
        changeYear: true,
        changeMonth: true
    });
    var od_maxdate=new Date();
    var month=od_maxdate.getMonth()+1;
    var year=od_maxdate.getFullYear();
    var date=od_maxdate.getDate();
    var OD_max_date = new Date(year,month,date);
    $('#ARE_tb_dte').datepicker("option","maxDate",OD_max_date);
    //CHANGE EVENT FOR LOGIN LIST BX
    $(document).on('change','#ARE_lb_loginid',function(){
//        $("html, body").animate({ scrollTop: $(document).height() }, "1000");
        $('#ARE_lbl_errmsg').hide();
        $('#ARE_lbl_checkmsg').hide();
        $('#ARE_tble_paint').hide();
        $("#ARE_tble_attachment").hide();
        $("#filetableuploads tr").remove();
        $('#attachafile').text('Attach a file');
        var ARE_loginidlistbx= $("#ARE_lb_loginid").val();
        $('#ARE_tble_attendence').hide();
        if(ARE_loginidlistbx=='SELECT')
        {
            $('#ARE_tble_attendence').hide();
            $('#ARE_lbl_dte').hide();
            $('#ARE_tb_date').hide();
            $('#ARE_lbl_session').hide();
            $('#ARE_lbl_reason').hide();
            $('#ARE_ta_reason').hide();
            $('#ARE_lb_ampm').hide();
            $('#ARE_lbl_report').hide();
            $('#ARE_ta_report').hide();
            $('#ARE_rd_permission').hide();
            $('#ARE_lbl_permission').hide();
            $('#ARE_rd_nopermission').hide();
            $('#ARE_lbl_nopermission').hide();
            $('#ARE_lb_timing').hide();
            $('#ARE_tble_paint').hide();
            $("#ARE_tble_attachment").hide();
            $("#filetableuploads tr").remove();
            $('#attachafile').text('Attach a file');
            $("#ARE_btn_submit,#ARE_mrg_projectlistbx").html('');
            ARE_clear()

        }
        else
        {
            $('.preloader', window.parent.document).show();
            var loginid=$('#ARE_lb_loginid').val();
            var xmlhttp=new XMLHttpRequest();
            xmlhttp.onreadystatechange=function() {
                if (xmlhttp.readyState==4 && xmlhttp.status==200) {

                    var final_array=JSON.parse(xmlhttp.responseText);
                    mindate=final_array[0];
                    project_array=final_array[1];
                    $('.preloader', window.parent.document).hide();
//                    if(project_array.length==0){
//
//                        var msg=err_msg[10].replace('[LOGIN ID]',$("#ARE_lb_loginid option:selected").text());
//                        $('#ARE_lbl_norole_err').text(msg).show();
//                        $('#ARE_tb_date').hide();
//                        $('#ARE_lbl_dte').hide();
//
//                    }
//                    else{
                    $('#ARE_tb_date').datepicker("option","minDate",mindate);
                    $('#ARE_lbl_norole_err').hide();
                    $('#ARE_tb_date').show();
                    $('#ARE_lbl_dte').show();
//                    }

//                    $('#ARE_tb_date').datepicker("option","minDate",mindate);
                }
            }
            var choice="login_id"
            xmlhttp.open("GET","DB_DAILY_REPORTS_PROJECT_PERMITS.php?login_id="+loginid+"&option="+choice,true);
            xmlhttp.send();
            ARE_clear()
            $('#ARE_lbl_dte').show();
            $('#ARE_tb_date').val('').show();
            $('#ARE_lbl_session').hide();
            $('#ARE_lbl_reason').hide();
            $('#ARE_ta_reason').hide();
            $("#ARE_btn_submit,#ARE_mrg_projectlistbx").html('');
            $('#ARE_lb_ampm').hide();
            $('#ARE_lbl_report').hide();
            $('#ARE_ta_report').hide();
            $('#ARE_rd_permission').hide();
            $('#ARE_lbl_permission').hide();
            $('#ARE_rd_nopermission').hide();
            $('#ARE_lbl_nopermission').hide();
            $('#ARE_lb_timing').hide();
//            $('#ARE_lbl_band').hide();
//            $('#ARE_tb_band').hide();
        }
    });
    //JQUERY LIB VALIDATION START
//    $("#ARE_tb_band").doValidation({rule:'numbersonly',prop:{realpart:10,leadzero:true}});
//    $("#ARE_tb_band").prop("title","NUMBERS ONLY")
    $(".amountonly").doValidation({rule:'numbersonly',prop:{realpart:5,imaginary:2}});
    //JQUERY LIB VALIDATION END

    // CHANGE EVENT FOR DATE
    $(document).on('change','#ARE_tb_date',function(){
//        $("html, body").animate({ scrollTop: $(document).height() }, "1000");
        $('.preloader', window.parent.document).show();
        $('#ARE_lbl_checkmsg').hide();
        ARE_clear()
        var reportdate=$('#ARE_tb_date').val();
        var loginid=$('#ARE_lb_loginid').val();
        var xmlhttp=new XMLHttpRequest();
        xmlhttp.onreadystatechange=function() {
            if (xmlhttp.readyState==4 && xmlhttp.status==200) {
                var msgalert=xmlhttp.responseText;
                $('.preloader', window.parent.document).hide();
                if(msgalert==1)
                {
                    var msg=err_msg[3].toString().replace("[DATE]",reportdate)
                    ARE_clear()
                    $("#ARE_tb_date").val("");
//                    $("#ARE_lbl_dte").hide();
                    $('#ARE_tble_attendence').hide();
                    $('#ARE_lbl_errmsg').text(msg).show();
//                    $('#ARE_lb_loginid').val('SELECT').show();
                }
                else
                {
                    ARE_clear()
                    $('#ARE_tble_attendence').val('SELECT').show();
                    $('#ARE_lbl_errmsg').hide();
                    $('#ARE_lb_attendance').prop('selectedIndex',0);
                }
            }
        }
        var choice="DATE"
        xmlhttp.open("GET","DB_DAILY_REPORTS_PROJECT_PERMITS.php?date_change="+reportdate+"&login_id="+loginid+"&option="+choice,true);
        xmlhttp.send();
    });
    // CHANGE EVENT FOR ATTENDANCE
    $('#ARE_lb_attendance').change(function(){
        $('#ARE_tble_frstsel_projectlistbx').html('');
        $('#ARE_btn_submit').attr('disabled','disabled');
        $('#ARE_tble_reasonlbltxtarea').html('');
        $('#wPaint').wPaint('clear');
        $('#ARE_tble_paint').hide();
        $("#ARE_tble_attachment").hide();
        $("#filetableuploads tr").remove();
        $('#attachafile').text('Attach a file');
        $('#ARE_btn_submit').hide();
        $('#ARE_tbl_enterthereport').html('');
        $('#ARE_tble_projectlistbx').hide();
        $('#ARE_lbl_session').hide();
        $('#ARE_lb_ampm').hide();
        if($('#ARE_lb_attendance').val()=='SELECT')
        {
            $('#ARE_rd_permission').hide();
            $('#ARE_lbl_permission').hide();
            $('#ARE_rd_nopermission').hide();
            $('#ARE_lbl_nopermission').hide();
            $('#ARE_lb_timing').hide();
            $('#ARE_tbl_enterthereport').html('');
            $('#ARE_tble_paint').hide();
            $("#ARE_tble_attachment").hide();
            $("#filetableuploads tr").remove();
            $('#attachafile').text('Attach a file');
            $('#ARE_tble_projectlistbx').hide();
//            $('#ARE_tble_bandwidth').html('');
            $('#ARE_lbl_session').hide();
            $('#ARE_lb_ampm').hide();
            $('#ARE_btn_submit').hide();
            $('#ARE_lbl_errmsg').hide();
            $('#ARE_lbl_checkmsg').hide();
        }
        else if($('#ARE_lb_attendance').val()=='1')
        {
            $('.preloader', window.parent.document).show();
            var reportdate=$('#ARE_tb_date').val();
            var loginid=$('#ARE_lb_loginid').val();
            var xmlhttp=new XMLHttpRequest();
            xmlhttp.onreadystatechange=function() {
                if (xmlhttp.readyState==4 && xmlhttp.status==200) {
                    $('.preloader', window.parent.document).hide();
                    $("html, body").animate({ scrollTop: 340 }, "1000");
                    var response=JSON.parse(xmlhttp.responseText);
                    if(response==0)
                    {
                        $('#ARE_lbl_checkmsg').text(err_msg[10]).show();
                        $('#ARE_lb_timing').hide();
                        $('#ARE_rd_permission').hide();
                        $('#ARE_lbl_permission').hide();
                        $('#ARE_rd_nopermission').hide();
                        $('#ARE_lbl_nopermission').hide();
                        $('#ARE_lbl_session').hide();
                        $('#ARE_lb_ampm').hide();
                        $('#ARE_lbl_txtselectproj').hide();
                        $('#ARE_tble_projectlistbx').hide();
                        $('#ARE_btn_submit').hide();
                        $('#ARE_lbl_errmsg').hide();
                        $('#ARE_tble_paint').hide();
                        $("#ARE_tble_attachment").hide();
                        $("#filetableuploads tr").remove();
                        $('#attachafile').text('Attach a file');
                    }
                    else{
                        $('#ARE_tbl_enterthereport,#ARE_ta_reason').html('');
                        $('#ARE_tble_paint').show();
                        $("#ARE_tble_attachment").show();
                        $("#filetableuploads tr").remove();
                        $('#attachafile').text('Attach a file');
                        $('#ARE_rd_permission').attr('checked',false);
                        $('#ARE_rd_nopermission').attr('checked',false);
                        $('#ARE_lb_timing').hide();
                        $('#ARE_rd_permission').show();
                        $('#ARE_lbl_permission').show();
                        $('#ARE_rd_nopermission').show();
                        $('#ARE_lbl_nopermission').show();
                        var permission_list='<option>SELECT</option>';
                        for (var i=0;i<permission_array.length;i++) {
                            permission_list += '<option value="' + permission_array[i] + '">' + permission_array[i] + '</option>';
                        }
                        $('#ARE_lb_timing').html(permission_list);
                        $('#ARE_lbl_session').hide();
                        $('#ARE_lb_ampm').hide();
                        $('#ARE_lbl_txtselectproj').show();
                        $('#ARE_tble_projectlistbx').show();
                        projectlist();
                        ARE_report();
//                        ARE_tble_bandwidth();
                        $('#ARE_btn_submit').hide();
                        $('#ARE_rd_permission').removeAttr("disabled");
                        $('#ARE_rd_nopermission').removeAttr("disabled");
                        $('#ARE_lbl_errmsg').hide();
                        $('#ARE_lbl_checkmsg').hide();
                    }
                }
            }
            var option="PRESENT";
            xmlhttp.open("POST","DB_DAILY_REPORTS_PROJECT_PERMITS.php?option="+option+"&reportdate="+reportdate+"&loginid="+loginid);
            xmlhttp.send();
        }
        else if($('#ARE_lb_attendance').val()=='0')
        {
            $('#ARE_rd_permission').attr('checked',false);
            $('#ARE_rd_nopermission').attr('checked',false);
            $('#ARE_lb_timing').hide();
            $('#ARE_rd_permission').show();
            $('#ARE_lbl_permission').show();
            $('#ARE_rd_nopermission').show();
            $('#ARE_lbl_nopermission').show();
            var permission_list='<option>SELECT</option>';
            for (var i=0;i<4;i++) {
                permission_list += '<option value="' + permission_array[i] + '">' + permission_array[i] + '</option>';
            }
            $('#ARE_lb_timing').html(permission_list);
            $('#ARE_lbl_session').show();
            $('#ARE_lb_ampm').val('SELECT').show();
            $('#ARE_tble_projectlistbx').hide();
            $('#ARE_tble_reasonlbltxtarea').html('');
            $('#ARE_tbl_enterthereport').html('');
            $('#ARE_tble_paint').hide();
            $("#ARE_tble_attachment").hide();
            $("#filetableuploads tr").remove();
            $('#attachafile').text('Attach a file');
            $('#ARE_btn_submit').hide();
            $('#ARE_rd_permission').attr('disabled','disabled');
            $('#ARE_rd_nopermission').attr('disabled','disabled');
            $('#ARE_lbl_errmsg').hide();
            $('#ARE_lbl_checkmsg').hide();
        }
        else if($('#ARE_lb_attendance').val()=='OD')
        {
            $('#ARE_rd_permission').attr('checked',false);
            $('#ARE_rd_nopermission').attr('checked',false);
            $('#ARE_lb_timing').hide();
            $('#ARE_rd_permission').show();
            $('#ARE_lbl_permission').show();
            $('#ARE_rd_nopermission').show();
            $('#ARE_lbl_nopermission').show();
            var permission_list='<option>SELECT</option>';
            for (var i=0;i<4;i++) {
                permission_list += '<option value="' + permission_array[i] + '">' + permission_array[i] + '</option>';
            }
            $('#ARE_lb_timing').html(permission_list);
            $('#ARE_lbl_session').show();
            $('#ARE_lb_ampm').val('SELECT').show();
            $('#ARE_tble_projectlistbx').hide();
            $('#ARE_tble_reasonlbltxtarea').html('');
            $('#ARE_tbl_enterthereport').html('');
            $('#ARE_tble_paint').hide();
            $("#ARE_tble_attachment").hide();
            $("#filetableuploads tr").remove();
            $('#attachafile').text('Attach a file');
            $('#ARE_btn_submit').hide();
            $('#ARE_rd_permission').attr('disabled','disabled');
            $('#ARE_rd_nopermission').attr('disabled','disabled');
            $('#ARE_lbl_errmsg').hide();
            $('#ARE_lbl_checkmsg').hide();
        }
    });
    // CLICK EVENT PERMISSION RADIO BUTTON
    $(document).on('click','#ARE_rd_permission',function()
    {
//        $("html, body").animate({ scrollTop: $(document).height() }, "1000");
        if($('#ARE_rd_permission').attr("checked","checked"))
        {
            $('#ARE_lb_timing').val('SELECT').show();
        }
        else
        {
            $('#ARE_lb_timing').hide();
            $('#ARE_lb_timing').prop('selectedIndex',0);
        }
    });
    // CLICK EVENT NOPERMISSION RADIO BUTTON
    $(document).on('click','#ARE_rd_nopermission',function()
    {
        $('#ARE_lb_timing').hide();
        $('#ARE_lb_timing').prop('selectedIndex',0);

    });
// FUNCTION FOR CLEAR FORM ELEMENTS
    function ARE_clear(){
        $('#ARE_tble_attendence').hide();
        $('#ARE_tble_reasonlbltxtarea').html('');
        $('#ARE_tble_frstsel_projectlistbx').html('');
        $('#ARE_tbl_enterthereport').html('');
        $('#wPaint').wPaint('clear');
//        $('#ARE_tble_bandwidth').html('');
        $('#ARE_btn_submit').html('');
        $('#ARE_lbl_session').hide();
        $('#ARE_rd_permission').hide();
        $('#ARE_lbl_permission').hide();
        $('#ARE_rd_nopermission').hide();
        $('#ARE_lbl_nopermission').hide();
        $('#ARE_lb_timing').hide();
        $('#ARE_lb_timing').prop('selectedIndex',0);
        $('#ARE_lb_ampm').hide();
        $('#ARE_btn_submit').hide();
        $('#ARE_tble_projectlistbx').hide();
        $('#ARE_lbl_norole_err').hide();
        $('#ARE_tble_paint').hide();
        $("#ARE_tble_attachment").hide();
        $("#filetableuploads tr").remove();
        $('#attachafile').text('Attach a file');
    }
    // CHANGE EVENT FOR SESSION LIST BOX
    $('#ARE_lb_ampm').change(function(){
        flag=1;
        $('#ARE_tble_reasonlbltxtarea,#ARE_tbl_enterthereport,#ARE_tble_frstsel_projectlistbx').html('');
        $('#wPaint').wPaint('clear');
        $('#ARE_btn_submit').hide();
        $('#ARE_tble_projectlistbx').hide();
        if($('#ARE_lb_ampm').val()=='SELECT')
        {
            $('#ARE_tble_reasonlbltxtarea').html('');
            $('#ARE_tble_frstsel_projectlistbx').html('');
            $('#ARE_tbl_enterthereport').html('');
            $('#ARE_tble_projectlistbx').hide();
//            $('#ARE_tble_bandwidth').html('');
            $('#ARE_btn_submit').hide();
            $('#ARE_lbl_errmsg').hide();
            $('#ARE_lbl_checkmsg').hide();
            $('#ARE_tble_paint').hide();
            $("#ARE_tble_attachment").hide();
            $("#filetableuploads tr").remove();
            $('#attachafile').text('Attach a file');
        }
        else if($('#ARE_lb_ampm').val()=='FULLDAY')
        {
            $('#ARE_tble_projectlistbx').hide();
            ARE_reason();
            $('#ARE_lb_timing').hide();
            $('#ARE_rd_permission').hide();
            $('#ARE_lbl_permission').hide();
            $('#ARE_rd_nopermission').hide();
            $('#ARE_lbl_nopermission').hide();
            $('#ARE_rd_permission').attr('disabled','disabled');
            $('#ARE_rd_nopermission').attr('disabled','disabled');
            $('#ARE_btn_submit').show();
            $('#ARE_lbl_errmsg').hide();
            $('#ARE_lbl_checkmsg').hide();
            $('#ARE_tble_paint').hide();
            $("#ARE_tble_attachment").hide();
            $("#filetableuploads tr").remove();
            $('#attachafile').text('Attach a file');
        }
        else
        {
            $('.preloader', window.parent.document).show();
            $('#ARE_tble_paint').hide();
            $("#ARE_tble_attachment").hide();
            $("#filetableuploads tr").remove();
            $('#attachafile').text('Attach a file');
            var reportdate=$('#ARE_tb_date').val();
            var loginid=$('#ARE_lb_loginid').val();
            var xmlhttp=new XMLHttpRequest();
            xmlhttp.onreadystatechange=function() {
                if (xmlhttp.readyState==4 && xmlhttp.status==200) {
                    $('.preloader', window.parent.document).hide();
                    $("html, body").animate({ scrollTop: $(document).height() }, "1000");
                    var response=JSON.parse(xmlhttp.responseText);
                    if(response==0)
                    {
                        $('#ARE_lbl_checkmsg').text(err_msg[10]).show();
                        $('#ARE_btn_submit').hide();
                        $('#ARE_rd_permission').hide();
                        $('#ARE_lbl_permission').hide();
                        $('#ARE_rd_nopermission').hide();
                        $('#ARE_lbl_nopermission').hide();
                        $('#ARE_lb_timing').hide();
                        $('#ARE_tble_projectlistbx').hide();
                        $('#ARE_lbl_txtselectproj').hide();
                        $('#ARE_lbl_errmsg').hide();
                        $('#ARE_tble_paint').hide();
                        $("#ARE_tble_attachment").hide();
                        $("#filetableuploads tr").remove();
                        $('#attachafile').text('Attach a file');
                    }
                    else
                    {
                        ARE_reason();
                        $('#ARE_btn_submit').hide();
                        $('#ARE_rd_permission').attr('checked',false);
                        $('#ARE_rd_nopermission').attr('checked',false);
                        $('#ARE_rd_permission').removeAttr("disabled");
                        $('#ARE_rd_nopermission').removeAttr("disabled");
                        $('#ARE_rd_permission').show();
                        $('#ARE_lbl_permission').show();
                        $('#ARE_rd_nopermission').show();
                        $('#ARE_lbl_nopermission').show();
                        $('#ARE_lb_timing').hide();
                        $('#ARE_tble_projectlistbx').show();
                        $('#ARE_lbl_txtselectproj').show();
                        projectlist();
                        ARE_report();
//                        ARE_tble_bandwidth();
                        $('#ARE_lbl_errmsg').hide();
                        $('#ARE_lbl_checkmsg').hide();
                        $('#ARE_tble_paint').show();
                        $("#ARE_tble_attachment").show();
                        $("#filetableuploads tr").remove();
                        $('#attachafile').text('Attach a file');
                    }
                }
            }
            var option="HALFDAYABSENT";
            xmlhttp.open("POST","DB_DAILY_REPORTS_PROJECT_PERMITS.php?option="+option+"&reportdate="+reportdate+"&logind="+loginid);
            xmlhttp.send();
        }
    });
    //CHANGE EVENT FOR REPORT TEXTAREA
    $(document).on('change','#ARE_ta_report',function(){

//        $('#ARE_btn_submit').show();
        $('#ARE_btn_submit').attr('disabled','disabled');
        $('#ARE_lbl_errmsg').hide();
//        $('#ARE_tble_bandwidth').html('');
    });
    //CHANGE EVENT FOR PAINT
    $(document).on('click','#wPaint',function(){
        $('#ARE_btn_submit').show();
        $('#ARE_btn_submit').attr('disabled','disabled');
    });
    // FUNCTION FOR PROJECT LIST
    function projectlist(){
        var project_list;
        for (var i=0;i<project_array.length;i++) {
            project_list += '<tr><td><input type="checkbox" id ="checkbox" name="checkbox[]" value="' + project_array[i][1] + '">' + project_array[i][0] + ' - '+ project_array[i][2]+'</td></tr>';
        }
        $('#ARE_tble_frstsel_projectlistbx').append(project_list).show();
    }
    //FUNCTION FOR REASON
    function ARE_reason(){
        $('<tr><td width="150"><label name="ARE_lbl_reason" id="ARE_lbl_reason" >REASON<em>*</em></label></td><td><textarea  name="ARE_ta_reason" id="ARE_ta_reason" ></textarea></td></tr>').appendTo($("#ARE_tble_reasonlbltxtarea"));
    }
    //FUNCTION FOR MULTIPLE ENTRY REASON
    function ARE_mulreason(){
        $('<tr><td width="150"><label name="ARE_lbl_reason" id="ARE_lbl_reason" >REASON<em>*</em></label></td><td><textarea  name="ARE_ta_reason" id="ARE_ta_reason" ></textarea></td></tr>').appendTo($("#ARE_tbl_reason"));
    }
    // FUNCTION FOR REPORT
    function ARE_report(){
        $('<tr><td width="150"><label name="ARE_lbl_report" id="ARE_lbl_report">ENTER THE REPORT<em>*</em></label></td><td><textarea  name="ARE_ta_report" id="ARE_ta_report" ></textarea></td></tr>').appendTo($("#ARE_tbl_enterthereport"));
    }
    // FUNCTION FOR PAINT
//    function ARE_mulpaint(){
//        $('<tr><td width="150"><label name="ARE_lbl_mulpaint" id="ARE_lbl_mulpaint" >DRAWING SURFACE</label></td><td><div id="wPaint1" class="isResizable"></div><center id="wPaint-img"></center></td></tr>').appendTo($("#ARE_tble_mulpaint"));
//    }
    function ARE_paint(){
        $('<tr><td width="150"><label name="ARE_lbl_paint" id="ARE_lbl_paint" >DRAWING SURFACE</label></td><td><div id="wPaint" class="isResizable"></div><center id="wPaint-img"></center></td></tr>').appendTo($("#ARE_tble_paint"));
    }
    //FORM VALIDATION
    $(document).on('click change blur','#ARE_form_adminreportentry',function(){
        if($("input[name=entry]:checked").val()=="SINGLE DAY ENTRY"){
            var ARE_sessionlstbx= $("#ARE_lb_ampm").val();
            var ARE_reasontxtarea =$("#ARE_ta_reason").val();
            var ARE_reportenter =$("#ARE_ta_report").val();
//            var ARE_bndtxt = $("#ARE_tb_band").val();
            var ARE_projectselectlistbx = $("input[id=checkbox]").is(":checked");
            var ARE_permissionlstbx = $("#ARE_lb_timing").val();
            var ARE_permission=$("input[name=permission]:checked").val()=="PERMISSION";
            var ARE_nopermission=$("input[name=permission]:checked").val()=="NOPERMISSION";
            var ARE_presenthalfdysvld=$("#ARE_lb_attendance").val();
            if(((ARE_presenthalfdysvld=='0') && (ARE_sessionlstbx=='AM' || ARE_sessionlstbx=="PM")) || ((ARE_presenthalfdysvld=='OD') && (ARE_sessionlstbx=='AM' || ARE_sessionlstbx=="PM") ))
            {
                if(((ARE_reasontxtarea.trim()!="")&&(ARE_reportenter!='')&&( ARE_projectselectlistbx==true) && ((ARE_permission==true) || (ARE_nopermission==true))))
                {
                    if(ARE_permission==true)
                    {
                        if(ARE_permissionlstbx!='SELECT')
                        {
                            $("#ARE_btn_submit").removeAttr("disabled");
                        }
                        else
                        {
                            $("#ARE_btn_submit").attr("disabled", "disabled");
                        }
                    }
                    else
                    {
                        $("#ARE_btn_submit").removeAttr("disabled");
                    }
                }
                else
                {
                    $("#ARE_btn_submit").attr("disabled", "disabled");
                }
            }
            else if((ARE_presenthalfdysvld=='0' && ARE_sessionlstbx=='FULLDAY') || (ARE_presenthalfdysvld=='OD' && ARE_sessionlstbx=='FULLDAY'))
            {
                if(ARE_reasontxtarea.trim()=="")
                {
                    $("#ARE_btn_submit").attr("disabled", "disabled");
                }
                else
                {
                    $("#ARE_btn_submit").removeAttr("disabled");
                }
            }
            else if(ARE_presenthalfdysvld=='1')
            {
                if(((ARE_reportenter.trim()!="")&&( ARE_projectselectlistbx==true) && ((ARE_permission==true) || (ARE_nopermission==true))))
                {
                    if(ARE_permission==true)
                    {
                        if(ARE_permissionlstbx!='SELECT')
                        {
                            $("#ARE_btn_submit").removeAttr("disabled");
                        }
                        else
                        {
                            $("#ARE_btn_submit").attr("disabled", "disabled");
                        }
                    }
                    else
                    {
                        $("#ARE_btn_submit").removeAttr("disabled");
                    }
                }
                else
                {
                    $("#ARE_btn_submit").attr("disabled", "disabled");
                }
            }
        }
        else if($("input[name=entry]:checked").val()=="MULTIPLE DAY ENTRY"){
            var ARE_reasontxtarea =$("#ARE_ta_reason").val();
            var ARE_presenthalfdysvld=$("#ARE_lb_attdnce").val();
            if((ARE_presenthalfdysvld=='0') || (ARE_presenthalfdysvld=='OD'))
            {
                if(ARE_reasontxtarea.trim()=="")
                {
                    $("#ARE_btn_save").attr("disabled", "disabled");
                }
                else
                {
                    $("#ARE_btn_save").removeAttr("disabled");
                }
            }
        }
    });
    // CLICK EVENT FOR SAVE BUTTON
    $(document).on('click','#ARE_btn_submit',function(){
        $('.preloader', window.parent.document).show();
        var request;
        var imgData = $("#wPaint").wPaint("image");
        $("#canvasImage").attr('src', imgData);
        var formElement = $('#ARE_form_adminreportentry').serialize();
        var choice="SINGLE DAY ENTRY";
        var loginname=$('#ARE_lb_loginid option:selected').text();
        // Send Request
        request = $.ajax({
            url: "DB_DAILY_REPORTS_PROJECT_PERMITS.php",
            type: "POST",
            data: formElement+"&choice="+choice+"&string="+imgData+"&upload_count="+upload_count,
            success: function(response){
                var msg_alert=response;
                $('.preloader', window.parent.document).hide();
                if(msg_alert==1){
                    $(document).doValidation({rule:'messagebox',prop:{msgtitle:"PROJECT PERMITS",msgcontent:err_msg[0],position:{top:150,left:500}}});
                    $('#ARE_lbl_dte').hide();
                    $('#ARE_tb_date').hide();
                    ARE_clear();
                    $("#ARE_lb_loginid").val('SELECT').show();
                }
                if(msg_alert==0)
                {
                    $(document).doValidation({rule:'messagebox',prop:{msgtitle:"PROJECT PERMITS",msgcontent:err_msg[4],position:{top:150,left:500}}});
//                    $('#ARE_lbl_dte').hide();
//                    $('#ARE_tb_date').hide();
//                    ARE_clear();
//                    $("#ARE_lb_loginid").val('SELECT').show();
                }
                if(msg_alert!=0 && msg_alert!=1)
                {
                    $(document).doValidation({rule:'messagebox',prop:{msgtitle:"PROJECT PERMITS",msgcontent:msg_alert,position:{top:150,left:500}}});
//                    $('#ARE_lbl_dte').hide();
//                    $('#ARE_tb_date').hide();
//                    ARE_clear();
//                    $("#ARE_lb_loginid").val('SELECT').show();
                }
            }
        });
    });
    // CHANGE EVENT FOR OPTION BUTTON
    $(document).on('change','#option',function(){
        $('#ARE_form_dailyuserentry').hide();
        $('#ARE_lbl_checkmsg').hide();
        $('#ARE_tble_paint').hide();
        $("#ARE_tble_attachment").hide();
        $("#filetableuploads tr").remove();
        $('#attachafile').text('Attach a file');
        if($('#option').val()=='PROJECT PERMITS')
        {
            $("#ARE_lbl_sinentry").show();
            $('#ARE_rd_sinentry').attr('checked',false);
            $('#ARE_rd_mulentry').attr('checked',false);
            $("#ARE_rd_sinentry").show();
            $("#ARE_lbl_mulentry").show();
            $("#ARE_rd_mulentry").show();
            $('#ARE_tble_ondutyentry').hide();
            $('#ARE_lbl_oderrmsg').hide();
        }
        else if(($('#option').val()=='ONDUTY REPORT ENTRY'))
        {
            $('#ARE_tble_ondutyentry').show();
            $('#ARE_lbl_session').hide();
            $('#ARE_tble_singledayentry').hide();
            $('#ARE_tble_mutipledayentry').hide();
            $('#ARE_tble_attendence').hide();
            ARE_clear()
            ARE_mulclear()
            $('#ARE_lbl_errmsg').text('').show();
            $("#ARE_ta_des").val('');
            $("#ARE_tb_dte").val('');
            $("#ARE_btn_odsubmit").attr("disabled", "disabled");
            $("#ARE_lbl_sinentry").hide();
            $("#ARE_rd_sinentry").hide();
            $("#ARE_lbl_mulentry").hide();
            $("#ARE_rd_mulentry").hide();
            $('#ARE_msg').hide();
            $("#ARE_lbl_multipleday").hide();
            $("#ARE_rd_sinemp").hide();
            $("#ARE_lbl_sinemp").hide();
            $("#ARE_rd_allemp").hide();
            $("#ARE_lbl_allemp").hide();
        }
        else
        {
            $('#ARE_tble_singledayentry').hide();
            $('#ARE_tble_mutipledayentry').hide();
            $('#ARE_tble_ondutyentry').hide();
            $('#ARE_tble_attendence').hide();
            ARE_clear()
            $('#ARE_rd_sinentry').attr('checked',false);
            $('#ARE_rd_mulentry').attr('checked',false);
            $("#ARE_lbl_sinentry").hide();
            $("#ARE_rd_sinentry").hide();
            $("#ARE_lbl_mulentry").hide();
            $("#ARE_rd_mulentry").hide();
        }
    });
    // CLICK EVENT FOR SINGLEDAYENTRY RADIO BUTTON
    $('#ARE_rd_sinentry').click(function(){
        $('#ARE_tble_singledayentry').show();
        $('#ARE_lbl_session').hide();
        $('#ARE_tble_ondutyentry').hide();
        $('#ARE_tble_mutipledayentry').hide();
        $('#ARE_lbl_loginid').show();
        $('#ARE_lb_loginid').val('SELECT').show();
        $('#ARE_lbl_reason').hide();
        $('#ARE_ta_reason').hide();
        ARE_clear()
        $('#ARE_tbl_attendence').hide();
        $('#ARE_btn_save').hide();
        $('#ARE_lbl_dte').hide();
        $('#ARE_tb_date').hide();
        $('#ARE_lbl_attdnce').hide();
        $('#ARE_lb_attdnce').hide();
//        $('#ARE_tble_mulpaint').hide();
        $("#ARE_lbl_multipleday").hide();
        $("#ARE_rd_sinemp").hide();
        $("#ARE_lbl_sinemp").hide();
        $("#ARE_rd_allemp").hide();
        $("#ARE_lbl_allemp").hide();
        $('#ARE_msg').hide();
        $('#ARE_tble_paint').hide();
        $("#ARE_tble_attachment").hide();
        $("#filetableuploads tr").remove();
        $('#attachafile').text('Attach a file');
    });
    // CLICK EVENT FOR MULTIPLEDAYENTRY RADIO BUTTON
    $("#ARE_rd_mulentry").click(function(){
        $("#ARE_lbl_multipleday").show();
        $("#ARE_rd_sinemp").show();
        $("#ARE_lbl_sinemp").show();
        $("#ARE_rd_allemp").show();
        $("#ARE_lbl_allemp").show();
        $('#ARE_lbl_loginid').hide();
        $('#ARE_lb_loginid').hide();
        $('#ARE_lbl_dte').hide();
        $('#ARE_tb_date').hide();
        $('#ARE_lbl_errmsg').hide();
        $('#ARE_rd_sinemp').attr('checked',false);
        $('#ARE_rd_allemp').attr('checked',false);
        ARE_clear()
        $('#ARE_lbl_checkmsg').hide();
        $('#ARE_tble_paint').hide();
        $("#ARE_tble_attachment").hide();
        $("#filetableuploads tr").remove();
        $('#attachafile').text('Attach a file');
    });
    //CLICK EVENT FOR SINGLE EMPLOYEE RADIO BUTTON
    $("#ARE_rd_sinemp").click(function(){
        $('#ARE_tble_mutipledayentry').show();
        $('#ARE_tble_singledayentry').hide();
        $('#ARE_lbl_lgnid').show();
        $('#ARE_lb_lgnid').val('SELECT').show();
        $("#ARE_lbl_sdte").hide();
        $("#ARE_tb_sdate").hide().val('');
        $("#ARE_lbl_edte").hide();
        $("#ARE_tb_edate").hide().val('');
        $('#ARE_tb_sdate').datepicker("option","minDate",mindate);
        $('#ARE_tb_sdate').datepicker("option","maxDate",max_date);
        $('#ARE_msg').hide();
        $('#ARE_tble_paint').hide();
        $("#ARE_tble_attachment").hide();
        $("#filetableuploads tr").remove();
        $('#attachafile').text('Attach a file');
        ARE_clear()
        ARE_mulclear()
    });
    // CLICK EVENT FOR ALL EMPLOYEE RADIO BUTTON
    $("#ARE_rd_allemp").click(function(){
        var xmlhttp=new XMLHttpRequest();
        xmlhttp.onreadystatechange=function() {
            if (xmlhttp.readyState==4 && xmlhttp.status==200) {
                var allmindate=xmlhttp.responseText;
                $('#ARE_tb_sdate').datepicker("option","minDate",allmindate);
                var maxdate=new Date();
                var month=maxdate.getMonth()+1;
                var year=maxdate.getFullYear();
                var date=maxdate.getDate();
                var allmaxdate = new Date(year,month,date);
                $('#ARE_tb_sdate').datepicker("option","maxDate",allmaxdate);
            }
        }
        var choice="ALLEMPDATE"
        xmlhttp.open("GET","DB_DAILY_REPORTS_PROJECT_PERMITS.php?&option="+choice,true);
        xmlhttp.send();
        $('#ARE_tble_mutipledayentry').show();
        $('#ARE_tble_singledayentry').hide();
        $('#ARE_lbl_lgnid').hide();
        $('#ARE_lb_lgnid').hide();
        $('#ARE_lb_lgnid').prop('selectedIndex',0);
        $("#ARE_lbl_sdte").show();
        $("#ARE_tb_sdate").show().val('');
        $("#ARE_lbl_edte").show();
        $("#ARE_tb_edate").show().val('');
//        $('#ARE_tb_sdate').datepicker("option","minDate",null);
//        $('#ARE_tb_sdate').datepicker("option","maxDate",null);
        $('#ARE_table_attendence').hide();
        $('#ARE_lbl_attdnce').hide();
        $('#ARE_lb_attdnce').hide();
//        $('#ARE_tble_mulpaint').hide();
        $('#ARE_lbl_reason').hide();
        $('#ARE_ta_reason').hide();
        $('#ARE_btn_save').hide();
        $('#ARE_msg').hide();
        $('#ARE_tble_paint').hide();
        $("#ARE_tble_attachment").hide();
        $("#filetableuploads tr").remove();
        $('#attachafile').text('Attach a file');
        ARE_clear()
    });
    // CHANGE EVENT FOR MULTIPLEDAY ENTRY LOGIN LIST BOX
    $(document).on('change','#ARE_lb_lgnid',function(){
        $("#ARE_lbl_sdte").show();
        $("#ARE_tb_sdate").show().val('');
        $("#ARE_lbl_edte").show();
        $("#ARE_tb_edate").show().val('');
    });
    // DATEPICKER FUNCTION FOR FROMDATE AND TODATE
    $('.change').datepicker({
        dateFormat:"dd-mm-yy",
        changeYear: true,
        changeMonth: true
    });
    var mindate;
    var max_date;
    // CHANGE EVENT FOR MULTIPLE DAY LOGINID LISTBOX
    $(document).on('change','#ARE_lb_lgnid',function(){
//        $("html, body").animate({ scrollTop: $(document).height() }, "1000");
        $('#ARE_lbl_errmsg').hide();
        var ARE_loginidlist= $("#ARE_lb_lgnid").val();
        $('#ARE_tble_attendence').hide();
        $('#ARE_tble_paint').hide();
        $("#ARE_tble_attachment").hide();
        $("#filetableuploads tr").remove();
        $('#attachafile').text('Attach a file');
        $('#ARE_msg').hide();
        if(ARE_loginidlist=='SELECT')
        {
            $('#ARE_table_attendence').hide();
            $("#ARE_lbl_sdte").hide();
            $("#ARE_tb_sdate").hide()
            $("#ARE_lbl_edte").hide();
            $("#ARE_tb_edate").hide();
            $('#ARE_lbl_reason').hide();
            $('#ARE_ta_reason').hide();
//            $('#ARE_tble_mulpaint').hide();
            $('#ARE_lbl_attdnce').hide();
            $('#ARE_lb_attdnce').hide();
            $('#ARE_btn_save').hide();
            ARE_clear()
        }
        else
        {
            $('.preloader', window.parent.document).show();
            var loginid=$('#ARE_lb_lgnid').val();
            var xmlhttp=new XMLHttpRequest();
            xmlhttp.onreadystatechange=function() {
                if (xmlhttp.readyState==4 && xmlhttp.status==200) {

                    var mindate=xmlhttp.responseText;
                    $('.preloader', window.parent.document).hide();
                    $('#ARE_tb_sdate').datepicker("option","minDate",mindate);
                    var max_date=new Date();
                    var month=max_date.getMonth()+1;
                    var year=max_date.getFullYear();
                    var date=max_date.getDate();
                    var max_date = new Date(year,month,date);
                    $('#ARE_tb_sdate').datepicker("option","maxDate",max_date);
                }
            }
            var choice="LOGINID"
            xmlhttp.open("GET","DB_DAILY_REPORTS_PROJECT_PERMITS.php?login_id="+loginid+"&option="+choice,true);
            xmlhttp.send();

            ARE_clear()
            $('#ARE_lbl_sdte').show();
            $('#ARE_tb_sdate').val('').show();
            $("#ARE_lbl_edte").show();
            $("#ARE_tb_edate").show();
            $('#ARE_lbl_reason').hide();
            $('#ARE_ta_reason').hide();
            $('#ARE_tble_attendence').hide();
            $('#ARE_lbl_attdnce').hide();
            $('#ARE_lb_attdnce').hide();
            $('#ARE_btn_save').hide();
//            $('#ARE_tble_mulpaint').hide();
        }
    });
    // CHANGE EVENT FOR FROMDATE
    $(document).on('change','#ARE_tb_sdate',function(){
//        $("html, body").animate({ scrollTop: $(document).height() }, "fast");
        var ARE_fromdate = $('#ARE_tb_sdate').datepicker('getDate');
        var date = new Date( Date.parse( ARE_fromdate ));
        date.setDate( date.getDate()  );
        var ARE_todate = date.toDateString();
        ARE_todate = new Date( Date.parse( ARE_todate ));
        $('#ARE_tb_edate').datepicker("option","minDate",ARE_todate);
        var max_date=new Date();
        var month=max_date.getMonth()+1;
        var year=max_date.getFullYear();
        var date=max_date.getDate();
        var max_date = new Date(year,month,date);
        $('#ARE_tb_edate').datepicker("option","maxDate",max_date);
    });
    // CHANGE FUNCTIOn FOR TODATE
    $(document).on('change','.valid',function(){
//        $("html, body").animate({ scrollTop: $(document).height() }, "fast");
        var loginid=$('#ARE_lb_lgnid').val();
        var fromdate=$('#ARE_tb_sdate').val();
        var todate=$('#ARE_tb_edate').val();
//        $('#ARE_tble_mulpaint').hide();
        $('#ARE_lbl_reason').hide();
        $('#ARE_ta_reason').hide();
        $('#ARE_btn_save').hide();
        $('#ARE_tble_paint').hide();
        $("#ARE_tble_attachment").hide();
        $("#filetableuploads tr").remove();
        $('#attachafile').text('Attach a file');
        if(fromdate!='' && todate!='')
        {
            $('.preloader', window.parent.document).show();
            var xmlhttp=new XMLHttpRequest();
            xmlhttp.onreadystatechange=function() {
                if (xmlhttp.readyState==4 && xmlhttp.status==200) {
                    $('.preloader', window.parent.document).hide();
                    var date_array=JSON.parse(xmlhttp.responseText);
                    var error_date='';
                    for(var i=0;i<date_array.length;i++){
                        if(i==0){
                            error_date=date_array[i]
                        }
                        else{
                            error_date+=','+date_array[i]
                        }
                    }
                    if(error_date=='')
                    {
                        $('#ARE_tbl_attendence').show();
                        $('#ARE_lbl_attdnce').show();
                        $('#ARE_lb_attdnce').val('SELECT').show();
                        $('#ARE_msg').text(msg).hide();
                    }
                    else
                    {
                        var msg=err_msg[3].toString().replace("[DATE]",error_date);
                        $('#ARE_msg').text(msg).show();
//                    $('#ARE_tb_sdate').val('').show();
//                    $('#ARE_tb_edate').val('').show();
                        $('#ARE_tbl_attendence').hide();
                        $('#ARE_lbl_attdnce').hide();
                        $('#ARE_lb_attdnce').val('SELECT').hide();
                        $('#ARE_lbl_reason').hide();
                        $('#ARE_ta_reason').hide();
                        $('#ARE_btn_save').hide();
                    }
                }
            }
            var option="BETWEEN DATE";
            xmlhttp.open("GET","DB_DAILY_REPORTS_PROJECT_PERMITS.php?option="+option+"&fromdate="+fromdate+"&todate="+todate+"&loginid="+loginid,true);
            xmlhttp.send();
        }
    });
    //CHANGE EVENT FOR MULTIPLEDAY ATTENDANCE
    $('#ARE_lb_attdnce').change(function(){
        $("html, body").animate({ scrollTop: $(document).height() }, "1000");
        $('#ARE_tbl_reason').html('');
        $('#ARE_tble_paint').hide();
        $("#ARE_tble_attachment").hide();
        $("#filetableuploads tr").remove();
        $('#attachafile').text('Attach a file');
        if($('#ARE_lb_attdnce').val()=='SELECT')
        {
            $('#ARE_lbl_reason').hide();
            $('#ARE_ta_reason').hide();
            $('#ARE_btn_save').hide();
//            $('#ARE_tble_mulpaint').hide();
//            $('#wPaint1').wPaint('clear');
        }
        else if(($('#ARE_lb_attdnce').val()=='0') || ($('#ARE_lb_attdnce').val()=='OD'))
        {
            ARE_mulreason()
            $('#ARE_lbl_reason').show();
            $('#ARE_ta_reason').show();
            $('#ARE_btn_save').show();
//            $('#ARE_tble_mulpaint').show();
//            $('#wPaint1').wPaint('clear');
        }
    });
    //CLICK EVENT FOR MULTIPLEDAY SAVE BUTTON
    $('#ARE_btn_save').click(function(){
        $('.preloader', window.parent.document).show();
        var request;
        var formElement = $('#ARE_form_adminreportentry').serialize();
        var choice="MULTIPLE DAY ENTRY";
        // Send Request
        request = $.ajax({
            url: "DB_DAILY_REPORTS_PROJECT_PERMITS.php",
            type: "POST",
            data: formElement+"&choice="+choice,
            success: function(response){
                var msg_alert=response;
                $('.preloader', window.parent.document).hide();
                if(msg_alert==1){
                    $(document).doValidation({rule:'messagebox',prop:{msgtitle:"PROJECT PERMITS",msgcontent:err_msg[0],position:{top:150,left:500}}});
                    ARE_mulclear()
                    $('#ARE_lbl_lgnid').hide();
                    $('#ARE_lb_lgnid').hide();
                    $('#ARE_rd_sinemp').attr('checked',false);
                    $('#ARE_rd_allemp').attr('checked',false);
                }
                else if(msg_alert==0)
                {
                    $(document).doValidation({rule:'messagebox',prop:{msgtitle:"PROJECT PERMITS",msgcontent:err_msg[4],position:{top:150,left:500}}});
                    ARE_mulclear()
                    $('#ARE_lbl_lgnid').hide();
                    $('#ARE_lb_lgnid').hide();
                    $('#ARE_rd_sinemp').attr('checked',false);
                    $('#ARE_rd_allemp').attr('checked',false);
                }
                else
                {
                    $(document).doValidation({rule:'messagebox',prop:{msgtitle:"PROJECT PERMITS",msgcontent:msg_alert,position:{top:150,left:500}}});
                    ARE_mulclear()
                    $('#ARE_lbl_lgnid').hide();
                    $('#ARE_lb_lgnid').hide();
                    $('#ARE_rd_sinemp').attr('checked',false);
                    $('#ARE_rd_allemp').attr('checked',false);
                }
            }
        });
    });
// FUNCTION FORM MULTIPLE ENTRY CLEAR FUNCTION
    function ARE_mulclear()
    {
        $('#ARE_lbl_sdte').hide();
        $('#ARE_tb_sdate').hide();
        $('#ARE_lbl_edte').hide();
        $('#ARE_tb_edate').hide();
        $('#ARE_lbl_reason').hide();
        $('#ARE_ta_reason').hide();
        $('#ARE_tbl_reason').html('');
        $('#ARE_btn_save').hide();
        $('#ARE_tbl_attendence').hide();
        $('#ARE_lbl_attdnce').hide();
        $('#ARE_lb_attdnce').hide();
        $('#ARE_lbl_norole_err').hide();
//        $('#wPaint1').wPaint('clear');
    }
    // ONDUTY ENTRY VALIDATION STARTS
    $('.enable').change(function(){
        if($("#ARE_ta_des").val()=='')
        {
            $("#ARE_btn_odsubmit").attr("disabled", "disabled");
        }
        else
        {
            $("#ARE_btn_odsubmit").removeAttr("disabled");
            $("#ARE_btn_odsubmit").show();
        }
    });
    //CHANGE EVENT ONDUTY ENTRY DATE FUNCTION
    $('#ARE_tb_dte').change(function(){
//        $("html, body").animate({ scrollTop: $(document).height() }, "fast");
        $('.preloader', window.parent.document).show();
        var reportdate=$('#ARE_tb_dte').val();
        var xmlhttp=new XMLHttpRequest();
        xmlhttp.onreadystatechange=function() {
            if (xmlhttp.readyState==4 && xmlhttp.status==200) {
                var msgalert=xmlhttp.responseText;
                $('.preloader', window.parent.document).hide();
                if(msgalert==1)
                {
                    var msg=err_msg[3].toString().replace("[DATE]",reportdate);
                    $('#ARE_lbl_oderrmsg').text(msg).show();
                    $('#ARE_tb_dte').val('').show();
                }
                else
                {
                    $('#ARE_lbl_oderrmsg').text(msg).hide();
                    $('#ARE_lbl_des').show();
                    $("#ARE_ta_des").show();
                    $("#ARE_btn_odsubmit").show();
                }
            }
        }
        var choice="ODDATE"
        xmlhttp.open("GET","DB_DAILY_REPORTS_PROJECT_PERMITS.php?date_change="+reportdate+"&option="+choice,true);
        xmlhttp.send();
    });
// CLICK EVENT ONDUTY SAVE BUTTON
    $('#ARE_btn_odsubmit').click(function(){
        $('.preloader', window.parent.document).show();
        var formElement = document.getElementById("ARE_form_adminreportentry");
        var xmlhttp=new XMLHttpRequest();
        xmlhttp.onreadystatechange=function() {
            if (xmlhttp.readyState==4 && xmlhttp.status==200) {
                var msg_alert=xmlhttp.responseText;
                $('.preloader', window.parent.document).hide();
                $(document).doValidation({rule:'messagebox',prop:{msgtitle:"ONDUTY ENTRY",msgcontent:msg_alert,position:{top:150,left:500}}});
                $('#ARE_tb_dte').val('');
                $('#ARE_ta_des').val('');
                $('#ARE_lbl_des').hide();
                $("#ARE_ta_des").hide();
                $("#ARE_btn_odsubmit").hide();
            }
        }
        var choice="ONDUTY";
        xmlhttp.open("POST","DB_DAILY_REPORTS_PROJECT_PERMITS.php?option="+choice,true);
        xmlhttp.send(new FormData(formElement));
    });
});
//DOCUMENT READY FUNCTION END
</script>
<!--SCRIPT TAG END-->
</head>
<!--HEAD TAG END-->
<!--BODY TAG START-->
<body>
<div class="wrapper">
    <div  class="preloader MaskPanel"><div class="preloader statusarea" ><div style="padding-top:90px; text-align:center"><img src="image/Loading.gif"/></div></div></div>
    <div class="title"><div style="padding-left:500px; text-align:left;" ><p><h3>PROJECT PERMITS</h3><p></div></div>
    <form name="ARE_form_adminreportentry" id="ARE_form_adminreportentry" class="content" method="POST">
        <table>
            <tr>
                <td width="150"><label name="ARE_lbl_optn" id="ARE_lbl_optn" >SELECT A OPTION</label><em>*</em></td>
                <td width="150">
                    <select id="option" name="option">
                        <option>SELECT</option>
                        <option>PROJECT PERMITS</option>
                        <option>ONDUTY REPORT ENTRY</option>
                    </select>
                </td>
            </tr>
        </table>
        <table>
            <tr>
                <td><input type="radio" id="ARE_rd_sinentry" name="entry" value="SINGLE DAY ENTRY"hidden/>
                    <label name="entry" id="ARE_lbl_sinentry" hidden>SINGLE DAY ENTRY</label></td>
            </tr>
            <tr>
                <td><input type="radio" id="ARE_rd_mulentry" name="entry" value="MULTIPLE DAY ENTRY"hidden/>
                    <label name="entry" id="ARE_lbl_mulentry" hidden>MULTIPLE DAY ENTRY</label></td>
            </tr>
            <tr>
                <td><label name="ARE_lbl_multipleday" id="ARE_lbl_multipleday" class="srctitle" hidden>MULTIPLE DAY ENTRY</label></td>
            </tr>
            <tr>
                <td><input type="radio" id="ARE_rd_sinemp" name="ARE_rd_emp" value="FOR SINGLE EMPLOYEE"hidden/>
                    <label name="ARE_lbl_emp" id="ARE_lbl_sinemp" hidden>FOR SINGLE EMPLOYEE</label></td>
            </tr>
            <tr>
                <td><input type="radio" id="ARE_rd_allemp" name="ARE_rd_emp" value="FOR ALL EMPLOYEE"hidden/>
                    <label name="ARE_lbl_emp" id="ARE_lbl_allemp" hidden>FOR ALL EMPLOYEE</label></td>
            </tr>
        </table>
        <table id="ARE_tble_singledayentry" hidden>
            <tr>
                <td width="150">
                    <label name="ARE_lbl_loginid" id="ARE_lbl_loginid" >EMPLOYEE NAME</label></td>
                <td>
                    <select name="ARE_lb_loginid" id="ARE_lb_loginid">
                    </select><br>
                </td><td><label id="ARE_lbl_norole_err" name="ARE_lbl_norole_err" class="errormsg" ></label></td></tr><br>
            <tr>
                <td width="150"><label name="ARE_lbl_dte" id="ARE_lbl_dte" hidden>DATE</label></td>
                <td><input type ="text" id="ARE_tb_date" class='proj datemandtry' hidden name="ARE_tb_date" style="width:75px;" /></td>
            </tr>
            <table id="ARE_tble_attendence" >
                <tr>
                    <td width="150"><label name="ARE_lbl_attendance" id="ARE_lbl_attendance" >ATTENDANCE</label></td>
                    <td width="150">
                        <select id="ARE_lb_attendance" name="ARE_lb_attendance">
                            <option>SELECT</option>
                            <option value="1">PRESENT</option>
                            <option value="0">ABSENT</option>
                            <option value="OD">ONDUTY</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td><input type="radio" name="permission" id="ARE_rd_permission" class='permissn'value="PERMISSION" hidden >
                        <label name="ARE_permission" id="ARE_lbl_permission">PERMISSION<em>*</em></label></td>
                    <td>
                        <select name="ARE_lb_timing" id="ARE_lb_timing" hidden >

                        </select>
                    </td>
                </tr>
                <tr>
                    <td nowrap><input type="radio" name="permission" id="ARE_rd_nopermission" class='permissn' value="NOPERMISSION" hidden >
                        <label name="ARE_nopermission" id="ARE_lbl_nopermission" nowrap>NO PERMISSION<em>*</em></label></td>
                </tr>
                <tr>
                    <td><label name="ARE_lbl_session" id="ARE_lbl_session" hidden >SESSION</label></td>
                    <td><select name="ARE_lb_ampm" id="ARE_lb_ampm" >
                            <option>SELECT</option>
                            <option>FULLDAY</option>
                            <option>AM</option>
                            <option>PM</option>
                        </select></td>
                </tr>
            </table>
            <table id="ARE_tble_reasonlbltxtarea"></table>
            <table id="ARE_tble_projectlistbx" hidden>
                <tr><td width="150"><label name="ARE_lbl_txtselectproj" id="ARE_lbl_txtselectproj" >PROJECT</label><em>*</em></td>
                    <td> <table id="ARE_tble_frstsel_projectlistbx" ></table></td>
                </tr>
            </table>
            <table id="ARE_tbl_enterthereport"></table>
            <table id="ARE_tble_paint" width=820></table>
            <table id="ARE_tble_attachment">
                <tr>
                    <td> </td>
                    <td>
                        <table ID="filetableuploads">

                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="150"><label></label></td>
                    <td>
                        <span id="attachprompt"><img width="15" height="15" src="https://ssl.gstatic.com/codesite/ph/images/paperclip.gif" border="0">
                        <a href="javascript:_addAttachmentFields('attachmentarea')" id="attachafile">Attach a file</a>
                        </span>
                    </td>
                </tr>
            </table>
            <tr>
                <input type="button"  class="btn" id="ARE_btn_submit" name="SAVE" value="SUBMIT"/>
            </tr>

            <td><label id="ARE_lbl_errmsg" name="ARE_lbl_errmsg" class="errormsg"></label></td>
            <td><label id="ARE_lbl_checkmsg" name="ARE_lbl_checkmsg" class="errormsg"></label></td>
        </table>
        <table id="ARE_tble_mutipledayentry" hidden>
            <tr>
                <td width="150">
                    <label name="ARE_lbl_lgnid" id="ARE_lbl_lgnid" >EMPLOYEE NAME</label></td>
                <td>
                    <select name="ARE_lb_lgnid" id="ARE_lb_lgnid">
                    </select><br>
                </td></tr><br>
            <tr>
                <td width="150"><label name="ARE_lbl_sdte" id="ARE_lbl_sdte" hidden>FROM DATE</label></td>
                <td><input type ="text" id="ARE_tb_sdate" class='proj datemandtry change valid' hidden name="ARE_tb_sdate" style="width:75px;" /></td>
            </tr>
            <tr>
                <td width="150"><label name="ARE_lbl_edte" id="ARE_lbl_edte" hidden>TO DATE</label></td>
                <td><input type ="text" id="ARE_tb_edate" class='proj datemandtry change valid' hidden name="ARE_tb_edate" style="width:75px;" /></td>
            </tr>
            <table id="ARE_tbl_attendence">
                <tr>
                    <td width="150"><label name="ARE_lbl_attdnce" id="ARE_lbl_attdnce" >ATTENDANCE</label></td>
                    <td width="150">
                        <select id="ARE_lb_attdnce" name="ARE_lb_attdnce">
                            <option>SELECT</option>
                            <option value="0">ABSENT</option>
                            <option value="OD">ONDUTY</option>
                        </select>
                    </td>
                </tr>
            </table>
            <table id="ARE_tbl_reason"></table>
            <!--            <table id="ARE_tble_mulpaint" width="820"></table>-->
            <input type="button"  class="btn" name="ARE_btn_save" id="ARE_btn_save"  value="SAVE" >
            </tr>
            <td><label id="ARE_msg" name="ARE_msg" class="errormsg"></label></td>
        </table>
        <table id="ARE_tble_ondutyentry" hidden>
            <tr>
                <td width="150"> <label name="ARE_lbl_dte" id="ARE_lbl_dte">DATE</label></td>
                <td><input type="text" id="ARE_tb_dte" name="ARE_tb_dte" class='proj datemandtry enable' style="width:75px;"/></td>
            </tr>
            <tr>
                <td width="150"> <label name="ARE_lbl_des" id="ARE_lbl_des" hidden>DESCRIPTION</label></td>
                <td><textarea id="ARE_ta_des" name="ARE_ta_des" class='enable' hidden></textarea></td>
            </tr>
            <tr>
                <td><input type="button" id="ARE_btn_odsubmit" name="ARE_btn_odsubmit" value="SAVE" class="btn" disabled hidden /></td>
            </tr>
        </table>
        <label id="ARE_lbl_oderrmsg" name="ARE_lbl_oderrmsg" class="errormsg"></label>
    </form>
</div>
</body>
<!--BODY TAG END-->
</html>
<!--HTML TAG END-->