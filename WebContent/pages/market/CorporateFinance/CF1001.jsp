<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.shiro.SecurityUtils"
import="org.apache.shiro.session.Session"
import="org.apache.shiro.subject.Subject"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>

<%
	String processBO = "com.app.TR.CorporateFinance";
	String processMETHOD = "CF1001";
	String serverUrl = request.getContextPath()+"/cm?ProcessMETHOD="+processMETHOD+"&ProcessBO="+processBO;
	Subject subject = SecurityUtils.getSubject(); 
	Session shiro_session= subject.getSession();
	String userId = (String)shiro_session.getAttribute("USER_ID") ;
	String InsData  = "1360000";//(String)shiro_session.getAttribute("Ins_Data") ;
%>

<link href="${ctx}/js/jquery-ui/jquery-ui.min.css" rel="stylesheet" type="text/css" />
<script src="${ctx}/js/jquery-ui/jquery-ui.min.js" type="text/javascript"></script>
<script src="${ctx}/js/ligerUI/js/plugins/ligerSpinner.js" type="text/javascript"></script>
<script src="${ctx}/js/ligerUI/js/plugins/ligerComboBox.js" type="text/javascript"></script>
<script src="${ctx}/js/ligerUI/js/plugins/ligerDateEditor.js" type="text/javascript"></script>
<script src="${ctx}/js/ligerUI/js/plugins/ligerRadio.js" type="text/javascript"></script>
<script src="${ctx}/js/ligerUI/js/plugins/ligerPopupEdit.js" type="text/javascript"></script>
<link href="${ctx}/js/ligerUI/skins/Gray/css/all.css" rel="stylesheet" /> 

<script type="text/javascript">
var priceMap = {};
var str_Biz = "SPOT";
var CUSTOMERDATA;
var BASEACCOUNTDATA;
var TERMACCOUNTDATA;
var $submitForm;
$(document).ready(function () {
    setInterval("startRequest()", 3500);
});
var webSocket = 
	new WebSocket('ws://localhost:8080/appWeb/websocket?WSCODE=CF0023');  

webSocket.onerror = function(event) { 
	onError(event) 
}; 

webSocket.onopen = function(event) { 
	onOpen(event) 
}; 

webSocket.onmessage = function(event) { 
	onMessage(event) 
};

function onMessage(event) {
	setFormData(event.data);

	$.ajax({
		type:'GET',
		url:'<%=serverUrl%>'+'&ACTION=Search'+'&seqno='+ event.data,
		dataType:'json',
		success:function(result)
	    {
		    if (result.ERR == null)
			{
		    	if(result.DealState=='Confim')
				 {
					setFormData(result);
			    }
           	}
           	else
            {
           		$.ligerDialog.error(result.ERR);
           	}
			
	    }
	});
	
}

function onOpen(event) {
	document.getElementById('messages').innerHTML 
		= 'Connection established';
}
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

function getManagerGrid()
{
	var table1 = $("#managerGrid");
    var row = $("<tr class='addTd'></tr>");
    var row1 = $("<tr class='addTd'></tr>");
    row.append("<td rowspan='2' style='text-align: center;border:1px;'>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>");
	for(var i=0;i<panels.length;i++)
	{
		  var jsonObject = panels[i];
		  var currency =  jsonObject['title'];
          var td = $("<td colspan='2' class='addTd'>"+currency+"</td>");
          var cArray = currency.split("_");
          var td1 = $("<td class='addTd'> SELL&nbsp&nbsp"+cArray[0]+"</td>");
          var td2 = $("<td class='addTd'> BUY&nbsp&nbsp"+cArray[0]+"</td>");
          row1.append(td1);
          row1.append(td2);
          row.append(td);
	}
    table1.append(row);
    table1.append(row1);
    for(var j=0;j<BizTypeData.length;j++)
    {
       var mData =  BizTypeData[j];
       var tenor = mData.text;
       var rowData = $("<tr class='addTd'></tr>");
       var td1 = $("<td class='addTd'> &nbsp&nbsp"+tenor+"</td>");
       rowData.append(td1);
	     for(var i=0;i<panels.length;i++)
	   	{
	   		  var jsonObject = panels[i];
	   		  var currency =  jsonObject['title'];
	          for(var t=0;t<TenorCurData.length;t++)
		        {
			        var tData = TenorCurData[t];
			   
			        if(currency==tData['CurrencyPair']&&tenor==tData['Tenor'])
				    {
			        	
			        	  var td2 = $("<td class='addTd'>&nbsp&nbsp"+tData['Sell']+"</td>");
			        	  var td3 = $("<td class='addTd'>&nbsp&nbsp"+tData['Buy']+"</td>");
			        	  break;
				    }
		        }
	      
	 	     rowData.append(td2);
	 	     rowData.append(td3);
	   	}

	     table1.append(rowData);
    }
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

var $dialog;  //交易对话框
var $form;    //交易表单
var BizTypeData = [
		           {id:'0',text:'SPOT',type:'SPOT'},{id:'-1',text:'TOM',type:'SPOT'},{id:'30',text:'1M',type:'FORWARD'},
				   {id:'-2',text:'TODAY',type:'SPOT'},{id:'3240',text:'9Y',type:'FORWARD'},{id:'1',text:'1D',type:'FORWARD'},
				   {id:'360',text:'1Y',type:'SPOT'},{id:'7',text:'1W',type:'FORWARD'},{id:'60',text:'2M',type:'FORWARD'}
                 ];


function changeBizTypeData(newvalue)
{
	$('#FXT_TERMDAYS').val(newvalue);
	 for (i = 0; i < BizTypeData.length; i++)
	{
	   if (BizTypeData[i].id == newvalue)
		   {
		    str_Biz = BizTypeData[i].type;
		    var cPair = $("[name=FXT_DEALTCCY]").val();
		   
			var str = "";
			$("#d1 input:radio").each(function () {
             if(this.checked )
                {
                 str=this.value;
                }
           });
		    var str1="";
				$("#BizType1 input:radio").each(function () {
		              if(this.checked )
		                 {
		            	  str1=this.value;
		                 }
		            });
	            if(str1!='SWAP')
		            {
				      $('#showTitle').html('<font size=\'4\' color=\'red\'>Near Leg:I '+str+'  '+str_Biz+' '+$("[name=FXT_DEALTCCY]").val()+'</font>');
		            }
		        for(var t=0;t<TenorCurData.length;t++)
			    {
			       var ct = TenorCurData[t];
			    
			       if(ct['CurrencyPair']==cPair&&BizTypeData[i].text==ct['Tenor'])
				    {
					    var sellPrice = ct['Sell'];
					    var buyPrice = ct['Buy'];
			    	   getBRFXSPREAD(cPair,sellPrice,buyPrice,str,'J',BizTypeData[i].text,BizTypeData[i].type);
			    	   break;
				    }
			    }
		   }
	}
		
}
function changeFBizTypeData(newvalue)
{
	$('#FXT_SWAPTERMDAYS').val(newvalue);
	 for (i = 0; i < BizTypeData.length; i++)
		{
		    var cPair = $("[name=FXT_DEALTCCY]").val();
		   if (BizTypeData[i].id == newvalue)
			   {
			      for(var t=0;t<TenorCurData.length;t++)
				    {
				       var ct = TenorCurData[t];
				    
				       if(ct['CurrencyPair']==cPair&&BizTypeData[i].text==ct['Tenor'])
					    {
				    	   var sellPrice = ct['Sell'];
						    var buyPrice = ct['Buy'];
							var str = "";
							$("#d1 input:radio").each(function () {
				             if(this.checked )
				                {
				                 str=this.value;
				                }
				           });
				    	   getBRFXSPREAD(cPair,sellPrice,buyPrice,str,"F",BizTypeData[i].text,BizTypeData[i].type);
					    }
				    }
			   }
		}
}
$(function ()
	{
	 getCustomerData();
	 getManagerGrid();
	 $form = $("#mainform").ligerForm();
	 $("#FXT_TRADEPURPOSE").ligerComboBox( {data:[
	                                     { text: '平盘', id: '1' }
	                                 ], value: '1',height:25}); 
	 $("#FXT_TRADETARGET").ligerComboBox( {data:[
	                                     { text: '客户', id: '1' }
	                                 ],value: '1',height:25}); 
	 $("#FXT_TRADEMODE").ligerComboBox( {data:[
	                                     { text: '代客', id: '1' },
	                                     { text: '自身', id: '2' }
	                                 ],value: '1',height:25}); 
	 $("#FXT_VALUEDATETYPE").ligerComboBox( {data:BizTypeData,height:25,width:100,
							 onSelected: function(newvalue) {changeBizTypeData(newvalue)}
		                      }); 
	 $("#FXT_SWAPVALUEDATETYPE").ligerComboBox( {data:BizTypeData,height:25,width:100,
		                        onSelected:function(newvalue) {changeFBizTypeData(newvalue)}
			                        });
	
	 $("#FXT_CUSTOMERID").ligerPopupEdit({
         condition: {
             prefixID: 'condtion_',
             fields: [{ name: 'TT_CUSTOMERID', type: 'text', label: '客户'}]
         },
         onSelected:f_selectCustomer,
         grid: getGridOptions(false),
         valueField: 'TT_CUSTOMERID',
         textField: 'TT_CUSTOMERID',
         width: 178,height:25
     });

	 $("#FXT_VALUEDATE").ligerDateEditor({height:25,width:100});	
	 $("#FXT_SWAPVALUEDATE").ligerDateEditor({height:25,width:100});	
	 $("#d1 input:radio").ligerRadio();
	 $("#BizType1 input:radio").ligerRadio();
	 $submitForm = $("#submitForm").ligerForm({
	    	labelWidth: 50,  validate:true, align: 'center',
	    	fields:[	//主表的表单栏位定义
	    	            { display: "人员",name:"FX_TREFNO", align: 'left', width: 150 },
	    	            { display: "密码",name:"DealState", width: 150 }
	    	]
	    });
	}); 

function doDeal(currency,type,side){
    var price = 2.3;
    var mform = new liger.get("mainform");
    var sell = $('#'+currency+"-L-S").html();
    var buy = $('#'+currency+"-R-B").html();
    
    var userId = '<%=userId%>';
    var InsData = '<%=InsData%>';
    $("[name=BFXT_TRADEMARKRATE]").val('6.374');
    $("[name=SFXT_TRADEMARKRATE]").val('6.374');
    var date = new Date();

    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var day = date.getDate();

    var nowDate = year + '-' + month + '-' + day;
    mform.setData({FXT_TRADEDATE:nowDate,FXT_TRADOR:userId,FXT_UNIT:InsData,FXT_DEALTCCY:currency,FXT_TRADEMARKRATE:'6.374',FXT_TRADEMARKPOINT:'12',FXT_SWAPTRADEMARKPOINT:'1'});
    var BSFlag = "";
	$("#d1 input:radio").each(function () {
     if(this.checked )
        {
    	 BSFlag=this.value;
        }
   });
    changeBuyOrSell(BSFlag);
	$dialog = $.ligerDialog.open({height: 850,width:1250,target: $("#mainform"),title:currency});
	$.ajax({url:'<%=serverUrl%>'+'&ACTION=getSeqno', dataType:'json', 
		success:function(result)
	    {
			if (result.ERR == null){
				$form.setData({FX_TREFNO:result.seqno});
           	}else{
           		$.ligerDialog.error(result.ERR);
           	}
			
	    }
	}); 
}

function timedCount()  {
	$('#timers').css("display","");
	var num=100;
	var interval=setInterval(function(){
	if(num==0){
	clearInterval(interval);
	}
	$('#timers').html(num--);
	},1000);

}

function doAsk()
{
	doAction('Ask');
	$dialog.hide();
}
function f_selectCustomer(e)
{
	 if (!e.data || !e.data.length) return;
	var selected = e.data[0]; 
	var cn =selected.TT_CUSTOMERNAMECN; 
 	$("[name=FXT_CUSTOMERCN]").val(cn);
	$("[name=FXT_CORECUSTOMERID]").val(selected.TT_CUSTOMERID);
 	getBASEACCOUNTDATA(selected.TT_CUSTOMERID);
 	getTERMACCOUNTDATA(selected.TT_CUSTOMERID);
	 $("#FXT_BASEACCOUNT").ligerPopupEdit({
         grid: getBaseAccountGrid(false),
         valueField: 'TT_SETTLEMENTID',
         textField: 'TT_SETTLEMENTID',
         width: 178,height:25
     });
	 $("#FXT_TERMACCOUNT").ligerPopupEdit({
         grid: getTermAccountGrid(false),
         valueField: 'TT_SETTLEMENTID',
         textField: 'TT_SETTLEMENTID',
         width: 178,height:25
     });
     
}
function changeBDealAmount(value)
{
	var str = "";
	$("#d1 input:radio").each(function () {
      if(this.checked )
         {
          str=this.value;
         }
    });
	var valueTypeID = $("#FXT_VALUEDATETYPE").val();
	var valueType  = "";
	for(var t=0;t<BizTypeData.length;t++)
	{
		var object = BizTypeData[t];
		if(object['id']==valueTypeID)
			{
			valueType = object['text'];
			}
	}
	var FvalueTypeID = $("#FXT_SWAPVALUEDATETYPE").val();
	var FvalueType  = "";
	for(var t=0;t<BizTypeData.length;t++)
	{
		var object = BizTypeData[t];
		if(object['id']==valueTypeID)
			{
			FvalueType = object['text'];
			}
	}
    
    	$("[name=FXT_DEALTCCY]").val();
    	var arr = $("[name=FXT_DEALTCCY]").val().split('_');
    	var url = '<%=request.getContextPath()+"/cm?ProcessMETHOD=getFXTRCOMBASERAT&ProcessBO=com.app.TR.CorporateFinanceHelper"%>'+'&TR_BASECCY='+arr[0]+'&TR_TERMSCCY='+arr[1]+'&TR_TENOR='+valueType+'&FTR_TENOR='+FvalueType;
	 	$.ajax({url:url, dataType:'json',async: false, 
			success:function(result)
		    {
				if (result.ERR == null){
					if('BUY' == str)
				      {
						$("[name=FXT_FORWARDNETCASHFLOW]").val((parseFloat(result['FTR_ASK'])*parseFloat(value)).toFixed(2));
						$("[name=FXT_SWAPNOTIONALAMT]").val((parseFloat(result['TR_BID'])*parseFloat(value)).toFixed(2));
						$("[name=FXT_SWAPNETCASHFLOW]").val(parseFloat(value));
				      }else{
				    	    $("[name=FXT_FORWARDNETCASHFLOW]").val((parseFloat(value)/parseFloat(result['FTR_BID'])).toFixed(2));
							$("[name=FXT_SWAPNOTIONALAMT]").val((parseFloat(value)/parseFloat(result['TR_ASK'])).toFixed(2));
							$("[name=FXT_SWAPNETCASHFLOW]").val(parseFloat(value));
					  }
	           	}else{
	           		$.ligerDialog.error(result.ERR);
	           	}
				
		    }
		}); 
     
}

function changeSDealAmount(value)
{
	var str = "";
	$("#d1 input:radio").each(function () {
      if(this.checked )
         {
          str=this.value;
         }
    });
	var valueTypeID = $("#FXT_VALUEDATETYPE").val();
	var valueType  = "";
	for(var t=0;t<BizTypeData.length;t++)
	{
		var object = BizTypeData[t];
		if(object['id']==valueTypeID)
			{
			valueType = object['text'];
			}
	}
	var FvalueTypeID = $("#FXT_SWAPVALUEDATETYPE").val();
	var FvalueType  = "";
	for(var t=0;t<BizTypeData.length;t++)
	{
		var object = BizTypeData[t];
		if(object['id']==valueTypeID)
			{
			FvalueType = object['text'];
			}
	}
   
    	$("[name=FXT_DEALTCCY]").val();
    	var arr = $("[name=FXT_DEALTCCY]").val().split('_');
    	var url = '<%=request.getContextPath()+"/cm?ProcessMETHOD=getFXTRCOMBASERAT&ProcessBO=com.app.TR.CorporateFinanceHelper"%>'+'&TR_BASECCY='+arr[0]+'&TR_TERMSCCY='+arr[1]+'&TR_TENOR='+valueType+'&FTR_TENOR='+FvalueType;
	 	$.ajax({url:url, dataType:'json',async: false, 
			success:function(result)
		    {
				if (result.ERR == null){
					if('BUY' == str)
				      {
						$("[name=FXT_SWAPTRADEMARKRATE]").val((parseFloat(value)/parseFloat(result['TR_BID'])).toFixed(2));
						$("[name=FXT_FORWARDNETCASHFLOW]").val(parseFloat(value));
						$("[name=FXT_SWAPNETCASHFLOW]").val((parseFloat(value)/parseFloat(result['FTR_ASK'])).toFixed(2));
				      }else{
				    	    $("[name=FXT_SWAPTRADEMARKRATE]").val((parseFloat(value)*parseFloat(result['TR_ASK'])).toFixed(2));
							$("[name=FXT_FORWARDNETCASHFLOW]").val(parseFloat(value));
							$("[name=FXT_SWAPNETCASHFLOW]").val((parseFloat(value)*parseFloat(result['FTR_BID'])).toFixed(2));
					  }
	           	}else{
	           		$.ligerDialog.error(result.ERR);
	           	}
				
		    }
		}); 
}
function getCustomerData()
{
	    var url = '<%=request.getContextPath()+"/cm?ProcessMETHOD=common&ProcessBO=com.app.sys.CommonBO&TABLE=TTP_CUSTOMERS"%>'+'&ACTION=select-all';
	 	$.ajax({url:url, dataType:'json',async: false, 
			success:function(result)
		    {
				if (result.ERR == null){
					CUSTOMERDATA = result;
	           	}else{
	           		$.ligerDialog.error(result.ERR);
	           	}
				
		    }
		}); 
}

function getBRFXSPREAD(currencyPair,sellPrice,buyPrice,BOS,direction,DealTenor,DealType)
{
      
       var url = '<%=request.getContextPath()+"/cm?ProcessMETHOD=getBRFXSPREAD&ProcessBO=com.app.TR.CorporateFinanceHelper"%>'+
       '&currencyPair='+currencyPair+'&TT_DEALTYPE='+DealType+'&TT_DEALTENOR='+DealTenor;
	 	$.ajax({url:url, dataType:'json',async: false, 
			success:function(result)
		    {
				if (result.ERR == null){
					if(BOS=="BUY")
					{
					if(direction=="J")
						{
							
									var sumCostPoint =parseFloat(buyPrice) +parseFloat(result['BRTT_BIDPOINT']);
									$("[name=BFXT_COSTPOINT]").val(sumCostPoint);
								    var sumDealPoint = sumCostPoint+parseFloat(result['COMTT_BIDPOINT'])-parseFloat(result['BRTT_BIDPOINT']);
									$("[name=BFXT_DEALPOINT]").val(sumDealPoint);
								    var cost = (parseFloat($("[name=BFXT_TRADEMARKRATE]").val())+parseFloat(sumCostPoint/10000)).toFixed(4);
								    $("[name=BFXT_DEALTCOSTRATE]").val(cost);
								    var Deal =(parseFloat($("[name=BFXT_DEALTCOSTRATE]").val()) + parseFloat(sumDealPoint/10000)).toFixed(4);
								    $("[name=BFXT_DEALTDEALDOWNRATE]").val(Deal);
								    $("[name=BFXT_DEALAFAVOURPOINT]").val(parseFloat(result['COMTT_BIDPOINT'])-parseFloat(result['BRTT_BIDPOINT']));
								    
								    
						}else{
									var SwapPoint = parseFloat(sellPrice) +parseFloat(result['BRTT_OFFERPOINT']);
									$("[name=BFXT_SWAPCOSTPOINT").val(SwapPoint);
								    var swapCost = (parseFloat($("[name=BFXT_TRADEMARKRATE]").val()) - parseFloat(SwapPoint/10000)).toFixed(4);
								    $("[name=BFXT_SWAPCOSTRATE").val(swapCost);
								    var swapDealPoint = parseFloat(sellPrice)+ parseFloat(result['COMTT_OFFERPOINT']);
								    $("[name=BFXT_SWAPDEALPOINT]").val(swapDealPoint); 
								    var swapDeal = (parseFloat($("[name=BFXT_SWAPCOSTRATE").val())-(parseFloat(result['COMTT_OFFERPOINT']-parseFloat(result['BRTT_OFFERPOINT']) )/10000)).toFixed(4) ; 
								    $("[name=BFXT_SWAPDEALDOWNRATE]").val(swapDeal);
								    $("[name=BFXT_SWAPDEALFAVOURPOINT]").val(parseFloat(result['COMTT_OFFERPOINT'])-parseFloat(result['BRTT_OFFERPOINT']));
								    
						   }
					}else if(BOS=="SELL")
					{
						if(direction=="J")
						{
									var sumCostPoint =parseFloat(sellPrice) - parseFloat(result['BRTT_OFFERPOINT']);
									$("[name=SFXT_COSTPOINT]").val(sumCostPoint);
								    var sumDealPoint = sumCostPoint-parseFloat(result['COMTT_OFFERPOINT'])+parseFloat(result['BRTT_OFFERPOINT']);
									$("[name=SFXT_DEALPOINT]").val(sumDealPoint);
								    var cost = (parseFloat($("[name=SFXT_TRADEMARKRATE]").val())+parseFloat(sumCostPoint/10000)).toFixed(4);
								    $("[name=SFXT_DEALTCOSTRATE]").val(cost);
								    var Deal =(parseFloat($("[name=SFXT_DEALTCOSTRATE]").val()) + parseFloat(sumDealPoint/10000)).toFixed(4);
								    $("[name=SFXT_DEALTDEALDOWNRATE]").val(Deal);
								    $("[name=SFXT_DEALAFAVOURPOINT]").val(parseFloat(result['COMTT_OFFERPOINT'])-parseFloat(result['BRTT_OFFERPOINT']));
						}else{
									var SwapPoint = parseFloat(buyPrice) +parseFloat(result['BRTT_BIDPOINT']);
									$("[name=SFXT_SWAPCOSTPOINT").val(SwapPoint);
								    var swapCost = (parseFloat($("[name=SFXT_TRADEMARKRATE]").val()) - parseFloat(SwapPoint/10000)).toFixed(4);
								    $("[name=SFXT_SWAPCOSTRATE").val(swapCost);
								    var swapDealPoint = parseFloat(sellPrice)+parseFloat(result['COMTT_BIDPOINT'])-parseFloat(result['BRTT_BIDPOINT']);;
								    $("[name=SFXT_SWAPDEALPOINT]").val(swapDealPoint); 
								    var swapDeal = (parseFloat($("[name=SFXT_SWAPCOSTRATE").val())+(parseFloat(result['COMTT_BIDPOINT']-parseFloat(result['BRTT_BIDPOINT']) )/10000)).toFixed(4) ; 
								    $("[name=SFXT_SWAPDEALDOWNRATE]").val(swapDeal);
								    $("[name=SFXT_SWAPDEALFAVOURPOINT]").val(parseFloat(result['COMTT_BIDPOINT'])-parseFloat(result['BRTT_BIDPOINT']));
						   }
					}
	           	}else{
	           		$.ligerDialog.error(result.ERR);
	           	}
				
		    }
		}); 
}

function getBASEACCOUNTDATA(customerNo)
{
    var url = '<%=request.getContextPath()+"/cm?ProcessMETHOD=getAccountByCustNo&ProcessBO=com.app.TR.CorporateFinanceHelper&SETTLEMENTCCY=other"%>'+'&CUSTOMERNO='+customerNo;
	 	$.ajax({url:url, dataType:'json',async: false, 
			success:function(result)
		    {
				if (result.ERR == null){
					BASEACCOUNTDATA = result;
	           	}else{
	           		$.ligerDialog.error(result.ERR);
	           	}
				
		    }
		}); 
}
function getTERMACCOUNTDATA(customerNo)
{
    var url = '<%=request.getContextPath()+"/cm?ProcessMETHOD=getAccountByCustNo&ProcessBO=com.app.TR.CorporateFinanceHelper&SETTLEMENTCCY=CNY"%>'+'&CUSTOMERNO='+customerNo;
 	$.ajax({url:url, dataType:'json',async: false, 
		success:function(result)
	    {
			if (result.ERR == null){
				TERMACCOUNTDATA = result;
           	}else{
           		$.ligerDialog.error(result.ERR);
           	}
			
	    }
	}); 
}
function getGridOptions(checkbox) {
    var options = {
        columns: [
        { display: '客户代码', name: 'TT_CUSTOMERID', align: 'left', width: 100, minWidth: 60 },
        { display: '客户名称(中文)', name: 'TT_CUSTOMERNAMECN', minWidth: 120, width: 100 },
        { display: '客户名称(英文)', name: 'TT_CUSTOMERNAMEEN', minWidth: 140, width: 100 },
        { display: '客户属性', name: 'TT_CUSTOMERPHONE', minWidth: 140, width: 100 }
        ], switchPageSizeApplyComboBox: false,
        data: $.extend({},CUSTOMERDATA),
        pageSize: 10,
        checkbox: checkbox
    };
    return options;
};


function getBaseAccountGrid(checkbox) {
    var options = {
        columns: [
                  { display: 'Customer', name: 'CUSTOMERNO', align: 'left', width: 100, minWidth: 60 },
                  { display: 'CustomerName', name: 'CUSTOMERNM', minWidth: 120, width: 100 },
                  { display: 'SettlementId', name: 'TT_SETTLEMENTID', minWidth: 140, width: 100 },
                  { display: 'SettlementCcy', name: 'TT_SETTLEMENTCCY', minWidth: 140, width: 100 }
                  ], switchPageSizeApplyComboBox: false,
                  data: $.extend({},BASEACCOUNTDATA),
                  pageSize: 10,
                  checkbox: checkbox
    };
    return options;
};
function getTermAccountGrid(checkbox) {
    var options = {
        columns: [
                  { display: 'Customer', name: 'CUSTOMERNO', align: 'left', width: 100, minWidth: 60 },
                  { display: 'CustomerName', name: 'CUSTOMERNM', minWidth: 120, width: 100 },
                  { display: 'SettlementId', name: 'TT_SETTLEMENTID', minWidth: 140, width: 100 },
                  { display: 'SettlementCcy', name: 'TT_SETTLEMENTCCY', minWidth: 140, width: 100 }
        ], switchPageSizeApplyComboBox: false,
        data: $.extend({},TERMACCOUNTDATA),
        pageSize: 10,
        checkbox: checkbox
    };
    return options;
};

function doQuery(){
	
    $.ligerDialog.open({
        height:150,  width: 250, showToggle: true, isResize: true, modal: false, title: '主管审核',target:$('#submitForm'), buttons: [
            { text: '确定', onclick: function (item, dialog) { timedCount();	doAction('Query'); dialog.hide();} },
            { text: '取消', onclick: function (item, dialog) { dialog.hide(); } }
        ]
    });

}

function doConfim(){
	doAction('Confim');
}

function doCancel(){
	doAction('Cancel');
}

function doExit(){
	doAction('Cancel');
	$dialog.hide();
}


function setFormData(data)
{
	
     $('#BFXT_TRADEMARKRATE').val(data.FXT_TRADEMARKRATE);
     $('#BFXT_DEALTCOSTRATE').val(data.FXT_DEALTCOSTRATE);
     $('#BFXT_COSTPOINT').val(data.FXT_COSTPOINT);
     
     $('#BFXT_DEALTCOSTRATE').val(data.FXT_DEALTCOSTRATE);
     $('#BFXT_DEALPOINT').val(data.FXT_DEALPOINT);
     $('#BFXT_DEALAFAVOURPOINT').val(data.FXT_DEALAFAVOURPOINT);
     $('#BFXT_SWAPDEALPOINT').val(data.FXT_SWAPDEALPOINT);
     $('#BFXT_SWAPDEALDOWNRATE').val(data.FXT_SWAPDEALDOWNRATE);
    
     $('#BFXT_SWAPCOSTPOINT').val(data.FXT_SWAPCOSTPOINT);
     $('#BFXT_SWAPCOSTRATE').val(data.FXT_SWAPCOSTRATE);
     $('#BFXT_SWAPDEALFAVOURPOINT').val(data.FXT_SWAPDEALFAVOURPOINT);
     
     $('#SFXT_TRADEMARKRATE').val(data.FXT_TRADEMARKRATE);
     $('#SFXT_COSTPOINT').val(data.FXT_COSTPOINT);
     $('#SFXT_DEALTCOSTRATE').val(data.FXT_DEALTCOSTRATE);
     $('#SFXT_DEALPOINT').val(data.FXT_DEALPOINT);
     $('#SFXT_DEALTDEALDOWNRATE').val(data.FXT_DEALTDEALDOWNRATE);
     $('#SFXT_DEALAFAVOURPOINT').val(data.FXT_DEALAFAVOURPOINT);
     $('#SFXT_SWAPCOSTRATE').val(data.FXT_SWAPCOSTRATE);
     $('#SFXT_SWAPCOSTPOINT').val(data.FXT_SWAPCOSTPOINT);

     $('#SFXT_SWAPDEALDOWNRATE').val(data.FXT_SWAPDEALDOWNRATE);

     $('#SFXT_SWAPDEALPOINT').val(data.FXT_SWAPDEALPOINT);
     $('#SFXT_SWAPDEALFAVOURPOINT').val(data.FXT_SWAPDEALFAVOURPOINT);
    $('#custormerProfit').html(parseFloat(data.FXT_DEALPOINT)-parseFloat(data.FXT_COSTPOINT)+parseFloat(data.FXT_SWAPDEALPOINT)-parseFloat(data.FXT_SWAPCOSTPOINT));
	
}
function doAction(action)
{		
	var form = liger.get('mainform');
 	var param=$("#mainform").serialize();
 	param = param + "&FXT_CUSTOMERID=" +$.ligerui.get("FXT_CUSTOMERID").getValue();
 	param = param + "&FXT_VALUEDATE="+$("#FXT_VALUEDATE").val();
 	param = param + "&FXT_SWAPVALUEDATE="+$("#FXT_SWAPVALUEDATE").val();
	param = param + "&FXT_SWAPTERMDAYS="+$("#FXT_SWAPTERMDAYS").val();
	param = param + "&FXT_TERMDAYS="+$("#FXT_TERMDAYS").val();
	
	for(var t=0;t<BizTypeData.length;t++)
		{
		  if($("#FXT_SWAPVALUEDATETYPE").val()==BizTypeData[t]['id'])
			  {
			  param = param + "&FXT_SWAPVALUEDATETYPE="+BizTypeData[t]['text'];
			  }
		  if($("#FXT_VALUEDATETYPE").val()==BizTypeData[t]['id'])
			  {
			  param = param + "&FXT_VALUEDATETYPE="+BizTypeData[t]['text'];
			  }
		}
 	console.log(param);
	if (form.valid()) {
       //	var param=$("#mainform").serialize();
       
       	$.ajax({
			type:'POST',
			url:'<%=serverUrl%>'+'&ACTION='+action,
			dataType:'json',
			data:param,
			success:function(result)
		    {
				if (result.ERR == null){
                	
               	}else{
               		$.ligerDialog.error(result.ERR);
               	}
		    }
		});       	
    } else {
    	form.showInvalid();
	}
}

function getForm()
{
	alert(JSON.stringify($("#mainform").serialize()));
}

function changeBizAttr(object)
{
	if(object!=null)
	{
		if(object=='SPOT')
		{
			var str = "";
			$("#d1 input:radio").each(function () {
              if(this.checked )
                 {
                  str=this.value;
                 }
            });
			$('#showTitle').html('<font size=\'4\' color=\'red\'>Near Leg:I '+str+' '+str_Biz+' '+$("[name=FXT_DEALTCCY]").val()+'</font>');
		}else if(object=='SWAP')
		{
			var str = "";
			$("#d1 input:radio").each(function () {
              if(this.checked )
                 {
                  str=this.value;
                 }
            });
			$('#showTitle').html('<font size=\'4\' color=\'red\'>Near Leg:I '+str+' SWAP '+$("[name=FXT_DEALTCCY]").val()+'</font>');
		}
	}
}

function changeBuyOrSell(object)
{ 
		var str = "";
		$("#BizType1 input:radio").each(function () {
          if(this.checked )
             {
              str=this.value;
             }
        });
        if('SWAP'==str)
         {
           $('#showTitle').html('<font size=\'4\' color=\'red\'>Near Leg:I '+object+'  SWAP '+$("[name=FXT_DEALTCCY]").val()+'</font>');

         }
        else
           {
        	 $('#showTitle').html('<font size=\'4\' color=\'red\'>Near Leg:I '+object+'  '+str_Biz+' '+$("[name=FXT_DEALTCCY]").val()+'</font>');
           }
        var arr = $("[name=FXT_DEALTCCY]").val().split('_');
        if(object=='BUY')
         {
	              $('#buy1').html(arr[0]);
	              $('#sell2').html(arr[0]);
	              $('#buy2').html(arr[1]);
	              $('#sell1').html(arr[1]);
	              $('#sellMarket1').css('display','none');
	              $('#sellMarket2').css('display','none');
	              $('#sellMarket3').css('display','none');
	              $('#buyMarket1').css('display','');
	              $('#buyMarket2').css('display','');
	              $('#buyMarket3').css('display','');
	              $('#sellRemittance1').css('display','none');
	              $('#sellRemittance2').css('display','none');
	              $('#buyRemittance1').css('display','');
	              $('#buyRemittance2').css('display','');
	              $('#JBuyTitle1').css('display','');
	              $('#JSellTitle1').css('display','none');
	              $('#FBuyTitle1').css('display','');
	              $('#FSellTitle1').css('display','none');
	              
         }else
          {
      	          $('#buy1').html(arr[1]);
	              $('#sell2').html(arr[1]);
	              $('#buy2').html(arr[0]);
	              $('#sell1').html(arr[0]); 
	              $('#sellMarket1').css('display','');
	              $('#sellMarket2').css('display','');
	              $('#sellMarket3').css('display','');
	              $('#buyMarket1').css('display','none');
	              $('#buyMarket2').css('display','none');
	              $('#buyMarket3').css('display','none');
	              $('#buyRemittance1').css('display','none');
	              $('#buyRemittance2').css('display','none');
	              $('#sellRemittance1').css('display','');
	              $('#sellRemittance2').css('display','');
	              $('#JBuyTitle1').css('display','none');
	              $('#JSellTitle1').css('display','');
	              $('#FBuyTitle1').css('display','none');
	              $('#FSellTitle1').css('display','');
          }
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
  <form id="mainform" style="display:none;">
    <%@ include  file="CF1003.jsp" %>
		
 </form>
  <form id="submitForm" style="display:none;">

  </form>
 <table id="managerGrid" style="border:1px ;width:950px;background-color:rgb(235, 243, 255)	;padding:5px;color:#ADADAD;text-align:center;font-weight:bold;">

 </table>
    <style type="text/css">
    body {
	    background: #FFFFFF;
	    padding-left:10px;
        font-size:13px;
	}
    .addTd {border-top: 1px solid #d0d0d0;border-left: 1px solid#d0d0d0;border-right: 1px solid #d0d0d0;border-bottom: 1px solid #d0d0d0;align:center,background-color:	#ECF5FF	}
    
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

           h1
           {
               font-size:20px;
               font-family:Verdana;
           }
           h4
           {
               font-size:16px;
               margin-top:25px;
               margin-bottom:10px;
           }
 
	.div
		{
		border:1px solid 	 	#7B7B7B;
		border-radius:15px;
		background:#F0F0F0;
		
		}
       td {
           padding: 3px;
       }
    </style>
    <script type="text/javascript">
        var panels = [
            {id:'p1',title:'USD_CNY',height:150,collapsible:true,cache:false,closable:true,href:'CF1002.jsp?Currency=USD_CNY'},
            {id:'p2',title:'USD_AUD',height:150,collapsible:true,cache:false,closable:true,href:'CF1002.jsp?Currency=USD_AUD'},
            {id:'p3',title:'USD_EUR',height:150,collapsible:true,cache:false,closable:true,href:'CF1002.jsp?Currency=USD_EUR'},
            {id:'p4',title:'USD_CHF',height:150,collapsible:true,cache:false,closable:true,href:'CF1002.jsp?Currency=USD_CHF'},
            {id:'p5',title:'USD_HKD',height:150,collapsible:true,cache:false,closable:true,href:'CF1002.jsp?Currency=USD_HKD'},
            {id:'p6',title:'CNY_HKD',height:150,collapsible:true,cache:false,closable:true,href:'CF1002.jsp?Currency=CNY_HKD'},
        ];
        var TenorCurData =[
                           {CurrencyPair:'USD_CNY',Tenor:'SPOT',Sell:'1',Buy:'12'},{CurrencyPair:'USD_CNY',Tenor:'TOM',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_CNY',Tenor:'1M',Sell:'1',Buy:'12'},{CurrencyPair:'USD_CNY',Tenor:'TODAY',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_CNY',Tenor:'9Y',Sell:'1',Buy:'12'},{CurrencyPair:'USD_CNY',Tenor:'1D',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_CNY',Tenor:'1Y',Sell:'1',Buy:'12'},{CurrencyPair:'USD_CNY',Tenor:'1W',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_CNY',Tenor:'2M',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_AUD',Tenor:'SPOT',Sell:'1',Buy:'12'},{CurrencyPair:'USD_AUD',Tenor:'TOM',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_AUD',Tenor:'1M',Sell:'1',Buy:'12'},{CurrencyPair:'USD_AUD',Tenor:'TODAY',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_AUD',Tenor:'9Y',Sell:'1',Buy:'12'},{CurrencyPair:'USD_AUD',Tenor:'1D',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_AUD',Tenor:'1Y',Sell:'1',Buy:'12'},{CurrencyPair:'USD_AUD',Tenor:'1W',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_AUD',Tenor:'2M',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_EUR',Tenor:'SPOT',Sell:'1',Buy:'12'},{CurrencyPair:'USD_EUR',Tenor:'TOM',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_EUR',Tenor:'1M',Sell:'1',Buy:'12'},{CurrencyPair:'USD_EUR',Tenor:'TODAY',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_EUR',Tenor:'9Y',Sell:'1',Buy:'12'},{CurrencyPair:'USD_EUR',Tenor:'1D',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_EUR',Tenor:'1Y',Sell:'1',Buy:'12'},{CurrencyPair:'USD_EUR',Tenor:'1W',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_EUR',Tenor:'2M',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_CHF',Tenor:'SPOT',Sell:'1',Buy:'12'},{CurrencyPair:'USD_CHF',Tenor:'TOM',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_CHF',Tenor:'1M',Sell:'1',Buy:'12'},{CurrencyPair:'USD_CHF',Tenor:'TODAY',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_CHF',Tenor:'9Y',Sell:'1',Buy:'12'},{CurrencyPair:'USD_CHF',Tenor:'1D',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_CHF',Tenor:'1Y',Sell:'1',Buy:'12'},{CurrencyPair:'USD_CHF',Tenor:'1W',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_CHF',Tenor:'2M',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_HKD',Tenor:'SPOT',Sell:'1',Buy:'12'},{CurrencyPair:'USD_HKD',Tenor:'TOM',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_HKD',Tenor:'1M',Sell:'1',Buy:'12'},{CurrencyPair:'USD_HKD',Tenor:'TODAY',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_HKD',Tenor:'9Y',Sell:'1',Buy:'12'},{CurrencyPair:'USD_HKD',Tenor:'1D',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_HKD',Tenor:'1Y',Sell:'1',Buy:'12'},{CurrencyPair:'USD_HKD',Tenor:'1W',Sell:'1',Buy:'12'},
                           {CurrencyPair:'USD_HKD',Tenor:'2M',Sell:'1',Buy:'12'},
                           {CurrencyPair:'CNY_HKD',Tenor:'SPOT',Sell:'1',Buy:'12'},{CurrencyPair:'CNY_HKD',Tenor:'TOM',Sell:'1',Buy:'12'},
                           {CurrencyPair:'CNY_HKD',Tenor:'1M',Sell:'1',Buy:'12'},{CurrencyPair:'CNY_HKD',Tenor:'TODAY',Sell:'1',Buy:'12'},
                           {CurrencyPair:'CNY_HKD',Tenor:'9Y',Sell:'1',Buy:'12'},{CurrencyPair:'CNY_HKD',Tenor:'1D',Sell:'1',Buy:'12'},
                           {CurrencyPair:'CNY_HKD',Tenor:'1Y',Sell:'1',Buy:'12'},{CurrencyPair:'CNY_HKD',Tenor:'1W',Sell:'1',Buy:'12'},
                           {CurrencyPair:'CNY_HKD',Tenor:'2M',Sell:'1',Buy:'12'}
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