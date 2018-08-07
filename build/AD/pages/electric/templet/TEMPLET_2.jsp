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
	
	String processBO = "com.app.electric.ElectricPagesBean";
	String processMETHOD = "templet";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO;
%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script src="${ctx}/js/jquery/jquery-1.8.3.min.js"></script>
<script src="${ctx}/js/highcharts/highcharts.js"></script>
<script type="text/javascript">

var container;

var webSocket = new WebSocket('ws://'+window.location.host+'${ctx}/websocket?WSCODE=ELE_DEV_<%=device_id%>');  

webSocket.onerror = function(event) { 
	 
}; 

webSocket.onopen = function(event) { 
	
}; 

webSocket.onmessage = function(event) { 
	var data = eval("(" + event.data + ")"); 
	if (data.REGISTER_ID != '<%=register_id %>'){
		return;
	}
	var x = (new Date(data.RECORD_TIME)).getTime(); 
	var y = Number(data.RECORD_DATA);
    container.series[0].addPoint([x, y], true, true);
};
	


$(function () {
	Highcharts.setOptions({
        global: {
            useUTC: false
        }
    });
	
	$('#container').highcharts({
    	chart: {
            type: 'areaspline',
            //animation: false, // don't animate in old IE
            events: {
                load: function () {
                    container = this;
                    $.ajax({
                		type:'GET',
                		async:false,
                		url:'<%=serverUrl%>'+'&ACTION=get-top-record&DEVICE_ID='+'<%=device_id%>'+'&REGISTER_ID='+'<%=register_id%>',
                		dataType:'json',
                		success:function(result)
                	    {
                			if (result.ERR == null){				
                				container.series[0].setData(result.Rows);          	
                           	}
                	    }
                	});
                }
            }
        },
        title: {
            text: '',
            floating: true,
        },
        credits: {
        	enabled: false
        },
        plotOptions: {        	          
        	series: {
        		animation: false
        	}
        },
        xAxis: {
        	type: 'datetime'
        },
        yAxis: {
        	title: {
            	rotation: 0,
                text: '<%=register_list.get(0).get("REGISTER_UNIT")%>'
            },
            offset:-10,
	        plotBands: [{
	            from: <%=register_list.get(0).get("MONITOR_MIN")%>,
	            to: <%=register_list.get(0).get("MONITOR_MAX")%>,
	            color: 'rgba(68, 170, 213, 0.1)'
	        }]
        },
        tooltip: {
            formatter: function () {
                return '<b>' + this.series.name + '</b><br/>' +
                    Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) + '<br/>' +
                    this.y + '<%=register_list.get(0).get("REGISTER_UNIT")%>';
            }
        },
        series: [{
            name: '<%=register_list.get(0).get("REGISTER_NAME")%>'
        }]
    });
});
</script>
<head>
<title>区域图</title>
</head>
<body>
<div id="container" style="height: 200px; margin: 0 no">
</div>
</body>
</html>