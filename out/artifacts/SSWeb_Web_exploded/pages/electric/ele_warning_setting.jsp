<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
    
</head>

<%
	String functionName = "短信邮箱预警设置表"; //功能名称	
	String processBO = "com.app.electric.ElectricPagesBean";
	String processMETHOD = "ele_warning_setting";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO;
	
	String serverUrlSelect = request.getContextPath()+"/cm?ProcessBO=com.app.electric.ElectricPagesBean&ProcessMETHOD=select";
%>

<script type="text/javascript">  
	

	var $grid;
	var $dialog;
	var $form;
	
	$(function ()
	{        	
		$("#pageloading").show();	
		
		$("#mainlayout").ligerLayout({ leftWidth: 200});
		
		//加载树
		$tree = $("#maintree").ligerTree({
			needCancel: false,
			checkbox: false,
			single: true,
            idFieldName :'NODE_ID',
            textFieldName : 'NODE_NAME',
            parentIDFieldName :'UPPER_NODE_ID',            
            onSelect: loadGrid,
            iconFieldName: 'ICON'
        });	
		
		$.ajax({
			type:'POST',
			url:'<%=serverUrl%>'+'&ACTION=select-menu',
			dataType:'json',
			success:function(result)
		    {
				if (result.ERR == null){
                	$tree.set({ data: result.Rows });
                	$tree.tree.width('100%');  //自动拓展
               	}else{
               		$.ligerDialog.error(result.ERR);
               	}
				$("#pageloading").hide();
		    }
		});
		
		//加载表格
		$grid = $("#maingrid").ligerGrid({
            height:'99%',width:'100%',
            columns: [
                { display: '联系人', name: 'CONTACT', width: 120 },
                { display: '接收报警级别', name: 'LEVEL_ID', width: 120 },
                { display: '手机号', name: 'PHONE', width: 200 },
                { display: '邮箱', name: 'EMAIL', width: 220 }
            ], usePager: false, rownumbers:true,               
            toolbar: { items: [
                { text: '新增', click: toolbarAction, icon: 'add' },
                { line: true },
                { text: '修改', click: toolbarAction, icon: 'modify' },
                { line: true },
                { text: '删除', click: toolbarAction, icon: 'delete' }
            ]
            }
        });
		
		//加载表单
		$form = $("#mainform").ligerForm({
        	inputWidth: 200, labelWidth: 150, space:50, validate:true, align: 'center',width: '98%',
        	fields:[	//表单栏位
        		{ display: "联系人",name:"CONTACT",type:"text",validate:{required:true}},
        		{ display: "接收报警级别",name:"LEVEL_ID",type:"select",validate:{required:false},options:{
					url: '<%=serverUrlSelect%>'+'&ACTION=warning-level-list',
	    			valueField: 'LEVEL_ID', textField: 'LEVEL_NAME'
				}},
        		{ display: "手机号",name:"PHONE",type:"text",validate:{required:false}},
        		{ display: "邮箱",name:"EMAIL",type:"text",validate:{required:false}},
        	],
        	buttons:[{text:"确认",click: doAction}]
        });
		
		$("#pageloading").hide();	
	});  
	

	function loadGrid(node){
    	NODE_ID = node.data.NODE_ID;
		doAction('select', 'NODE_ID='+NODE_ID);			
    }
	
	 function toolbarAction(item)
     {
     	if (NODE_ID == ''){        		
     		var manager = $.ligerDialog.tip({ title: '提示',content:'请选择连接终端列表！'});
     		setTimeout(function () { manager.close(); }, 3000);
			 	return;
     	}
     	     	
     	action = item.icon;
     	if (action == "add"){
     		$form.setData({CONTACT:'',PHONE:'',EMAIL:''});
     		$form.setEnabled(['CONTACT','PHONE','EMAIL'],true);
     	}else if (action == "modify"){
     		var select = $grid.getSelectedRow();
     		if (select == null){
     			var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
     			setTimeout(function () { manager.close(); }, 3000);
     			return;
     		}
     		$form.setData(select);
     		$form.setEnabled(['PHONE','EMAIL'],true);
     		$form.setEnabled(['CONTACT'],false);
     	}else if (action == "delete"){
     		var select = $grid.getSelectedRow();
     		if (select == null){
     			var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
     			setTimeout(function () { manager.close(); }, 3000);
     			return;
     		}
     		$form.setData(select);
     		$form.setEnabled(['CONTACT','PHONE','EMAIL'],false);        		
     	}
     	$dialog = $.ligerDialog.open({title: item.text ,height: 500,width: 500,target: $("#mainform")});
     }
     
     function doAction(act, input)
	 {		
    	if (act != null) action = act;
		var form = liger.get('mainform');
		if (input != null || form.valid()) {
          		$("#pageloading").show();
           	var param=$("#mainform").serialize();
           	if (input != null) param = input;
           
           	if (NODE_ID != null) param += '&NODE_ID='+NODE_ID;  	//特殊处理
           	
           	$.ajax({
    			type:'POST',
    			url:'<%=serverUrl%>'+'&ACTION='+action,
    			dataType:'json',
    			data:param,
    			success:function(result)
    		    {
    				if (result.ERR == null){
	                	$grid.set({ data: result });
	                	$grid.sortedData = '';
	               	}else{
	               		$.ligerDialog.error(result.ERR);
	               	}
					$("#pageloading").hide();
					if ($dialog != null) $dialog.hide();
    		    }
    		});       	
        } else {
        	form.showInvalid();
		}
	 }
</script>	 

<body style="padding:4px; overflow:hidden;">
	<div class="l-loading" id="pageloading"></div>
	<div id="mainlayout">	
		<div position="left" title="连接终端列表" id="maintree" style="width:100%;height:95%;overflow-y:auto;">
		</div>
		<div position="center" title="预警通知人员列表" id="maingrid" style="width:1200px;position:relative">
		</div>
	</div>
	<form id="mainform"></form>
</body>
</html>