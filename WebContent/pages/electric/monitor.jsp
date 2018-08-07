<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>

    <link rel="stylesheet" type="text/css" href="${ctx}/js/easyui/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/js/easyui/themes/icon.css">
    <script type="text/javascript" src="${ctx}/js/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${ctx}/js/easyui/plugins/jquery.portal.js"></script>
    <script type="text/javascript" src="${ctx}/js/highcharts/highcharts.js"></script>
    
    <style type="text/css">
		.portal{
			padding:3px;
			margin:0px;
			border:0px dashed #99BBE8;
			overflow:visible;
		}
		.portal-noborder{
			border:0;
		}
		.portal-panel{
			margin-bottom:6px;
		}
		.portal-column-td{
			vertical-align:top;
		}	
		.portal-column{
			padding:3px;
			overflow:hidden;
		}
		.portal-proxy{
			opacity:0.6;
			filter:alpha(opacity=60);
		}
		.portal-spacer{
			border:2px dashed #99BBE8;
			margin-bottom:10px;
		}
		.panel-icon{
			background:url('../../images/icons/some/chart_line.png') no-repeat center center;
		}
    </style>
</head>

<%
	String functionName = "单表维护"; //功能名称	
	String processBO = "com.app.electric.ElectricPagesBean";
	String processMETHOD = "monitor";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO;
%>

<script type="text/javascript">  

	var webSocket = new WebSocket('ws://'+window.location.host+'${ctx}/websocket?WSCODE=ELE_WARNING');  
	
	webSocket.onerror = function(event) { 
		 
	}; 
	
	webSocket.onopen = function(event) { 
		
	}; 
	
	webSocket.onmessage = function(event) { 
		var data = eval("(" + event.data + ")"); 
		var x = (new Date(data.RECORD_TIME)).getTime(); 
		var y = parseInt(data.RECORD_DATA);
		if ($("#DEV_"+data.DEVICE_ID).prev()) {
			$("#DEV_"+data.DEVICE_ID).prev().css("background","rgba(255,50,50,0.5)");
		}
		
		setTimeout(function () { 
			if ($("#DEV_"+data.DEVICE_ID).prev()) {
				$("#DEV_"+data.DEVICE_ID).prev().css("background","");
			}
	    }, 2000);

	};
	
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
            onSelect: reAddPortal,
            onContextmenu: function (node, e)
            { 
            	loadPortal(node, false);
            	return false;
            },
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
		
		$('#portal').portal();
		
		$("#pageloading").hide();	
	});  
	
	function reAddPortal(node){
		loadPortal(node, true);
	}
	
	var col = 0;
	function loadPortal(node, clear){
		 var node_id = node.data.NODE_ID;
		 $("#pageloading").show();	
		 $.ajax({
				type:'POST',
				url:'<%=serverUrl%>'+'&ACTION=select-device&NODE_ID='+node_id,
				dataType:'json',
				success:function(result)
			    {
					if (result.ERR == null){
						// clear
						if (clear){
							col = 0;
							var panels = $('#portal').portal('getPanels');
							for(var i=0; i<panels.length; i++){
			                    //cc.push(panels[i].attr('id'));
			                    $('#portal').portal('remove', panels[i]);
			                }
						}

						for (var i=0; i<result.Rows.length; i++){
							var device = result.Rows[i];
							var dev_href = [];
							var urlnum = 0;
							if (device.CUSTOMIZE_TEMPLET == 'true'){
								dev_href = 'templet/DEVTYPE_'+device.DEVICE_TYPE_ID+'.jsp?device_id='+device.DEVICE_ID;
								urlnum += 1;
							}else{
								for (var j=0; j<device.ELE_DEVICE_TYPE_REGISTER.length; j++){
									var register = device.ELE_DEVICE_TYPE_REGISTER[j];
									//0-预制模板；1-曲线图；2-区域图；3-柱状图；4-饼状图；5-仪表图；6-数字图
									if (register.TEMPLET_ID == '0'){
										dev_href += ';templet/DEVTYPE_'+device.DEVICE_TYPE_ID+'-REG_'+register.REGISTER_ID+'.jsp?device_id='+device.DEVICE_ID;
									}else{  
										dev_href += ';templet/TEMPLET_'+register.TEMPLET_ID+'.jsp?device_id='+device.DEVICE_ID+'%26device_type_id='+register.DEVICE_TYPE_ID+'%26register_id='+register.REGISTER_ID;
									}
									urlnum += 1;
								}
							}
							
							var timstamp = (new Date()).valueOf();  
							dev_href = dev_href + "&t=" + timstamp;   
							// create the panel
							//var p = $('<div><div id = "pan"></div></div>').appendTo($('#portal'));
							var p = $('<div></div>').appendTo($('#portal'));
							p.panel({
								iconCls: 'panel-icon',
								id: 'DEV_'+device.DEVICE_ID,
								title: device.AREA_NAME+'-'+device.BOX_NAME+'-'+device.DEVICE_NAME,
								href: 'monitor_iframe.jsp?hrefs='+dev_href,
								//height: 220 * urlnum + 28,
								//maximizable: true,
								closable: true,
								collapsible: true
								
							});
							//p.draggable({});
							//add the panel to portal
							$('#portal').portal('add', {
								panel: p,
								columnIndex: col
							});
							
							col = col+1;
							if (col>=4){
								col = 0;
							}
						}						
	               	}else{
	               		$.ligerDialog.error(result.ERR);
	               	}
					$("#pageloading").hide();
			    }
			});
     }

	
	function iframeAutoFit(iframeObj) {
		if (!iframeObj)
			return;
		iframeObj.height = (iframeObj.Document ? iframeObj.Document.body.scrollHeight
				: iframeObj.contentDocument.body.offsetHeight-18);
	}
</script>	 

<body style="padding:4px; overflow:hidden;">
	<div class="l-loading" id="pageloading"></div>
	<div id="mainlayout">	
		<div position="left" title="连接终端列表" id="maintree" style="width:100%;height:95%;overflow-y:auto;">
		</div>
		<div position="center" title="设备监控图表" id="portal" style="width:1200px;position:relative">
	        <div></div>
	        <div></div>
	        <div></div>
	        <div></div>
		</div>
	</div>
	<form id="mainform" style="display:none;"></form>
</body>
</html>