<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/pages/common/header.jsp" %>
<%@ taglib prefix="shiro" uri="/WEB-INF/shiro.tld" %>  
<%@ page import="org.apache.shiro.SecurityUtils"
import="org.apache.shiro.session.Session"
import="org.apache.shiro.subject.Subject"%>
<title><fmt:message key="sys_title"/></title>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/auth-index.css" />

<script type="text/javascript">

var tab = null;
var accordion = null;  
//tabid计数器，保证tabid不会重复
var tabidcounter = 0;
$(function() { 

	// 布局
	$("#main-content").ligerLayout({
		leftWidth : 200,
		height : '100%',
		heightDiff : -26,
		space : 4,
		onHeightChanged : layoutHeiheightChangeEvent
	});

	var height = $(".l-layout-center").height();
	// Tab
	$("#framecenter").ligerTab({
		height : height,
		dragToMove : true,
		showSwitch: true,
		showSwitchInTab: false
	});
	

	$(".l-link").hover(function() {
		$(this).addClass("l-link-over");
	}, function() {
		$(this).removeClass("l-link-over");
	});

	tab = $("#framecenter").ligerGetTabManager();
	
	//加载导航菜单
	loadLeftMenu();	
});


function layoutHeiheightChangeEvent(options) {
	if (tab)
		tab.addHeight(options.diff);
}

var actionNode;
var bookmarktree;
var statedata = [];

function opennew(item, i)
{
   window.open(actionNode.data.URL);
}

function bookmark(item, i)
{
	if (actionNode.data){	
		//查找重复
		for(var i=0; i<statedata.length; i++){
	        var val = statedata[i];
	        if (val.ID == actionNode.data.ID){
				return;
			}
	    }
		
		var nodes = [];
	    nodes.push({ TEXT: actionNode.data.TEXT, URL: actionNode.data.URL, ID: actionNode.data.ID});
		bookmarktree.append(null, nodes); 
		savecookie();
	}
}

function unbookmark(item, i)
{
	bookmarktree.remove(actionNode); 
	savecookie();
}

function getCookie(name){
    var cookies = unescape(document.cookie).split(';');
    if (!cookies.length) return '';
    for(var i=0; i<cookies.length; i++){
        var pair = cookies[i].split('=');
        if ($.trim(pair[0]) == name){
            return $.trim(pair[1]);
        }
    }
    return '[]';
}

function savecookie()
{
	statedata = [];
	for(var i=0; i<bookmarktree.data.length; i++){
        var val = bookmarktree.data[i];
        var status = val.__status;
		if ('delete' != status){
			statedata.push({ TEXT: val.TEXT, URL: val.URL, ID: val.ID});
		}
    }
	
	var state = escape(JSON.stringify(statedata));
    var date = new Date();
    date.setTime(date.getTime() + 30*24*3600*1000);
    document.cookie = 'bookmark_state='+state+';expires='+date.toGMTString();
}

function onSelect(node)
{
	var url = node.data.URL;
		var text = node.data.TEXT;
		var tabid = $(node.target).attr("tabid");
		if (!url) {
			return;
		}
		if (node.data.TYPE == "2") {
			return;
		}
    if (!tabid) {
        tabidcounter++;
        tabid = "tabid" + tabidcounter;
        $(node.target).attr("tabid", tabid);
    }
    addTabEvent(tabid, text, url);
}


function loadLeftMenu() {
	 var $leftmenu = $("#leftmenu");
	 
	 var lmenu = $.ligerMenu({ top: 100, left: 100, width: 120, items:
         [{ text: '新窗口打开', click: opennew},
          { text: '加入收藏', click: bookmark}]
         });
	 
	 var bookmarklmenu = $.ligerMenu({ top: 100, left: 100, width: 120, items:
         [{ text: '新窗口打开', click: opennew},
          { text: '取消收藏', click: unbookmark}]
         });

	 //加载栏目
     $.getJSON('${pageContext.request.contextPath}/cm?ProcessBO=com.app.sys.Authority&ProcessMETHOD=findTopMenuByUser&time=' + new Date().getTime(), function (menus)
     {
    	//bookmark
    	 statedata = JSON.parse(getCookie('bookmark_state'));
         $leftmenu.append('<div id="main_bookmark" title="个人收藏夹" class="l-scroll"><ul id="sub_bookmark"></ul></div>');
         bookmarktree = $("#sub_bookmark").ligerTree({
        	data:statedata,
      		isExpand:false,
      		checkbox:false,
      		needCancel:false,
      		textFieldName:'TEXT',
      		idFieldName:'ID',
      		onSelect: onSelect,
			onContextmenu: function (node, e)
             { 
                 actionNode = node;
                 bookmarklmenu.show({ top: e.pageY, left: e.pageX });
                 return false;
             }
      	});
      	$("#sub_bookmark").css("margin-top","3px").css("width","200px");
      	
      	//end bookmark
      	
      	
         $(menus.data).each(function (i, menu)
         {
        	 $leftmenu.append('<div id="main_'+menu.ID+'" title="' + menu.NAME + '" class="l-scroll"><ul id="sub_'+menu.ID+'"></ul></div>');
        	 //加载栏目菜单
        	 $.getJSON('${pageContext.request.contextPath}/cm?ProcessBO=com.app.sys.Authority&ProcessMETHOD=findAllSubMenuByParent&TopMenuID=' + menu.ID + '&time=' + new Date().getTime(), function(submenu) {
             	var tree = $("#sub_"+menu.ID).ligerTree({
             		data:submenu.data,
             		isExpand:false,              		
             		checkbox:false,
             		needCancel:false,
             		textFieldName:'TEXT',
             		idFieldName:'ID',
             		parentIDFieldName :'TOPMENUID',
             		onSelect: onSelect,
             		onContextmenu: function (node, e)
                    { 
                        actionNode = node;
                        lmenu.show({ top: e.pageY, left: e.pageX });
                        return false;
                    }

             	});
             	$("#sub_"+menu.ID).css("margin-top","3px").css("width","200px");
             	
             });//加载栏目菜单end
         });
          
         
      	
         //Accordion
         accordion = $leftmenu.ligerAccordion();
         $("#pageloading").hide();
     });//加载栏目end 
}


function addTabEvent(tabid, text, url) {
	tab.addTabItem({
		tabid : tabid,
		text : text,
		url : url
	});
	tab.reload(tabid);
}

Koala.changepassword = function ()
{
    $(document).bind('keydown.changepassword', function (e)
    {
        if (e.keyCode == 13)
        {
            doChangePassword();
        }
    });

    var changepasswordPanel = null;
    if (!window.changePasswordWin)
    {
    	changepasswordPanel = $("#changepasswordPanel");

        window.changePasswordWin = $.ligerDialog.open({
            width: 400,
            height: 190, 
            top: 200,
            isResize: true,
            title: '用户修改密码',
            target: changepasswordPanel,
            buttons: [
            { text: '<fmt:message key="ok"/>', onclick: function ()
            {
                doChangePassword();
            }
            },
            { text: '<fmt:message key="cancel"/>', onclick: function ()
            {
                window.changePasswordWin.hide();
                $(document).unbind('keydown.changepassword');
            }
            }
            ]
        });
    }
    else
    {
        window.changePasswordWin.show();
    }

    function doChangePassword()
    {
        var OldPassword = $("#oldPassword").val();
        var newPassword = $("#newPassword").val();
        var confirmPassword = $("#confirmPassword").val();
        
        if (confirmPassword != newPassword){
        	$.ligerDialog.error("两次密码输入不一致");
        	return;
        }        
        
        var data = "oldPassword=" + OldPassword + "&newPassword=" + newPassword;
        //验证
        var form = document.forms[0];
        if(!Validator.Validate(form,3))return;
        $.ajax({
        	method:"post",
        	url:"cm?ProcessMETHOD=changeUserPassword&ProcessBO=com.app.sys.Authority",
        	data:data,
        	success:function(result) {
        		if (result.ERR == null){
        			$.ligerDialog.alert("密码修改成功");
        			changePasswordWin.hidden();
               	}else{
               		$.ligerDialog.error(result.ERR);
               	}
        	}
        });
    }

};
/**
//刷新数据
$(document).ready(function () {
	startRequest();
    setInterval("startRequest()", 60000);
});

function startRequest() {
	$.ajax({
		type:'GET',
		url:'cm?ProcessMETHOD=getIndexCount&ProcessHP=com.app.help.MenuHelper',
		dataType:'json',
		success:function(result)
	    {
			$("#taskCount").html("待办任务("+result.taskCount+")");
	    }
	});
}
**/
</script>

<style type="text/css">
.l-tree{
width: 400px;
}
</style> 
<% 
Subject subject = SecurityUtils.getSubject(); 
Session shiro_session= subject.getSession();
%>
</head>
<body style="padding:0px;background:#EAEEF5;overflow:hidden;">  
<div id="pageloading"></div>  
<div id="topmenu" class="l-topmenu">
        <div class="l-topmenu-logo"></div>
        <div class="l-topmenu-title"><fmt:message key="sys_title"/></div>
        <shiro:user>
	        <div class="l-topmenu-welcome"> 
	            <span class="l-topmenu-username">[<fmt:message key="welcome"/>, <%=shiro_session.getAttribute("USER_NAME") %>]</span>  &nbsp; 
	            [<a href="javascript:Koala.changepassword()"><fmt:message key="update"/><fmt:message key="password"/></a>] &nbsp; 
	            [<a href="${pageContext.request.contextPath}/logout"><fmt:message key="logout"/></a>]
	        </div>
	        
	        <div class="l-topmenu-note"> 
	            [<a id="taskCount" href="javascript:addTabEvent('task', '待办任务', 'pages/system/flow/task.jsp');">待办任务()</a>]  &nbsp; 
	            [<a href="">系统通知()</a>] &nbsp; 
	            [<a href="">用户消息()</a>]
	        </div>
        </shiro:user>
  </div>
  
  <div id="main-content" style="width:99.2%; margin:0 auto; margin-top:4px; "> 
        <div position="left"  title='<fmt:message key="system"/><fmt:message key="menu"/>' id="leftmenu22"  style="position:relative; overflow-y:auto">
	        <div id="leftmenu" style="position:relative; overflow-y:auto">
	        </div>
        </div>
        <div position="center" id="framecenter"> 
            <div tabid="home" title='<fmt:message key="home"/>' style="height:300px" >
                <iframe frameborder="0" name="home" id="home" src="${pageContext.request.contextPath}/pages/common/welcome.jsp"></iframe>
            </div> 
        </div> 
        
    </div>
    <div  style="height:26px; line-height:26px; text-align:center;">
            Copyright © 2000-2016 SkySoft Software
    </div>
    <div style="display:none"></div>
    <form id="changepasswordPanel" style="display:none;">
		<table cellpadding="0" cellspacing="0" class="form2column" >
			<tr>
				<td class="label">旧密码:</td>
				<td class="content">
					<input name="oldPassword" type="password" id="oldPassword" class="input-common" dataType="Require" />
				</td>
			</tr>
			<tr>
				<td class="label">新密码:</td>
				<td class="content">
					<input name="newPassword" type="password" id="newPassword" class="input-common" dataType="Require" maxLength="16" />
				</td>
			</tr>
			<tr>
				<td class="label">确认密码:</td>
				<td class="content">
					<input name="confirmPassword" type="password" id="confirmPassword" class="input-common" dataType="Require" maxLength="16" />
				</td>
			</tr>
		</table>
	</form>
</body>

</html>