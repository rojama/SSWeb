<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
</head>

<%
	String functionName = "操作维护"; //功能名称
	String TableName = "aut_operation";  //数据库表名
	
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
		
		//$("#mainlayout").ligerLayout();
		
		$grid = $("#maingrid").ligerGrid({
			width: '100%', height: '100%',heightDiff:28,
			columns: [  //主表的标题栏位定义
                { display: '操作序号', name: 'OPE_ID', id:'OPE_ID', align: 'left', width: 150 },
                { display: '操作编号', name: 'OPE_CODE', id:'OPE_CODE', align: 'left', width: 100 },
                { display: '简体中文名称', name: 'OPE_NAME', id:'OPE_NAME', width: 100 },	
                { display: '英文名称', name: 'OPE_ENGNAME', id:'OPE_ENGNAME', width: 100 },	
                { display: '繁体中文名称', name: 'OPE_TWNAME', id:'OPE_TWNAME', width: 100 },
                { display: '维护时间', name: 'SYSTEM_DATETIME', width: 150 }
	        ], usePager: false, rownumbers:true,allowUnSelectRow: true,
	        url:'<%=serverUrl%>'+'&ACTION=select-page',
	        toolbar: { items: [
	            { text: '新增', click: toolbarAction, icon: 'add' },
	            { line: true },
	            { text: '修改', click: toolbarAction, icon: 'modify' },
	            { line: true },
	            { text: '删除', click: toolbarAction, icon: 'delete' },
	            { line: true },
	            { text: '查询', click: toolbarAction, icon: 'search' }
	        ]
	        }
	    });
		
		$form = $("#mainform").ligerForm({
	    	inputWidth: 200, labelWidth: 100, space:50, validate:true, align: 'center',width: '98%',
	    	fields:[	//主表的表单栏位定义
   	        	{ display: "操作序号",name:"OPE_ID",type:"text",validate:{required:true}},
        		{ display: "操作编号",name:"OPE_CODE",type:"text",validate:{required:true}},
        		{ display: "简体中文名称",name:"OPE_NAME",type:"text",validate:{required:true}},
        		{ display: "英文名称",name:"OPE_ENGNAME",type:"text",validate:{required:false}},
        		{ display: "繁体中文名称",name:"OPE_TWNAME",type:"text",validate:{required:false}},
        		{ display: "维护时间",name:"SYSTEM_DATETIME",type:"text",validate:{required:false}}
	    	],
	    	buttons:[{text:"确认",click: doAction}]
	    });
	});  
	
	var action = "";
	function toolbarAction(item)
    {
    	action = item.icon;
    	if (action == "add"){
    		$form.setData({OPE_ID:'UUID自动',OPE_CODE:'',OPE_NAME:'',OPE_ENGNAME:'',OPE_TWNAME:'',SYSTEM_DATETIME:'TIME自动'});
    		var select = $grid.getSelectedRow();        		
    		if (select != null){
    			$form.setData({OPE_SUPER_ID:select.OPE_ID});
       		}
    		$form.setEnabled(['OPE_CODE','OPE_NAME','OPE_ENGNAME','OPE_TWNAME'],true);
    		$form.setEnabled(['OPE_ID','SYSTEM_DATETIME'],false);
    	}else if (action == "modify"){
    		var select = $grid.getSelectedRow();
    		if (select == null){
    			 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
    			 setTimeout(function () { manager.close(); }, 3000);
    			 return;
    		}
    		$form.setData(select);
    		$form.setData({SYSTEM_DATETIME:'TIME自动'});
    		$form.setEnabled(['OPE_ID','OPE_NAME','OPE_ENGNAME','OPE_TWNAME'],true);
    		$form.setEnabled(['OPE_ID','SYSTEM_DATETIME'],false);
    	}else if (action == "delete"){
    		var select = $grid.getSelectedRow();
    		if (select == null){
    			 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
    			 setTimeout(function () { manager.close(); }, 3000);
    			 return;
    		}
    		$form.setData(select);
    		$form.setEnabled(['OPE_ID','OPE_CODE','OPE_NAME','OPE_ENGNAME','OPE_TWNAME','SYSTEM_DATETIME'],false);        		
    	}else if (action == "search"){  //查找数据
			$grid.showFilter();
    		return;
		}
    	$dialog = $.ligerDialog.open({height: 500,width: 500,target: $("#mainform")});
    	action = action+'|select-all';
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

<body style="padding:4px">
	<div class="l-loading" id="pageloading"></div>
	<div id="mainlayout">	
		<div id="maingrid" position="center" title="<%=functionName%>"></div>
	</div>
	<form id="mainform" style="display:none;"></form>
</body>
</html>