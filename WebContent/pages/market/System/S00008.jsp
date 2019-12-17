<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
import="org.apache.shiro.SecurityUtils"
import="org.apache.shiro.session.Session"
import="org.apache.shiro.subject.Subject"
import="java.util.*"
import="java.text.*"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<%@ include file="/pages/common/commonhead.jsp" %>
<style type="text/css">
.standardTitle
{
    text-align:center;
    background-color: white;
    font-weight:bold;
    font-size: 14pt;
    color: #24abf8;
}
</style>

</head>

<body style="padding:4px; overflow:hidden;">
<p class="standardTitle">产品管理信息维护</p>
<br/>
<br/>
	<div class="l-loading" id="pageloading"></div>
	<div id="maingrid"></div>
	<form id="mainform" style="display:none;"></form>
</body>

<%

	String Systemdate=new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime()); 
	String Systemtime=new SimpleDateFormat("HHmmss").format(Calendar.getInstance().getTime()); 


	Subject subject = SecurityUtils.getSubject(); 
	Session shiro_session= subject.getSession();
	String LoginUserID = (String)shiro_session.getAttribute("USER_ID");
	
	
	String TableName = "TR_COM_SYS_Prodct";  //数据库表名
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
				
		$grid = $("#maingrid").ligerGrid({
	        height:'100%',width:'100%',heightDiff:-3,
	        columns: [  //主表的标题栏位定义
	            { display: '对象属性ID', name: 'TR_PRODUCTID', align: 'left', width: 80 },
	            { display: '对象属性说明', name: 'TR_PRODUCTNUM', width: 80 },
	            { display: '产品类型', name: 'TR_PRODUCTTYPE', width: 150 },
	            { display: '产品说明', name: 'TR_PRODUCTDESC' , width: 150},
	            { display: '父节点', name: 'TR_PARENTSID' , width: 150},
	            { display: '是否页节点', name: 'TR_ISLASTPOINT' , width: 150},
	            { display: '录入日期', name: 'MAINTAINDATE' , width: 150},
	            { display: '录入时间', name: 'MAINTAINTIME' , width: 150},
	            { display: '录入人员', name: 'MAINTAINUSERID' , width: 150}
	        ], pageSize:20 ,rownumbers:true,allowUnSelectRow: true,
	        url:'<%=serverUrl%>'+'&ACTION=select-page',
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
	    		{ display: '对象属性ID', name: 'TR_PRODUCTID',type:"text",validate:{required:true}},
	    		{ display: '对象属性说明', name: 'TR_PRODUCTNUM',type:"text",validate:{required:true}},
	    		{ display: '产品类型', name: 'TR_PRODUCTTYPE',type:"text",validate:{required:true}},
	    		{ display: '产品说明', name: 'TR_PRODUCTDESC' ,type:"text",validate:{required:true}},  		
	    		{ display: '父节点', name: 'TR_PARENTSID' ,type:"text",validate:{required:true}},  		
	    		{ display: '是否页节点', name: 'TR_ISLASTPOINT' ,type:"text",validate:{required:true}},  		
	    		{ display: '录入日期', name: 'MAINTAINDATE' ,type:"text",validate:{required:true}},  		
	    		{ display: '录入时间', name: 'MAINTAINTIME' ,type:"text",validate:{required:true}},  		
	    		{ display: '录入人员', name: 'MAINTAINUSERID' ,type:"text",validate:{required:true}}  		
	    	],
	    	buttons:[{text:"确认",click: doAction}]
	    });
	});  
	
	var action = "";
	function toolbarAction(item)
	{
		action = item.icon;
		if (action == "add"){  //新增数据
			$form.setData({ TR_PRODUCTID:'',TR_PRODUCTNUM:'',
							TR_PRODUCTTYPE:'',TR_PRODUCTDESC:'',
							TR_PARENTSID:'',TR_ISLASTPOINT:'',
							MAINTAINDATE:'<%=Systemdate%>',MAINTAINTIME:'<%=Systemtime%>',MAINTAINUSERID:'<%=LoginUserID%>'});  
			$form.setEnabled(['TR_PRODUCTID','TR_PRODUCTNUM','TR_PRODUCTTYPE','TR_PRODUCTDESC','TR_PARENTSID','TR_ISLASTPOINT'],true);
			$form.setEnabled(['MAINTAINDATE','MAINTAINTIME','MAINTAINUSERID'],false);
			$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform"),title:'新增数据'});
		}else if (action == "modify"){  //修改数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setData({MAINTAINDATE:'<%=Systemdate%>',MAINTAINTIME:'<%=Systemtime%>',MAINTAINUSERID:'<%=LoginUserID%>'});  
			$form.setEnabled(['TR_PRODUCTID','TR_PRODUCTNUM','TR_PRODUCTTYPE','TR_PRODUCTDESC','TR_PARENTSID','TR_ISLASTPOINT'],true);
			$form.setEnabled(['MAINTAINDATE','MAINTAINTIME','MAINTAINUSERID'],false);
			$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform"),title:'修改数据'});
		}else if (action == "delete"){  //删除数据
			var select = $grid.getSelectedRow();
			if (select == null){
				 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
				 setTimeout(function () { manager.close(); }, 3000);
				 return;
			}
			$form.setData(select);
			$form.setEnabled(['TR_PRODUCTID','TR_PRODUCTNUM','TR_PRODUCTTYPE','TR_PRODUCTDESC','TR_PARENTSID','TR_ISLASTPOINT','MAINTAINDATE','MAINTAINTIME','MAINTAINUSERID'],false);
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
	       	console.log(param);
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
</html>