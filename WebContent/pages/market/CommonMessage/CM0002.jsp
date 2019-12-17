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
	String TableName = "TR_COM_BIZ_CcyPair";  //数据库表名
	
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
		                    { display: '报价币', name: 'TR_BASECCY', minWidth: 80 },
		        			{ display: '被报报价币', name: 'TR_TERMSCCY', minWidth: 80 },
		        			{ display: '参考数据源种类', name: 'TR_REFDATASOURCE', minWidth: 80 },
		        			{ display: '自动报价标示', name: 'TR_AUTOQUOTEFLAG', minWidth: 80 },
		        			{ display: '自动交易标示', name: 'TR_AUTOTRADEFLAG', minWidth: 80 },
		        			{ display: '即期汇率小数点位数', name: 'TR_SPOTDPS', minWidth: 80 },
		        			{ display: '调期点小数点位数', name: 'TR_SWAPDPS', minWidth: 80 },
		        			{ display: 'AllInRate小数点位数', name: 'TR_ALLINRATEDPS', minWidth: 80 },
		        			{ display: '双边自动报价标示', name: 'TR_AUTOQUOTEBILATERAL ', minWidth: 80 },
		        			{ display: '双边自动交易标示', name: 'TR_AUTOTRADEBILATERAL ', minWidth: 80 },
		        			{ display: '自动交易最高限额', name: 'TR_MAXTRADEAMOUNT', minWidth: 80 },
		        			{ display: '双边自动交易最高限额', name: 'TR_MAXTRADEAMOUNT ', minWidth: 80 },
		        			{ display: '自动回价成交的最高限额', name: 'TR_AUTOMIXAMT', minWidth: 80 },
		        			{ display: '自动回价成交的最高次数', name: 'TR_AUTOTIMES  ', minWidth: 80 },
		        			{ display: '自动回价bid浮动的点数', name: 'TR_AUTOBIDPOINT', minWidth: 80 },
		        			{ display: '自动回价offer浮动的点数', name: 'TR_AUTOOFFERPOINT  ', minWidth: 80 },
		        			{ display: '报价中bid与offer的最大差值', name: 'TR_BIDOFFERDIFF ', minWidth: 80 },
		        			{ display: '录入时间', name: 'MAINTAINDATE', minWidth: 80 },
                            { display: '录入时间', name: 'MAINTAINTIME', minWidth: 80 },
		        			{ display: '录入人员', name: 'MAINTAINUSERID', minWidth: 80 }                
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
		    	inputWidth: 200, labelWidth: 180, space:50, validate:true, align: 'center',width: '98%',
		    	fields:[	//主表的表单栏位定义
		    	        	{ display: '报价币', name: 'TR_BASECCY', minWidth: 80 },
		    				{ display: '被报报价币', name: 'TR_TERMSCCY', minWidth: 80 },
		    				{ display: '参考数据源种类', name: 'TR_REFDATASOURCE', minWidth: 80 },
		    				{ display: '自动报价标示', name: 'TR_AUTOQUOTEFLAG', minWidth: 80 },

		    				{ display: '自动交易标示', name: 'TR_AUTOTRADEFLAG', minWidth: 80 },
		    				{ display: '即期汇率小数点位数', name: 'TR_SPOTDPS', minWidth: 80 },
		    				{ display: '调期点小数点位数', name: 'TR_SWAPDPS', minWidth: 80 },
		    				{ display: 'AllInRate小数点位数', name: 'TR_ALLINRATEDPS', minWidth: 80 },

		    				{ display: '双边自动报价标示', name: 'TR_AUTOQUOTEBILATERAL ', minWidth: 80 },
		    				{ display: '双边自动交易标示', name: 'TR_AUTOTRADEBILATERAL ', minWidth: 80 },
                            { display: '自动交易最高限额', name: 'TR_MAXTRADEAMOUNT', minWidth: 80 },
		    				{ display: '双边自动交易最高限额', name: 'TR_MAXTRADEAMOUNT ', minWidth: 80 },

		    				{ display: '自动回价成交的最高限额', name: 'TR_AUTOMIXAMT', minWidth: 80 },
		    				{ display: '自动回价成交的最高次数', name: 'TR_AUTOTIMES  ', minWidth: 80 },
		    				{ display: '自动回价bid浮动的点数', name: 'TR_AUTOBIDPOINT', minWidth: 80 },
                            { display: '自动回价offer浮动的点数', name: 'TR_AUTOOFFERPOINT  ', minWidth: 80 },

		    				{ display: '报价中bid与offer的最大差值', name: 'TR_BIDOFFERDIFF ', minWidth: 80 },
		    				{ display: '录入日期', name: 'MAINTAINDATE', minWidth: 80 },
		    				{ display: '录入时间', name: 'MAINTAINTIME', minWidth: 80 },
		    				{ display: '录入人员', name: 'MAINTAINUSERID', minWidth: 80 }  
		    				              
		    	],
		    	buttons:[{text:"确认",click: doAction}]
		    });
		});  
		
		var action = "";
		function toolbarAction(item)
		{
			action = item.icon;
			if (action == "add"){  //新增数据
				$form.setData({TR_BASECCY:'',TR_TERMSCCY:'',TR_REFDATASOURCE:'',TR_AUTOQUOTEFLAG:'',
					TR_AUTOTRADEFLAG:'',TR_SPOTDPS:'',TR_SWAPDPS:'',TR_ALLINRATEDPS:'',
					TR_AUTOQUOTEBILATERAL:'',TR_AUTOTRADEBILATERAL:'',TR_MAXTRADEAMOUNT:'',TR_MAXTRADEAMOUNT:'',
					TR_AUTOMIXAMT:'',TR_AUTOTIMES:'',TR_AUTOBIDPOINT:'',TR_AUTOOFFERPOINT:'',
                    TR_BIDOFFERDIFF:'',MAINTAINDATE:'',MAINTAINTIME:'',MAINTAINUSERID:''});  
				$form.setData({MAINTAINDATE:'<%=Systemdate%>',MAINTAINTIME:'<%=Systemtime%>',MAINTAINUSERID:'<%=LoginUserID%>'});  
				$form.setEnabled(['TR_BASECCY','TR_TERMSCCY','TR_REFDATASOURCE','TR_AUTOQUOTEFLAG',
				                  'TR_AUTOTRADEFLAG','TR_SPOTDPS','TR_SWAPDPS','TR_ALLINRATEDPS',
				                  'TR_AUTOQUOTEBILATERAL','TR_AUTOTRADEBILATERAL','TR_MAXTRADEAMOUNT','TR_MAXTRADEAMOUNT',
				                  'TR_AUTOMIXAMT','TR_AUTOTIMES','TR_AUTOBIDPOINT','TR_AUTOOFFERPOINT',
				                  'TR_BIDOFFERDIFF','MAINTAINDATE','MAINTAINTIME','MAINTAINUSERID'],true);
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
				$form.setEnabled(['TR_BASECCY','TR_TERMSCCY','TR_REFDATASOURCE','TR_AUTOQUOTEFLAG',
				                  'TR_AUTOTRADEFLAG','TR_SPOTDPS','TR_SWAPDPS','TR_ALLINRATEDPS',
				                  'TR_AUTOQUOTEBILATERAL','TR_AUTOTRADEBILATERAL','TR_MAXTRADEAMOUNT','TR_MAXTRADEAMOUNT',
				                  'TR_AUTOMIXAMT','TR_AUTOTIMES','TR_AUTOBIDPOINT','TR_AUTOOFFERPOINT',
				                  'TR_BIDOFFERDIFF','MAINTAINDATE','MAINTAINTIME','MAINTAINUSERID'],true);
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
				$form.setData({MAINTAINDATE:'<%=Systemdate%>',MAINTAINTIME:'<%=Systemtime%>',MAINTAINUSERID:'<%=LoginUserID%>'});  
				$form.setEnabled(['TR_BASECCY','TR_TERMSCCY','TR_REFDATASOURCE','TR_AUTOQUOTEFLAG',
				                  'TR_AUTOTRADEFLAG','TR_SPOTDPS','TR_SWAPDPS','TR_ALLINRATEDPS',
				                  'TR_AUTOQUOTEBILATERAL','TR_AUTOTRADEBILATERAL','TR_MAXTRADEAMOUNT','TR_MAXTRADEAMOUNT',
				                  'TR_AUTOMIXAMT','TR_AUTOTIMES','TR_AUTOBIDPOINT','TR_AUTOOFFERPOINT',
				                  'TR_BIDOFFERDIFF','MAINTAINDATE','MAINTAINTIME','MAINTAINUSERID'],false);
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