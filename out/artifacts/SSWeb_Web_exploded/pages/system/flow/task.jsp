<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
</head>

<%
	String functionName = "待办任务"; //功能名称
	//String TableName = "test";  //数据库表名
	
	String processBO = "com.app.snaker.SnakerServer";
	String processMETHOD = "task";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO;
%>

<script type="text/javascript">  
	var $grid;
	var $dialog;
	
	$(function ()
	{        	
		$("#pageloading").hide();	
		
		//$("#mainlayout").ligerLayout();
		
		$grid = $("#maingrid").ligerGrid({
	        height:'99%',width:'100%',
	        columns: [  //主表的标题栏位定义
	            { display: '任务编号', name: 'id', align: 'left', width: 80 },
	            { display: '任务名称', name: 'taskName', width: 80 },
	            { display: '任务显示名称', name: 'displayName', width: 150 },
	            { display: '任务创建时间', name: 'createTime', width: 150 },
	            { display: '任务到期时间', name: 'expireTime', width: 150 },
	            { display: '任务执行地址', name: 'actionUrl', width: 150 }
	        	], pageSize:20 ,rownumbers:true,
	        toolbar: { items: [
	            { text: '审批', click: toolbarAction, icon: 'true' , action: 'approve'},
	            { line: true },
	            { text: '驳回', click: toolbarAction, icon: 'candle', action: 'reject' },
	            { line: true },
	            { text: '处理', click: toolbarAction, icon: 'bookpen', action: 'process' },
	            { line: true },
	            { text: '查询', click: toolbarAction, icon: 'search' }
	        ]
	        }
	    });
		
		
		doAction('select-all');
	});  
	
	var action = "";
	function toolbarAction(item)
	{
		if (item.action){
			action = item.action;
		}else{
			action = item.icon;
		}
		if (action == "approve"){  //新增数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			doAction(action, select);
		}else if (action == "process"){  //处理数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$dialog = $.ligerDialog.open({height: 800,width: 1000, isResize:true, url: "${ctx}/"+select.actionUrl,title:'处理《'+select.displayName+'》任务'});
		}else if (action == "reject"){  //驳回数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$.ligerDialog.prompt('驳回原因', function (yes,value) { 
				if(yes) {
					select.reason = value;
					doAction("reject", select);
				}
			});
			
		}else if (action == "search"){  //查找数据
			$grid.showFilter();
		}
		action = action + '|select-all';
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
					if ($dialog) {
						$dialog.hide();
						$.ligerDialog.success('处理成功');
					}
                	$grid.set({ data: result });
                	$grid.sortedData = '';
                	
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
</body>
</html>