
<%
	String urls = (String) request.getParameter("hrefs");
	if (urls.startsWith(";")) {
		urls = urls.substring(1);
	}
	String[] hrefs = urls.split(";");
	System.out.println(urls);
	for (String href : hrefs) {
		if (href.trim().isEmpty())
			continue;
%>
<iframe src="<%=href%>" width="100%" height="100%" frameborder="no" 
		 border="0" marginwidth="0"
		marginheight="0" scrolling="no" onload="iframeAutoFit(this)"></iframe>

<%
	}
%>