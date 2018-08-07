<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>证书维护</title>

	<%
		String processBO = "com.app.cert.CertCtrl";
		String processMETHOD = "main";
		String serverUrl = request.getContextPath()+"/cm?ProcessBO="+processBO+"&ProcessMETHOD="+processMETHOD;
	%>

	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/default/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/icon.css"/>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/plugins/jquery.edatagrid.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/iscroll-zoom.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.photoClip.js"></script>
	<script src="${pageContext.request.contextPath}/js/common/ImagePreview.js" type="text/javascript"></script>

</head>
<body>
<table id="dg" title="学员信息" style="width:100%;height:500px"
		toolbar="#toolbar" idField="USER_ID" pagination="true"
		rownumbers="true" fitColumns="true" singleSelect="true">
	<thead>
		<tr>
			<th field="USER_ID" width="100" editor="{type:'validatebox',options:{required:true}}">证书编号</th>
			<th field="USER_NAME" width="80" editor="{type:'validatebox',options:{required:true}}">姓名</th>
			<th field="USER_SEX" width="60" editor="{type:'combobox',options:{required:true, data: [
				{text: '男', value: '男', selected: true},
				{text: '女',	value: '女'}
				]}}">性别</th>
			<th field="USER_AGE" width="60" editor="{type:'numberbox',options:{required:true, min:1,max:100}}">年龄</th>
			<th field="CERT_LEVEL" width="80" editor="{type:'combobox',options:{required:true, data: [
				{text: '一级', value: '一级', selected: true},
				{text: '二级', value: '二级'}
				]}}">级别</th>
			<th field="CERT_START" width="80" editor="{type:'combobox',options:{required:true, data: [
				{text: '五星', value: '五星', selected: true},
				{text: '四星', value: '四星'},
				{text: '三星', value: '三星'}
				]}}">星级</th>
			<th field="USER_IMAGE" width="150" editor="{type:'filebox',options:{required:true}}" formatter="imageFormatter">照片</th>
		</tr>
	</thead>
</table>
<div id="toolbar">
	<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="javascript:$('#dg').edatagrid('addRow')">新增</a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="javascript:$('#dg').edatagrid('destroyRow')">删除</a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-save" plain="true" onclick="javascript:$('#dg').edatagrid('saveRow')">保存</a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="javascript:$('#dg').edatagrid('cancelRow')">撤销</a>
</div>


<div id="Imgview" class="easyui-window" title="照片预览" style="width:300px;height:400px;"
	 data-options="modal:true">
	<img id="imgBig" src=""/>
</div>

<script type="text/javascript">

	function imageFormatter(value,row,index){
		return "<img src='"+value+"' onclick=\"bigImg(this,'"+row.USER_NAME+"')\" width='150' height='20'/>";
	}

	//打开大的图片
    function bigImg(imgObj, title){
       	$("#imgBig")[0].src = imgObj.src;
        $('#Imgview').window('open');
   	}

    function getBase64Image(img) {
        var canvas = document.createElement("canvas");
        canvas.width = img.width;
        canvas.height = img.height;

        var ctx = canvas.getContext("2d");
        ctx.drawImage(img, 0, 0, img.width, img.height);

        var dataURL = canvas.toDataURL("image/png");
        return dataURL
    }

	$(function() {
        $('#Imgview').window('close');

        $.extend($.fn.datagrid.defaults.editors, {
			filebox : {
				init : function(container, options) {
				    var uploadid = "upload" + new Date().getTime();
				    var imgid = "img" + new Date().getTime();
					$("<div><table><tr><td><input type='file' id='"+uploadid+
						"' /></td></tr><tr><td><img id='"+imgid+
						"'/></td></tr></table></div>").appendTo(container);
                    $("#"+uploadid).uploadPreview({ Img: imgid, Width: 50, Height: 50});
                    return $("#"+imgid)[0];
				},

				getValue : function(target) {
					return getBase64Image(target);
				},
				setValue : function(target, value) {
                    target.src = value
                    $('#dg').edatagrid('fixRowHeight');
				},
				resize : function(target, width) {
                    $(target).css("width", width)
				}

			}
		});

		$('#dg').edatagrid({
			url : '<%=serverUrl%>_get',
			saveUrl: '<%=serverUrl%>_save',
			updateUrl: '<%=serverUrl%>_update',
			destroyUrl: '<%=serverUrl%>_destroy',
			autoSave: true,
			destroyMsg:{
				norecord:{	// when no record is selected
					title:'警告',
					msg:'没有选中一条记录！'
				},
				confirm:{	// when select a row
					title:'确认',
					msg:'你确认要删除这条记录吗？'
				}
			}
		});

	});


</script>
</body>
</html>