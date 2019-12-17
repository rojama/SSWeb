<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>trade-center</title>
<%@ include file="/pages/common/header.jsp" %>
<%@ taglib prefix="shiro" uri="/WEB-INF/shiro.tld" %>

<script type="text/javascript">

var gridData = [];
	gridData.push({'TradeDate':'20160101','DealNo':'TEST160101000001','Status':'Quote','Currencys':'EUR/CNY','DealType':'SPOT','direction':'B/-','Currency':'EUR','Amount':'2,349,876.98'});
	gridData.push({'TradeDate':'20160103','DealNo':'TEST160101000002','Status':'TimeOut','Currencys':'EUR/CNY','DealType':'SPOT','direction':'B/-','Currency':'EUR','Amount':'3,899,876.98'});

var gridData1 = [];
gridData1.push({'TradeDate':'20161101','DealNo':'TEST160101220001','Status':'TimeOut','Currencys':'EUR/CNY','DealType':'FORWARD','direction':'B/-','Currency':'EUR','Amount':'2,451,876.98'});
gridData1.push({'TradeDate':'20161103','DealNo':'TEST160101220002','Status':'Quote','Currencys':'EUR/CNY','DealType':'FORWARD','direction':'B/-','Currency':'EUR','Amount':'5,869,846.98'});
	
	
var jsonObj = {};
 	jsonObj.Rows = gridData;
 	
 	var jsonObj1 = {};
 	jsonObj1.Rows = gridData1;

var maingrid1 = "";
var maingrid2 = "";
var maingrid3 = "";
 	
$(function(){

	//PageLoader.initTopToolBar();
	maingrid1 = PageLoader.initGridPanel1();
	maingrid2 = PageLoader.initGridPanel2();
	maingrid3 = PageLoader.initGridPanel3();

	maingrid1.set({data:jsonObj});
	maingrid2.set({data:jsonObj1});
	maingrid3.set({data:jsonObj});

	$("#tab1").ligerTab({});

	
});


var menu1 = { width: 120, items:
    [
    { text: '即期'},
    { line: true },
    { text: '远期' },
    { line: true },
    { text: '掉期'}
    ]
};


PageLoader = {

	initTopToolBar:function()
	{
		  
          $("#toptoolbar").ligerToolBar({ items: [
               { text: '<fmt:message key="add"/>', icon:'add'},
               { line: true },
        	   { text: '<fmt:message key="remove"/>',icon: 'delete' },
        	   { line: true },
        	   { text: '<fmt:message key="edit"/>',icon: 'modify' },
        	   { line: true },
        	   { text: '<fmt:message key="save"/>',icon: 'save' },
        	   { line: true }
            ]
          });
	},
	initGridPanel1:function()
	{
		var g = $("#maingrid1").ligerGrid({
			columns:[
					{display:'交易时间',name:'TradeDate',width:'100',align:'center'},
					{display:'交易编号',name:'DealNo',width:'150',align:'center'},
					{display:'交易状态',name:'Status',width:'100',align:'center'},
					{display:'货币对',name:'Currencys',width:'150',align:'center'},
					{display:'交易类型',name:'DealType',width:'150',align:'center'},
					{display:'交易方向',name:'direction',width:'150',align:'center'},
					{display:'交易币别',name:'Currency',width:'100',align:'center'},
					{display:'交易金额',name:'Amount',width:'100',align:'left'}
				],
				data:jsonObj,
				usePager:false
			});

		return g;
	},
	initGridPanel2:function()
	{
		var g = $("#maingrid2").ligerGrid({
			columns:[
					{display:'交易时间',name:'TradeDate',width:'100',align:'center'},
					{display:'交易编号',name:'DealNo',width:'150',align:'center'},
					{display:'交易状态',name:'Status',width:'100',align:'center'},
					{display:'货币对',name:'Currencys',width:'150',align:'center'},
					{display:'交易类型',name:'DealType',width:'150',align:'center'},
					{display:'交易方向',name:'direction',width:'150',align:'center'},
					{display:'交易币别',name:'Currency',width:'100',align:'center'},
					{display:'交易金额',name:'Amount',width:'100',align:'left'}
				],
				data:jsonObj,
				usePager:false
			});

		return g;
	},
	initGridPanel3:function()
	{
		var g = $("#maingrid3").ligerGrid({
			columns:[
					{display:'交易时间',name:'TradeDate',width:'100',align:'center'},
					{display:'交易编号',name:'DealNo',width:'150',align:'center'},
					{display:'交易状态',name:'Status',width:'100',align:'center'},
					{display:'货币对',name:'Currencys',width:'150',align:'center'},
					{display:'交易类型',name:'DealType',width:'150',align:'center'},
					{display:'交易方向',name:'direction',width:'150',align:'center'},
					{display:'交易币别',name:'Currency',width:'100',align:'center'},
					{display:'交易金额',name:'Amount',width:'100',align:'left'}
				],
				data:jsonObj,
				usePager:false
			});

		return g;
	}
}

</script>
</head>
<body>
<br/>
<div id="topTab" >
          <div id="tab1" style="width: 100%;overflow:hidden; border:1px solid #A3C0E8; "> 
            <div title="即期" >
              <table border="0" cellpadding="0" cellspacing="0" height="80%">
				  <tr>
				    <td>&nbsp;</td>
				  </tr>
				  <tr>
				    <td>
				        
				        <div id="toptoolbar1"></div> 
				    	<div id="maingrid1"></div>
				    </td>
				  </tr>
				  <tr>
				    <td>&nbsp;</td>
				  </tr>
				  <tr>
				    <td>
				      <table height="100%">
				        <tr>
				          <td>
				            <table>
				              <tr>
				                <td>&nbsp;</td>
				                <td>&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px" width="80">交易日</td>
				                <td height="25px" width="80"><input type='text' value="2016-01-01" /></td>
				              </tr>
				              <tr>
				                <td height="25px">交易编号</td>
				                <td height="25px"><input type='text' value="TEST160101000001"/></td>
				              </tr>
				              <tr>
				                <td height="25px">报价行员</td>
				                <td height="25px"><input type='text' value="USER!"/></td>
				              </tr>
				              <tr>
				                <td height="25px">营业机构</td>
				                <td height="25px"><input type='text' value="B002"/></td>
				              </tr>
				              <tr>
				                <td height="25px">询价行员</td>
				                <td height="25px"><input type='text' value="USER2"/></td>
				              </tr>
				              <tr>
				                <td height="25px">客户号</td>
				                <td height="25px"><input type='text' value="TEST"/></td>
				              </tr>
				              <tr>
				                <td>&nbsp;</td>
				                <td>&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px">交易对象</td>
				                <td height="25px"><input type='text' value="客户"/></td>
				              </tr>
				              <tr>
				                <td height="25px">交易目的</td>
				                <td height="25px"><input type='text' value="平盘"/></td>
				              </tr>
				              <tr>
				                <td height="25px">结算剩余时间</td>
				                <td height="25px"><input type='text' value="92"/></td>
				              </tr>
				              <tr>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				              </tr>
				            </table>
				          </td>
				          <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				          <td>
				            <table border="0">
				              <tr>
				                <td height="25px" width="80">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px" width="80" colspan="6">SPOT:I BUY EUR 1.0 m vs CNY </td>
				              </tr>
				              <tr>
				                <td height="25px">买&nbsp;<input type="radio"></td>
				                <td height="25px"><input type='text' value='EUR' size='5'/></td>
				                <td height="25px"><input type='text' value='234,9876.98' style="text-align: right"/></td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px">卖&nbsp;<input type="radio"></td>
				                <td height="25px"><input type='text' value='CNY' size='5'/></td>
				                <td height="25px" ><input type='text' value='4,356,296.98' style="text-align: right"/></td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				               <td height="25px">&nbsp;</td>
				               <td height="25px">&nbsp;</td>
				               <td height="25px">&nbsp;</td>
				               <td height="25px">&nbsp;</td>
				               <td height="25px">Bid</td>
				               <td height="25px">Ask</td>
				              </tr>
				              <tr>
				                <td height="25px">区间别</td>
				                <td height="25px"><input type='text' value='SPOT'/></td>
				                <td height="25px">&nbsp;&nbsp;市场价</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px"><input type='text' value="10.500000" style="text-align: right"/>/</td>
				                <td height="25px"><input type='text' value="" /></td>
				              </tr>
				              <tr>
				                <td height="25px">&nbsp;</td>
				                <td height="25px">0</td>
				                <td height="25px">&nbsp;&nbsp;平盘汇率</td>
				                <td height="25px"><input type="text" value="53.00" style="text-align: right"/></td>
				                <td height="25px"><input type='text' value="10.494700" style="text-align: right"/>/</td>
				                <td height="25px"><input type='text' value="" /></td>
				              </tr>
				              <tr>
				                <td height="25px">交割日期</td>
				                <td height="25px"><input type="text" value="2016-01-01"/></td>
				                <td height="25px">&nbsp;&nbsp;客户汇率</td>
				                <td height="25px"><input type="text" value="10,603.00" style="text-align: right"/></td>
				                <td height="25px"><input type='text' value="9.494700" style="text-align: right"/>/</td>
				                <td height="25px"><input type='text' value="" /></td>
				              </tr>
				              <tr>
				                <td height="25px" width="80">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px" width="80">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px" width="80">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px" width="80">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				            </table>
				          </td>
				        </tr>
				      </table>
				    </td>
				  </tr>
				  <tr>
				    <td align="center">
				       <input type="button" value="发送"/>
				       <input type="button" value="拒绝"/>
				       <input type="button" value="解锁"/>
				    </td>
				  </tr>
				</table>
            </div>
            <div title="远期" >
              <table border="0" cellpadding="0" cellspacing="0" height="80%">
				  <tr>
				    <td>&nbsp;</td>
				  </tr>
				  <tr>
				    <td>
				        
				        <div id="toptoolbar2"></div> 
				    	<div id="maingrid2"></div>
				    </td>
				  </tr>
				  <tr>
				    <td>&nbsp;</td>
				  </tr>
				  <tr>
				    <td>
				      <table height="100%">
				        <tr>
				          <td>
				            <table>
				              <tr>
				                <td>&nbsp;</td>
				                <td>&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px" width="80">交易日</td>
				                <td height="25px" width="80"><input type='text' value="2016-02-02" /></td>
				              </tr>
				              <tr>
				                <td height="25px">交易编号</td>
				                <td height="25px"><input type='text' value="TEST160101220001"/></td>
				              </tr>
				              <tr>
				                <td height="25px">报价行员</td>
				                <td height="25px"><input type='text' value="USER2"/></td>
				              </tr>
				              <tr>
				                <td height="25px">营业机构</td>
				                <td height="25px"><input type='text' value="B003"/></td>
				              </tr>
				              <tr>
				                <td height="25px">询价行员</td>
				                <td height="25px"><input type='text' value="USER3"/></td>
				              </tr>
				              <tr>
				                <td height="25px">客户号</td>
				                <td height="25px"><input type='text' value="TEST"/></td>
				              </tr>
				              <tr>
				                <td>&nbsp;</td>
				                <td>&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px">交易对象</td>
				                <td height="25px"><input type='text' value="客户"/></td>
				              </tr>
				              <tr>
				                <td height="25px">交易目的</td>
				                <td height="25px"><input type='text' value="平盘"/></td>
				              </tr>
				              <tr>
				                <td height="25px">结算剩余时间</td>
				                <td height="25px"><input type='text' value="92"/></td>
				              </tr>
				              <tr>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				              </tr>
				            </table>
				          </td>
				          <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				          <td>
				            <table border="0">
				              <tr>
				                <td height="25px" width="80">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px" width="80" colspan="6">SPOT:I BUY EUR 1.0 m vs CNY </td>
				              </tr>
				              <tr>
				                <td height="25px">买&nbsp;<input type="radio"></td>
				                <td height="25px"><input type='text' value='EUR' size='5'/></td>
				                <td height="25px"><input type='text' value='114,977.98' style="text-align: right"/></td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px">卖&nbsp;<input type="radio"></td>
				                <td height="25px"><input type='text' value='CNY' size='5'/></td>
				                <td height="25px" ><input type='text' value='4,343,861.98' style="text-align: right"/></td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				               <td height="25px">&nbsp;</td>
				               <td height="25px">&nbsp;</td>
				               <td height="25px">&nbsp;</td>
				               <td height="25px">&nbsp;</td>
				               <td height="25px">Bid</td>
				               <td height="25px">Ask</td>
				              </tr>
				              <tr>
				                <td height="25px">区间别</td>
				                <td height="25px"><input type='text' value='SPOT'/></td>
				                <td height="25px">&nbsp;&nbsp;市场价</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px"><input type='text' value="10.510000" style="text-align: right"/>/</td>
				                <td height="25px"><input type='text' value="" /></td>
				              </tr>
				              <tr>
				                <td height="25px">&nbsp;</td>
				                <td height="25px">0</td>
				                <td height="25px">&nbsp;&nbsp;平盘汇率</td>
				                <td height="25px"><input type="text" value="53.00" style="text-align: right"/></td>
				                <td height="25px"><input type='text' value="10.494700" style="text-align: right"/>/</td>
				                <td height="25px"><input type='text' value="" /></td>
				              </tr>
				              <tr>
				                <td height="25px">交割日期</td>
				                <td height="25px"><input type="text" value="2016-01-01"/></td>
				                <td height="25px">&nbsp;&nbsp;客户汇率</td>
				                <td height="25px"><input type="text" value="10,603.00" style="text-align: right"/></td>
				                <td height="25px"><input type='text' value="9.494700" style="text-align: right"/>/</td>
				                <td height="25px"><input type='text' value="" /></td>
				              </tr>
				              <tr>
				                <td height="25px" width="80">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px" width="80">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px" width="80">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px" width="80">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				            </table>
				          </td>
				        </tr>
				      </table>
				    </td>
				  </tr>
				  <tr>
				    <td align="center">
				       <input type="button" value="发送"/>
				       <input type="button" value="拒绝"/>
				       <input type="button" value="解锁"/>
				    </td>
				  </tr>
				</table>
            </div>
            <div title="掉期" >
              <table border="0" cellpadding="0" cellspacing="0" height="80%">
				  <tr>
				    <td>&nbsp;</td>
				  </tr>
				  <tr>
				    <td>
				        
				        <div id="toptoolbar3"></div> 
				    	<div id="maingrid3"></div>
				    </td>
				  </tr>
				  <tr>
				    <td>&nbsp;</td>
				  </tr>
				  <tr>
				    <td>
				      <table height="100%">
				        <tr>
				          <td>
				            <table>
				              <tr>
				                <td>&nbsp;</td>
				                <td>&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px" width="80">交易日</td>
				                <td height="25px" width="80"><input type='text' value="2016-01-01" /></td>
				              </tr>
				              <tr>
				                <td height="25px">交易编号</td>
				                <td height="25px"><input type='text' value="TEST160101000003"/></td>
				              </tr>
				              <tr>
				                <td height="25px">报价行员</td>
				                <td height="25px"><input type='text' value="USER!"/></td>
				              </tr>
				              <tr>
				                <td height="25px">营业机构</td>
				                <td height="25px"><input type='text' value="B002"/></td>
				              </tr>
				              <tr>
				                <td height="25px">询价行员</td>
				                <td height="25px"><input type='text' value="USER2"/></td>
				              </tr>
				              <tr>
				                <td height="25px">客户号</td>
				                <td height="25px"><input type='text' value="TEST"/></td>
				              </tr>
				              <tr>
				                <td>&nbsp;</td>
				                <td>&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px">交易对象</td>
				                <td height="25px"><input type='text' value="客户"/></td>
				              </tr>
				              <tr>
				                <td height="25px">交易目的</td>
				                <td height="25px"><input type='text' value="平盘"/></td>
				              </tr>
				              <tr>
				                <td height="25px">结算剩余时间</td>
				                <td height="25px"><input type='text' value="92"/></td>
				              </tr>
				              <tr>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				              </tr>
				            </table>
				          </td>
				          <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				          <td>
				            <table border="0">
				              <tr>
				                <td height="25px" width="80">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px" width="80" colspan="6">SPOT:I BUY EUR 1.0 m vs CNY </td>
				              </tr>
				              <tr>
				                <td height="25px">买&nbsp;<input type="radio"></td>
				                <td height="25px"><input type='text' value='EUR' size='5'/></td>
				                <td height="25px"><input type='text' value='234,9876.98' style="text-align: right"/></td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px">卖&nbsp;<input type="radio"></td>
				                <td height="25px"><input type='text' value='CNY' size='5'/></td>
				                <td height="25px" ><input type='text' value='4,356,296.98' style="text-align: right"/></td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				               <td height="25px">&nbsp;</td>
				               <td height="25px">&nbsp;</td>
				               <td height="25px">&nbsp;</td>
				               <td height="25px">&nbsp;</td>
				               <td height="25px">Bid</td>
				               <td height="25px">Ask</td>
				              </tr>
				              <tr>
				                <td height="25px">区间别</td>
				                <td height="25px"><input type='text' value='SPOT'/></td>
				                <td height="25px">&nbsp;&nbsp;市场价</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px"><input type='text' value="10.500000" style="text-align: right"/>/</td>
				                <td height="25px"><input type='text' value="" /></td>
				              </tr>
				              <tr>
				                <td height="25px">&nbsp;</td>
				                <td height="25px">0</td>
				                <td height="25px">&nbsp;&nbsp;平盘汇率</td>
				                <td height="25px"><input type="text" value="53.00" style="text-align: right"/></td>
				                <td height="25px"><input type='text' value="10.494700" style="text-align: right"/>/</td>
				                <td height="25px"><input type='text' value="" /></td>
				              </tr>
				              <tr>
				                <td height="25px">交割日期</td>
				                <td height="25px"><input type="text" value="2016-01-01"/></td>
				                <td height="25px">&nbsp;&nbsp;客户汇率</td>
				                <td height="25px"><input type="text" value="10,603.00" style="text-align: right"/></td>
				                <td height="25px"><input type='text' value="9.494700" style="text-align: right"/>/</td>
				                <td height="25px"><input type='text' value="" /></td>
				              </tr>
				              <tr>
				                <td height="25px" width="80">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px" width="80">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px" width="80">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				              <tr>
				                <td height="25px" width="80">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px" >&nbsp;</td>
				                <td height="25px">&nbsp;</td>
				              </tr>
				            </table>
				          </td>
				        </tr>
				      </table>
				    </td>
				  </tr>
				  <tr>
				    <td align="center">
				       <input type="button" value="发送"/>
				       <input type="button" value="拒绝"/>
				       <input type="button" value="解锁"/>
				    </td>
				  </tr>
				</table>
            </div>
          </div>
        </div> 


</body>
</html>