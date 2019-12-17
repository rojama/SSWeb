<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
<%@ page import="org.apache.shiro.SecurityUtils"
import="org.apache.shiro.session.Session"
import="org.apache.shiro.subject.Subject"%>
<!--<link href="${pageContext.request.contextPath}/css/bootstrap.css" rel="stylesheet" type="text/css" />-->
<script src="${pageContext.request.contextPath}/js/jquery.qrcode.min.js" type="text/javascript"></script>
</head>

<%
	String functionName = "单表维护"; //功能名称
	String TableName = "clbx_ccjhs";  //数据库表名
	String processDefinitionKey = "6dad15b30c494e69b6dc2ffc1369d225";  //流程键
	String SubTableName = "clbx_ccjhs_sub";  //数据库表名
	
	String processBO = "com.app.sys.CommonBO";
	String processMETHOD = "common";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO+"&TABLE="+TableName+"&PROKEY="+processDefinitionKey+"&SUBTABLE="+SubTableName;
%>

<script type="text/javascript">  
var $form;
var $subgrid;
var $btn;
var qcode;
var groupicon = "../../js/ligerUI/skins/icons/communication.gif";

$(function ()
{
	
	$("#mainlayout").ligerLayout();
	
	$form = $("#mainform").ligerForm({ 
    	inputWidth: 200, labelWidth: 100, space:50, validate:true, align: 'center',width: '98%',
    	fields:[	//主表的表单栏位定义
    	    { display: "申请单号",name:"sqbh",type:"text",validate:{required:true}, group: "基础信息",groupicon: groupicon},
    		{ display: "申请日期",name:"sqrq",type:"date",validate:{required:true}},
    		{ display: "出差范围",name:"ccfw",type:"select",newline: false,validate:{required:true},
	    		editor: {
					data:[{id:'1',text:'是'},{id:'2',text:'否'}],
					value:'2'
				}
    		},
    		{ display: "出差起始日期",name:"ccqsrq",type:"date",validate:{required:true},editor:{onChangeDate:caldate}},
    		{ display: "申请人",name:"sqr",type:"text",newline: false,validate:{required:true}} , 
    		{ display: "出差地点",name:"ccdd",type:"text",validate:{required:true},editor:{onBlur:code}},
    		{ display: "出差结束日期",name:"ccjsrq",type:"date",newline: false,validate:{required:true},editor:{onChangeDate:caldate}},
    		{ display: "费用归属部门",name:"fyjsbm",type:"text",validate:{required:true},editor:{onBlur:caldate}},
    		{ display: "推荐宾馆",name:"tjbg",type:"text",newline: false,validate:{required:false}},
    		{ display: "总计天数",name:"zjts",type:"int",validate:{required:true}},
    		{ display: "出差人员名单",name:"ccrymd",type:"text",validate:{required:true}},
    		{ display: "人数",name:"rs",type:"int",newline: false,validate:{required:true}},
    		{ display: "工作任务计划",name:"gzrwjh",type:"textarea",width:320,validate:{required:true}, group: "任务计划",groupicon: groupicon},
    		{ display: "二维码",name:"ewm",type:"textarea",newline: false,width:80,validate:{required:true}},
    		{ display: "计划达成目标",name:"jhdcmb",type:"textarea",width:550,validate:{required:true}}, 
    		
    		{ display: "流程文件",name:"FileInput",type:"popup",validate:{required:false},group: "费用预算",groupicon: groupicon,
        		editor: {
    				onButtonClick: selectFileInput
    			}
    		}
    	]
    	
    });
	
	$form.setData({sqbh:'UUID',sqrq:new Date(),sqr:"<%=SecurityUtils.getSubject().getPrincipal()%>"});
	
	$form.setEnabled(['sqrq','sqr','sqbh'],false);
	
	
	$subgrid = $("#subgrid").ligerGrid({
        height:'99%',width: '660',
        columns: [  //子表的标题栏位定义
            { display: '费用类别', name: 'fylb', align: 'left', width: 150 ,editor: { type: 'text' } },
            { display: '金额', name: 'je', width: 300 ,editor: { type: 'number' },
            	render: function(item)
                {
                    return formatCurrency(item.je) + "元";
                }
	            ,
	            totalSummary:
	            {
	                render: function (suminf, column, cell)
	                {
	                    return '合计：'+formatCurrency(suminf.sum) + "元";
	                }
	            }
            },
            
        ],  usePager: false ,rownumbers:true, enabledEdit: true, isScroll: false,
        data: { Rows: [{fylb:'ddd',je:0},{fylb:'ddd',je:0}] },
        toolbar: { items: [
            { text: '新增', click: addNewRow, icon: 'add' },
            { line: true },
            { text: '删除', click: deleteRow, icon: 'delete' }
        ]
        }
    });
	
	
	$btn = $("#btn").ligerButton(
    {
        click: doAction, text:'确认'
    }
    );

	qcode = $("#ewm").parent();
	qcode.empty();
});

function code(){
	qcode.empty();
	qcode.qrcode({ 
	    render: "table", //table方式 
	    width: 80, //宽度 
	    height:80, //高度 
	    text: utf16to8($form.getData().ccdd + $form.getData().sqr) //任意内容 
	});
	
}

function utf16to8(str) {  
    var out, i, len, c;  
    out = "";  
    len = str.length;  
    for (i = 0; i < len; i++) {  
        c = str.charCodeAt(i);  
        if ((c >= 0x0001) && (c <= 0x007F)) {  
            out += str.charAt(i);  
        } else if (c > 0x07FF) {  
            out += String.fromCharCode(0xE0 | ((c >> 12) & 0x0F));  
            out += String.fromCharCode(0x80 | ((c >> 6) & 0x3F));  
            out += String.fromCharCode(0x80 | ((c >> 0) & 0x3F));  
        } else {  
            out += String.fromCharCode(0xC0 | ((c >> 6) & 0x1F));  
            out += String.fromCharCode(0x80 | ((c >> 0) & 0x3F));  
        }  
    }  
    return out;  
}


function formatCurrency(num)
{
    if (!num) return "0.00";
    num = num.toString().replace(/\$|\,/g, '');
    if (isNaN(num))
        num = "0.00";
    sign = (num == (num = Math.abs(num)));
    num = Math.floor(num * 100 + 0.50000000001);
    cents = num % 100;
    num = Math.floor(num / 100).toString();
    if (cents < 10)
        cents = "0" + cents;
    for (var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++)
        num = num.substring(0, num.length - (4 * i + 3)) + ',' +
num.substring(num.length - (4 * i + 3));
    return (((sign) ? '' : '-') + '' + num + '.' + cents);
}


function deleteRow()
{
    var manager = $("#subgrid").ligerGetGridManager();
    manager.deleteSelectedRow();
}
function addNewRow()
{
    var manager = $("#subgrid").ligerGetGridManager();
    manager.addRow();
} 


function caldate(){
	if ($form.getData().ccjsrq && $form.getData().ccqsrq){
		var day = ($form.getData().ccjsrq - $form.getData().ccqsrq)/24/3600/1000;
		if ($form) $form.setData({zjts:day});
	}	
}

function doAction()
{		
	var form = liger.get('mainform');
	var action = 'add|start-process';
	
	
	if (form.valid()) {
      	$("#pageloading").show();
       	var param=$("#mainform").serialize();
       	
        //加入子表数据
       	var manager = $("#subgrid").ligerGetGridManager();
       	manager.endEdit();
       	param += '&SUBDATA='+JSON.stringify(manager.getData());
    	
        
       	$.ajax({
			type:'POST',
			url:'<%=serverUrl%>'+'&ACTION='+action,
			dataType:'json',
			data:param,
			success:function(result)
		    {
				if (result.ERR == null){
					$.ligerDialog.success('交易成功,流程编号为：'+result.OrderNo);
               	}else{
               		$.ligerDialog.error(result.ERR);
               	}
				$("#pageloading").hide();					
		    }
		});       	
    } else {
    	form.showInvalid();
	}
}


var $fileDialog;
//打开上传框
function selectFileInput(){
	$fileDialog = $.ligerDialog.open({height: 100,width: 400,target: $("#Fileupload"), 
		buttons: [ { text: '确定', onclick: function (item, dialog) { selectFile(); } },
		           { text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
}
//确定文件选择
function selectFile() {
	var form = document.forms["Fileupload"];	
	if (form["upload"].files.length > 0)
	{
		var file = form["upload"].files[0];
		var reader = new FileReader();		
		reader.onloadend = function() {
			if (reader.error) {
				console.log(reader.error);
			} else {
				$form.getEditor('FileInput').setValue(reader.result);
	        	$form.getEditor('FileInput').setText($("#upload")[0].value);
	        	if ($fileDialog != null) $fileDialog.hide();
			}
		}
		reader.readAsBinaryString(file);
	}
	else
	{
		alert ("Please choose a file.");
	}
}
</script>

<body style="padding:4px">
	<div class="l-loading" id="pageloading"></div>	
	<div id="mainlayout">
		
		<div id="maingrid" position="center" title="<%=functionName%>">
			<form id="mainform" class="table table-bordered"></form>	
			<form id="Fileupload" style="display:none;">
				<table>
					<tr><td><input type="file" id="upload" /></td></tr>
				</table>
			</form>
			<div id="code"></div> 
			<div id="subgrid"></div>
			<br>
			<div id="btn"></div>
			
		</div>
	</div>
</body>
</html>