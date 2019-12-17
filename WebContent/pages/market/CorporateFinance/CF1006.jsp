<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<%@ include file="/pages/common/commonhead.jsp" %>

<%
	String processBO = "com.app.TR.CorporateFinance";
	String processMETHOD = "CF1001";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO;
%>

    <title>Saving Portal State - jQuery EasyUI</title>
    <link rel="stylesheet" type="text/css" href="${ctx}/js/easyui/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/js/easyui/themes/icon.css">
    <script type="text/javascript" src="${ctx}/js/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${ctx}/js/easyui/plugins/jquery.portal.js"></script>
    <link rel="stylesheet" type="text/css" href="${ctx}/js/easyui/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/js/easyui/themes/icon.css">
    <script type="text/javascript" src="${ctx}/js/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${ctx}/js/easyui/plugins/jquery.portal.js"></script>
    <script src="${ctx}/js/ligerUI/js/plugins/ligerSpinner.js" type="text/javascript"></script>
    <script type="text/javascript">

    $(function ()
    		{
    			$("form").ligerForm();
    			$("#txt1").ligerSpinner({ height: 28,width:40, type: 'int' });
    		}); 
    </script>
    <style type="text/css">
	.div
		{
		border:1px solid 	 	#7B7B7B;
		border-radius:15px;
		background:#F0F0F0;
		
		}
		.l-text-field{
		    position: absolute;
		    top: 0px;
		    left: 0px;
		    height: 28px;
		    line-height: 28px;
		    padding-left: 2px;
		    padding-top: 0px;
		    padding-bottom: 0px;
		    vertical-align: middle;
		    background-color: #fff;
		    width: 110px;
		    border: 0;
		    margin: 0;
		    outline: none;
		    color: #555555;
		}
	td {
           padding: 4px;
       }	
    </style>
</head>
<body style="padding:10px">
<center>
	<div class="easyui-tabs" data-options="tabWidth:112" style="border:1px solid#7B7B7B;width:1000px;height:600px;">
	<div title="Home" style="float:left;padding:10px ">
	   <div  style="width:900px;height:30px;">
	      I BUY USD SELL CNY
	   </div>
	   <div title="Sub Tabs" style="float:left;padding:10px;width:600px;height:400px;">
			<div class="easyui-tabs" data-options="fit:true,plain:true" style="border:1px solid#7B7B7B;">
				<div title="Price Calculation" style="padding:10px;">	
					<div style="padding:5px;width:550px;">
					<div  style="height:30px;width:450px;">
					<table>
						<tr>
						<td><img alt="" src="${ctx}/images/icons/other/block.gif">Latest &nbsp;&nbsp;&nbsp;</td>
						<td><img alt="" src="${ctx}/images/icons/other/block.gif">Accept &nbsp;&nbsp;&nbsp;</td>
						<td><img alt="" src="${ctx}/images/icons/other/block.gif">Send   &nbsp;&nbsp;&nbsp;</td>
						<td><img alt="" src="${ctx}/images/icons/other/block.gif">WithDraw &nbsp;&nbsp;&nbsp;</td>
						<td>TimeOut</td>
						<td>    
						<input id="txt1" type="text" value="3" class="l-text-field"  style="height: 26px;width:40px">
						

						</td></tr>
							</table>
						</div>
						<br>
						<table>
					       <tr>
					         <td style="background-color:#6495ED;"></td> <td style="background-color:#6495ED;">ValueDate</td><td style="background-color:#6495ED;">CCYPair</td><td style="background-color:#6495ED;">Market</td><td style="background-color:#6495ED;">CCYPair</td><td style="background-color:#6495ED;">Client</td><td style="background-color:#6495ED;"></td>
					       </tr>
					       <tr>
					       <td  style="width:60px;background-color:#6495ED;">SPOT</td>
					             <td style="width:100px;background-color:#B2DFEE;">2014-10-11</td>
					             <td  style="width:60px;background-color:#FF4040;">
					                 <div id="" style="float:left;font-size:20px;margin-top:8px;">6.45</div><br>
	                               <div id="" style="float:right;font-size:25px;font-weight:bold;">00</div>
					              </td>
					                 <td  style="width:60px;background-color:#DEDEDE;">
					              <div id="" style="float:left;font-size:20px;margin-top:8px;">6.45</div><br>
	                               <div id="" style="float:right;font-size:25px;font-weight:bold;">00</div>
					              </td>
					                 <td  style="width:60px;background-color:#EEDC82;">
					                   <div id="" style="float:left;font-size:20px;margin-top:8px;">6.45</div><br>
	                               <div id="" style="float:right;font-size:25px;font-weight:bold;">00</div>
					              </td>
					                 <td  style="width:60px;background-color:#DEDEDE;">
					                   <div id="" style="float:left;font-size:20px;margin-top:8px;">6.45</div><br>
	                               <div id="" style="float:right;font-size:25px;font-weight:bold;">00</div>
					              </td>
					              <td  style="width:20px;background-color:#DEDEDE;">
					              </td>
					       </tr>
					  
					       
					</table>
					</div>
				</div>
				<div title="Leg Summary" style="padding:10px;">Content 2</div>
			</div>
		</div>
		<div title="Sub Tabs" style="float:left;padding:10px;width:300px;height:400px;">
			<div class="easyui-tabs" data-options="fit:true,plain:true" style="border:1px solid#7B7B7B;">
				<div title="Summary" style="padding:10px;">
				<table>
				<tbody>
				</tbody>
				</table>
                </div>
			</div>
		</div>
	</div>
		
    </div>
</center>
</body>
</html>
