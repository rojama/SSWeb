<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
</head>

<%
	String functionName = "广告投放区域管理"; //功能名称
	String TableName = "AD_AREA";  //数据库表名
	
	String processBO = "com.app.sys.CommonBO";
	String processMETHOD = "common";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO+"&TABLE="+TableName;
	
	String serverUrlSelect = request.getContextPath()+"/cm?ProcessBO=com.app.ad.ADPagesBean&ProcessMETHOD=select";
%>

<script type="text/javascript">  
	var $grid;
	var $dialog;
	var $form;
	
	$(function ()
	{        	
		$("#pageloading").hide();	
				
		$grid = $("#maingrid").ligerGrid({
	        height:'100%',width:'100%',heightDiff:28,
	        columns: [  //主表的标题栏位定义
	            { display: '区域编号', name: 'AREA_ID',id: 'AREA_ID',  width: 80 },
	            { display: '区域名称', name: 'AREA_NAME',id: 'AREA_NAME', align: 'left', width: 150 },
	            { display: '上级区域编号', name: 'UPPER_AREA_ID' ,id: 'UPPER_AREA_ID' , width: 150},
	            { display: '关联机构', name: 'INS_CODE' , width: 80}
	        ], usePager: false,rownumbers:true,allowUnSelectRow: true,
	        url:'<%=serverUrl%>'+'&ACTION=select-all',
	        tree: {
            	columnId: 'AREA_NAME',
                idField: 'AREA_ID',
                parentIDField: 'UPPER_AREA_ID'
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
	    		{ display: "区域编号",name:"AREA_ID",type:"text",validate:{required:true}},
	    		{ display: "区域名称",name:"AREA_NAME",type:"text",validate:{required:true}},
	    		{ display: "上级区域编号",name:"UPPER_AREA_ID",type:"text",validate:{required:false}},
	    		{ display: "关联机构",name:"INS_CODE",type:"select",validate:{required:false},options:{
	    			valueField: 'NODE_VALUE',textField: 'NODE_NAME',treeLeafOnly:false,
	    			tree:{ url: '<%=serverUrlSelect%>'+'&ACTION=ins-tree',
	    				checkbox: false, 	    				
	    				idFieldName :'NODE_ID',
		                textFieldName : 'NODE_NAME',
		                parentIDFieldName :'UPPER_NODE_ID',            
		                iconFieldName: 'ICON' 
		            }
				}},  		
	    	],
	    	buttons:[{text:"确认",click: doAction}]
	    });
	});  
	
	var action = "";
	function toolbarAction(item)
	{
		action = item.icon;
		if (action == "add"){  //新增数据			
			$form.setData({AREA_ID:'',AREA_NAME:'',UPPER_AREA_ID:'',INS_CODE:''});  
			$form.setEnabled(['AREA_ID','AREA_NAME','UPPER_AREA_ID','INS_CODE'],true);
			var select = $grid.getSelectedRow();
			if (select != null){
				$form.setData({UPPER_AREA_ID:select.AREA_ID}); 
			}
			$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform"),title:'新增数据'});
		}else if (action == "modify"){  //修改数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setEnabled(['AREA_NAME','UPPER_AREA_ID','INS_CODE'],true);
			$form.setEnabled(['AREA_ID'],false);
			$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform"),title:'修改数据'});
		}else if (action == "delete"){  //删除数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setEnabled(['AREA_ID','AREA_NAME','UPPER_AREA_ID','INS_CODE'],false);
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
	<form id="mainform"></form>
</body>
</html>