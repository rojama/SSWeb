<%@page import="com.app.sys.JsonUtil"%>
<%@page import="com.app.help.InstitutionHelper"%>
<%@page import="com.app.help.RoleHelper"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
<script src="${pageContext.request.contextPath}/js/common/ImagePreview.js" type="text/javascript"></script>
</head>

<%
	String functionName = "机构维护"; //功能名称
	String processBO = "com.app.sys.CommonBO";
	String processMETHOD = "common";
	String TableName = "aut_institution";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO+"&TABLE="+TableName;

	String action =request.getParameter("action");
	String locale=(String)session.getAttribute("locale");
	RoleHelper obj_Role = new RoleHelper();
	InstitutionHelper obj_Ins = new InstitutionHelper();
	
	if("getRoleData".equals(action))
	{
		String INS_ID =(String)request.getParameter("INS_ID");
		String INS_SUPER_ID =(String)request.getParameter("INS_SUPER_ID");
		
		List<Map<String,Object>> list=obj_Role.innerFindInsRole(locale,INS_ID,INS_SUPER_ID);
		
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


<script type="text/javascript">  
		var $grid;
		var $dialog;
		var $form;
		
		  var _roled
		  var _roleDiv
		
        $(function ()
        {        	
			$("#pageloading").hide();	
			
			//$("#mainlayout").ligerLayout();
						
			$grid = $("#maingrid").ligerGrid({
				width: '100%', height: '100%',heightDiff:28,
				columns: [
					{ display: '机构序号', name: 'INS_ID', id:'INS_ID', align: 'left', width: 150 },
	                { display: '机构编号', name: 'INS_CODE', id:'INS_CODE', align: 'left', width: 100 },
	                { display: '简体中文名称', name: 'INS_NAME', id:'INS_NAME', width: 100 },	
	                { display: '英文名称', name: 'INS_ENGNAME', id:'INS_ENGNAME', width: 100 },	
	                { display: '繁体中文名称', name: 'INS_TWNAME', id:'INS_TWNAME', width: 100 },	
	                { display: '排序', name: 'INS_ORDER', id:'INS_ORDER', align: 'left', width: 50 },	
	                { display: "上级机构编号",name:"INS_SUPER_ID",  width: 150 },
	                { display: '维护时间', name: 'SYSTEM_DATETIME', width: 150 }
                ], usePager: false, rownumbers:true,allowUnSelectRow: true,
                tree: {
                	columnId: 'INS_ID',
                    idField: 'INS_ID',
                    parentIDField: 'INS_SUPER_ID'
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
	        	    { display: "机构序号",name:"INS_ID",type:"text",validate:{required:true}},
	        		{ display: "机构编号",name:"INS_CODE",type:"text",validate:{required:true}},
	        		{ display: "简体中文名称",name:"INS_NAME",type:"text",validate:{required:true}},
	        		{ display: "英文名称",name:"INS_ENGNAME",type:"text",validate:{required:false}},
	        		{ display: "繁体中文名称",name:"INS_TWNAME",type:"text",validate:{required:false}},
	        		{ display: "排序",name:"INS_ORDER",type:"int",validate:{required:true}},
	        		{ display: "上级机构编号",name:"INS_SUPER_ID",type:"text",validate:{required:false}},
	        		{ display: "维护时间",name:"SYSTEM_DATETIME",type:"text",validate:{required:false}}
	        	],
	        	buttons:[{text:"<fmt:message key="save"/>",click: doAction}]
	        });
			
			_roled=$("#roleTree").ligerTree({
			 		 nodeDraggable: false,
			 		 autoCheckboxEven:false
			});
			
			action = 'select-all';
			doAction();
        });  
        
        var action = "";
        function toolbarAction(item)
        {
        	action = item.icon;
        	if (action == "add"){
        		$form.setData({INS_ID:'UUID自动',INS_CODE:'',INS_NAME:'',INS_ENGNAME:'',INS_TWNAME:'',INS_ORDER:'0',INS_SUPER_ID:'',SYSTEM_DATETIME:'TIME自动'});
        		var select = $grid.getSelectedRow();        		
        		if (select != null){
        			$form.setData({INS_SUPER_ID:select.INS_ID});
	       		}
        		$form.setEnabled(['INS_CODE','INS_NAME','INS_ENGNAME','INS_TWNAME','INS_ORDER','INS_SUPER_ID'],true);
        		$form.setEnabled(['INS_ID','SYSTEM_DATETIME'],false);
        	}else if (action == "modify"){
        		var select = $grid.getSelectedRow();
        		if (select == null){
        			 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
        			 setTimeout(function () { manager.close(); }, 3000);
        			 return;
        		}
        		$form.setData(select);
        		$form.setData({SYSTEM_DATETIME:'TIME自动'});
        		$form.setEnabled(['INS_ID','INS_NAME','INS_ENGNAME','INS_TWNAME','INS_ORDER','INS_SUPER_ID'],true);
        		$form.setEnabled(['INS_ID','SYSTEM_DATETIME'],false);
        	}else if (action == "delete"){
        		var select = $grid.getSelectedRow();
        		if (select == null){
        			 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
        			 setTimeout(function () { manager.close(); }, 3000);
        			 return;
        		}
        		$form.setData(select);
        		$form.setEnabled(['INS_ID','INS_CODE','INS_NAME','INS_ENGNAME','INS_TWNAME','INS_ORDER','INS_SUPER_ID','SYSTEM_DATETIME'],false);        		
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
        
      //给机构增加角色，初始化角色窗口
        function Role()
        {	
        	var row=$grid.getSelectedRow();
        	if(checkSelectRow(row))
        	{
        		initRoleTreeData(row);  //初始化角色树
        		
    	   		_roleDiv=$.ligerDialog.open({ 
    	    		width: 500,
    	            height: 300, 
    	            top: 100,
    	            isResize: true,
    	            title:"<fmt:message key='role' />",
    	    		target: $("#divRole"),
    	    		buttons:[
    	    			{text:"<fmt:message key='save' />",onclick:roleSave},
    	    			{text:"<fmt:message key='reset' />",onclick:roleReset}
    	    		]
    	   		});
        	}
        }
      
      //检核选中行数
        function checkSelectRow(row)
    	{
        	if (row == null){
	   			 var manager = $.ligerDialog.tip({ title: '提示',content:'请选择一条数据！'});
	   			 setTimeout(function () { manager.close(); }, 3000);
	   			 return false;
	   		}else{
	   			return true;
	   		}
    	}
    	
    	//获取机构角色树的数据
    	function initRoleTreeData(row)
    	{
    		var INS_ID=row.INS_ID;
    		var INS_SUPER_ID=row.INS_SUPER_ID;
    		$.getJSON('${pageContext.request.contextPath}/pages/system/aut/aut_institution.jsp?action=getRoleData&INS_ID='+INS_ID+'&INS_SUPER_ID='+INS_SUPER_ID+'&time=' + new Date().getTime(), function(result) {
    			  _roled.setData(result);
    		});
    	}
    	
    	//保存机构角色
    	function roleSave()
    	{
    		 //获取未完成选中的ID
             var nodes = [];
             var g=_roled;
             $(".l-checkbox-incomplete", _roled.tree).parent().parent("li").each(function ()
             {
                var treedataindex = parseInt($(this).attr("treedataindex"));
                nodes.push({ target: this, data: g._getDataNodeByTreeDataIndex(g.data, treedataindex) });
             });  
             
             //获取已完成选中的ID
             var note = $("#roleTree").ligerGetTreeManager().getChecked();
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
            	for(var l=0;l<note.length;l++)
            	{
            		id+=note[l].data.id+";";
            	}
            	
            	id=id.substring(0,id.length-1);
            }
            
            var rows=$grid.getSelectedRow();
            $("#ProcessMETHOD").attr("value","SaveInsRole");
            $("#InsID").attr("value",rows.INS_ID);
            $("#InsRoleData").attr("value",id);
       	 	var param=$("#thisForm").serialize();
       	  	ajax(param);
            
            _roleDiv.hide();
    	}
    	
    	//重置机构角色
    	function roleReset()
    	{	
    		_roled.selectNode("");
    	}
        
    	function ajax(param)
    	{
    		$.ajax({
    			type:'POST',
    			url:'${pageContext.request.contextPath}/cm',
    			dataType:'json',
    			data:param,
    			success:function(json)
    		    {	
    		    	  message(json);
    		     	  PageLoader.initGridData();
    		    }
    		});
    	}
</script>	 

<body style="padding:4px">
	<div class="l-loading" id="pageloading"></div>
	<div id="mainlayout">	
		<div id="maingrid" position="center" title="<%=functionName%>"></div>
	</div>
	<form id="mainform" style="display:none;"></form>
	<div id="divRole" style="display: none;">
   		<ul id="roleTree">
   </div>
   <form name="thisForm" id="thisForm">
      <input type="hidden" name="Data" id="Data"/>
      <input type="hidden" name="InsID" id="InsID"/>
      <input type="hidden" name="InsRoleData" id="InsRoleData"/>
      <input type="hidden" name="ProcessMETHOD" id="ProcessMETHOD"  value="Save"/>
	  <input type="hidden" name="ProcessBO" id="ProcessBO"  value="com.app.aut.Institution"/>
  </form>	
</body>
</html>