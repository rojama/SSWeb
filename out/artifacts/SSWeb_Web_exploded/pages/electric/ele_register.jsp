<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>

	<style type="text/css">
		.l-icon-write{ background:url('../../images/icons/some/page_white_paintbrush.png') no-repeat center;}
		.l-icon-read{ background:url('../../images/icons/some/page_white_text.png') no-repeat center;}
    </style>
</head>

<%
	String functionName = "寄存器操作"; //功能名称	
	String processBO = "com.app.electric.ElectricPagesBean";
	String processMETHOD = "ele_register";
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
				{ display: '区域编号', name: 'AREA_ID',id: 'AREA_ID',  width: 80 },
				{ display: '区域名称', name: 'AREA_NAME',id: 'AREA_NAME', width: 100 },
	            { display: '盒子编号', name: 'BOX_ID', width: 80 },
	            { display: '盒子名称', name: 'BOX_NAME', width: 100 },
				{ display: '设备编号', name: 'DEVICE_ID', width: 80 },
				{ display: '设备识别号', name: 'DEVICE_NUM', width: 80 },
				{ display: '设备名称', name: 'DEVICE_NAME', width: 100 },
				{ display: '设备类型', name: 'DEVICE_TYPE_ID', width: 100 },
				{ display: '通讯协议', name: 'PROTOCOL_ID', width: 100 },
                { display: '寄存器编号', name: 'REGISTER_ID',  width: 80 },
                { display: '寄存器名称', name: 'REGISTER_NAME' , width: 100 },
                { display: '寄存器地址', name: 'REGISTER_ADDRESS', width: 80 },
	            { display: '寄存器长度', name: 'REGISTER_LENGTH', width: 100 },	            
	            { display: '寄存器类型', name: 'REGISTER_TYPE' , width: 100 },
	            { display: '自动获取数据', name: 'REGISTER_BREAK' , width: 100 },
	            { display: '寄存器内容乘数', name: 'REGISTER_MULTIPLY' , width: 100 },
	            { display: '寄存器内容单位', name: 'REGISTER_UNIT' , width: 100 },
	            { display: '寄存器错误内容', name: 'REGISTER_ERR' , width: 100 },
	            { display: '寄存器错误提示', name: 'REGISTER_ERR_NAME' , width: 100 },
	            { display: '预警上线', name: 'MONITOR_MAX' , width: 100 },
	            { display: '预警下线', name: 'MONITOR_MIN' , width: 100 },
	            { display: '图表模板类型', name: 'TEMPLET_ID' , width: 100 }             
	            
            ], usePager: false, rownumbers:true,               
            toolbar: { items: [
                { text: '读取', click: toolbarAction, icon: 'read' },
                { line: true },
                { text: '写入', click: toolbarAction, icon: 'write' }
            ]
            }
        });
		
		//加载表单
		$form = $("#mainform").ligerForm({
        	inputWidth: 200, labelWidth: 200, space:50, validate:true, align: 'center',width: '98%',
        	fields:[	//表单栏位
        	    { display: '盒子编号', name: 'BOX_ID', type:"text",validate:{required:true}},
        	    { display: "设备编号",name:"DEVICE_ID",type:"text",validate:{required:true}},
        	    { display: "设备类型",name:"DEVICE_TYPE_ID",type:"text",validate:{required:true}},
        	    { display: "寄存器编号",name:"REGISTER_ID",type:"text",validate:{required:true}},
        		{ display: "寄存器名称",name:"REGISTER_NAME",type:"text",validate:{required:true}},
        		{ display: "通讯协议",name:"PROTOCOL_ID",type:"text",validate:{required:true}},        		
        		{ display: "寄存器值(线圈用ON/OFF表示)",name:"REGISTER_VALUE",type:"text",validate:{required:true}}
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
     	if (action == "read"){
     		var select = $grid.getSelectedRow();
     		if (select == null){
     			var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
     			setTimeout(function () { manager.close(); }, 3000);
     			return;
     		}
     		$form.setData(select);
     		$form.setData({REGISTER_VALUE:'读取'}); 
     		$form.setEnabled(['BOX_ID','DEVICE_ID','REGISTER_ID','REGISTER_NAME','DEVICE_TYPE_ID','PROTOCOL_ID','REGISTER_VALUE'],false);
     	}else if (action == "write"){
     		var select = $grid.getSelectedRow();
     		if (select == null){
     			var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
     			setTimeout(function () { manager.close(); }, 3000);
     			return;
     		}
     		$form.setData(select);
     		$form.setData({REGISTER_VALUE:''});  
     		$form.setEnabled(['BOX_ID','DEVICE_ID','REGISTER_ID','REGISTER_NAME','DEVICE_TYPE_ID','PROTOCOL_ID','REGISTER_VALUE'],false);
     		$form.setEnabled(['REGISTER_VALUE'],true);
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
	                	if (result.Rows) {
	                		$grid.set({ data: result });
	                	}
	                	$grid.sortedData = '';
	                	if ($dialog != null) {
	                		if ($dialog._getVisible()) {
	                			$.ligerDialog.success('维护成功,寄存器返回值：'+result.RECORD_DATA);
		                	}
	                	}
	                		
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
		<div position="center" title="寄存器列表" id="maingrid" style="width:1200px;position:relative">
		</div>
	</div>
	<form id="mainform"></form>
</body>
</html>