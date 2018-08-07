<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
</head>

<%
	String functionName = "流程监控"; //功能名称
	//String TableName = "test";  //数据库表名
	
	String processBO = "com.app.snaker.SnakerServer";
	String processMETHOD = "order";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO;
%>

<script type="text/javascript">  
	var $grid;
	var $dialog;
	var $hisgrid;
	
	$(function ()
	{        	
		$("#pageloading").hide();	
		
		//$("#mainlayout").ligerLayout();
		
		$grid = $("#maingrid").ligerGrid({
	        height:'99%',width:'100%',
	        columns: [  //主表的标题栏位定义
	            { display: '流程编号', name: 'id', align: 'left', width: 80 },
	            { display: '流程名称', name: 'processDisplayName', width: 80 },
	            { display: '流程发起人员', name: 'creator', width: 150 },
	            { display: '流程发起时间', name: 'createTime', width: 150 },
	            { display: '流程到期时间', name: 'expireTime', width: 150 },
	            { display: '流程更新时间', name: 'lastUpdateTime', width: 150 }
	        ], pageSize:20 ,rownumbers:true,
	        toolbar: { items: [
	            { text: '任务历史', click: toolbarAction, icon: 'view', action:'history'  },
	            { line: true },	           
	            { text: '查询', click: toolbarAction, icon: 'search', action:'search' }
	        ]
	        }
	    });
		
		$hisgrid = $("#hisgrid").ligerGrid({
			height:'420',width:'99%',
	        columns: [  //主表的标题栏位定义
	            { display: '任务编号', name: 'id', align: 'left', width: 80 },
	            { display: '任务名称', name: 'taskName', width: 80 },
	            { display: '任务显示名称', name: 'displayName', width: 100 },
	            { display: '任务创建时间', name: 'createTime', width: 150 },
	            { display: '任务到期时间', name: 'expireTime', width: 150 },
	            { display: '任务执行地址', name: 'actionUrl', width: 150 }
	        	], pageSize:20 ,rownumbers:true
	    });
		
		doAction('select-all');
	});  
	
	var action = "";
	function toolbarAction(item)
	{
		action = item.action;
		if (action == "history"){
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$dialog = $.ligerDialog.open({height: 500,width: 800,target: $("#hisgrid"),title:'任务历史数据'});
			doAction("history",select);
		}else if (action == "search"){  //查找数据
			$grid.showFilter();
		}
	}
	
	function doAction(action, param)
	{		
	      	$("#pageloading").show();
	       	
	       	$.ajax({
				type:'POST',
				url:'<%=serverUrl%>'+'&ACTION='+action,
				dataType:'json',
				data:param,
				success:function(result)
			    {
					if (result.ERR == null){						
						if (action == 'history'){
							$hisgrid.set({ data: result });
		                	$hisgrid.sortedData = '';
						}else{
							if ($dialog) {
								$dialog.hide();
								$.ligerDialog.success('维护成功');
							}
							$grid.set({ data: result });
		                	$grid.sortedData = '';
						}	                	
	                	
	               	}else{
	               		$.ligerDialog.error(result.ERR);
	               	}
					$("#pageloading").hide();
			    }
			});       	
	}
</script>	 

<body style="padding:4px">
	<div class="l-loading" id="pageloading"></div>
	<div id="mainlayout">	
		<div id="maingrid" position="center" title="<%=functionName%>"></div>
	</div>
	<form id="hisgrid" style="display:none;"></form>
</body>
</html>