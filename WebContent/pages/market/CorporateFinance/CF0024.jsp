<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<%@ include file="/pages/common/commonhead.jsp" %>

<%
	String processBO = "com.app.TR.CorporateFinance";
	String processMETHOD = "CF0024";
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
    <script src="${ctx}/js/common/commonMethod.js" type="text/javascript"></script>
    
    
    <style type="text/css">
		.l-text-field1
		{
			border-top-style: none;
			border-left-style: none;
			border-right-style: none;
			border-bottom-style: none;
			width: 60px;
			background:transparent;
		}
		
		.l-text-align-right
		{
			text-align: right
		}
		
		.l-text-font-size
		{
			font-size: 25px;
		}
		
    </style>
    
    <script type="text/javascript">

    $(function ()
	{
    	
		$("#txt1").ligerSpinner({ height: 28,width:40, type: 'int' });
		initGridData();
		
	}); 

    //哨兵标志位防止hideSpinner 方法多次被调用
    var isSinnerFlag = true;

    
    var BRTT_BIDPOINT=0;
    var BRTT_OFFERPOINT=0;

    var COMTT_OFFERPOINT=0;
    var COMTT_BIDPOINT=0;

	//买卖标志
    var BUYORSELLFLAG="";
    
	var cloneObj ="";
	var idObj="";
	var targetIdObj="";
	var tempObj="";
	function initSpinner(id)
    {
	    var targetId=id+"_DIVTARGET";
	    
		if(idObj=="")
		{
			idObj=id;
			targetIdObj=targetId;
		}
		else
		{
			if(idObj!=id)
			{ 
				if(isSinnerFlag)
				{
					hideSpinner();
				}

				idObj=id;
				targetIdObj=targetId;
				cloneObj="";
			}
			else
			{
				 return ;
			}
		}
    	
    	cloneObj=$("#spinner1").clone(true).appendTo("#"+targetId);

   	 	if(idObj.indexOf("TEMP")!=-1)
   	   	{
   	 		tempObj = $(cloneObj).ligerSpinner({ height: 30,width:70, type: 'float' ,decimalplace:4,step:0.0001,interval:1000,onChangeValue:changeSpinnerValue});
   	 		$("#"+id+"_DIVINIT").css('display','none');
   	   	}
   	 	else
   	   	{
   	 		tempObj = $(cloneObj).ligerSpinner({ height: 30,width:70, type: 'int',step:1,interval:1000,onChangeValue:changeSpinnerValue});
   	 		$("#"+id).css('display','none');
   	   	}
   	 	
   		isSinnerFlag=true;
   	 	
   	 	tempObj.setValue($("#"+id).val());

   	 	//setTimeout("hideSpinner()",3000); 
    }

	
	
	function blurSpinner()
    {
        //setTimeout("hideSpinner()",1500);  
    }
	
	//当调整器3秒内没有获得焦点或 失去焦点1.5秒后就要样控件复原
	function hideSpinner()
	{
		if(!isSinnerFlag)
		{
			return;
		}
		
		var isFocus=$(cloneObj).is(":focus");  

		if(!isFocus)
		{
			isSinnerFlag=false;
			
			formatSpinner();

			if(idObj.indexOf("TEMP")!=-1)
			{
				$("#"+idObj+"_DIVINIT").css('display','block'); 
			}
			else
			{
				$("#"+idObj).css('display','block'); 
			}
			
			$("#"+targetIdObj).empty();
			cloneObj="";
			idObj="";
			targetIdObj="";
			
		}
	}

	function formatSpinner()
	{
		 
		var tempval = tempObj.getValue();

	    if((tempval+"")=="0")
		{
	    	tempval="00";
	    }

		if(idObj.indexOf("TEMP")!=-1)
		{
			$("#"+idObj+"A").attr("value",tempval.substring(0,tempval.length-2));
			$("#"+idObj+"B").attr("value",tempval.substring(tempval.length-2));
		}
		else
		{
			$("#"+idObj).attr("value",tempval);
		}
		 
	}

	function changeSpinnerValue(val)
	{
		val = parseFloat(val);
		
		if(idObj.indexOf("TEMP_COSTRATE")!=-1)
		{
			var FXT_COSTPOINT= parseFloat($("#FXT_COSTPOINT").val());
			var FXT_SWAPCOSTPOINT = parseFloat($("#FXT_SWAPCOSTPOINT").val());

			var FXT_DEALPOINT = parseFloat($("#FXT_DEALPOINT").val());
			var FXT_SWAPDEALPOINT = parseFloat($("#FXT_SWAPDEALPOINT").val());

			
			FXT_COSTPOINT=FXT_COSTPOINT.div(10000);
			FXT_SWAPCOSTPOINT=FXT_SWAPCOSTPOINT.div(10000);

			FXT_DEALPOINT=FXT_DEALPOINT.div(10000);
			FXT_SWAPCOSTPOINT=FXT_SWAPCOSTPOINT.div(1000);

			var tempVal = val+"";
			$("#TEMP_TDEALDOWNRATE").attr("value",val);
			$("#TEMP_TDEALDOWNRATEA").attr("value",tempVal.substring(0,tempVal.length-2));
			$("#TEMP_TDEALDOWNRATEB").attr("value",tempVal.substring(tempVal.length-2));

			$("#TEMP_COSTRATE").attr("value",val);
			$("#TEMP_COSTRATEA").attr("value",tempVal.substring(0,tempVal.length-2));
			$("#TEMP_COSTRATEB").attr("value",tempVal.substring(tempVal.length-2));

			if(BUYORSELLFLAG=="BUY")
			{
				$("#FXT_DEALTCOSTRATE").attr("value",val.sub(FXT_COSTPOINT));
				$("#FXT_SWAPCOSTRATE").attr("value",val.add(FXT_SWAPCOSTPOINT).toFixed(4));

				$("#FXT_DEALTDEALDOWNRATE").attr("value",val.sub(FXT_DEALPOINT));
				$("#FXT_SWAPDEALDOWNRATE").attr("value",val.add(FXT_SWAPCOSTPOINT).toFixed(4));
			}
			else if(BUYORSELLFLAG=="SELL")
			{
				$("#FXT_DEALTCOSTRATE").attr("value",val.add(FXT_COSTPOINT).toFixed(4));
				$("#FXT_SWAPCOSTRATE").attr("value",(val-FXT_SWAPCOSTPOINT).toFixed(4));

				$("#FXT_DEALTDEALDOWNRATE").attr("value",val.add(FXT_DEALPOINT).toFixed(4));
				$("#FXT_SWAPDEALDOWNRATE").attr("value",(val-FXT_SWAPCOSTPOINT).toFixed(4));
			}
		}
		else if(idObj=="FXT_COSTPOINT")
		{
			getCountFAVOURPOINT(val);
			
			val=val.div(10000);

			$("#FXT_DEALTCOSTRATE").attr("value",val.add($("#TEMP_COSTRATE").val()).toFixed(4));

			
			
		}
		else if(idObj=="FXT_SWAPCOSTPOINT")
		{

			getCountFAVOURPOINT(val);
			
			val=val.div(10000);
			
			$("#FXT_SWAPCOSTRATE").attr("value",val.add($("#TEMP_COSTRATE").val()).toFixed(4));

			
		}
		else if(idObj=="FXT_DEALPOINT")
		{
			getCountAFAVOURPOINT(val);
			
			val=val.div(10000);
			
			$("#FXT_DEALTDEALDOWNRATE").attr("value",val.add($("#TEMP_TDEALDOWNRATE").val()).toFixed(4));
			
		}
		else if(idObj=="FXT_SWAPDEALPOINT")
		{
			getCountAFAVOURPOINT(val);
			
			val=val.div(10000);
			
			$("#FXT_SWAPDEALDOWNRATE").attr("value",val.add($("#TEMP_TDEALDOWNRATE").val()).toFixed(4));
		}
	}

	//计算平盘点差
	function getCountFAVOURPOINT(val)
	{

		var FXT_COSTPOINT  = parseInt($("#FXT_COSTPOINT").val());
		var FXT_SWAPCOSTPOINT = parseInt($("#FXT_SWAPCOSTPOINT").val());
		
		if(idObj=="FXT_COSTPOINT")
		{
			$("#FXT_DEALFAVOURPOINT").attr("value",FXT_SWAPCOSTPOINT.sub(val));
		}
		else if(idObj=="FXT_SWAPCOSTPOINT")
		{
			$("#FXT_DEALFAVOURPOINT").attr("value",val.sub(FXT_COSTPOINT));
		}
		
	}

	//计算客户点差
	function getCountAFAVOURPOINT(val)
	{
		var FXT_DEALPOINT  = parseInt($("#FXT_DEALPOINT").val());
		var FXT_SWAPDEALDOWNRATE = parseInt($("#FXT_SWAPDEALPOINT").val());

		if(idObj=="FXT_DEALPOINT")
		{
			$("#FXT_DEALAFAVOURPOINT").attr("value",FXT_SWAPDEALDOWNRATE.sub(val));
		}
		else if(idObj=="FXT_SWAPCOSTPOINT")
		{
			$("#FXT_DEALAFAVOURPOINT").attr("value",val.sub(FXT_SWAPDEALDOWNRATE));
		}
		
	}
	
	//初始化页面所有数据
	function initGridData()
	{
		var rel =  '${param.getdata}';

		if(rel!=""&&rel!=null)
		{
			rel = $.parseJSON(rel); 

			$("#seqno").attr("value",rel.FX_TREFNO);
			
			$("#FXT_TRADEDATE").attr("value",rel.FXT_TRADEDATE);
			$("#FXT_VALUEDATE").attr("value",rel.FXT_VALUEDATE);
			$("#FXT_SWAPVALUEDATE").attr("value",rel.FXT_SWAPVALUEDATE);

			$("#FXT_VALUEDATETYPE").attr("value",rel.FXT_VALUEDATETYPE);
			$("#FXT_SWAPVALUEDATETYPE").attr("value",rel.FXT_SWAPVALUEDATETYPE);
			
			var TEMP_FXT_TRADEMARKRATE = afterZero(rel.FXT_TRADEMARKRATE,4);
			var TEMP_FXT_TRADEMARKRATEA = TEMP_FXT_TRADEMARKRATE.substring(0,TEMP_FXT_TRADEMARKRATE.length-2);
			var TEMP_FXT_TRADEMARKRATEB = TEMP_FXT_TRADEMARKRATE.substring(TEMP_FXT_TRADEMARKRATE.length-2);
			
			$("#FXT_TRADEMARKRATE").attr("value",TEMP_FXT_TRADEMARKRATE);
			$("#FXT_TRADEMARKPOINT").attr("value",rel.FXT_TRADEMARKPOINT);
			$("#FXT_SWAPTRADEMARKPOINT").attr("value",rel.FXT_SWAPTRADEMARKPOINT);

			var FXT_SPREAD = parseInt(rel.FXT_SWAPTRADEMARKPOINT).sub(rel.FXT_TRADEMARKPOINT);
			
			$("#FXT_SPREAD").attr("value",FXT_SPREAD);
			
			var FXT_BUYORSELL_CUS ="SELL";//rel.FXT_BUYORSELL_CUS;

			BUYORSELLFLAG=FXT_BUYORSELL_CUS

			if(FXT_BUYORSELL_CUS=="BUY")
			{
				$("#FXT_TRADEMARKRATEA_ASK").attr("value",TEMP_FXT_TRADEMARKRATEA);
				$("#FXT_TRADEMARKRATEB_ASK").attr("value",TEMP_FXT_TRADEMARKRATEB);

				$("#FXT_TRADEMARKPOINT_ASK").attr("value",beforezero(rel.FXT_TRADEMARKPOINT,2));
				$("#FXT_SWAPTRADEMARKPOINT_BID").attr("value",beforezero(rel.FXT_SWAPTRADEMARKPOINT,2));
			}
			else if(FXT_BUYORSELL_CUS=="SELL")
			{
				$("#FXT_TRADEMARKRATEA_BID").attr("value",TEMP_FXT_TRADEMARKRATEA);
				$("#FXT_TRADEMARKRATEB_BID").attr("value",TEMP_FXT_TRADEMARKRATEB);

				$("#FXT_TRADEMARKPOINT_BID").attr("value",beforezero(rel.FXT_TRADEMARKPOINT,2));
				$("#FXT_SWAPTRADEMARKPOINT_ASK").attr("value",beforezero(rel.FXT_SWAPTRADEMARKPOINT,2));
			}

			$("#TEMP_TDEALDOWNRATE").attr("value",TEMP_FXT_TRADEMARKRATE);
			$("#TEMP_TDEALDOWNRATEA").attr("value",TEMP_FXT_TRADEMARKRATEA);
			$("#TEMP_TDEALDOWNRATEB").attr("value",TEMP_FXT_TRADEMARKRATEB);

			$("#TEMP_COSTRATE").attr("value",TEMP_FXT_TRADEMARKRATE);
			$("#TEMP_COSTRATEA").attr("value",TEMP_FXT_TRADEMARKRATEA);
			$("#TEMP_COSTRATEB").attr("value",TEMP_FXT_TRADEMARKRATEB);
			
			$("#FXT_COSTPOINT").attr("value",rel.FXT_COSTPOINT);
			$("#FXT_SWAPCOSTPOINT").attr("value",rel.FXT_SWAPCOSTPOINT);
			$("#FXT_DEALTCOSTRATE").attr("value",rel.FXT_DEALTCOSTRATE);
			$("#FXT_SWAPCOSTRATE").attr("value",rel.FXT_SWAPCOSTRATE);
			

			$("#FXT_DEALPOINT").attr("value",rel.FXT_DEALPOINT);
			$("#FXT_SWAPDEALPOINT").attr("value",rel.FXT_SWAPDEALPOINT);
			$("#FXT_DEALTDEALDOWNRATE").attr("value",rel.FXT_DEALTDEALDOWNRATE);
			$("#FXT_SWAPDEALDOWNRATE").attr("value",rel.FXT_SWAPDEALDOWNRATE);

			
			$("#FXT_DEALFAVOURPOINT").attr("value",parseInt(rel.FXT_SWAPCOSTPOINT)-parseInt(rel.FXT_COSTPOINT));
			$("#FXT_DEALAFAVOURPOINT").attr("value",parseInt(rel.FXT_SWAPDEALPOINT)-parseInt(rel.FXT_DEALPOINT));

		}
	}

	//获取大小额点差
	function getBRFXSPREAD()
	{
		$.ajaxSettings.async = false;
		var url ="${pageContext.request.contextPath}/cm?ProcessBO=com.app.TR.CorporateFinanceHelper&ProcessMETHOD=getBRFXSPREAD&time="+ new Date().getTime();

		$.getJSON(url ,function(result){

		});
	}

	function afterZero(num,digits)
	{
		var len=0;

		var newnum=num+"";

		var flag = newnum.indexOf(".");
		
		if(flag!=-1)
		{
			var temp = newnum.substring(flag+1);
			
			len=temp.length;
			
			if(len==0)
			{
				len=digits;
			}
			else
			{
				len=digits.sub(len);
			}
		}
		else 
		{
			newnum+=".";
			len=digits
		}
		
		if(len<=digits)
		{
			while(len>0)
			{
				newnum+="0";
				len--;
			}
		}

		return newnum;
	}

	function beforezero(num,digits)
	{
		num+="";
		
		var len = num.length;

		if(len>=digits)
		{
			return num;
		}

		var temp=5;
		
		while(true)
		{
			num = "0"+num;

			if(num.length>=digits)
			{
				break;
			}
		}

		return num;
	}


	function send()
	{
		var FXT_DEALTCOSTRATE = $("#FXT_DEALTCOSTRATE").val();
		var FXT_SWAPCOSTRATE = $("#FXT_SWAPCOSTRATE").val();
		
		var FXT_DEALTDEALDOWNRATE = $("#FXT_DEALTDEALDOWNRATE").val();
		var FXT_SWAPDEALDOWNRATE = $("#FXT_SWAPDEALDOWNRATE").val();

		var tempA = 0;
		var tempB = 0;
		
		//计算总收益
		if(BUYORSELLFLAG=="BUY")
		{
			tempA = parseFloat(FXT_DEALTDEALDOWNRATE)-parseFloat(FXT_DEALTCOSTRATE);
			tempB = parseFloat(FXT_SWAPCOSTRATE)-parseFloat(FXT_SWAPDEALDOWNRATE);
		}
		else if(BUYORSELLFLAG=="SELL")
		{
			tempA = parseFloat(FXT_DEALTCOSTRATE)-parseFloat(FXT_DEALTDEALDOWNRATE);
			tempB = parseFloat(FXT_SWAPDEALDOWNRATE)-parseFloat(FXT_SWAPCOSTRATE);
		}
		
		$("#FXT_TEMP_SUM").attr("value",tempA.add(tempB));

		var param=$("#thisForm1").serialize();
			param+="&WSCODE=CF0023";
		

		$.ajax({
			type:'POST',
			url:'<%=serverUrl%>'+'&ACTION=Confim',
			dataType:'json',
			data:param,
			success:function(result)
		    {
				 				
		    }
		}); 
	}
	
    </script>
    
</head>
<body style="padding:10px">
<div style="display: none">
<input type="text" id="spinner1" onblur="blurSpinner()"/>
</div>
<center>
	<div class="easyui-tabs" data-options="tabWidth:112" style="border:1px solid#7B7B7B;width:1200px;height:600px;">
	<div title="Home" style="float:left;padding:10px ">
	   <div  style="width:900px;height:30px;">
	      I BUY USD SELL CNY
	   </div>
	   <div title="Sub Tabs" style="float:left;padding:10px;width:800px;height:400px;">
			<div class="easyui-tabs" data-options="fit:true,plain:true" style="border:1px solid#7B7B7B;">
				<div title="Price Calculation" style="padding:10px;">	
					<div style="padding:5px;width:550px;">
					<div  style="height:30px;width:450px;">
					<table>
						<tr>
							<td><img alt="" src="${ctx}/images/icons/other/block.gif">Latest &nbsp;&nbsp;&nbsp;</td>
							<td><img alt="" src="${ctx}/images/icons/other/block.gif">Accept &nbsp;&nbsp;&nbsp;</td>
							<td><img alt="" src="${ctx}/images/icons/other/block.gif"><a href="javascript:send()">Send</a>   &nbsp;&nbsp;&nbsp;</td>
							<td><img alt="" src="${ctx}/images/icons/other/block.gif">WithDraw &nbsp;&nbsp;&nbsp;</td>
							<td>TimeOut</td>
							<td><input id="txt1" type="text" value="3" class="l-text-field"  style="height: 26px;width:40px"></td>
						</tr>
					</table>
					</div>
					<br>
					<form id="thisForm1">
					<input type="hidden" id="seqno" name="seqno"/>
					<input type="hidden" id="FXT_TRADEMARKRATE" name="FXT_TRADEMARKRATE" value="00.0000"/>
					<input type="hidden" id="FXT_TRADEMARKPOINT" name="FXT_TRADEMARKPOINT" value="00"/>
					<input type="hidden" id="FXT_SWAPTRADEMARKPOINT" name="FXT_SWAPTRADEMARKPOINT" value="00"/>
					<input type="hidden" id="FXT_TEMP_SUM" name="FXT_TEMP_SUM" value=""/><!-- 总收益 -->
					<table border="1" width="770" onmouseup="">
				       <tr>
				         <td style="background-color:#0088CC;" height="25"></td> 
				         <td style="background-color:#0088CC;" align="center"><font color="#ffffff">日期</font></td>
				         <td style="background-color:#0088CC;" colspan="2" align="center"><font color="#00FFFF">CCYPair Market</font></td>
				         <td style="background-color:#0088CC;" colspan="2" align="center"><font color="#7FFF00">CCYPair All in(平盘)</font></td>
				         <td style="background-color:#0088CC;" colspan="2" align="center"><font color="#00FA9A">CCYPair All in(客户)</font></td>
				       </tr>
				         <tr style="background-color:#CAE1FF">
				         	
				         	<td height="55" style="background-color:#0088CC;"><font color="#ffffff">SPOT</font></td>
				         	
				         	<td align="center" style="background-color:#FCFCFC;">
				         	  <input type="text" id="FXT_TRADEDATE" name="FXT_TRADEDATE" class="l-text-field1" readonly/>
				         	</td>
				         	
				         	<td align="right" style="background-color:#EDEDED;">
				         	    <input type="text" id="FXT_TRADEMARKRATEA_BID" class="l-text-field1 l-text-align-right" value="00.00" readonly><br/>
				         	    <input type="text" id="FXT_TRADEMARKRATEB_BID" class="l-text-field1 l-text-align-right l-text-font-size" value="00" readonly>
				         	</td>
				         	<td align="right" style="background-color:#EDEDED;">
				         	    <input type="text" id="FXT_TRADEMARKRATEA_ASK" class="l-text-field1 l-text-align-right" value="0.00" readonly><br/>
				         	    <input type="text" id="FXT_TRADEMARKRATEB_ASK" class="l-text-field1 l-text-align-right l-text-font-size" value="00" readonly>
				         	</td>
				         	
				         	
				         	<td align="right" style="background-color:#FCFCFC;">
				         	  <div id="TEMP_COSTRATE_DIVINIT" onclick="">
				         	    <input type="hidden" id="TEMP_COSTRATE" value="00.0000"/>
				         	    <input type="text" id="TEMP_COSTRATEA" class="l-text-field1 l-text-align-right" value="00.00" readonly><br/>
				         	    <input type="text" id="TEMP_COSTRATEB" class="l-text-field1 l-text-align-right l-text-font-size" value="00" readonly>
				         	  </div>
				         	  <div id="TEMP_COSTRATE_DIVTARGET"></div>
				         	</td>
				         	<td align="right" style="background-color:#FCFCFC;">&nbsp;</td>

				         	<td align="right" align="right" style="background-color:#EDEDED;">
				         	  <input type="hidden" id="TEMP_TDEALDOWNRATE" value="00.0000"/>
				         	  <input type="text" id="TEMP_TDEALDOWNRATEA" class="l-text-field1 l-text-align-right" value="00.00" readonly/><br/>
				         	  <input type="text" id="TEMP_TDEALDOWNRATEB" class="l-text-field1 l-text-align-right l-text-font-size" value="00" readonly/>
				         	</td>
				         	<td align="right" align="right" style="background-color:#EDEDED;">
				         	  &nbsp;
				         	</td>
				         	 
				         </tr>
				         <tr>
				         	<td style="background-color:#0088CC;">
				         	  <input type="text" id="FXT_VALUEDATETYPE" class="l-text-field1" style="color: #ffffff" readonly/>
				         	</td>
				         	<td height="35" align="center" style="background-color:#FCFCFC;">
				         	  <input type="text" id="FXT_VALUEDATE"  name="FXT_VALUEDATE" class="l-text-field1"/>
				         	</td>
				         	<td align="right" style="background-color:#EDEDED;">
				         		<input type="text" id="FXT_TRADEMARKPOINT_BID" class="l-text-field1 l-text-align-right" value="00" readonly/></br>
				         	</td>
				         	<td align="right" style="background-color:#EDEDED;">
				         		<input type="text" id="FXT_TRADEMARKPOINT_ASK" class="l-text-field1 l-text-align-right" value="00" readonly/></br>
				         	</td>
				         	
				         	<td align="right" style="background-color:#FCFCFC;">
				         		<input type="text" id="FXT_COSTPOINT" name="FXT_COSTPOINT" class="l-text-field1 l-text-align-right"  value="00" onclick="initSpinner('FXT_COSTPOINT')"/>
				         		<div id="FXT_COSTPOINT_DIVTARGET" onm></div>
				         	</td>
				         	<td align="right" style="background-color:#FCFCFC;">
				         		<input type="text" id="FXT_DEALTCOSTRATE" name="FXT_DEALTCOSTRATE" class="l-text-field1 l-text-align-right" value="00.0000" readonly/>
				         	</td>
				         	
				         	
				         	<td align="right" style="background-color:#EDEDED;">
				         		<input type="text" id="FXT_DEALPOINT" name="FXT_DEALPOINT" class="l-text-field1 l-text-align-right" value="00" onclick="initSpinner('FXT_DEALPOINT')"/>
				         		<div id="FXT_DEALPOINT_DIVTARGET" ></div>
				         	</td>
				         	<td align="right" style="background-color:#EDEDED;">
				         	  <input type="text" id="FXT_DEALTDEALDOWNRATE" name="FXT_DEALTDEALDOWNRATE" class="l-text-field1 l-text-align-right" value="00.0000" readonly/>
				         	</td>
				         </tr>		
				         <tr>
				         	<td style="background-color:#0088CC;">
				         	   <input type='text' id="FXT_SWAPVALUEDATETYPE" name="FXT_SWAPVALUEDATETYPE" class="l-text-field1" style="color: #ffffff" readonly/>
				         	</td>
				         	<td height="35" align="center" style="background-color:#FCFCFC;">
				         	  <input type="text" id="FXT_SWAPVALUEDATE" name="FXT_SWAPVALUEDATE" class="l-text-field1"/>
				         	</td>
				         	<td align="right" style="background-color:#EDEDED;">
				         		<input type="text" id="FXT_SWAPTRADEMARKPOINT_BID" class="l-text-field1 l-text-align-right" value="00" readonly/>
				         	</td>
				         	<td align="right" style="background-color:#EDEDED;">
				         		<input type="text" id="FXT_SWAPTRADEMARKPOINT_ASK" class="l-text-field1 l-text-align-right" value="00" readonly/>
				         	</td>
				         	
				         	<td align="right" style="background-color:#FCFCFC;">
				         		<input type="text" id="FXT_SWAPCOSTPOINT" name="FXT_SWAPCOSTPOINT" class="l-text-field1 l-text-align-right" value="00" onclick="initSpinner('FXT_SWAPCOSTPOINT')"/><br/>
				         		<div id="FXT_SWAPCOSTPOINT_DIVTARGET"></div>
				         	</td>
				         	<td align="right" style="background-color:#FCFCFC;">
				         		<input type="text" id="FXT_SWAPCOSTRATE" name="FXT_SWAPCOSTRATE" class="l-text-field1 l-text-align-right" value="00.0000" readonly/>
				         	</td>
				         	
				         	<td align="right" style="background-color:#EDEDED;">
				         	  <input type="text" id="FXT_SWAPDEALPOINT" name="FXT_SWAPDEALPOINT" class="l-text-field1 l-text-align-right" value="00" onclick="initSpinner('FXT_SWAPDEALPOINT')"/>
				         	  <div id="FXT_SWAPDEALPOINT_DIVTARGET"></div>
				         	</td>
				         	<td align="right" style="background-color:#EDEDED;">
				         	  <input type="text" id="FXT_SWAPDEALDOWNRATE" name="FXT_SWAPDEALDOWNRATE" class="l-text-field1 l-text-align-right" value="00.0000" readonly/>
				         	</td>
				         </tr>	
				         <tr>
				         	<td height="35" style="background-color:#0088CC;"><font color="#ffffff">GAP</font></td>
				         	<td style="background-color:#FCFCFC;">
				         	  <input type="text" id="FXT_TERMDAYS" name="FXT_TERMDAYS" class="l-text-field1 l-text-align-right" value="0"/>
				         	</td>
				         	<td align="center" style="background-color:#EDEDED;" colspan="2">
				         	  <input type="text" id="FXT_SPREAD" name="FXT_SPREAD" class="l-text-field1 l-text-align-right" value="0" readonly/>
				         	</td>
				         	<td align="center" style="background-color:#FCFCFC;" colspan="2">
				         	  <input type="text" id="FXT_DEALFAVOURPOINT" class="l-text-field1 l-text-align-right" value="0" readonly/>
				         	</td>
				         	<td align="center" style="background-color:#EDEDED;" colspan="2">
				         	  <input type="text" id="FXT_DEALAFAVOURPOINT" class="l-text-field1 l-text-align-right" value="0" readonly/>
				         	</td>
				         </tr>	
					</table>
					</form>
					</div>
				</div>
				<div title="Leg Summary" style="padding:10px;">Content 2</div>
			</div>
		</div>
		<div title="Sub Tabs" style="float:left;padding:10px;width:300px;height:400px;">
			<div class="easyui-tabs" data-options="fit:true,plain:true" style="border:1px solid#7B7B7B;">
				<div title="Summary" style="padding:10px;">
				<table border="1" height="85%">
				  <tr>
				    <td align="right">Taker:</td>
				    <td><input type="text" id=""/></td>
				  </tr>
				  <tr>
				    <td align="right">Taker Group:</td>
				    <td><input type="text" id=""/></td>
				  </tr>
				  <tr>
				    <td align="right">Estimated Porfito:</td>
				    <td><input type="text" id=""/></td>
				  </tr>
				  <tr>
				    <td align="right">Competion:</td>
				    <td><input type="text" id=""/></td>
				  </tr>
				  <tr>
				    <td align="right">CCY Pair:</td>
				    <td><input type="text" id=""/></td>
				  </tr>
				  <tr>
				    <td align="right">Total Net:</td>
				    <td><input type="text" id=""/></td>
				  </tr>
				  <tr>
				    <td align="right">Req Spot:</td>
				    <td><input type="text" id=""/></td>
				  </tr>
				  <tr>
				    <td align="right">Req Near Pts:</td>
				    <td><input type="text" id=""/></td>
				  </tr>
				  <tr>
				    <td align="right">Req Far Pts:</td>
				    <td><input type="text" id=""/></td>
				  </tr>
				  <tr>
				    <td align="right">Req Swap Pts:</td>
				    <td><input type="text" id=""/></td>
				  </tr>
				  <tr>
				    <td align="right">Swap Pts:</td>
				    <td><input type="text" id=""/></td>
				  </tr>
				</table>
                </div>
			</div>
		</div>
	</div>
		
    </div>
</center>
</body>
</html>