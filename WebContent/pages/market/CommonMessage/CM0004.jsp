<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"import="org.apache.shiro.session.Session"
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
	String TableName = "TR_COM_CptyInfo";  //数据库表名
	
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
		                    { display: '交易对手代码', name: 'TR_CPTYINFOCPTYID', minWidth: 80 },
		        			{ display: '交易对手中文名称', name: 'TR_CPTYNAME', minWidth: 80 },
		        			{ display: '交易对手中文名称', name: 'BIC', minWidth: 80 },
		        			{ display: 'DTC机构代码', name: 'TR_CITYCODE', minWidth: 80 },
		        			{ display: '城市代码', name: 'TR_CPTYHEADID', minWidth: 80 },
                            { display: '交易对手类别', name: 'TR_CPTYTYPE', minWidth: 80 },
		        			{ display: '通讯方式', name: 'TR_DELIVERTYPE', minWidth: 80 },
                            { display: '是否于CLS清算机构开户记号', name: 'TR_CLSACNTFLAG', minWidth: 80 },
		        			{ display: '电传号码', name: 'TR_TELEX', minWidth: 80 },
		        			{ display: '电传押码记号', name: 'TR_DESFLAG', minWidth: 80 },
		        			{ display: '电文所使用的姓名及地址', name: 'SWIFTNAMEADDR', minWidth: 80 },
		        			{ display: '电文所使用参数', name: 'TR_SWIFTNAMEADDRFORBOND', minWidth: 80 },

		                    { display: '地址', name: 'TR_ADDRESS', minWidth: 80 },
		        			{ display: '记账代码', name: 'TR_ACCCODE', minWidth: 80 },
		        			{ display: '电话号码', name: 'TR_PHONENO', minWidth: 80 },
		        			{ display: '传真号码', name: 'TR_FAXNO', minWidth: 80 },
		        			{ display: '确认函收报行', name: 'TR_CONFIRMATIONCPTYID', minWidth: 80 },
		        			{ display: 'E-mail地址', name: 'TR_EMAILADDR', minWidth: 80 },
		        			{ display: '是否加入伊斯坦协议', name: 'TR_ISDAFLAG', minWidth: 80 },
		        			{ display: '停用日期', name: 'TR_ENDDATE', minWidth: 80 },
		        			{ display: '预约记号', name: 'TR_ORDERFLAG', minWidth: 80 },
		        			{ display: '录入日期', name: 'TR_MAINTAINDATE', minWidth: 80 },
		        			{ display: '录入时间', name: 'TR_MAINTAINTIME', minWidth: 80 },
		        			{ display: '录入人员', name: 'TR_MAINTAINUSERID', minWidth: 80 }
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
		    	        	  { display: '交易对手代码', name: 'TR_CPTYINFOCPTYID', minWidth: 80 },
			        			{ display: '交易对手中文名称', name: 'TR_CPTYNAME', minWidth: 80 },
			        			{ display: '交易对手中文名称', name: 'BIC', minWidth: 80 },
			        			{ display: 'DTC机构代码', name: 'TR_CITYCODE', minWidth: 80 },
			        			{ display: '城市代码', name: 'TR_CPTYHEADID', minWidth: 80 },
	                            { display: '交易对手类别', name: 'TR_CPTYTYPE', minWidth: 80 },
			        			{ display: '通讯方式', name: 'TR_DELIVERTYPE', minWidth: 80 },
	                            { display: '是否于CLS清算机构开户记号', name: 'TR_CLSACNTFLAG', minWidth: 80 },
			        			{ display: '电传号码', name: 'TR_TELEX', minWidth: 80 },
			        			{ display: '电传押码记号', name: 'TR_DESFLAG', minWidth: 80 },
			        			{ display: '电文所使用的姓名及地址', name: 'SWIFTNAMEADDR', minWidth: 80 },
			        			{ display: '电文所使用参数', name: 'TR_SWIFTNAMEADDRFORBOND', minWidth: 80 },

			                    { display: '地址', name: 'TR_ADDRESS', minWidth: 80 },
			        			{ display: '记账代码', name: 'TR_ACCCODE', minWidth: 80 },
			        			{ display: '电话号码', name: 'TR_PHONENO', minWidth: 80 },
			        			{ display: '传真号码', name: 'TR_FAXNO', minWidth: 80 },
			        			{ display: '确认函收报行', name: 'TR_CONFIRMATIONCPTYID', minWidth: 80 },
			        			{ display: 'E-mail地址', name: 'TR_EMAILADDR', minWidth: 80 },
			        			{ display: '是否加入伊斯坦协议', name: 'TR_ISDAFLAG', minWidth: 80 },
			        			{ display: '停用日期', name: 'TR_ENDDATE', minWidth: 80 },
			        			{ display: '预约记号', name: 'TR_ORDERFLAG', minWidth: 80 },
			        			{ display: '录入日期', name: 'TR_MAINTAINDATE', minWidth: 80 },
			        			{ display: '录入时间', name: 'TR_MAINTAINTIME', minWidth: 80 },
			        			{ display: '录入人员', name: 'TR_MAINTAINUSERID', minWidth: 80 }
		    	],
		    	buttons:[{text:"确认",click: doAction}]
		    });
		});  
		
		var action = "";
		function toolbarAction(item)
	{             
			
			action = item.icon;
			if (action == "add"){  //新增数据
				$form.setData({TR_CPTYINFOCPTYID:'',TR_CPTYNAME:'',BIC:'',TR_CITYCODE:'',
					TR_CPTYHEADID:'',TR_CPTYTYPE:'',TR_DELIVERTYPE:'',TR_CLSACNTFLAG:'',
					TR_TELEX:'',TR_DESFLAG:'',SWIFTNameAddr:'',TR_SWIFTNAMEADDRFORBOND:'',
					
					TR_ADDRESS:'',TR_ACCCODE:'',TR_PHONENO:'',TR_FAXNO:'',
				    TR_CONFIRMATIONCPTYID:'',TR_EMAILADDR:'',TR_ISDAFLAG:'',TR_ENDDATE:'',
					TR_ORDERFLAG:'',TR_MAINTAINDATE:'',TR_MAINTAINTIME:'',TR_MAINTAINUSERID:''});

				$form.setData({TR_MAINTAINDATE:'<%=Systemdate%>',TR_MAINTAINTIME:'<%=Systemtime%>',TR_MAINTAINUSERID:'<%=LoginUserID%>'});  
				$form.setEnabled(['TR_CPTYINFOCPTYID','TR_CPTYNAME','BIC','TR_CITYCODE',
				                  'TR_CPTYHEADID','TR_CPTYTYPE','TR_DELIVERTYPE','TR_CLSACNTFLAG',
				                  'TR_TELEX','TR_DESFLAG','SWIFTNAMEADDR','TR_SWIFTNAMEADDRFORBOND',
				                   'TR_ADDRESS','TR_ACCCODE','TR_PHONENO','TR_FAXNO',
				                  'TR_CONFIRMATIONCPTYID','TR_EMAILADDR','TR_ISDAFLAG','TR_ENDDATE',
				                  'TR_ORDERFLAG','TR_MAINTAINDATE','TR_MAINTAINTIME','TR_MAINTAINUSERID'],true);
				$form.setEnabled(['TR_MAINTAINDATE','TR_MAINTAINTIME','TR_MAINTAINUSERID'],false);
				$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform"),title:'新增数据'});
			}else if (action == "modify"){  //修改数据
				var select = $grid.getSelectedRow();
				if (select == null){
					 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
					 setTimeout(function () { manager.close(); }, 3000);
					 return;
				}
				$form.setData(select);
				$form.setData({TR_MAINTAINDATE:'<%=Systemdate%>',TR_MAINTAINTIME:'<%=Systemtime%>',TR_MAINTAINUSERID:'<%=LoginUserID%>'});  
				$form.setEnabled(['TR_CPTYINFOCPTYID','TR_CPTYNAME','BIC','TR_CITYCODE',
				                  'TR_CPTYHEADID','TR_CPTYTYPE','TR_DELIVERTYPE','TR_CLSACNTFLAG',
				                  'TR_TELEX','TR_DESFLAG','SWIFTNAMEADDR','TR_SWIFTNAMEADDRFORBOND',
				                  'TR_ADDRESS','TR_ACCCODE','TR_PHONENO','TR_FAXNO',
				                  'TR_CONFIRMATIONCPTYID','TR_EMAILADDR','TR_ISDAFLAG','TR_ENDDATE',
				                  'TR_ORDERFLAG','TR_MAINTAINDATE','TR_MAINTAINTIME','TR_MAINTAINUSERID'],true);
                
				$form.setEnabled(['TR_MAINTAINDATE','TR_MAINTAINTIME','TR_MAINTAINUSERID'],false);
				$dialog = $.ligerDialog.open({height: 400,width: 500,target: $("#mainform"),title:'修改数据'});
			}else if (action == "delete"){  //删除数据
				var select = $grid.getSelectedRow();
				if (select == null){
					 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
					 setTimeout(function () { manager.close(); }, 3000);
					 return;
				}
				$form.setData(select);
				$form.setData({TR_MAINTAINDATE:'<%=Systemdate%>',TR_MAINTAINTIME:'<%=Systemtime%>',TR_MAINTAINUSERID:'<%=LoginUserID%>'});   
				$form.setEnabled(['TR_CPTYINFOCPTYID','TR_CPTYNAME','BIC','TR_CITYCODE',
				                  'TR_CPTYHEADID','TR_CPTYTYPE','TR_DELIVERTYPE','TR_CLSACNTFLAG',
				                  'TR_TELEX','TR_DESFLAG','SWIFTNAMEADDR','TR_SWIFTNAMEADDRFORBOND',
				                  'TR_ADDRESS','TR_ACCCODE','TR_PHONENO','TR_FAXNO',
				                  'TR_CONFIRMATIONCPTYID','TR_EMAILADDR','TR_ISDAFLAG','TR_ENDDATE',
				                  'TR_ORDERFLAG','TR_MAINTAINDATE','TR_MAINTAINTIME','TR_MAINTAINUSERID'],false);
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