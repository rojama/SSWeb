<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>证书查询</title>
    <%
        String processBO = "com.app.cert.CertCtrl";
        String processMETHOD = "main_query";
        String serverUrl = request.getContextPath() + "/cm?ProcessBO=" + processBO + "&ProcessMETHOD=" + processMETHOD;
    %>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.min.js"></script>
    <!-- import Vue.js -->
    <script src="//vuejs.org/js/vue.min.js"></script>
    <!-- import stylesheet -->
    <link rel="stylesheet" href="//unpkg.com/iview/dist/styles/iview.css">
    <!-- import iView -->
    <script src="//unpkg.com/iview/dist/iview.min.js"></script>
</head>
<body>
<div id="cert" style="padding:0.5cm">
    <i-input v-model="user_id" style="width:300px" placeholder="请输入证书编号" maxlength="20">
        <i-button slot="append" @click="query">查询证书</i-button>
    </i-input>
    <br>
    <Card style="width:600px">
        <div style="text-align:left">
            <h3>{{ message }}</h3>
            <img style="width:570px" v-bind:src="imagesrc">
        </div>
    </Card>

</div>


<script type="text/javascript">

    var app = new Vue({
        el: '#cert',
        data: {
            user_id: '',
            message: '',
            imagesrc: ''
        },
        methods: {
            query: function () {
                if (this.user_id == ''){
                    return;
                }
                this.message = '查询中...';
                this.imagesrc = '';
                var _self=this;
                $.ajax({
                    type:'POST',
                    url:'<%=serverUrl%>',
                    dataType:'json',
                    data:{USER_ID:this.user_id},
                    success:function(result)
                    {
                        if (result.ERR == null){
                            _self.message = "查询成功！";
                            _self.imagesrc = result.CERT_IMAGE;
                        }else{
                            _self.message = "查询失败！"+result.ERR;
                        }
                    }
                });
            }
        }
    })

</script>
</body>
</html>