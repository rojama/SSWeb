<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
</head>

<%
	String functionName = "盒子管理"; //功能名称
	
	String processBO = "com.app.electric.ElectricPagesBean";
	String processMETHOD = "ele_box";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO;
	
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
	            { display: '盒子编号', name: 'BOX_ID', width: 80 },
	            { display: '所属区域编号', name: 'AREA_ID', width: 80 },
	            { display: '盒子名称', name: 'BOX_NAME', width: 150 },
	            { display: '连接端口', name: 'CONNECT_PORT' , width: 150},
	            { display: '盒子硬件号', name: 'BOX_NUM', width: 150 }
	        ], pageSize:20 ,rownumbers:true,allowUnSelectRow: true,
	        url:'<%=serverUrl%>'+'&ACTION=select-page',
	        toolbar: { items: [
	            { text: '新增', click: toolbarAction, icon: 'add' },
	            { line: true },
	            { text: '修改', click: toolbarAction, icon: 'modify' },
	            { line: true },
	            { text: '删除', click: toolbarAction, icon: 'delete' },
	            { line: true },
	            { text: '查询', click: toolbarAction, icon: 'search' },
	            { line: true },
	            { text: '重连', click: toolbarAction, icon: 'refresh' }
	        ]
	        }
	    });


		$form = $("#mainform").ligerForm({
	    	inputWidth: 200, labelWidth: 100, space:50, validate:true, align: 'center',width: '98%',
	    	fields:[	//主表的表单栏位定义
	    		{ display: "盒子编号",name:"BOX_ID",type:"text",validate:{required:true}},
	    		{ display: "所属区域编号",name:"AREA_ID",type:"select",validate:{required:true},options:{
	    			valueField: 'NODE_ID',textField: 'NODE_NAME',treeLeafOnly:false,
	    			tree:{ url: '<%=serverUrlSelect%>'+'&ACTION=area-tree',
	    				checkbox: false, 	    				
	    				idFieldName :'NODE_ID',
		                textFieldName : 'NODE_NAME',
		                parentIDFieldName :'UPPER_NODE_ID',            
		                iconFieldName: 'ICON' 
		            }
				}},
	    		{ display: "盒子名称",name:"BOX_NAME",type:"text",validate:{required:true}},
	    		{ display: "连接端口",name:"CONNECT_PORT",type:"int",validate:{required:true, min:1024, max:65535}},
	    		{ display: "盒子设备号",name:"BOX_NUM",type:"text",validate:{required:true}}
	    	],
	    	buttons:[{text:"确认",click: doAction}]
	    });
		
	});  
	
	var action = "";
	function toolbarAction(item)
	{
		action = item.icon;
		if (action == "add"){  //新增数据
			$form.setData({BOX_ID:'',AREA_ID:'',BOX_NAME:'',CONNECT_PORT:'',BOX_NUM:''});  
			$form.setEnabled(['BOX_ID','AREA_ID','BOX_NAME','CONNECT_PORT','BOX_NUM'],true);
			$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform"),title:'新增数据'});
		}else if (action == "modify"){  //修改数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setEnabled(['BOX_ID','AREA_ID','BOX_NAME','CONNECT_PORT','BOX_NUM'],true);
			$form.setEnabled(['BOX_ID'],false);
			$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform"),title:'修改数据'});
		}else if (action == "delete"){  //删除数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setEnabled(['BOX_ID','AREA_ID','BOX_NAME','CONNECT_PORT','BOX_NUM'],false);
			$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform"),title:'删除数据'});
		}else if (action == "search"){  //查找数据
			$grid.showFilter();
		}else if (action == "refresh"){  //重新连接盒子
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			doAction('&BOX_ID='+select.BOX_ID);
		}
	}
	
	function doAction(p)
	{		
		var form = liger.get('mainform');
		if (action == 'refresh' || form.valid()) {
	      	$("#pageloading").show();
	       	var param=$("#mainform").serialize();
	       	if (p) action = action + p;
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
						}else if (action == 'refresh'){
							$.ligerDialog.success('重连成功');
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