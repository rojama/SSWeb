<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
</head>

<%
	String functionName = "流程部署"; //功能名称
	String processBO = "com.app.activiti.ActTask";
	String processMETHOD = "repository";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO;
%>


<script type="text/javascript">  
		var $grid;
		var $dialog;
		var $form;
		
        $(function ()
        {        	
			$("#pageloading").hide();	
			
			$("#mainlayout").ligerLayout();
			
			$grid = $("#maingrid").ligerGrid({
                height:'99%',width:'100%',
                columns: [
	                { display: '流程编号', name: 'Id', align: 'left', width: 50 },
	                { display: '流程名称', name: 'Name', width: 100 },
	                { display: '流程类别', name: 'Category' , width: 80},
	                { display: '流程部署日期', name: 'DeploymentTime', width: 150 }           
                ], pageSize:20 ,rownumbers:true,
                toolbar: { items: [
	                { text: '新增', click: toolbarAction, icon: 'add' },
	                { line: true },
	                { text: '修改', click: toolbarAction, icon: 'modify' },
	                { line: true },
	                { text: '删除', click: toolbarAction, icon: 'delete' }
                ]
                }
            });
			
			$form = $("#mainform").ligerForm({
	        	inputWidth: 200, labelWidth: 100, space:50, validate:true, align: 'center',width: '98%',
	        	fields:[	//表单栏位
	        	    { display: "流程编号",name:"Id",type:"text",validate:{required:true}},
	        		{ display: "流程名称",name:"Name",type:"text",validate:{required:false}},
	        		{ display: "流程类别",name:"Category",type:"text",validate:{required:false}},
	        		{ display: "流程文件名",name:"FileName",type:"hidden",validate:{required:false}},
	        		{ display: "流程文件",name:"FileInput",type:"popup",validate:{required:false},
		        		editor: {
	        				onButtonClick: selectFileInput
	        			}
	        		}
	        	],
	        	buttons:[{text:"确认",click: doAction}]
	        });
			
			action = 'search';
			doAction();
        });  
        
        var action = "";
        function toolbarAction(item)
        {
        	action = item.icon;
        	if (action == "add"){
        		$form.setData({Id:'自动',Name:'',Category:'',FileInput:''});
        		$form.setEnabled(['Id','Name','Category','FileInput'],true);
        		$form.setEnabled(['Id'],false);
        	}else if (action == "modify"){
        		var select = $grid.getSelectedRow();
        		if (select == null){
        			 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
        			 setTimeout(function () { manager.close(); }, 3000);
        			 return;
        		}
        		$form.setData(select);
        		$form.setEnabled(['Id','Name','Category','FileInput'],true);
        		$form.setEnabled(['Id'],false);
        	}else if (action == "delete"){
        		var select = $grid.getSelectedRow();
        		if (select == null){
        			 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
        			 setTimeout(function () { manager.close(); }, 3000);
        			 return;
        		}
        		$form.setData(select);
        		$form.setEnabled(['Id','Name','Category','FileInput'],false);        		
        	}
        	$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform")});
        }
        
        function doAction()
		{		
			var form = liger.get('mainform');
			if (action == 'search' || form.valid()) {
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
        					if ($dialog) $dialog.hide();
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
        
        
        var $fileDialog;
        
        //打开上传框
        function selectFileInput(){
        	$("#upload")[0].value="";
        	$fileDialog = $.ligerDialog.open({height: 150,width: 300,target: $("#Fileupload")});
        }
      
        
        function selectFile() {
			var form = document.forms["Fileupload"];
			
			if (form["upload"].files.length > 0)
			{
				var file = form["upload"].files[0];
				
				// try sending
				var reader = new FileReader();
				
				reader.onloadend = function() {
					if (reader.error) {
						console.log(reader.error);
					} else {
						//
						$form.getEditor('FileName')[0].value = $("#upload")[0].value;
						$form.getEditor('FileInput').setValue(reader.result);
			        	$form.getEditor('FileInput').setText($("#upload")[0].value);
			        	if ($fileDialog != null) $fileDialog.hide();
			        	
					}
				}
				reader.readAsBinaryString(file);
			}
			else
			{
				alert ("Please choose a file.");
			}
		}
</script>	 

<body style="padding:4px">
	<div class="l-loading" id="pageloading"></div>
	<div id="mainlayout">	
		<div id="maingrid" position="center" title="<%=functionName%>"></div>
	</div>
	<form id="mainform" style="display:none;"></form>
		
	<form id="Fileupload" style="display:none;">
		<table>
			<tr><td><input type="file"  name="upload" id="upload" /></td></tr>
			<tr><td><input type="button" onclick="selectFile();" value="确定"/></td></tr>
		</table>
	</form>
</body>
</html>