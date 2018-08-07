<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
</head>

<%
	String functionName = "报警级别设置"; //功能名称
	String TableName = "ELE_WARNING_LEVEL";  //数据库表名
	
	String processBO = "com.app.sys.CommonBO";
	String processMETHOD = "common";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO+"&TABLE="+TableName;
	
	String serverUrlSelect = request.getContextPath()+"/cm?ProcessBO=com.app.electric.ElectricPagesBean&ProcessMETHOD=select";
%>
<script src="./CustomersData.js"></script>

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
	            { display: '报警级别编号', name: 'LEVEL_ID', width: 80 },
	            { display: '报警级别名称', name: 'LEVEL_NAME', width: 150 },
	            { display: '持续时间（秒）', name: 'CONTINUE_TIME' , width: 150},
	            { display: '溢出比例（%）', name: 'OVERFLOW_BALANCE', width: 150 }
	        ], pageSize:20 ,rownumbers:true,allowUnSelectRow: true,
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
	    		{ display: "报警级别编号",name:"LEVEL_ID",type:"text",validate:{required:true}},
	    		{ display: "报警级别名称",name:"LEVEL_NAME",type:"text",validate:{required:true}},
	    		{ display: "持续时间(秒)",name:"CONTINUE_TIME",type:"int",validate:{required:true, min:0}},
	    		{ display: "溢出比例(%)",name:"OVERFLOW_BALANCE",type:"int",validate:{required:true, min:0}}  
	    	],
	    	buttons:[{text:"确认",click: doAction}]
	    });
		
	});  
	
	var action = "";
	function toolbarAction(item)
	{
		action = item.icon;
		if (action == "add"){  //新增数据
			$form.setData({LEVEL_ID:'',LEVEL_NAME:'',CONTINUE_TIME:'',OVERFLOW_BALANCE:''});  
			$form.setEnabled(['LEVEL_ID','LEVEL_NAME','CONTINUE_TIME','OVERFLOW_BALANCE'],true);
			$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform"),title:'新增数据'});
		}else if (action == "modify"){  //修改数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setEnabled(['LEVEL_ID','LEVEL_NAME','CONTINUE_TIME','OVERFLOW_BALANCE'],true);
			$form.setEnabled(['LEVEL_ID'],false);
			$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform"),title:'修改数据'});
		}else if (action == "delete"){  //删除数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setEnabled(['LEVEL_ID','LEVEL_NAME','CONTINUE_TIME','OVERFLOW_BALANCE'],false);
			$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform"),title:'删除数据'});
		}else if (action == "search"){  //查找数据
			$grid.showFilter();
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