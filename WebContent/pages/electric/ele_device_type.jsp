<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
</head>

<%
	String functionName = "设备类型维护"; //功能名称
	String TableName = "ELE_DEVICE_TYPE";  //数据库表名
	String SubTableName = "ELE_DEVICE_TYPE_REGISTER";  //数据库表名
	
	String processBO = "com.app.sys.CommonBO";
	String processMETHOD = "common";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO+"&TABLE="+TableName+"&SUBTABLE="+SubTableName;
%>

<script type="text/javascript">  
	var $grid;
	var $subgrid;
	var $dialog;
	var $form;
	
	$(function ()
	{        	
		$("#pageloading").hide();	
				
		$grid = $("#maingrid").ligerGrid({
	        height:'100%',width:'100%',heightDiff:-3,
	        columns: [  //主表的标题栏位定义
	            { display: '设备类型编号', name: 'DEVICE_TYPE_ID', width: 80 },
	            { display: '设备类型名称', name: 'DEVICE_TYPE_NAME', width: 150 },
	            { display: '通讯协议', name: 'PROTOCOL_ID' , width: 150},
	            { display: '使用预制模板', name: 'CUSTOMIZE_TEMPLET' , width: 150}
	        ], pageSize:20 ,rownumbers:true,allowUnSelectRow: true,
	        url:'<%=serverUrl%>'+'&ACTION=select-page',
	        toolbar: { items: [
	            { text: '新增', click: toolbarAction, icon: 'add' },
	            { line: true },
	            { text: '修改', click: toolbarAction, icon: 'modify' },
	            { line: true },
	            { text: '删除', click: toolbarAction, icon: 'delete' },
	            { line: true },
	            { text: '查看', click: toolbarAction, icon: 'view' },
	            { line: true },
	            { text: '查询', click: toolbarAction, icon: 'search' }
	        ]},
	        onDblClickRow : function (data, rowindex, rowobj)
            {
	        	toolbarAction({icon:'view'});
            }
	    });
		

		$form = $("#mainform").ligerForm({
	    	inputWidth: 200, labelWidth: 100, space:50, validate:true, align: 'center',width: '98%',
	    	fields:[	//主表的表单栏位定义
	    		{ display: "设备类型编号",name:"DEVICE_TYPE_ID",type:"text",validate:{required:true}},
	    		{ display: "设备类型名称",name:"DEVICE_TYPE_NAME",type:"text",validate:{required:true}},
	    		{ display: "通讯协议",name:"PROTOCOL_ID",type:"select",validate:{required:true},options:{
					data:[{id:'MODBUS',text:'MODBUS'},{id:'IEC104',text:'IEC104'}]
				}},
	    		{ display: "使用预制模板",name:"CUSTOMIZE_TEMPLET",type:"radiolist",validate:{required:true},options:{
					data:[{id:'true',text:'是'},{id:'false',text:'否'}],
					value:'false'
				}} 
	    	],
	    	buttons:[{text:"确认",click: doAction}]
	    });
		
		$subgrid = $("#subgrid").ligerGrid({
	        height:'99%',width:'98%',
	        columns: [  //子表的标题栏位定义
	            { display: '寄存器编号', name: 'REGISTER_ID',  width: 80 ,editor: { type: 'text' } },
	            { display: '寄存器名称', name: 'REGISTER_NAME' , width: 100 ,editor: { type: 'text' } },
	            { display: '寄存器地址', name: 'REGISTER_ADDRESS', width: 80 ,editor: { type: 'int' } },
	            { display: '寄存器长度', name: 'REGISTER_LENGTH', width: 100 ,editor: { type: 'int' } },
	            { display: '寄存器类型', name: 'REGISTER_TYPE' , width: 100 ,editor: { type: 'select' ,
	            	data:[{id:'1',text:'线圈寄存器'},{id:'2',text:'离散输入寄存器'},{id:'3',text:'保持寄存器'},{id:'4',text:'输入寄存器'}]}
	            },
	            { display: '自动获取数据', name: 'REGISTER_BREAK' , width: 100 ,editor: { type: 'select' , 
	            	data:[{id:'true',text:'是'},{id:'false',text:'否'}]} 
	            },
                {display: '寄存器折算公式', name: 'REGISTER_MULTIPLY', width: 100, editor: {type: 'text'}},
	            { display: '寄存器内容单位', name: 'REGISTER_UNIT' , width: 100 ,editor: { type: 'text' } },
	            { display: '寄存器错误内容', name: 'REGISTER_ERR' , width: 100 ,editor: { type: 'text' } },
	            { display: '寄存器错误提示', name: 'REGISTER_ERR_NAME' , width: 100 ,editor: { type: 'text' } },
	            { display: '预警上线', name: 'MONITOR_MAX' , width: 100 ,editor: { type: 'int' } },
	            { display: '预警下线', name: 'MONITOR_MIN' , width: 100 ,editor: { type: 'int' } },
	            { display: '图表模板类型', name: 'TEMPLET_ID' , width: 100 ,editor: { type: 'select' , 
	            	data:[{id:'0',text:'预制模板'},{id:'1',text:'曲线图'},{id:'2',text:'区域图'},{id:'3',text:'柱状图'},
	            	      {id:'4',text:'饼状图'},{id:'5',text:'仪表图'},{id:'6',text:'数字图'}]}
	            } 
	        ],  usePager: false ,rownumbers:true, enabledEdit: true, isScroll: false,
	        toolbar: { items: [
	            { text: '新增', click: addNewRow, icon: 'add' },
	            { line: true },
	            { text: '删除', click: deleteRow, icon: 'delete' }
	        ]
	        }
	    });

	});  
	
	var action = "";
	function toolbarAction(item)
	{
		action = item.icon;
		if (action == "add"){  //新增数据
			$subgrid.set({data: []});
			$form.setData({DEVICE_TYPE_ID:'',DEVICE_TYPE_NAME:'',PROTOCOL_ID:'',CUSTOMIZE_TEMPLET:'false'});  
			$form.setEnabled(['DEVICE_TYPE_ID','DEVICE_TYPE_NAME','PROTOCOL_ID','CUSTOMIZE_TEMPLET'],true);
			$dialog = $.ligerDialog.open({height: 'auto',width: 800,target: $("#maindialog"),title:'新增数据'});
		}else if (action == "modify"){  //修改数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}			
			$form.setData(select);
			$form.setEnabled(['DEVICE_TYPE_ID','DEVICE_TYPE_NAME','PROTOCOL_ID','CUSTOMIZE_TEMPLET'],true);
			$form.setEnabled(['DEVICE_TYPE_ID'],false);
			doAction('select-sub');
			$dialog = $.ligerDialog.open({height: 'auto',width: 800,target: $("#maindialog"),title:'修改数据'});			
		}else if (action == "delete"){  //删除数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setEnabled(['DEVICE_TYPE_ID','DEVICE_TYPE_NAME','PROTOCOL_ID','CUSTOMIZE_TEMPLET'],false);
			doAction('select-sub');
			$dialog = $.ligerDialog.open({height: 'auto',width: 800,target: $("#maindialog"),title:'删除数据'});
		}else if (action == "view"){  //查看数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setEnabled(['DEVICE_TYPE_ID','DEVICE_TYPE_NAME','PROTOCOL_ID','CUSTOMIZE_TEMPLET'],false);
			doAction('select-sub');
			$dialog = $.ligerDialog.open({height: 'auto',width: 800,target: $("#maindialog"),title:'查看数据'});
		}else if (action == "search"){  //查找数据
			$grid.showFilter();
		}		
	}
	
	function doAction(act)
	{
		var thisact = action;
		if (act) {
			thisact = act;
		}
		
		if (thisact == 'view'){
			$dialog.hide();
			return;
		}
		
		var form = liger.get('mainform');
		if (thisact == 'select-sub' || form.valid()) {
	      	$("#pageloading").show();
	       	var param=$("#mainform").serialize();

	       	//加入子表数据
	       	var manager = $("#subgrid").ligerGetGridManager();
	       	manager.endEdit();
            param += '&SUBDATA='+encodeURI(JSON.stringify(manager.getData()));            
            
	       	$.ajax({
				type:'POST',
				url:'<%=serverUrl%>'+'&ACTION=' + thisact + '|select-all',
				dataType:'json',
				data:param,
				success:function(result)
			    {
					if (result.ERR == null){
	                	if (thisact == 'select-sub'){
	                		$subgrid.set({ data: result });
		                	$subgrid.sortedData = '';
	                	}else{
	                		if ($dialog) {
								$dialog.hide();
								$.ligerDialog.success('维护成功');
								$grid.reload();
							}
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

</script>	 

<body style="padding:4px; overflow:hidden;">
	<div class="l-loading" id="pageloading"></div>
	<div id="maingrid"></div>
	<div id="maindialog">
		<form id="mainform"></form>
		<div id="subgrid"></div>
	</div>
</body>
</html>