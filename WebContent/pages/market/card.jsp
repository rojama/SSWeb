<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>

<%
	String processBO = "com.app.market.MainBO";
	String processMETHOD = "process";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO;
%>

<link href="${ctx}/js/jquery-ui/jquery-ui.min.css" rel="stylesheet" type="text/css" />
<script src="${ctx}/js/jquery-ui/jquery-ui.min.js" type="text/javascript"></script>

<script type="text/javascript"> 
var priceMap = {};

$(document).ready(function () {
    setInterval("startRequest()", 1500);
});

function startRequest() {
	$.ajax({
		type:'GET',
		url:'<%=serverUrl%>'+'&ACTION=getAll',
		dataType:'json',
		success:function(result)
	    {
			if (result.ERR == null){
				for(var item in panels) {
					var cur = panels[item].title;
					var id = cur+"-L";
					setPrice(id, result[id]);
					id = cur+"-R";
					setPrice(id, result[id]);
					id = cur+"-RL";
					setPrice(id, result[id]);
					id = cur+"-RR";
					setPrice(id, result[id]);
				}           	
           	}else{
           		$.ligerDialog.error(result.ERR);
           	}
	    }
	});
}

function setPrice(id, value){
	if (value){
		$("#"+id+"-S").html(value.substring(0,value.length-2)); 
		$("#"+id+"-B").html(value.substring(value.length-2));
		if (id in priceMap){
			if (priceMap[id]<value){
				$("#"+id+"-D").html("<i class='fa fa-arrow-up'></i>");
				$("#"+id+"-D").css("color","#c00");
				$("#"+id+"-S").css("color","#c00");
				$("#"+id+"-B").css("color","#c00");
				setTimeout(function () { 
// 					$("#"+id+"-S").css("color","#000");
// 					$("#"+id+"-B").css("color","#000");
					$("#"+id+"-S").animate({color:"#000"},400);
					$("#"+id+"-B").animate({color:"#000"},400);
			    }, 1000);
			}else if (priceMap[id]>value){
				$("#"+id+"-D").html("<i class='fa fa-arrow-down'></i>"); 
				$("#"+id+"-D").css("color","#0c0");
				$("#"+id+"-S").css("color","#0c0");
				$("#"+id+"-B").css("color","#0c0");
				setTimeout(function () { 
// 					$("#"+id+"-S").css("color","#000");
// 					$("#"+id+"-B").css("color","#000");
					$("#"+id+"-S").animate({color:"#000"},400);
					$("#"+id+"-B").animate({color:"#000"},400);
			    }, 1000);
			}else{
				$("#"+id+"-D").html("");
			}
		}
		priceMap[id] = value;
		$("#"+id+"-D").fadeIn(0);
		setTimeout(function () { 
			$("#"+id+"-D").fadeOut(400);
	    }, 1000);
	}
}

function changePrice(currency,type){
	$.ajax({
		url:'<%=serverUrl%>'+'&ACTION=changePrice&Type='+type+'&Currency='+currency
	});
}

</script>


    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Saving Portal State - jQuery EasyUI</title>
    <link rel="stylesheet" type="text/css" href="${ctx}/js/easyui/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/js/easyui/themes/icon.css">
    <script type="text/javascript" src="${ctx}/js/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${ctx}/js/easyui/plugins/jquery.portal.js"></script>
    
    <link href="${ctx}/js/AdminEx/css/style.css" rel="stylesheet">
</head>
<body>
    
    <div id="pp" style="width:1278px;position:relative">
        <div style="width:320px;"></div>
        <div style="width:320px;"></div>
        <div style="width:320px;"></div>
        <div style="width:320px;"></div>
    </div>
    <style type="text/css">
    body {
	    background: #FFFFFF;
	}
	.panel-body {
	    background-color: rgb(235, 243, 255);
	}
		.portal{
			padding:5px;
			margin:10px;
			border:0px dashed #99BBE8;
			overflow:visible;
		}
		.portal-noborder{
			border:0;
		}
		.portal-panel{
			margin-bottom:6px;
		}
		.portal-column-td{
			vertical-align:top;
		}	
		.portal-column{
			padding:3px;
			overflow:hidden;
		}
		.portal-proxy{
			opacity:0.6;
			filter:alpha(opacity=60);
		}
		.portal-spacer{
			border:2px dashed #99BBE8;
			margin-bottom:10px;
		}
    </style>
    <script type="text/javascript">
        var panels = [
            {id:'p1',title:'USD_CNY',height:150,collapsible:true,cache:false,closable:true,href:'spot-card.jsp?Currency=USD_CNY'},
            {id:'p2',title:'USD_AUD',height:150,collapsible:true,cache:false,closable:true,href:'spot-card.jsp?Currency=USD_AUD'},
            {id:'p3',title:'USD_EUR',height:150,collapsible:true,cache:false,closable:true,href:'spot-card.jsp?Currency=USD_EUR'},
            {id:'p4',title:'USD_CHF',height:150,collapsible:true,cache:false,closable:true,href:'spot-card.jsp?Currency=USD_CHF'},
            {id:'p5',title:'USD_HKD',height:150,collapsible:true,cache:false,closable:true,href:'spot-card.jsp?Currency=USD_HKD'},
            {id:'p6',title:'CNY_HKD',height:150,collapsible:true,cache:false,closable:true,href:'spot-card.jsp?Currency=CNY_HKD'},
        ];
        function getCookie(name){
            var cookies = document.cookie.split(';');
            if (!cookies.length) return '';
            for(var i=0; i<cookies.length; i++){
                var pair = cookies[i].split('=');
                if ($.trim(pair[0]) == name){
                    return $.trim(pair[1]);
                }
            }
            return '';
        }
        function getPanelOptions(id){
            for(var i=0; i<panels.length; i++){
                if (panels[i].id == id){
                    return panels[i];
                }
            }
            return undefined;
        }
        function getPortalState(){
            var aa = [];
            for(var columnIndex=0; columnIndex<4; columnIndex++){
                var cc = [];
                var panels = $('#pp').portal('getPanels', columnIndex);
                for(var i=0; i<panels.length; i++){
                    cc.push(panels[i].attr('id'));
                }
                aa.push(cc.join(','));
            }
            return aa.join(':');
        }
        function addPanels(portalState){
            var columns = portalState.split(':');
            for(var columnIndex=0; columnIndex<columns.length; columnIndex++){
                var cc = columns[columnIndex].split(',');
                for(var j=0; j<cc.length; j++){
                    var options = getPanelOptions(cc[j]);
                    if (options){
                        var p = $('<div/>').attr('id',options.id).appendTo('body');
                        p.panel(options);
                        $('#pp').portal('add',{
                            panel:p,
                            columnIndex:columnIndex
                        });
                    }
                }
            }
            
        }
        
        $(function(){
            $('#pp').portal({
                onStateChange:function(){
                    var state = getPortalState();
                    var date = new Date();
                    date.setTime(date.getTime() + 30*24*3600*1000);
                    document.cookie = 'portal-state='+state+';expires='+date.toGMTString();
                }
            });
            var state = getCookie('portal-state');
            if (!state){
                state = 'p1,p2:p3,p4:p5:p6';    // the default portal state
            }
            addPanels(state);
            $('#pp').portal('resize');
        });
    </script>
</body>
</html>