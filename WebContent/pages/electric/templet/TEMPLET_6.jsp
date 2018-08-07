<%@page import="java.math.BigDecimal"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="com.app.sys.*"%>
<%@page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@ taglib prefix="c" uri="/WEB-INF/c.tld" %>
<%
	String device_id = (String) request.getParameter("device_id");
	String device_type_id = (String) request.getParameter("device_type_id");
	String register_id = (String) request.getParameter("register_id");
	Map<String, Object> where = new HashMap<String, Object>();
	where.put("DEVICE_TYPE_ID", device_type_id);
	where.put("REGISTER_ID", register_id);
	List<Map<String,Object>> register_list = DB.seleteByKey("ele_device_type_register", where);	
	
	BigDecimal register_multiply = (BigDecimal)register_list.get(0).get("REGISTER_MULTIPLY");

	String processBO = "com.app.electric.ElectricPagesBean";
	String processMETHOD = "templet";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO;
%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<style type="text/css">
h1.jumbo {
	font-size:10;
	margin:0;
	color:#4d63bc;
	font-family:'Source Sans Pro', Helvetica, Arial, sans-serif;
}
.align-center{ 
margin:0 auto; 
text-align:center; 
} 
</style>
<script type="text/javascript" src="${ctx}/js/jquery/jquery-1.8.3.min.js"></script>
<script src="${ctx}/js/highcharts/highcharts.js"></script>
<script type="text/javascript" src="${ctx}/js/countUp.js"></script>
<script type="text/javascript">

var container;

var webSocket = new WebSocket('ws://'+window.location.host+'${ctx}/websocket?WSCODE=ELE_DEV_<%=device_id%>');  

webSocket.onerror = function(event) { 
	 
}; 

webSocket.onopen = function(event) { 
	
}; 

var old = 0;

webSocket.onmessage = function(event) { 
	var data = eval("(" + event.data + ")"); 
	if (data.REGISTER_ID != '<%=register_id %>'){
		return;
	}
	var y = Number(data.RECORD_DATA);
	$("#time").html(data.RECORD_TIME);
	(new CountUp("display", old, y, 0, 1, options)).start();
	old = y;
};

var options = {
		  useEasing : true, 
		  useGrouping : false, 
		  separator : ',', 
		  decimal : '.', 
		  prefix : '<%=register_list.get(0).get("REGISTER_NAME")%>: ', 
		  suffix : ' <%=register_list.get(0).get("REGISTER_UNIT")%>' 
		};
		
		
$(function () {
	$.ajax({
		type:'GET',
		async:false,
		url:'<%=serverUrl%>'+'&ACTION=get-top-record&DEVICE_ID='+'<%=device_id%>'+'&REGISTER_ID='+'<%=register_id%>',
		dataType:'json',
		success:function(result)
	    {
			if (result.ERR == null){				
				var y = Number(result.Rows[result.Rows.length-1].RECORD_DATA);
				$("#time").html(result.Rows[result.Rows.length-1].RECORD_TIME);
				
				(new CountUp("display", old, y, <%=register_multiply.stripTrailingZeros().scale()%>, 1, options)).start();
				old = y;
           	}
	    }
	});
});
		
</script>
<head>
<title>数字图</title>
</head>
<body>
<div id="container" style="height: 70px; margin: 0 no" class="align-center">
<div class="time" id="time" style="margin: 5px;"></div>
<h1 class="jumbo" id="display"></h1>
</div>
</body>
</html>