<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
</head>

<%
	String functionName = "菜单维护"; //功能名称
	String TableName = "aut_menu";  //数据库表名
	
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
	            { display: '编号', name: 'ID', align: 'left', width: 150 },
	            { display: '简体名称', name: 'NAME', width: 100 },
	            { display: '英文名称', name: 'ENGNAME', width: 100 },
	            { display: '繁体名称', name: 'TWNAME' , width: 100},
	            { display: '地址', name: 'URL',align: 'left', width: 250 },
	            { display: '可见', name: 'ISVALID', width: 50 },
	            { display: '排序', name: 'SORT_ORDER', width: 50 },
	            { display: '上级编号', name: 'TOPMENUID', width: 150 },
                { display: '维护时间', name: 'CREATE_DATE', width: 150 }
	        ], usePager: false,rownumbers:true,allowUnSelectRow: true,
	        tree: {
            	columnName: 'ID',
                idField: 'ID',
                parentIDField: 'TOPMENUID'
            },
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
	    		{ display: "编号",name:"ID",type:"text",validate:{required:true}},
	    		{ display: "简体名称",name:"NAME",type:"text",validate:{required:true}},
	    		{ display: "英文名称",name:"ENGNAME",type:"text",validate:{required:false}},
	    		{ display: "繁体名称",name:"TWNAME",type:"text",validate:{required:false}},
	    		{ display: "地址",name:"URL",type:"text",validate:{required:false}},
	    		{ display: "可见",name:"ISVALID",type:"text",validate:{required:false}},
	    		{ display: "排序",name:"SORT_ORDER",type:"int",validate:{required:false}},
	    		{ display: "上级编号",name:"TOPMENUID",type:"text",validate:{required:false}},
	    		{ display: "维护时间",name:"CREATE_DATE",type:"text",validate:{required:false}}
	    	],
	    	buttons:[{text:"确认",click: doAction}]
	    });
		
		action = 'select-all';
		doAction();
	});  
	
	var action = "";
	function toolbarAction(item)
	{
		action = item.icon;
		if (action == "add"){  //新增数据			
			$form.setData({ID:'UUID',NAME:'',ENGNAME:'',TWNAME:'',URL:'',ISVALID:'Y',SORT_ORDER:'0',TOPMENUID:'',CREATE_DATE:'TIME'});  
			$form.setEnabled(['NAME','ENGNAME','TWNAME','URL','ISVALID','SORT_ORDER','TOPMENUID'],true);
			$form.setEnabled(['ID','CREATE_DATE'],false);
			var select = $grid.getSelectedRow();        		
    		if (select != null){
    			$form.setData({TOPMENUID:select.ID});
       		}
			$dialog = $.ligerDialog.open({height: 500,width: 500,target: $("#mainform"),title:'新增数据'});
		}else if (action == "modify"){  //修改数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setData({CREATE_DATE:'TIME'});
			$form.setEnabled(['NAME','ENGNAME','TWNAME','URL','ISVALID','SORT_ORDER','TOPMENUID'],true);
			$form.setEnabled(['ID','CREATE_DATE'],false);
			$dialog = $.ligerDialog.open({height: 500,width: 500,target: $("#mainform"),title:'修改数据'});
		}else if (action == "delete"){  //删除数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setEnabled(['NAME','ENGNAME','TWNAME','URL','ISVALID','SORT_ORDER','TOPMENUID','CREATE_DATE'],false);
			$dialog = $.ligerDialog.open({height: 500,width: 500,target: $("#mainform"),title:'删除数据'});
		}else if (action == "search"){  //查找数据
			$grid.showFilter();
		}
		action = action + '|select-all';
	}
	
	function doAction()
	{		
		var form = liger.get('mainform');
		if (action == 'select-all' || form.valid()) {
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
						}
	                	$grid.set({ data: result });
	                	$grid.sortedData = '';
	                	
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