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
<script src="${ctx}/js/highcharts/highcharts-more.js"></script>
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
	container.series[0].points[0].update(y);
};
	

$(function () {

    $('#container').highcharts({

        chart: {
            type: 'gauge',
            plotBackgroundColor: null,
            plotBackgroundImage: null,
            plotBorderWidth: 0,
            plotShadow: false,
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
                				var y = Number(result.Rows[result.Rows.length-1].RECORD_DATA);
                				container.series[0].points[0].update(y);    	
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
        tooltip: {
        	enabled: false
        },
        pane: {
            startAngle: -150,
            endAngle: 150,
            background: [{
                backgroundColor: {
                    linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
                    stops: [
                        [0, '#FFF'],
                        [1, '#333']
                    ]
                },
                borderWidth: 0,
                outerRadius: '109%'
            }, {
                backgroundColor: {
                    linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
                    stops: [
                        [0, '#333'],
                        [1, '#FFF']
                    ]
                },
                borderWidth: 1,
                outerRadius: '107%'
            }, {
                // default background
            }, {
                backgroundColor: '#DDD',
                borderWidth: 0,
                outerRadius: '105%',
                innerRadius: '103%'
            }]
        },

        // the value axis
        yAxis: {
            min: <%=register_list.get(0).get("MONITOR_MIN")%>-((<%=register_list.get(0).get("MONITOR_MAX")%>)-(<%=register_list.get(0).get("MONITOR_MIN")%>))/4,
            max: <%=register_list.get(0).get("MONITOR_MAX")%>+((<%=register_list.get(0).get("MONITOR_MAX")%>)-(<%=register_list.get(0).get("MONITOR_MIN")%>))/4,

            minorTickInterval: 'auto',
            minorTickWidth: 1,
            minorTickLength: 10,
            minorTickPosition: 'inside',
            minorTickColor: '#666',

            tickPixelInterval: 30,
            tickWidth: 2,
            tickPosition: 'inside',
            tickLength: 10,
            tickColor: '#666',
            labels: {
                step: 2,
                rotation: 'auto'
            },
            title: {
                text: '<%=register_list.get(0).get("REGISTER_UNIT")%>'
            },
            plotBands: [{
            	from: <%=register_list.get(0).get("MONITOR_MIN")%>,
	            to: <%=register_list.get(0).get("MONITOR_MAX")%>,
                color: '#55BF3B' // green
            }, {
                from: <%=register_list.get(0).get("MONITOR_MIN")%>-((<%=register_list.get(0).get("MONITOR_MAX")%>)-(<%=register_list.get(0).get("MONITOR_MIN")%>))/4,
                to: <%=register_list.get(0).get("MONITOR_MIN")%>,
                color: '#DF5353' // yellow
            }, {
                from: <%=register_list.get(0).get("MONITOR_MAX")%>,
                to: <%=register_list.get(0).get("MONITOR_MAX")%>+((<%=register_list.get(0).get("MONITOR_MAX")%>)-(<%=register_list.get(0).get("MONITOR_MIN")%>))/4,
                color: '#DF5353' // red
            }]
        },

        series: [{
            name: '<%=register_list.get(0).get("REGISTER_UNIT")%>',
            data: [0],
            tooltip: {
                valueSuffix: ' <%=register_list.get(0).get("REGISTER_UNIT")%>'
            }
        }]
    });
});
</script>
<head>
<title>仪表图</title>
</head>
<body>
<div id="container" style="height: 200px; margin: 0 no">
</div>
</body>
</html>