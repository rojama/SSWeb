<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/commonhead.jsp" %>
    <script type="text/javascript">
    		var data = [];
             
              data.push({ id: 1, pid: 0, text: '1' });
            data.push({ id: 2, pid: 1, text: '1.1' });
            data.push({ id: 4, pid: 2, text: '1.1.2' });
             data.push({ id: 5, pid: 2, text: '1.1.2' });      

            data.push({ id: 10, pid: 8, text: 'wefwfwfe' });
             data.push({ id: 11, pid: 8, text: 'wgegwgwg' });
            data.push({ id: 12, pid: 8, text: 'gwegwg' });

             data.push({ id: 6, pid: 2, text: '1.1.3', ischecked: true });
            data.push({ id: 7, pid: 2, text: '1.1.4' });
            data.push({ id: 8, pid: 7, text: '1.1.5' });
            data.push({ id: 9, pid: 7, text: '1.1.6' });
         
        $(function ()
        {
            var tree = $("#tree1").ligerTree({  
            data:data, 
             idFieldName :'id',
             slide : false,
             parentIDFieldName :'pid'
             });
             treeManager = $("#tree1").ligerGetTreeManager();
             treeManager.collapseAll();
           
        });
    </script>
</head>
<body style="padding:10px">   
    <div style="width:200px; height:300px; margin:10px; float:left; border:1px solid #ccc; overflow:auto;  ">
    <ul id="tree1"></ul>
    </div> 
 
        <div style="display:none">
     
    </div>
</body>
</html>
