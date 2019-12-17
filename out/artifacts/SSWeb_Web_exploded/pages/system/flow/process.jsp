<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
		
</head>

<%
	String functionName = "流程部署"; //功能名称
	//String TableName = "test";  //数据库表名
	
	String processBO = "com.app.snaker.SnakerServer";
	String processMETHOD = "process";
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
	            { display: '流程编号', name: 'id', align: 'left', width: 80 },
	            { display: '流程名称', name: 'name', width: 80 },
	            { display: '流程显示名称', name: 'displayName', width: 150 },
	            { display: '流程版本', name: 'version', width: 150 },
	            { display: '流程启动地址', name: 'instanceUrl', width: 150 },
	            { display: '流程创建时间', name: 'createTime', width: 150 },
	            { display: '状态', name: 'state' , width: 150}
	        ], pageSize:20 ,rownumbers:true,
	        toolbar: { items: [
	            { text: '新增', click: toolbarAction, icon: 'add' },
	            { line: true },
	            { text: '修改', click: toolbarAction, icon: 'modify' },
	            { line: true },
	            { text: '删除', click: toolbarAction, icon: 'delete' },
	            { line: true },
	            { text: '启动', click: toolbarAction, icon: 'right', action: 'start' },
	            { line: true },
	            { text: '查询', click: toolbarAction, icon: 'search' }
	        ]
	        }
	    });
		
		doAction('select-all');
	});  

	function toolbarAction(item)
	{
		if (item.action){
			action = item.action;
		}else{
			action = item.icon;
		}
		if (action == "add"){  //新增数据
			$dialog = $.ligerDialog.open({height: 800,width: 1000, isResize:true, url: './processDesigner.jsp',title:'新增数据'});
		}else if (action == "modify"){  //修改数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$dialog = $.ligerDialog.open({height: 800,width: 1000, isResize:true, url: './processDesigner.jsp?process='+select.id,title:'修改数据'});
		}else if (action == "delete"){  //删除数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}			
			doAction('delete','processId='+select.id);			
		}else if (action == "search"){  //查找数据
			$grid.showFilter();
		}else if (action == "start"){  //启动数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			if(select.instanceUrl){  //有维护的用页面启动流程。
				$dialog = $.ligerDialog.open({height: 800,width: 1000, isResize:true, url: "${ctx}/"+select.instanceUrl,title:'启动《'+select.displayName+'》流程'});
			}else{
				doAction('start','processId='+select.id);
			}
		}
	}
	
	function doAction(action, param)
	{		
		var form = liger.get('mainform');
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
	}
</script>	 

<body style="padding:4px">
	<div class="l-loading" id="pageloading"></div>
	<div id="mainlayout">	
		<div id="maingrid" position="center" title="<%=functionName%>"></div>
	</div>

</body>
</html>