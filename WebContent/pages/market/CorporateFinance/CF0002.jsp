
<%
	String Currency = (String) request.getParameter("Currency");
%>

<div style="position:relative">
<div style="position:absolute ; top:0px; left:0px;"><a href="javascript:void(0);" onclick="changePrice('<%=Currency%>','left-up')"><i class="fa fa-chevron-up"></i></a></div>
<div style="position:absolute ; top:40px; left:0px;"><a href="javascript:void(0);" onclick="changePrice('<%=Currency%>','left-down')"><i class="fa fa-chevron-down"></i></a></div>
<div style="position:absolute ; top:0px; left:150px;"><a href="javascript:void(0);" onclick="changePrice('<%=Currency%>','right-up')"><i class="fa fa-chevron-up"></i></a></div>
<div style="position:absolute ; top:40px; left:150px;"><a href="javascript:void(0);" onclick="changePrice('<%=Currency%>','right-down')"><i class="fa fa-chevron-down"></i></a></div>
<div style="position:absolute ; top:50px; left:60px;"><a href="javascript:void(0);" onclick="changePrice('<%=Currency%>','left')"><i class="fa fa-chevron-left"></i></a></div>
<div style="position:absolute ; top:50px; left:100px;"><a href="javascript:void(0);" onclick="changePrice('<%=Currency%>','right')"><i class="fa fa-chevron-right"></i></a></div>


<div style="position:absolute ; top:15px; left:15px;">
	<div id="<%=Currency%>-L-D" style="position:absolute ;left:6px;"></div>
	<div id="<%=Currency%>-L-S" style="float:left;font-size:10px;margin-top:8px;">0.00</div>
	<div id="<%=Currency%>-L-B" style="float:right;font-size:35px;font-weight:bold;">00</div>
</div>

<div style="padding-left:79px;padding-top:15px;float:left;">|</div>

<div style="position:absolute ; top:15px; left:85px;">
	<div id="<%=Currency%>-R-D" style="position:absolute ;left:6px;"></div>
	<div id="<%=Currency%>-R-S" style="float:left;font-size:10px;margin-top:8px;">0.00</div>
	<div id="<%=Currency%>-R-B" style="float:right;font-size:35px;font-weight:bold;">00</div>
</div>

<div style="position:absolute ; top:15px; left:180px;">
	<div id="<%=Currency%>-RL-D" style="position:absolute ;left:6px;"></div>
	<div id="<%=Currency%>-RL-S" style="float:left;margin-top:8px;">0.00</div>
	<div id="<%=Currency%>-RL-B" style="float:right;margin-top:5px;font-size:20px;font-weight:bold;">00</div>
</div>

<div style="padding-left:226px;padding-top:15px;">|</div>

<div style="position:absolute ; top:15px; left:230px;">
	<div id="<%=Currency%>-RR-D" style="position:absolute ;left:6px;"></div>
	<div id="<%=Currency%>-RR-S" style="float:left;margin-top:8px;">0.00</div>
	<div id="<%=Currency%>-RR-B" style="float:right;margin-top:5px;font-size:20px;font-weight:bold;">00</div>
</div>
<div id="<%=Currency%>-RA" style="float:right;padding-right:30px;padding-top:10px;">CMDS</div>


<div id="<%=Currency%>-C" style="position:absolute ; top:80px; left:0px;"><a href="#chevron-up"><i class="fa fa-play"></i></a></div>
<div id="<%=Currency%>-AQ" style="position:absolute ; top:76px; left:20px;"><input type="checkbox"/>Auto Quote</div>
<div style="position:absolute ; top:76px; left:110px;">
<input name="<%=Currency%>-RA" type="radio" checked/>Norm
<input name="<%=Currency%>-RA" type="radio"/>Vol
<input name="<%=Currency%>-RA" type="radio"/>H Vol
</div>

</div>	

