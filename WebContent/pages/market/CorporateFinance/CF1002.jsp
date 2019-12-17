
<%
	String Currency = (String) request.getParameter("Currency");
%>

<div style="position:relative">

<a href="javascript:void(0);" onclick="doDeal('<%=Currency%>','spot','sell')">
	<div style="position:absolute ; top:15px; left:15px;">
		<div id="<%=Currency%>-L-D" style="position:absolute ;left:6px;"></div>
		<div id="<%=Currency%>-L-S" style="float:left;font-size:10px;margin-top:8px;">0.00</div>
		<div id="<%=Currency%>-L-B" style="float:right;font-size:35px;font-weight:bold;">00</div>
	</div>
</a>

<div style="padding-left:79px;padding-top:15px;float:left;">|</div>

<a href="javascript:void(0);" onclick="doDeal('<%=Currency%>','spot','buy')">
	<div style="position:absolute ; top:15px; left:85px;">
		<div id="<%=Currency%>-R-D" style="position:absolute ;left:6px;"></div>
		<div id="<%=Currency%>-R-S" style="float:left;font-size:10px;margin-top:8px;">0.00</div>
		<div id="<%=Currency%>-R-B" style="float:right;font-size:35px;font-weight:bold;">00</div>
	</div>
</a>

</div>	

