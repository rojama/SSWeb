<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/header.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>F0002</title>

<script type="text/javascript">

var sqbh ="${param.sqbh}";
var ProcessBO ="com.app.sys.CommonBO";
var ProcessMETHOD = "common";

var $form;
var $subgrid;
var $btn;
var qcode;
var groupicon = "../../js/ligerUI/skins/icons/communication.gif";

$(function(){
	$("#mainlayout").ligerLayout();
	PageLoader.initForm();
	PageLoader.initLigerGrid();
	PageLoader.initData();
	PageLoader.initSubData();
});

PageLoader = {

	initForm:function()
	{
		$form = $("#mainform").ligerForm({ 
	    	inputWidth: 200, labelWidth: 100, space:50, validate:true, align: 'center',width: '98%',
	    	fields:[	//主表的表单栏位定义
	    	    { display: "申请单号",name:"sqbh",type:"text",validate:{required:true}, group: "基础信息",groupicon: groupicon},
	    		{ display: "申请日期",name:"sqrq",type:"date",validate:{required:true}},
	    		{ display: "出差范围",name:"ccfw",type:"select",newline: false,validate:{required:true},
		    		editor: {
						data:[{id:'1',text:'是'},{id:'2',text:'否'}],
						value:'2'
					}
	    		},
	    		{ display: "出差起始日期",name:"ccqsrq",type:"date",validate:{required:true},},
	    		{ display: "申请人",name:"sqr",type:"text",newline: false,validate:{required:true}} , 
	    		{ display: "出差地点",name:"ccdd",type:"text",validate:{required:true},editor:{onBlur:code}},
	    		{ display: "出差结束日期",name:"ccjsrq",type:"date",newline: false,validate:{required:true}},
	    		{ display: "费用归属部门",name:"fyjsbm",type:"text",validate:{required:true}},
	    		{ display: "推荐宾馆",name:"tjbg",type:"text",newline: false,validate:{required:false}},
	    		{ display: "总计天数",name:"zjts",type:"int",validate:{required:true}},
	    		{ display: "出差人员名单",name:"ccrymd",type:"text",validate:{required:true}},
	    		{ display: "人数",name:"rs",type:"int",newline: false,validate:{required:true}},
	    		{ display: "工作任务计划",name:"gzrwjh",type:"textarea",width:320,validate:{required:true}, group: "任务计划",groupicon: groupicon},
	    		{ display: "二维码",name:"ewm",type:"textarea",newline: false,width:80,validate:{required:true}},
	    		{ display: "计划达成目标",name:"jhdcmb",type:"textarea",width:550,validate:{required:true}}
	    	]
	    });
	},
	initLigerGrid:function()
	{
		$subgrid = $("#subgrid").ligerGrid({
	        height:'99%',width: '660',
	        columns: [  //子表的标题栏位定义
	            { display: '费用类别', name: 'fylb', align: 'left', width: 150 ,editor: { type: 'text' } },
	            { display: '金额', name: 'je', width: 300 ,editor: { type: 'number' },
	            	render: function(item)
	                {
	                    return formatCurrency(item.je) + "元";
	                }
		            ,
		            totalSummary:
		            {
		                render: function (suminf, column, cell)
		                {
		                    return '合计：'+formatCurrency(suminf.sum) + "元";
		                }
		            }
	            },
	            
	        ], usePager: false ,rownumbers:true, enabledEdit: true, isScroll: false
	       
	        
	    });
	},
	initData:function()
	{
		var param = "ProcessBO="+ProcessBO;
		    param += "&ProcessMETHOD="+ProcessMETHOD;
		    param += "&TABLE=clbx_ccjhs&sqbh="+sqbh;
		    param += "&ACTION=select";
		    
		var tableData = ajax(param);

		$form.set("data",tableData.Rows[0]);
		
		console.log(tableData);
		
				    
	},
	initSubData:function()
	{
		var param = "ProcessBO="+ProcessBO;
	    param += "&ProcessMETHOD="+ProcessMETHOD;
	    param += "&TABLE=clbx_ccjhs_sub&sqbh="+sqbh;
	    param += "&ACTION=select";
	    
		var tableSubData = ajax(param);

		$subgrid.set({ data: tableSubData });
	}	
}

function formatCurrency(num)
{
    if (!num) return "0.00";
    num = num.toString().replace(/\$|\,/g, '');
    if (isNaN(num))
        num = "0.00";
    sign = (num == (num = Math.abs(num)));
    num = Math.floor(num * 100 + 0.50000000001);
    cents = num % 100;
    num = Math.floor(num / 100).toString();
    if (cents < 10)
        cents = "0" + cents;
    for (var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++)
        num = num.substring(0, num.length - (4 * i + 3)) + ',' +
		num.substring(num.length - (4 * i + 3));
    return (((sign) ? '' : '-') + '' + num + '.' + cents);
}

function ajax(param)
{
	var rtnData = "";
	
	$.ajax({
		type:'POST',
		url:'${pageContext.request.contextPath}/cm',
		cache:false,
		dataType:'json',
		data:param,
		async:false,
		success:function(result)
	    {
			rtnData = result;
	    }
	});	

	return rtnData;
}

</script>

</head>
<body>
<div class="l-loading" id="pageloading"></div>	
<div id="mainlayout">
	
	<div id="maingrid" position="center" title="">
		<form id="mainform" class="table table-bordered"></form>	
		<form id="Fileupload" style="display:none;">
			<table>
				<tr><td><input type="file" id="upload" /></td></tr>
			</table>
		</form>
		<div id="code"></div> 
		<div id="subgrid"></div>
		<br>
		<div id="btn"></div>
		
	</div>
</div>
	
</body>
</html>