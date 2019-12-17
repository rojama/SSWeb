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
 <div class="easyui-tabs" data-options="tabWidth:112" style="border:1px solid#7B7B7B;width:1050px;height:600px;">
	<div title="Home" style="padding:10px ">
	<div  style="height:30px;width:1000px;"> <input type="radio">spot/forward  &nbsp; &nbsp; &nbsp; &nbsp;
	<input type="radio">swap&nbsp; &nbsp; &nbsp; &nbsp;<img alt="" src="${ctx}/images/icons/other/block.gif">submit</div>
	<div>
	  <div  class="div" id="lForm"  style="float:left;height:500px;width:300px;background:#F0F0F0;align:center">
	  <br>
      <table>
	           <tbody>
              <tr>
               <td>
                   <label>交易号：</label>
               </td>
               <td>
                  <input id="TRADENO"  name="TRADENO" type="text"  style="width: 174px;">
               </td>
               </tr>
               <tr>
               <td>
                   <label>询价行员：</label>
               </td>
               <td>
                 <input id="TRADENO" name="TRADENO" type="text"  style="width: 174px;">     
                  </td>
               </tr>
                <tr>
               <td>
                   <label>营业机构：</label>
               </td>
               <td>
                                <input id="TRADENO" name="TRADENO" type="text"  style="width: 174px;">     
               
               </td>
               </tr>
               <tr>
               <td>
                   <label>报价行员：</label>
               </td>
               <td>
                 <input id="TRADENO" name="TRADENO" type="text"  style="width: 174px;">     
               </td>
               </tr>
              <tr>
               <td>
                  <label> 交易目的：</label>
               </td>
               <td>
          	                              <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">

               </td>
           </tr>
	       <tr>
	         <td>
	                   <label>交易对象：</label>
	               </td>
	               <td>
	                	                              <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">

	                </td>
	          </tr>
	         <tr>
	         <td>
	               <label> 交易类型：</label>
	               </td>
	               <td>
	         	                              <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">

	                </td>
	           </tr>
               <tr>
               <td>
                   <label >交易号：</label>
               </td>
               <td>
                 <input  name="TRADENO" type="text"  style="width: 174px;">     
               </td>
               </tr>
               <tr>
               <td>
                   <label >核心客户编号：</label>
               </td>
               <td>
                 <input id="TRADENO" name="TRADENO" type="text"  style="width: 174px;">     
               </td>
               </tr>
               <tr>
               </tr>
              <tr>
               <td>
                   <label >客户优惠：</label>
               </td>
               <td>
                 <input id="TRADENO" name="TRADENO" type="text"  style="width: 174px;">     
               </td>
               </tr>
              <tr>
               <td>
                   <label>优惠后利润点：</label>
               </td>
               <td>
                 <input id="TRADENO" name="TRADENO" type="text"  style="width: 174px;">     
               </td>
               </tr>
	           </tbody>
	           </table>
             </div>
              <div  style="float:left;width:10px;height:500px;">
              </div>
            <div class="div" id="cForm" style="float:left;height:500px;width:700px">
            <br>
              <table align="center">
	           <tbody>
               <tr>
                 <td colspan="6" align="center" >
                <hr/>
                </td>
               </tr>
               <tr>
               <td colspan="6" align="center" >
               <font size="6">spot</font>
               </td>
               </tr>
               <tr>
                 <td colspan="6" align="center">
                <hr/>
                </td>
               </tr>
               <tr>
                <td align="right" valign="top">Type:</td>
                <td align="left" colspan="5">
                <input id="rbtnl_0" type="radio" name="rbtnl" value="1" checked="checked" class="l-hidden" ><label>I buy</label> <input id="rbtnl_1" type="radio" name="rbtnl" value="2" class="l-hidden" ><label >I sell</label>
                </td>
                </tr> 
              <tr>
                <td >
                  Account
                </td>
                <td colspan="2">
	                               <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">
	            </td>
               </tr>
               <tr>
                   <td >
                   <label>valuedate:</label>
                   </td>
                   <td colspan="2">
	                 <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">
	               </td>
                   <td >
                   <label>MaturityDate:</label>
                   </td>
                   <td colspan="2">
	                 <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">
	               </td>
	      
               </tr>
               <tr>
                <td width="60px">
                   <label>I Buy USD:</label>
                 </td>
                 <td colspan="2">
	                               <input id="TRADENO" name="TRADENO" type="text"  style="width: 155px;">
	              </td>
	             <td >
	              <label>I Buy USD:</label>
                 </td>
                 <td colspan="2">
	                  <input id="TRADENO" name="TRADENO" type="text"  style="width: 155px;">
	              
	              </td>
               </tr>
               <tr>
                   <td width="60px">
                   <label>I Sell USD:</label>
                 </td>
                 <td colspan="2">
	                               <input id="TRADENO" name="TRADENO" type="text"  style="width: 155px;">
	              </td>
	             <td >
	              <label>I Sell USD:</label>
                 </td>
                 <td colspan="2">
	                  <input id="TRADENO" name="TRADENO" type="text"  style="width: 155px;">
	              
	              </td>
               </tr>
                 <tr>
                 <td colspan="5" align="center">
                <hr/>
                </td>
               </tr>

	           <tr>
	 
                <td>
	                     市场价
	              </td>
	              <td>
	                              <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">
	              
	              </td>
	               <td>
	                              <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">
	              </td>
	               <td>
	                              <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">
	              
	              </td>
	               <td>
	                              <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">
	              
	              </td>
	               <td>
	              </td>
	           </tr>
	          <tr>
	              <td>
	                        平盘汇率
	              </td>
	              <td>
	                              <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">
	              
	              </td>
	               <td>
	                              <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">
	              
	              </td>
	               <td>
	                              <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">
	              
	              </td>
	               <td>
	                              <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">
	              
	              </td>
	               <td>
	              </td>
	          </tr>
	          <tr>
	              <td>
	                        客户汇率
	              </td>
	              <td>
	                              <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">
	              
	              </td>
	               <td>
	                              <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">
	              
	              </td>
	               <td>
	                              <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">
	              
	              </td>
	               <td>
	                              <input id="TRADENO" name="TRADENO" type="text"  style="width: 95px;">
	              
	              </td>
	               <td>
	              </td>
	          </tr>
	           </tbody>
	           </table>
            </div>
            </div>
            </div>
	</div>
</center>
</body>
</html>
