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
	var x = data.RECORD_TIME; 
	var y = Number(data.RECORD_DATA);
    container.series[0].setData([{
        name: x,
        y: y
    },{
        name: '空白',
        y: 100-y
    }]);
};
	


$(function () {
	Highcharts.setOptions({
        global: {
            useUTC: false
        }
    });
	
	$('#container').highcharts({
    	chart: {
            type: 'pie',
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
                				var x = result.Rows[result.Rows.length-1].RECORD_TIME; 
                				var y = Number(result.Rows[result.Rows.length-1].RECORD_DATA);
                			    container.series[0].setData([{
                			        name: x,
                			        y: y
                			    },{
                			        name: '空白',
                			        y: 100-y
                			    }]);
                           	}
                	    }
                	});
                }
            }
        },
        title: {
            text: '<%=register_list.get(0).get("REGISTER_NAME")%>',
            align: 'left',
            y: 100,
            floating: true
        },
        credits: {
        	enabled: false
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: false
                },
                showInLegend: false
            }
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        series: [{
            name: '<%=register_list.get(0).get("REGISTER_NAME")%>',
            data: [{
                name: '',
                y: 0
            },{
                name: '',
                y: 100
            }]
            
        }]
    });
});
</script>
<head>
<title>饼状图</title>
</head>
<body>
<div id="container" style="height: 200px; margin: 0 no">
</div>
</body>
</html>