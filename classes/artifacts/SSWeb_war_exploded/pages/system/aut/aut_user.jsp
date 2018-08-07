<%@page import="com.app.sys.JsonUtil"%>
<%@page import="com.app.help.RoleHelper"%>
<%@page import="com.app.help.InstitutionHelper"%>
<%@page import="org.apache.shiro.session.Session"%>
<%@page import="org.apache.shiro.SecurityUtils"%>
<%@page import="org.apache.shiro.subject.Subject"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

String functionName = "用户维护"; //功能名称
String processBO = "com.app.sys.CommonBO";
String processMETHOD = "common";
String TableName = "aut_user";
String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO+"&TABLE="+TableName;

	String action = (String)request.getParameter("action");
	String locale=(String)session.getAttribute("locale");
	
	InstitutionHelper obj_InstitutionHelper = new InstitutionHelper();
	RoleHelper obj_role = new RoleHelper();
	if("getInsData".equals(action))//获取机构树
	{
		String USER_ID=(String)request.getParameter("USER_ID");
		List<Map<String, Object>> list=obj_InstitutionHelper.innerFindInstitutionUser(locale, USER_ID, "");
		String dataAsJson=JsonUtil.list2json(list);
		
		dataAsJson=dataAsJson.replace("INS_ID", "id");
		dataAsJson=dataAsJson.replace("NAME", "text");
		dataAsJson=dataAsJson.replace("null", "false");
		dataAsJson=dataAsJson.replace("ISCHECKED", "ischecked");
		
		PrintWriter pw = response.getWriter();
		pw.print(dataAsJson);
		pw.flush();
		pw.close(); 
	}
	else if("getRoleData".equals(action))//获取用户树
	{
		String USER_ID=(String)request.getParameter("USER_ID"); 
		List<Map<String, Object>> list=obj_role.innerFindUserRole(locale, USER_ID, "");
		String dataAsJson=JsonUtil.list2json(list);
		
		dataAsJson=dataAsJson.replace("ROLE_ID", "id");
		dataAsJson=dataAsJson.replace("NAME", "text");
		dataAsJson=dataAsJson.replace("null", "false");
		dataAsJson=dataAsJson.replace("ISCHECKED", "ischecked");
		
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
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ligerUI/js/plugins/ligerGrid.js"></script>
<script type="text/javascript">  
  
var $grid;
var $dialog;
var $form;
  var _ins;
  var _insDiv;
  var _role;
  var _roleDiv;
  var _dialog;
  var _edit;
  var start_Data=[{IS_START:'Y',text:'<fmt:message key="yes"/>'},{IS_START:'N',text:'<fmt:message key="no"/>'}];
  
   $(function(){
	   $("#pageloading").hide();	
							
		$grid = $("#maingrid").ligerGrid({
			width: '100%', height: '100%',heightDiff:28,
			columns: [
				{ display: '用户序号', name: 'USER_ID', id:'USER_ID', align: 'left', width: 150 },
	            { display: '简体中文名称', name: 'USER_NAME', id:'USER_NAME', width: 100 },	
	            { display: '英文名称', name: 'USER_ENGNAME', id:'USER_ENGNAME', width: 100 },	
	            { display: '繁体中文名称', name: 'USER_TWNAME', id:'USER_TWNAME', width: 100 },	
	            { display: '停用', name: 'IS_START', width: 50 },
	            { display: '维护时间', name: 'SYSTEM_DATETIME', width: 150 }
	        ], usePager: false, rownumbers:true,allowUnSelectRow: true,
	        toolbar: { items: [
	            	{ text: '<fmt:message key="add"/>', click: toolbarAction, icon: 'add' },
		            { line: true },
		            { text: '<fmt:message key="edit"/>', click: toolbarAction, icon: 'modify' },
		            { line: true },
		            { text: '<fmt:message key="remove"/>', click: toolbarAction, icon: 'delete' },
	        	   { line: true },
	        	   { text: '<fmt:message key="resetpsd"/>',click:Resetpsd,icon:'settings'},
	        	   { line: true },
                   { text: '<fmt:message key="institution"/>',click:Institution,icon:'memeber'},
	        	   { line: true },
                   { text: '<fmt:message key="role"/>',click:Role,icon:'role'}
	        ]
	        }
	    });
		
		$form = $("#mainform").ligerForm({
	    	inputWidth: 200, labelWidth: 150, space:50, validate:true, align: 'center',width: '98%',
	    	fields:[	//表单栏位	        	    
	    	    { display: "用户序号",name:"USER_ID",type:"text",validate:{required:true}},
	    		{ display: "简体中文名称",name:"USER_NAME",type:"text",validate:{required:true}},
	    		{ display: "英文名称",name:"USER_ENGNAME",type:"text",validate:{required:false}},
	    		{ display: "繁体中文名称",name:"USER_TWNAME",type:"text",validate:{required:false}},
	    		{ display: "停用",name:"IS_START",type:"text",validate:{required:false}},
	    		{ display: "维护时间",name:"SYSTEM_DATETIME",type:"text",validate:{required:false}}
	    	],
	    	buttons:[{text:"<fmt:message key='save'/>",click: doAction}]
	    });
		
   		_ins=PageLoader.initInsTree();//初始化机构用户
   		_role=PageLoader.initRoleTree();//初始化机构角
   		
   		action = 'select-all';
   		doAction();
   });
   

   var action = "";
   function toolbarAction(item)
   {
   	action = item.icon;
   	if (action == "add"){
   		$form.setData({USER_ID:'',USER_NAME:'',USER_ENGNAME:'',USER_TWNAME:'',IS_START:'N',SYSTEM_DATETIME:'TIME自动'});
   		$form.setEnabled(['USER_ID','USER_NAME','USER_ENGNAME','USER_TWNAME','IS_START'],true);
   		$form.setEnabled(['SYSTEM_DATETIME'],false);
   	}else if (action == "modify"){
   		var select = $grid.getSelectedRow();
   		if (select == null){
   			 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
   			 setTimeout(function () { manager.close(); }, 3000);
   			 return;
   		}
   		$form.setData(select);
   		$form.setData({SYSTEM_DATETIME:'TIME自动'});
   		$form.setEnabled(['USER_ID','USER_NAME','USER_ENGNAME','USER_TWNAME','IS_START'],true);
   		$form.setEnabled(['USER_ID','SYSTEM_DATETIME'],false);
   	}else if (action == "delete"){
   		var select = $grid.getSelectedRow();
   		if (select == null){
   			 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
   			 setTimeout(function () { manager.close(); }, 3000);
   			 return;
   		}
   		$form.setData(select);
   		$form.setEnabled(['USER_ID','USER_NAME','USER_ENGNAME','USER_TWNAME','IS_START','SYSTEM_DATETIME'],false);        		
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
   
   PageLoader = {   		
		   
		   initGridData:function()//初始化用户数据
			{
			 	$.getJSON('${pageContext.request.contextPath}/cm?ProcessBO=com.app.aut.User&ProcessMETHOD=findAll&time=' + new Date().getTime(), function(result) {
			  
					  var jsonObj = {};   
					     
					  jsonObj.Rows = result.data;
					  
					  $grid.set({data:jsonObj});
				});
			 },
			 
		 initInsTree:function()//初始化机构用户树
		 {
		 	var g=$("#InsTree").ligerTree({
		 		 nodeDraggable: true,
		 		 autoCheckboxEven:false
		 	});
		 	return g;
		 },
		 initRoleTree:function()//初始化用户角色树
		 {
		 	var g=$("#roleTree").ligerTree({
		 		 nodeDraggable: true,
		 		 autoCheckboxEven:false
		 	});
		 	return g;
		 }
   }

   
   //重置密码
   function Resetpsd()
   {
   	  var row=$grid.getSelectedRow();
  		if(checkSelectRow(row))
  		{
	   		_edit=$.ligerDialog.open({ 
		    		width: 350,
		            height: 300, 
		            top: 100,
		            isResize: true,
		            title:"<fmt:message key='reset'/><fmt:message key='password'/>",
		    		target: $("#passwordForm"),
		    		buttons:[
		    			{text:"<fmt:message key='save' />",onclick:savePsd}
		    		]
		    });
	    
		    $("#USERID").attr("value",row.USER_ID);
		    $("#PASSWORD").attr("value","");
		    $("#REPASSWORD").attr("value","");
  		}
   }
   //保存密码
   function savePsd()
   {
   		var param=$("#passwordForm").serialize();
		ajax(param);
		_edit.hide();
   }
    
   
   //用户机构树弹窗 
   function Institution()
   {
    	var row=$grid.getSelectedRow();
    	if(checkSelectRow(row))
    	{
   	    	getTreeData("getInsData",row);
    		_insDiv=$.ligerDialog.open({ 
	    		width: 500,
	            height: 300, 
	            top: 100,
	            isResize: true,
	            title:"<fmt:message key='institution'/>",
	    		target: $("#InsTree"),
	    		buttons:[
	    			{text:"<fmt:message key='save' />",onclick:saveUserIns},
	    			{text:"<fmt:message key='reset' />",onclick:resetTree}
	    		]
    		});
    	}
    }
    
    //用户角色树弹窗
    function Role()
    {
    	
    	var row=$grid.getSelectedRow();
    	if(checkSelectRow(row))
    	{	
    		getTreeData("getRoleData",row)
	    	_roleDiv=$.ligerDialog.open({ 
	    		width: 500,
	            height: 300, 
	            top: 100,
	            isResize: true,
	            title:"<fmt:message key='role'/>",
	    		target: $("#roleTree"),
	    		buttons:[
	    			{text:"<fmt:message key='save' />",onclick:saveUserRole},
	    			{text:"<fmt:message key='reset' />",onclick:resetTree}
	    		]
	    	});
    	}
    }
   
   //检核选中行数
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
	
	//将用户已经存在的用户机构和用户角色打勾
	function getTreeData(action,row)
	{
		var id=row.USER_ID
	
		$.getJSON('${pageContext.request.contextPath}/pages/system/aut/aut_user.jsp?action='+action+'&USER_ID='+id+'&time='+ new Date().getTime(),function(result){
				
				if(action=="getInsData")
				{	
					 _ins.setData(result);
				}
				else if(action=="getRoleData")
				{
					 _role.setData(result);
				}
		});
	}
   
   //保存用户角色
   function saveUserRole()
   {
   		var id=getSelectID(_role);
   		var row=$grid.getSelectedRow();
   		
   		$("#ProcessMETHOD").attr("value","SaveRole");
   		$("#RoleData").attr("value",id);
   		$("#USER_ID").attr("value",row.USER_ID);
   		
   		var param=$("#thisForm").serialize();
   		ajax(param);
   		_roleDiv.hide();
   }
   
   //保存机构用户
   function saveUserIns()
   {
   		var id=getSelectID(_ins);
   		var row=$grid.getSelectedRow();
   		
   		$("#ProcessMETHOD").attr("value","SaveIns");
   		$("#InsData").attr("value",id);
   		$("#USER_ID").attr("value",row.USER_ID);
   		
   		var param=$("#thisForm").serialize();
   		ajax(param);
   		_insDiv.hide();
   }
   
   //重置选中的节点
   function resetTree()
   {
   		_ins.selectNode("");
   		_role.selectNode("");
   }
   
   //获取已选中的节点
   function getSelectID(ids)
   {
   		
   		//获取未完成选中的ID
         var nodes = [];
         var g=ids;
         $(".l-checkbox-incomplete", g.tree).parent().parent("li").each(function ()
         {
            var treedataindex = parseInt($(this).attr("treedataindex"));
            nodes.push({ target: this, data: g._getDataNodeByTreeDataIndex(g.data, treedataindex) });
         });
         
   		var note=ids.getChecked();
		var id="";
		
		if(nodes.length>0)
        {
         	for(var i=0;i<nodes.length;i++)
         	{
         		id+=nodes[i].data.id+";";
         	}
        }
		
		if(note.length>0)
		{
			for(var i=0;i<note.length;i++)
			{
				id +=note[i].data.id + ";";
			}
			
			id=id.substring(0,id.length-1);
		}
		
		return id
   }
   
   function ajax(param)
   {
   		$.ajax({
			type:'POST',
			url:'<%=contextPath%>/cm',
			dataType:'json',
			data:param,
			success:function(json)
		    {
		    	  message(json);	
		     	  PageLoader.initGridData();
		    }
   		});
   }
   
   function message(json)
   {
		var mes=JSON.stringify(json);
		
		if(undefined!=json.MSG)
		{	
			$.ligerDialog.success("<fmt:message key='success'/>");
		}
		
		if(undefined!=json.ERR)
		{
			$.ligerDialog.error("<fmt:message key='error'/>"+json.ERR);
		}
   }
   
</script>
</head>
<body style="padding:4px; overflow:hidden;">
    <div id="mainlayout">	
		<div id="maingrid" position="center" title="<%=functionName%>"></div>
	</div>
	<form id="mainform" style="display:none;"></form>
   
   <div id="divIns" style="display: none;">
   		<ul id="InsTree">
   </div>
   
   <div id="divRole" style="display: none;">
   		<ul id="roleTree">
   </div>
   
   <form id="thisForm">
     <input type="hidden" name="AddData" id="AddData"/>
     <input type="hidden" name="EditData" id="EditData"/>
     <input type="hidden" name="DelData" id="DelData"/>
     <input type="hidden" name="InsData" id="InsData"/>
     <input type="hidden" name="RoleData" id="RoleData"/>
     <input type="hidden" name="USER_ID" id="USER_ID"/>
     <input type="hidden" name="ProcessMETHOD" id="ProcessMETHOD"  value="Save"/>
	 <input type="hidden" name="ProcessBO" id="ProcessBO"  value="com.app.aut.User"/>
   </form>
   <form id="editForm" style="display: none">
   	 <table border="0" cellpadding="0" cellspacing="0" class="form2column">
   	   <tr>
   	     <td class="label"><fmt:message key='user' />ID</td>
   	     <td><input type="text" name="USID" id="USID" class="input-common" disabled/></td>
   	   </tr>
   	   <tr>
	       <td class="label"><fmt:message key='zh_ch_name' /></td>
	       <td><input type="text" name="USER_NAME" id="USER_NAME" class="input-common"/></td>
	    </tr>
	    <tr>
	       <td class="label"><fmt:message key='en_us_name' /></td>
	       <td><input type="text" name="USER_ENGNAME" id="USER_ENGNAME" class="input-common"/></td>
	    </tr>
	    <tr>
	      <td class="label"><fmt:message key='zh_tw_name' /></td>
	      <td><input type="text" name="USER_TWNAME" id="USER_TWNAME" class="input-common"/></td>
	    </tr>
	    <tr>
	      <td class="label"><fmt:message key='start'/></td>
	      <td>
	        <select name="IS_START" id="IS_START" class="select-common">
               <option value="Y"><fmt:message key='yes' /></option>
               <option value="N"><fmt:message key='no' /></option>
	        </select>
	      </td>
	    </tr>
   	 </table>
   </form>
   <form id="passwordForm" style="display: none">
      <input type="hidden" name="ProcessMETHOD" id="ProcessMETHOD"  value="ResetPassword"/>
	  <input type="hidden" name="ProcessBO" id="ProcessBO"  value="com.app.aut.User"/>
      <table border="0" cellpadding="0" cellspacing="0" class="form2column">
        <tr>
   	     <td class="label"><fmt:message key='user' />ID</td>
   	     <td><input type="text" name="USERID" id="USERID" class="input-common" readonly/></td>
   	   </tr>
   	   <tr>
   	     <td class="label"><fmt:message key='password' /></td>
   	     <td><input type="password" name="PASSWORD" id="PASSWORD" class="input-common"/></td>
   	   </tr>
   	   <tr>
   	     <td class="label"><fmt:message key='ok' /><fmt:message key='password' /></td>
   	     <td><input type="password" name="REPASSWORD" id="REPASSWORD" class="input-common"/></td>
   	   </tr>
      </table>
   </form>
</body>
</html>