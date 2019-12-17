<%@page import="com.app.sys.*"%>
<%@page import="com.app.help.TempMenuHelper"%>
<%@page import="com.app.help.OperationHelper"%>
<%@page import="com.app.help.MenuHelper"%>
<%@page import="com.app.help.RoleHelper"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String functionName = "角色维护"; //功能名称
String processBO = "com.app.sys.CommonBO";
String processMETHOD = "common";
String TableName = "aut_role";
String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO+"&TABLE="+TableName;

	String action = (String)request.getParameter("action");
	String locale=(String)session.getAttribute("locale");
	
	RoleHelper obj_Role = new RoleHelper();
	if("findAll".equals(action))
	{
		List<Map<String,Object>> list = obj_Role.innerFindRole(locale, "");
		String dataAsJson=JsonUtil.list2json(list);
		PrintWriter pw = response.getWriter();
		pw.print(dataAsJson);
		pw.flush();
		pw.close(); 
	}
	else if("menuData".equals(action))
	{
		String ROLE_ID=(String)request.getParameter("ROLE_ID");
		String ROLE_SUPER_ID=(String)request.getParameter("ROLE_SUPER_ID");
		
		MenuHelper obj_MenuHelper = new MenuHelper();
		List<Map<String,Object>> list = obj_MenuHelper.innerFindMenu(locale, ROLE_ID,ROLE_SUPER_ID);
		String dataAsJson=JsonUtil.list2json(list);
		dataAsJson=dataAsJson.replace("ID", "id");
		dataAsJson=dataAsJson.replace("TEXT", "text");
		dataAsJson=dataAsJson.replace("null", "false");
		dataAsJson=dataAsJson.replace("ISCHECKED", "ischecked");
		PrintWriter pw = response.getWriter();
		pw.print(dataAsJson);
		pw.flush();
		pw.close(); 
	}
	else if("OperData".equals(action))
	{
		OperationHelper obj_Oper= new OperationHelper();
		List<Map<String,Object>> list = obj_Oper.findOperationData(locale);
		String dataAsJson=JsonUtil.list2json(list);
		PrintWriter pw = response.getWriter();
		pw.print(dataAsJson);
		pw.flush();
		pw.close();
	}
	else if("TempData".equals(action))
	{
		String ROLE_ID = request.getParameter("ROLE_ID").toString();
		
		TempMenuHelper ojb_TempMenu = new TempMenuHelper();
		List<Map<String,Object>> list = ojb_TempMenu.innerFindTempData(ROLE_ID);
		
		String dataAsJson=JsonUtil.list2json(list);
		dataAsJson=dataAsJson.replace("ID", "id");
		dataAsJson=dataAsJson.replace("TEXT", "text");
		PrintWriter pw = response.getWriter();
		pw.print(dataAsJson);
		pw.flush();
		pw.close();
	}
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/header.jsp" %>
<%@ taglib prefix="shiro" uri="/WEB-INF/shiro.tld" %>
<script type="text/javascript">  
var $grid;
var $dialog;
var $form;
var _menuTree;
var _initButton;
var _initOper;

$(function ()
{        	
	$("#pageloading").hide();	
	
	//$("#mainlayout").ligerLayout();
				
	$grid = $("#maingrid").ligerGrid({
		width: '100%', height: '100%',heightDiff:28,
		columns: [
			{ display: '角色序号', name: 'ROLE_ID', id:'ROLE_ID', align: 'left', width: 150 },
            { display: '角色编号', name: 'ROLE_CODE', id:'ROLE_CODE', align: 'left', width: 100 },
            { display: '简体中文名称', name: 'ROLE_NAME', id:'ROLE_NAME', width: 100 },	
            { display: '英文名称', name: 'ROLE_ENGNAME', id:'ROLE_ENGNAME', width: 100 },	
            { display: '繁体中文名称', name: 'ROLE_TWNAME', id:'ROLE_TWNAME', width: 100 },	
            { display: '排序', name: 'ROLE_ORDER', id:'ROLE_ORDER', align: 'left', width: 50 },	
            { display: '停用', name: 'IS_START', width: 50 },
            { display: "上级角色编号",name:"ROLE_SUPER_ID",  width: 150 },
            { display: '维护时间', name: 'SYSTEM_DATETIME', width: 150 }
        ], usePager: false, rownumbers:true,allowUnSelectRow: true,
        tree: {
        	columnId: 'ROLE_ID',
            idField: 'ROLE_ID',
            parentIDField: 'ROLE_SUPER_ID'
        },
        toolbar: { items: [
            { text: '<fmt:message key="add"/>', click: toolbarAction, icon: 'add' },
            { line: true },
            { text: '<fmt:message key="edit"/>', click: toolbarAction, icon: 'modify' },
            { line: true },
            { text: '<fmt:message key="remove"/>', click: toolbarAction, icon: 'delete' },
            { line: true },
            { text: '<fmt:message key="role"/>',click:Role, icon:'role'}
        ]
        }
    });
	
	$form = $("#mainform").ligerForm({
    	inputWidth: 200, labelWidth: 150, space:50, validate:true, align: 'center',width: '98%',
    	fields:[	//表单栏位	        	    
    	    { display: "角色序号",name:"ROLE_ID",type:"text",validate:{required:true}},
    		{ display: "角色编号",name:"ROLE_CODE",type:"text",validate:{required:true}},
    		{ display: "简体中文名称",name:"ROLE_NAME",type:"text",validate:{required:true}},
    		{ display: "英文名称",name:"ROLE_ENGNAME",type:"text",validate:{required:false}},
    		{ display: "繁体中文名称",name:"ROLE_TWNAME",type:"text",validate:{required:false}},
    		{ display: "排序",name:"ROLE_ORDER",type:"int",validate:{required:true}},
    		{ display: "停用",name:"IS_START",type:"text",validate:{required:false}},
    		{ display: "上级角色编号",name:"ROLE_SUPER_ID",type:"text",validate:{required:false}},
    		{ display: "维护时间",name:"SYSTEM_DATETIME",type:"text",validate:{required:false}}
    	],
    	buttons:[{text:"<fmt:message key='save'/>",click: doAction}]
    });
	
	_menuTree=$("#menuTree").ligerTree({
		 nodeDraggable: true
	});
	
	_initButton=$("#buttonFunction").ligerGrid({
 		usePager :false,
 		enabledEdit: true,
 		enabledSort:false,
 		tree: { columnName: 'text' }
 	});
	
	action = 'select-all';
	doAction();
});  

var action = "";
function toolbarAction(item)
{
	action = item.icon;
	if (action == "add"){
		$form.setData({ROLE_ID:'UUID自动',ROLE_CODE:'',ROLE_NAME:'',ROLE_ENGNAME:'',ROLE_TWNAME:'',ROLE_ORDER:'0',IS_START:'N',ROLE_SUPER_ID:'',SYSTEM_DATETIME:'TIME自动'});
		var select = $grid.getSelectedRow();        		
		if (select != null){
			$form.setData({ROLE_SUPER_ID:select.ROLE_ID});
   		}
		$form.setEnabled(['ROLE_CODE','ROLE_NAME','ROLE_ENGNAME','ROLE_TWNAME','ROLE_ORDER','ROLE_SUPER_ID','IS_START'],true);
		$form.setEnabled(['ROLE_ID','SYSTEM_DATETIME'],false);
	}else if (action == "modify"){
		var select = $grid.getSelectedRow();
		if (select == null){
			 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
			 setTimeout(function () { manager.close(); }, 3000);
			 return;
		}
		$form.setData(select);
		$form.setData({SYSTEM_DATETIME:'TIME自动'});
		$form.setEnabled(['ROLE_ID','ROLE_CODE','ROLE_NAME','ROLE_ENGNAME','ROLE_TWNAME','ROLE_ORDER','ROLE_SUPER_ID','IS_START'],true);
		$form.setEnabled(['ROLE_ID','SYSTEM_DATETIME'],false);
	}else if (action == "delete"){
		var select = $grid.getSelectedRow();
		if (select == null){
			 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
			 setTimeout(function () { manager.close(); }, 3000);
			 return;
		}
		$form.setData(select);
		$form.setEnabled(['ROLE_ID','ROLE_CODE','ROLE_NAME','ROLE_ENGNAME','ROLE_TWNAME','ROLE_ORDER','ROLE_SUPER_ID','IS_START','SYSTEM_DATETIME'],false);        		
	}
	$dialog = $.ligerDialog.open({height: 500,width: 500,target: $("#mainform")});
	action = action+'|select-all';
}

function doAction()
{		
	var form = liger.get('mainform');
	if (action == 'select-all' || form.valid()) {
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
                	$grid.set({ data: result });
                	$grid.sortedData = '';
               	}else{
               		$.ligerDialog.error(result.ERR);
               	}
				$("#pageloading").hide();
				if ($dialog != null) $dialog.hide();
		    }
		});       	
    } else {
    	form.showInvalid();
	}
}

//消息提示
function message(json)
{
	var mes=JSON.stringify(json);
	
	if(undefined!=json.MSG)
	{	
		$.ligerDialog.success("<fmt:message key='success'/>");
	}
	
	if(undefined!=json.ERR)
	{
		$.ligerDialog.error("<fmt:message key='error'/>");
	}
}

function checkSelectRow(row)
{
	if (!row) { alert('请选择行'); return false; }
		
	var i=0;
	$.each($grid.getCheckedRows(), function(index, element) {
 		i++;
	});
   
    if(i>1)
    {
   	  alert('请只选择一行'); 
   	  return false;
    }
    
    return true;
}


//设置角色权限
var _RoleDialog;
function Role()
{
	var row = $grid.getSelectedRow();
	if(checkSelectRow(row))
	{
		getMenuTree(row);
	    _RoleDialog=$.ligerDialog.open({ 
   		  width: 700,
          height: 600,
          isResize: true,
          title:"<fmt:message key='role'/>",
   		  target: $("#menuTree"),
   		  buttons:[
   			{text:"<fmt:message key='save' />",onclick:RoleSave},
   			{text:"<fmt:message key='reset'/>",onclick:Cancle}
   		]
   	   });
   	}
}

function getMenuTree(row)
{
	  
	 var ROLE_ID=row.ROLE_ID;
	 var ROLE_SUPER_ID=row.ROLE_SUPER_ID
	 
	 $.getJSON('${pageContext.request.contextPath}/pages/system/aut/aut_role.jsp?action=menuData&ROLE_ID='+ROLE_ID+'&ROLE_SUPER_ID='+ROLE_SUPER_ID+'&time='+ new Date().getTime(),function(result){
	 	 _menuTree.setData(result);
	 });
}

function RoleSave()
{
	var row=$grid.getSelectedRow();
	var role_id=row.ROLE_ID;
	$("#ROLE_ID").attr("value",role_id); 
	$("#ProcessMETHOD").attr("value","SaveAuthority"); 
	$("#ProcessBO").attr("value","com.app.aut.Role"); 
	var note = _menuTree.getChecked(true);
	$("#TEXT").attr("value",JSON.stringify(note));
	var param=$("#thisForm").serialize();
	
	$.ajax({
		type:'POST',
		url:'<%=contextPath%>/cm',
		dataType:'json',
		data:param,
		success:function(json)
	    {	
			_RoleDialog.hide();
	    }
	});
}

function Cancle()
{
	_menuTree.selectNode("");
}

function initOperData()
{
	$.getJSON('${pageContext.request.contextPath}/pages/system/aut/aut_role.jsp?action=OperData&time=' + new Date().getTime(), function(result) {
		  
		  var columns =[];
		  var jsonObj = {};
	  	  jsonObj.Rows = result;
	  	  
	  	  columns.push({display:'ID',name:'id',width:'200',align:'left'});
	  	  columns.push({display:'<fmt:message key="name"/>',name:'text',width:'200',align:'left'});
	  	  
		  for(var i=0;i<jsonObj.Rows.length;i++)
		  {
		  	 var name=jsonObj.Rows[i].NAME;
		  	 var Code=jsonObj.Rows[i].OPE_CODE;
		  	 columns.push({ display: name, name: Code, align: 'center', width: 55,editor: { type: 'checkbox' }});
		  }
		  _initButton.set('columns', columns); 
		  _initButton.toggleCol("id",false);//隐藏id列
         _initButton.reRender();
	});
}

</script>
</head>
<body style="padding:4px">
	
  <form name="thisForm" id="thisForm">
  	  <input type="hidden" name="Data" id="Data"/>
  	  <input type="hidden" name="ID" id="ID"/>
  	  <input type="hidden" name="TEXT" id="TEXT"/>
  	  <input type="hidden" name="ROLE_ID" id="ROLE_ID"/>
  	  <input type="hidden" name="TOPMENUID" id="TOPMENUID"/>
      <input type="hidden" name="ProcessMETHOD" id="ProcessMETHOD"/>
	  <input type="hidden" name="ProcessBO" id="ProcessBO"/>
  </form>
   <div id="mainlayout">	
		<div id="maingrid" position="center" title="<%=functionName%>"></div>
	</div>
	<form id="mainform" style="display:none;"></form>
   <div id="navtab" style="display: none">
   	  <div title="<fmt:message key='menu' />权限">
   	  	 <ul id="menuTree">
   	  </div>
   	  <div title="按钮权限">
   	     <div id="buttonFunction"></div>
   	  </div>
   </div>

</body>
</html>