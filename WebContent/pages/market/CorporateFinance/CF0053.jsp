<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
import = "com.app.utility.DESUtil" 
import = "java.net.URLEncoder" 
%>
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>

<%
	String target = "service=1YwiT965lk&org=1360000&user=001634&pass=1&task=FUNFXF90";
	target = URLEncoder.encode(DESUtil.encode(target),  "UTF-8");
	
%>
<script type="text/javascript">
$(function ()
		{
	window.location.href='http://192.168.80.113:6060/granite-develop/page.go?name=osc&target='+'<%=target %>';
		});
	
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>登录</title>
</head>

<body style="padding:4px; overflow:hidden;">
<div class="l-loading" id="pageloading"></div>
<div id="maingrid"></div>
<form id="mainform" style="display:none;"></form>
</body>
</html>