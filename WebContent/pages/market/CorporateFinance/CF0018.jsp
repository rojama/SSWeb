<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="org.apache.shiro.session.Session"
	import="org.apache.shiro.subject.Subject"
	import="java.util.*"
	import="java.text.*"    
	import="org.apache.shiro.SecurityUtils"
%>
<%
       
	String Systemtime=new SimpleDateFormat("HHmmss").format(Calendar.getInstance().getTime()); 
	String Systemdate=new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime()); 
	
	
	Subject subject = SecurityUtils.getSubject(); 
	Session shiro_session= subject.getSession();
	String LoginUserID = (String)shiro_session.getAttribute("USER_ID");
	String functionName = "单表维护"; //功能名称
	String TableName = "TR_COM_FXBOARDSPREAD2";  //数据库表名
	
	String processBO = "com.app.sys.CommonBO";
	String processMETHOD = "common";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO+"&TABLE="+TableName;
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/pages/common/commonhead.jsp" %>
<html>

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
		                    { display: '币种代码', name: 'TT_UNITID', type:"text" },
		        			{ display: '币种中文名称', name: 'TT_CURRENCYPAIR',type:"text"},
		        			{ display: '币种中文名称', name: 'TT_DEALTYPE',type:"text"},

		        			{ display: '货币期限', name: 'TT_DEALTENOR',type:"text"},
		        			{ display: '牌价Bid浮动的点数', name: 'TT_BIDPOINT',type:"text"},
		        			{ display: '牌价Offer浮动的点数', name: 'TT_OFFERPOINT',type:"text"},
		        			{ display: '操作人员', name: 'TT_MAINTANCEUSER',type:"text"},
		        			{ display: '报价日期', name: 'TT_MAINTANCEDATE',type:"text"},
		        			
		        			
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
		    	inputWidth: 200, labelWidth: 150, space:50, validate:true, align: 'center',width: '98%',
		    	fields:[	//主表的表单栏位定义
		    	        	    { display: '币种代码', name: 'TT_UNITID', type:"text" },
			        			{ display: '币种中文名称', name: 'TT_CURRENCYPAIR',type:"text"},
			        			{ display: '币种中文名称', name: 'TT_DEALTYPE',type:"text"},

			        			{ display: '货币期限', name: 'TT_DEALTENOR',type:"text"},
			        			{ display: '牌价Bid浮动的点数', name: 'TT_BIDPOINT',type:"text"},
			        			{ display: '牌价Offer浮动的点数', name: 'TT_OFFERPOINT',type:"text"},

			        			{ display: '操作人员', name: 'TT_MAINTANCEUSER',type:"text"},
			        			{ display: '报价日期', name: 'TT_MAINTANCEDATE',type:"text"},
			        			
			        		
			        			
		    	],
		    	buttons:[{text:"确认",click: doAction}]
		    });
		});  
		
		var action = "";
		function toolbarAction(item)
		{
			action = item.icon;
			if (action == "add"){  //新增数据
				$form.setData({TT_UNITID:'',TT_CURRENCYPAIR:'',TT_DEALTYPE:'',TT_DEALTENOR:'',
					TT_BIDPOINT:'',TT_OFFERPOINT:'',TT_MAINTANCEUSER:'',TT_MAINTANCEDATE:''});  
				$form.setData({TT_MAINTANCEUSER:'<%=LoginUserID%>',TT_MAINTANCEDATE:'<%=Systemdate%>'}); 
				$form.setEnabled(['TT_UNITID','TT_CURRENCYPAIR','TT_DEALTYPE','TT_DEALTENOR',
				                  'TT_BIDPOINT','TT_OFFERPOINT','TT_MAINTANCEUSER','TT_MAINTANCEDATE'],true);
				$form.setEnabled(['TT_MAINTANCEUSER','TT_MAINTANCEDATE'],false);
				$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform"),title:'新增数据'});
			}else if (action == "modify"){  //修改数据
				var select = $grid.getSelectedRow();
				if (select == null){
					 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
					 setTimeout(function () { manager.close(); }, 3000);
					 return;
				}
				$form.setData(select);
				$form.setData({TT_MAINTANCEUSER:'<%=LoginUserID%>',TT_MAINTANCEDATE:'<%=Systemdate%>'}); 
				$f$form.setEnabled(['TT_UNITID','TT_CURRENCYPAIR','TT_DEALTYPE','TT_DEALTENOR',
					                  'TT_BIDPOINT','TT_OFFERPOINT','TT_MAINTANCEUSER','TT_MAINTANCEDATE'],true);
				$form.setEnabled(['TT_MAINTANCEUSER','TT_MAINTANCEDATE'],false);
				$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform"),title:'修改数据'});
			}else if (action == "delete"){  //删除数据
				var select = $grid.getSelectedRow();
				if (select == null){
					 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
					 setTimeout(function () { manager.close(); }, 3000);
					 return;
				}
				$form.setData(select);
				$form.setData({TT_MAINTANCEUSER:'<%=LoginUserID%>',TT_MAINTANCEDATE:'<%=Systemdate%>'}); 
				$form.setEnabled(['TT_UNITID','TT_CURRENCYPAIR','TT_DEALTYPE','TT_DEALTENOR',
				                  'TT_BIDPOINT','TT_OFFERPOINT','TT_MAINTANCEUSER','TT_MAINTANCEDATE'],false);
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


<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body style="padding:4px; overflow:hidden;">
	<div class="l-loading" id="pageloading"></div>
	<div id="maingrid"></div>
	<form id="mainform" style="display:none;"></form>
</body>
</html>