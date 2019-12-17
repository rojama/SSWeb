<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
</head>

<%
	String functionName = "参数维护"; //功能名称
	String TableName = "ele_setting";  //数据库表名
	
	String processBO = "com.app.sys.CommonBO";
	String processMETHOD = "common";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO+"&TABLE="+TableName;
%>

<script type="text/javascript">  
	var $grid;
	var $dialog;
	var $form;
	
	$(function ()
	{        	
		$("#pageloading").hide();	
				
		$grid = $("#maingrid").ligerGrid({
	        height:'100%',width:'100%',heightDiff:-3,
	        columns: [  //主表的标题栏位定义
	            { display: '设置编号', name: 'SETTING_ID', width: 80 },
	            { display: '设置名称', name: 'SETTING_NAME', width: 200 },
	            { display: '设置值', name: 'SETTING_VALUE', width: 150 }
	        ], pageSize:20 ,rownumbers:true,allowUnSelectRow: true,
	        url:'<%=serverUrl%>'+'&ACTION=select-page',
	        toolbar: { items: [
	            { text: '修改', click: toolbarAction, icon: 'modify' }
	        ]
	        }
	    });
		
		$form = $("#mainform").ligerForm({
	    	inputWidth: 300, labelWidth: 100, space:50, validate:true, align: 'center',width: '98%',
	    	fields:[	//主表的表单栏位定义
	    		{ display: "设置编号",name:"SETTING_ID",type:"text",validate:{required:true}},
	    		{ display: "设置名称",name:"SETTING_NAME",type:"text",validate:{required:true}},
	    		{ display: "设置值",name:"SETTING_VALUE",type:"text",validate:{required:true}}
	    	],
	    	buttons:[{text:"确认",click: doAction}]
	    });
	});  
	
	var action = "";
	function toolbarAction(item)
	{
		action = item.icon;
		if (action == "modify"){  //修改数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setEnabled(['SETTING_ID','SETTING_NAME','SETTING_VALUE'],true);
			$form.setEnabled(['SETTING_ID','SETTING_NAME'],false);
			$dialog = $.ligerDialog.open({height: 300,width: 500,target: $("#mainform"),title:'修改数据'});
		}
	}
	
	function doAction()
	{		
		var form = liger.get('mainform');
		if (form.valid()) {
	      	$("#pageloading").show();
	       	var param=$("#mainform").serialize();
	       	
	       	$.ajax({
				type:'POST',
				url:'<%=serverUrl%>'+'&ACTION='+action,
				dataType:'json',
				data:param,
				success:function(result)
			    {
					if (result.ERR == null){
						if ($dialog) {
							$dialog.hide();
							$.ligerDialog.success('维护成功');
							$grid.reload();
						}	                	
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
</script>	 

<body style="padding:4px; overflow:hidden;">
	<div class="l-loading" id="pageloading"></div>
	<div id="maingrid"></div>
	<form id="mainform"></form>
</body>
</html>