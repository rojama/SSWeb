<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <style type="text/css">
	.l-text{
	  height:27px;
	}

	.l-text-date{
	 height:30px;
	}

}
	</style>
<div class="easyui-tabs" data-options="tabWidth:112" style="border:1px solid#7B7B7B;width:1150px;height:750px;">
			 <div id="currencyDiv" title="明细" style="padding:10px ">
				<div  style="height:30px;width:950px;"> 
				   <table>
					 <tbody>
						<tr>
						 <td>
						  <div id="BizType1">
								<input type="radio"  name="FXT_INSTRUMENT" value="1" onclick="changeBizAttr(this.value)" checked/><label>SPOT/FORWARD</label> 
								<input type="radio"  name="FXT_INSTRUMENT" value="2" onclick="changeBizAttr(this.value)"/><label>SWAP</label>
						 </div> 
						 </td>
						 <td>	&nbsp; &nbsp; &nbsp; &nbsp;<a href="#" onclick="doQuery()"><img alt="" src="${ctx}/images/icons/16x16/up.gif"><label>询价</label></a></td>
						</tr>
				 </tbody>
				 </table>
			</div>
					<div>
					       <div  class="div" id="lForm"  style="float:left;height:650px;width:300px;background:#F0F0F0;align:center">
					         <br>
				               <table>
						           <tbody>
						               <tr>
							                 <td>
							                    <label for="FXT_TRADEDATE">交易日：</label>
							                </td>
							                <td>
							                    <input id="FXT_TRADEDATE" name="FXT_TRADEDATE" type="text" class="ui-textbox" />
							                   <div style="display: none"> <input  name="FXT_DEALTCCY" type="text"  class="ui-textbox" /></div>
							                </td>
						                 </tr>
						               <tr>
							                 <td>
							                    <label>交易编号：</label>
							                </td>
							                <td>
							                    <input id="FX_TREFNO" name="FX_TREFNO" type="text" class="ui-textbox" style="height:25px"/>
							                </td>
						                 </tr>
						                 <tr>
							                 <td>
							                    <label for="FXT_TRADOR">询价行员：</label>
							                </td>
							                <td>
							                    <input  id="FXT_TRADOR" name="FXT_TRADOR" type="text" class="ui-textbox" style="height:25px"/>
							                </td>
						                </tr>
						                 <tr>
							                 <td>
							                    <label for="FXT_UNIT">营业机构：</label>
							                </td>
							                <td>
							                    <input  id="FXT_UNIT" name="FXT_UNIT" type="text" class="ui-textbox" style="height:25px"/>
							                </td>
						                </tr>
						                 <tr>
							                 <td>
							                    <label for="PRICER">报价行员：</label>
							                </td>
							                <td>
							                    <input  id="PRICER" name="PRICER" type="text" class="ui-textbox" style="height:25px"/>
							                </td>
						                </tr>
						                 <tr>
							                 <td>
							                    <label> 交易目的:</label> 
							                </td>
							                <td>
                                             <div id="FXT_TRADEPURPOSE"></div>
							                </td>
						                </tr>
						                <tr>
							                <td>
							                    <label> 交易对象:</label> 
							                </td>
							                <td>
                                             <div id="FXT_TRADETARGET"></div>
							                </td>
						                </tr>
						                <tr>
							                <td>
							                    <label> 交易类型:</label> 
							                </td>
							                <td>
                                             <div id="FXT_TRADEMODE"></div>
							                </td>
						                </tr>
						                <tr>
							                <td>
							                    <label> 客户号:</label> 
							                </td>
							                <td>
							                    <input type="text" id="FXT_CUSTOMERID"/> 
							                </td>
						                </tr>
						                <tr>
							                <td>
							                    <label> 核心客户编号:</label> 
							                </td>
							                <td>
							                    <input  id="FXT_CORECUSTOMERID" name="FXT_CORECUSTOMERID" type="text" class="ui-textbox" style="height:25px"/>
							                </td>
						                </tr>
						               <tr>
							                <td colspan="2">
							                <div class="l-text" style="width:260px;">
			                               <input name="FXT_CUSTOMERCN" type="text" id="FXT_CUSTOMERCN"  class="l-text-field"  style="height:25px;width: 250px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>
							                </td>
						                </tr>
						                <tr>
							                <td>
							                    <label> 外币账号:</label> 
							                </td>
							                <td>
							                      <input type="text" id="FXT_BASEACCOUNT"/> 
							                </td>
						                </tr>
						                <tr>
							                <td>
							                    <label> 人民币账号:</label> 
							                </td>
							                <td>
							                     <input type="text" id="FXT_TERMACCOUNT" style="width:174;height:25px"/> 
							                </td>
						                </tr>
						                 <tr>
							                <td>
							                    <label> 客户优惠:</label> 
							                </td>
							                <td>
							                    <input  id="CLIENTID" name="CLIENTID" type="text" class="ui-textbox" style="height:25px"/>
							                </td>
						                </tr>
						                <tr>
							                <td>
							                    <label> 优惠后利润点:</label> 
							                </td>
							                <td>
							                    <input  id="CLIENTID" name="CLIENTID" type="text" class="ui-textbox" style="height:25px"/>
							                </td>
						                </tr>
						           </tbody>
					           </table>
				            </div>
				               <div  style="float:left;width:10px;height:650px;">
              </div>
              <div class="div" id="cForm" style="float:left;height:650px;width:800px">
                 <table align="center">
	               <tbody>
		               <tr>
			                 <td colspan="8" align="center" style="height:1px;">
			                  <hr/>
			                </td>
		               </tr>
		               <tr>
			               <td colspan="8" align="center" >
			               <label id="showTitle"></label>
			               </td>
		               </tr>
		               <tr>
			                 <td colspan="8" align="center" style="height:1px;">
			                  <hr/>
			                </td>
		               </tr>
		               <tr>
			                <td  valign="top" width="80px"> <label>Type:</label></td>
				            <td align="left" colspan="7">
			                       <div id="d1">
								        <input type="radio" value="BUY" name="FXT_BUYORSELL_CUS" checked onclick="changeBuyOrSell(this.value)"/><label>I BUY&nbsp;</label>
								        <input type="radio" value="SELL" name="FXT_BUYORSELL_CUS" onclick="changeBuyOrSell(this.value)"/><label>I Sell&nbsp;</label>
								   </div> 
			                </td> 
		               </tr> 
  						<tr>
			                <td width="80px">
			                  <label>I BUY&nbsp;</label><label id="buy1"></label>:
			                </td>
			                <td colspan="3">
									  <input  id="FXT_SWAPTRADEMARKRATE" name="FXT_SWAPTRADEMARKRATE" type="text" onkeyup = "changeBDealAmount(this.value)" class="ui-textbox" style="height:25px"/>
				            </td>
				            <td >
				             <label>I BUY&nbsp;</label><label id="buy2"></label>:
			                </td>
			                <td colspan="3">
									  <input  id="FXT_FORWARDNETCASHFLOW" name="FXT_FORWARDNETCASHFLOW" type="text" class="ui-textbox" style="height:25px"/>
				            </td>
		               </tr>
		               <tr>
		                   <td width="80px">
		                   <label>I Sell&nbsp;</label><label id="sell1"></label>:
		                 </td>
		                 <td colspan="3">
								<input  id="FXT_SWAPNOTIONALAMT" name="FXT_SWAPNOTIONALAMT" type="text" class="ui-textbox" style="height:25px"/>
			              </td>
			             <td >
			             <label>I Sell&nbsp;</label><label  id="sell2"></label>:
		                 </td>
		                 <td colspan="3">
							 <input  id="FXT_SWAPNETCASHFLOW" name="FXT_SWAPNETCASHFLOW" type="text" class="ui-textbox" style="height:25px"/>
			             </td>
		               </tr>
		               <tr>
		                   <td width="80px">
		                   <label>近端日期:</label>
		                   </td>
		                   <td>
		                    <div id="FXT_VALUEDATETYPE" style="float:left"></div>
			               </td>
			                  <td style="width:10px">
			               		 <input  id="FXT_TERMDAYS" type="text" size="4"/>
			                 </td>
			                 <td> 
						      <input type="text" id="FXT_VALUEDATE" /> 			              
						     </td>
			            
			     
		                   <td width="80px">
		                   <label>远端日期:</label>
		                   </td>
		                    <td>
		                    <div id="FXT_SWAPVALUEDATETYPE"></div>
			               </td>
			               <td style="width:10px">
			               		 <input  id="FXT_SWAPTERMDAYS" type="text" size="4"/>
			               </td>
			                <td> 
						      <input type="text" id="FXT_SWAPVALUEDATE" /> 			              
						  </td>
			              
		                </tr>
						</tbody>
					</table>
		           <table align="center">
	                   <tbody>
		               <tr>
		                 <td colspan="8" align="center">
		                 <hr/>
		                 </td>
		              </tr>
		              <tr id="JBuyTitle1"><td width="80px" ></td><td></td><td align="right">Bid</td><td style="width:5px"></td><td align="right">Ask</td><td align="right">Points</td>  <td style="width:5px"></td><td></td></tr>
		              <tr id="JSellTitle1"><td width="80px" ></td><td colspan="3"></td><td align="right">Point</td><td align="right">Bid</td><td style="width:5px"></td><td align="right">Ask</td>  <td style="width:5px"></td><td></td></tr>
			          <tr id="buyMarket1">
			            <td rowspan="3" align="left"><label>近端</label></td>
			             <td>
			                  <label> 市场价</label>
			            </td>
      					  <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="txtName" type="text" id="txtName"   class="l-text-field" style="height:25px;width: 118px;">
			                               <div class="l-text-l"></div> 
			                               <div class="l-text-r"></div></div>			              
			              </td>
			              <td style="width:5px">/</td>
      					 <td>
			                            <div class="l-text" style="width:120px;">
			                               <input name="BFXT_TRADEMARKRATE" type="text" id="BFXT_TRADEMARKRATE"   class="l-text-field" style="height:25px;width: 110px;"   ligeruiid="BFXT_TRADEMARKRATE"  >
			                            <div class="l-text-l"></div> 
			                            <div class="l-text-r"></div></div>
			              </td>
      			
		               
			         </tr>
			         <tr id="buyMarket2">
			              <td>
			                  <label> 平盘汇率</label>
			              </td>
			              <td>
			                               <div class="l-text" style="width:120px;">
			                               <input name="txtName" type="text" id="txtName"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>
			              
			              </td>
			              <td style="width:5px">/</td>
			               <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="BFXT_DEALTCOSTRATE" type="text" id="BFXT_DEALTCOSTRATE"  ligeruiid="BFXT_DEALTCOSTRATE" class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="BFXT_COSTPOINT" type="text" id="BFXT_COSTPOINT"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
	
			         </tr>
			         <tr id="buyMarket3">
			       
			              <td>
			                        <label>客户汇率</label>
			              </td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="txtName" type="text" id="txtName"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			               <td style="width:5px">/</td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="BFXT_DEALTDEALDOWNRATE" type="text" id="BFXT_DEALTDEALDOWNRATE"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="BFXT_DEALPOINT" type="text" id="BFXT_DEALPOINT"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			                <td style="width:5px"></td>
      					  <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="BFXT_DEALAFAVOURPOINT" type="text" id="BFXT_DEALAFAVOURPOINT"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			         </tr>
			           <tr id="sellMarket1">
			            <td rowspan="3" align="left"><label>近端</label></td>
			             <td>
			                  <label> 市场价</label>
			            </td>
      					  <td>
			              </td>
			              <td style="width:5px"></td>
      					 <td>
			              </td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="SFXT_TRADEMARKRATE" type="text" id="SFXT_TRADEMARKRATE"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			              <td style="width:10px">/</td>
      					  <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="txtName" type="text" id="txtName"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
		               
			         </tr>
			         <tr id="sellMarket2">
			              <td>
			                  <label> 平盘汇率</label>
			              </td>
			              <td>
			              </td>
			              <td style="width:5px"></td>
			               <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="SFXT_COSTPOINT" type="text" id="SFXT_COSTPOINT"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="SFXT_DEALTCOSTRATE" type="text" id="SFXT_DEALTCOSTRATE"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			               <td style="width:5px">/</td>
      					  <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="txtName" type="text" id="txtName"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			         </tr>
			         <tr id="sellMarket3">
			              <td>
			                        <label>客户汇率</label>
			              </td>
      					 <td>
 								<div class="l-text" style="width:120px;">
			                               <input name="SFXT_DEALAFAVOURPOINT" type="text" id="SFXT_DEALAFAVOURPOINT"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			               <td style="width:5px"></td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="SFXT_DEALPOINT" type="text" id="SFXT_DEALPOINT"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="SFXT_DEALTDEALDOWNRATE" type="text" id="SFXT_DEALTDEALDOWNRATE"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			                <td style="width:5px">/</td>
      					  <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="txtName" type="text" id="txtName"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			         </tr>
			         <tr></tr>
			         <tr>
			                 <td colspan="8" align="center" style="height:1px;">
			                  <hr/>
			                </td>
		              </tr>
		              <tr id="FBuyTitle1"><td width="80px"></td><td colspan="1"></td><td align="right">Points</td><td style="width:5px"></td><td align="right">Bid</td><td align="right">Ask</td></tr>
		              <tr id="FSellTitle1"><td width="80px" ></td><td></td><td align="right">Bid</td><td style="width:5px"></td><td align="right">Ask</td><td align="right">Points</td>  </tr>
			          
			          <tr id="buyRemittance1">
			           <td rowspan="2" align="left"><label>远端</label></td>
			              <td>
			                  <label> 平盘汇率</label>
			              </td>
			              <td>
			              </td>
			                <td style="width:5px"></td>
			               <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="BFXT_SWAPCOSTPOINT" type="text" id="BFXT_SWAPCOSTPOINT"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="BFXT_SWAPCOSTRATE" type="text" id="BFXT_SWAPCOSTRATE"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			                <td style="width:5px">/</td>
      					  <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="txtName" type="text" id="txtName"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			         </tr>
			         <tr id="sellRemittance1">
			           <td rowspan="2" align="left"><label>远端</label></td>
			              <td>
			                  <label> 平盘汇率</label>
			              </td>
			              <td>
			                               <div class="l-text" style="width:120px;">
			                               <input name="txtName" type="text" id="txtName"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>
			              
			              </td>
			                <td style="width:5px">/</td>
			               <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="SFXT_SWAPCOSTRATE" type="text" id="SFXT_SWAPCOSTRATE"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="SFXT_SWAPCOSTPOINT" type="text" id="SFXT_SWAPCOSTPOINT"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			                <td style="width:5px"></td>
      					  <td>
 								              
			              </td>
			         </tr>
			         <tr id="buyRemittance2">
			              <td>
			                        <label>客户汇率</label>
			              </td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="BFXT_SWAPDEALFAVOURPOINT" type="text" id="BFXT_SWAPDEALFAVOURPOINT"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			                 <td style="width:5px"></td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="BFXT_SWAPDEALPOINT" type="text" id="BFXT_SWAPDEALPOINT"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="BFXT_SWAPDEALDOWNRATE" type="text" id="BFXT_SWAPDEALDOWNRATE"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			                <td style="width:5px">/</td>
      					  <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="txtName" type="text" id="txtName"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			         </tr>
			          <tr id="sellRemittance2">
			              <td>
			                        <label>客户汇率</label>
			              </td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="txtName" type="text" id="txtName"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			                 <td style="width:5px">/</td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="SFXT_SWAPDEALDOWNRATE" type="text" id="SFXT_SWAPDEALDOWNRATE"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
      					 <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="SFXT_SWAPDEALPOINT" type="text" id="SFXT_SWAPDEALPOINT"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			                <td style="width:5px"></td>
      					  <td>
 										<div class="l-text" style="width:120px;">
			                               <input name="SFXT_SWAPDEALFAVOURPOINT" type="text" id="SFXT_SWAPDEALFAVOURPOINT"  class="l-text-field"  style="height:25px;width: 110px;">
			                               <div class="l-text-l"></div>
			                               <div class="l-text-r"></div></div>			              
			              </td>
			         </tr>
	           </tbody>
	            </table>
              </div>
            </div>
          </div>
	</div>