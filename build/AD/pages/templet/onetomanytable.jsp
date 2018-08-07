<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
</head>

<%
	String functionName = "主子表维护"; //功能名称
	String TableName = "TEST";  //数据库表名
	String SubTableName = "SUBTEST";  //数据库表名
	
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
	            { display: '主编号', name: 'BLOCK_ID', align: 'left', width: 80 },
	            { display: '序号', name: 'TITLE_NO', width: 80 },
	            { display: '名称', name: 'TITLE_NAME', width: 150 },
	            { display: '分类', name: 'TYPE_ID' , width: 150}
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
	    		{ display: "主编号",name:"BLOCK_ID",type:"text",validate:{required:true}},
	    		{ display: "序号",name:"TITLE_NO",type:"text",validate:{required:true}},
	    		{ display: "名称",name:"TITLE_NAME",type:"text",validate:{required:true}},
	    		{ display: "分类",name:"TYPE_ID",type:"text",validate:{required:true}}  		
	    	],
	    	buttons:[{text:"确认",click: doAction}]
	    });
		
		$subgrid = $("#subgrid").ligerGrid({
	        height:'99%',width:'98%',
	        columns: [  //子表的标题栏位定义
	            { display: '子编号', name: 'sub_id', align: 'left', width: 80 ,editor: { type: 'text' } },
	            { display: '序号', name: 'TITLE_NO', width: 80 ,editor: { type: 'text' } },
	            { display: '名称', name: 'TITLE_NAME', width: 100 ,editor: { type: 'text' } },
	            { display: '分类', name: 'TYPE_ID' , width: 100 ,editor: { type: 'text' } }
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
			$form.setData({BLOCK_ID:'',TITLE_NO:'',TITLE_NAME:'',TYPE_ID:''});  
			$form.setEnabled(['BLOCK_ID','TITLE_NO','TITLE_NAME','TYPE_ID'],true);
			$dialog = $.ligerDialog.open({height: 'auto',width: 500,target: $("#maindialog"),title:'新增数据'});
		}else if (action == "modify"){  //修改数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}			
			$form.setData(select);
			$form.setEnabled(['TITLE_NO','TITLE_NAME','TYPE_ID'],true);
			$form.setEnabled(['BLOCK_ID'],false);
			doAction('select-sub');
			$dialog = $.ligerDialog.open({height: 'auto',width: 500,target: $("#maindialog"),title:'修改数据'});			
		}else if (action == "delete"){  //删除数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setEnabled(['BLOCK_ID','TITLE_NO','TITLE_NAME','TYPE_ID'],false);
			doAction('select-sub');
			$dialog = $.ligerDialog.open({height: 'auto',width: 500,target: $("#maindialog"),title:'删除数据'});
		}else if (action == "view"){  //查看数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setEnabled(['BLOCK_ID','TITLE_NO','TITLE_NAME','TYPE_ID'],false);
			doAction('select-sub');
			$dialog = $.ligerDialog.open({height: 'auto',width: 500,target: $("#maindialog"),title:'查看数据'});
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
            param += '&SUBDATA='+JSON.stringify(manager.getData());            
            
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
	<div id="maindialog" style="display:none;">
		<form id="mainform"></form>
		<div id="subgrid"></div>
	</div>
</body>
</html>