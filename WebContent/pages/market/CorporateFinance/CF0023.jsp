<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
</head>

<%
	String processBO = "com.app.TR.CorporateFinance";
	String processMETHOD = "CF0023";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO;
%>

<script type="text/javascript">  

var webSocket = 
	new WebSocket('ws://localhost:8080/appWeb/websocket?WSCODE=CF1001');

webSocket.onerror = function(event) {
	onError(event)
};

webSocket.onopen = function(event) {
	onOpen(event)
};

webSocket.onmessage = function(event) {
	onMessage(event)
};

function onMessage(event) {
	document.getElementById('messages').innerHTML 
		+= '<br />' + event.data;
   	$.ajax({
		type:'POST',
		url:'<%=serverUrl%>'+'&ACTION=getAll',
		dataType:'json',
		data:'',
		success:function(result)
	    {
		    
			if (result.ERR == null){
			
				
					$grid.reload();
	                	
           	}else{
           		$.ligerDialog.error(result.ERR);
           	}
			$("#pageloading").hide();					
	    }
	});       	
}

function onOpen(event) {
	document.getElementById('messages').innerHTML 
		= 'Connection established';
}

function onError(event) {
	alert(event.data);
}

function start() {
	webSocket.send('hello');
	return false;
}


	var $grid;
	var $dialog;
	var $form;
	
	$(function ()
	{        	
		$("#pageloading").hide();	
				
		$grid = $("#maingrid").ligerGrid({
	        height:'90%',width:'100%',heightDiff:-3,
	        columns: [  //主表的标题栏位定义
	            { display: "询价序号",name:"FX_TREFNO", align: 'left', width: 80 },
	            { display: "交易状态",name:"DealState", width: 150 },
	            { display: "货币对",name:"FXT_DEALTCCY", width: 80 },
	            { display: "交易类型",name:"FXT_INSTRUMENT", width: 150 },
	            { display: "交易方向",name:"FXT_BUYORSELL_CUS" , width: 150},
	            { display: "交易价格",name:"FXT_SWAPTRADEMARKRATE", width: 80 },
	            { display: "交易数量",name:"amount", width: 150 }	            
	        ], pageSize:20 ,rownumbers:true,allowUnSelectRow: true,
	        url:'<%=serverUrl%>'+'&ACTION=getAll',
	        toolbar: { items: [
	            { text: '处理', click: toolbarAction, icon: 'process' },
	            { line: true },
	            { text: '解锁', click: toolbarAction, icon: 'unlock' },
	            { line: true },
	            { text: '查询', click: toolbarAction, icon: 'search' }
	        ]
	        }
	    });
		
		$form = $("#mainform").ligerForm({});
	});  
	
	var action = "";
	function toolbarAction(item)
	{
		action = item.icon;
		if (action == "process"){  //新增数据
			//$form.setData({block_id:'',title_no:'',title_name:'',type_id:''});  
			//$form.setEnabled(['block_id','title_no','title_name','type_id'],true);
			var select = $grid.getSelectedRow();
			
			var urls="${pageContext.request.contextPath}/pages/TR/CorporateFinance/CF0024.jsp?getdata="+JSON.stringify(select);
			$dialog = $.ligerDialog.open({height: 800,width: 1200,url: urls,title:'新增数据'});
		}else if (action == "modify"){  //修改数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setEnabled(['title_no','title_name','type_id'],true);
			$form.setEnabled(['block_id'],false);
			$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform"),title:'修改数据'});
		}else if (action == "delete"){  //删除数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setEnabled(['block_id','title_no','title_name','type_id'],false);
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
	<div>
		<input type="submit" value="Start" onclick="start()" />
	</div>
	<div id="messages"></div>
</body>
</html>