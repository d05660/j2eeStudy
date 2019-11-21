<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="utf-8"></meta>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"></meta>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"></meta>
    <meta name="renderer" content="webkit" />
    <link rel="icon" href="<%=basePath%>static/favicon.ico" type="image/x-icon" />
    <title>部门管理</title>
    <link rel="stylesheet" href="<%=basePath%>webjars/layui/css/layui.css" />
    <link rel="stylesheet" href="<%=basePath%>webjars/font-awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="<%=basePath%>static/css/zadmin.css">
    <link rel="stylesheet" href="<%=basePath%>static/css/common.css">
    <link rel="stylesheet" href="<%=basePath%>static/css/animate.min.css">
</head>
<body class="animated fadeIn timo-layout-page">
    <div class="page-loading">
        <div class="rubik-loader"></div>
    </div>
    <div class="animated fadeIn layui-card">
        <div class="layui-card-header timo-card-header">
            <span><i class="fa fa-bars"></i> 部门管理</span>
            <i class="layui-icon layui-icon-refresh refresh-btn"></i>
        </div>
        <div class="layui-card-body">
            <div class="layui-row timo-card-screen put-row">
                <div class="pull-right screen-btn-group">
                    <div class="btn-group-left">
                        <button class="layui-btn open-popup" id="add_btn">
                            <i class="fa fa-plus"></i> 添加
                        </button>
                        <button class="layui-btn open-popup" data-type="getCheckData" id="del_btn">
                            <i class="fa fa-trash"></i> 删除
                        </button>
                    </div>
                </div>
            </div>
            <div class="timo-table-wrap">
                <table class="layui-hide timo-table" id="dept-table" lay-filter="allAttr"></table>
            </div>
        </div>
    </div>

    <script type="text/html" id="column-toolbar">
        <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
        <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">删除</a>
    </script>

    <script src="<%=basePath%>webjars/jquery/jquery.min.js"></script>
    <script src="<%=basePath%>webjars/layui/layui.all.js"></script>
    <script src="<%=basePath%>static/js/zadmin.js"></script>
    <script src="<%=basePath%>static/js/common.js"></script>

    <script>
    layui.config({
        base : '<%=basePath%>static/js/'
    }).use([ 'jquery', 'layer', 'table', 'element' ], function() {
        var layer = layui.layer
        , table = layui.table;
        table.render({
            elem : '#dept-table'
            , url : '<%=basePath%>api/department/list'
            , cellMinWidth : 80
            , page : true
            , id : 'deptTable'
            , limits : [ 10, 20, 50 ]
            , cols : [ [ 
                { checkbox : true }
                , { field : 'id', title : 'ID', hide : true }
                , { field : 'name', title : '名称' }
                , { field : 'description', title : '描述' }
                , { title : '操作', align : 'center', toolbar : '#column-toolbar' } ]
            ]
        });
        $("#add_btn").on("click", function() {
            layer.open({
                content : "<%=basePath%>departmentChange",
                title : "新增部门",
                area : [ '500px', '260px' ],
                type : 2,
                maxmin : true,
                shadeClose : true,
                end : function() {
                    table.reload('deptTable');
                }
            });
            return false;
        });
        $("#del_btn").on("click", function() {
            var checkStatus = table.checkStatus('deptTable')
            , checkData = checkStatus.data;
            if (checkData.length === 0) {
                return layer.msg('请选择数据');
            }
            layer.confirm('确定删除吗?', function(index) {
                var reqBody = checkData.reduce(function(acc, cur) {
                    acc.push(cur.id);
                    return acc;
                }, []);
                ajaxJsonRequest("POST", '<%=basePath%>api/department/delete', JSON.stringify(reqBody), function(data) {
                    layer.close(index);
                    handlerResult(data, function() {
                        parent.layer.msg("删除成功", {icon: 6});
                        table.reload('deptTable');
                    });
                });
            });
            return false;
        });
        table.on('tool', function(obj) {
            var data = obj.data;
            var event = obj.event;
            if (event === 'edit') {
                layer.open({
                    content : '<%=basePath%>departmentChange/' + data.id,
                    title : "编辑",
                    area : [ '500px', '260px' ],
                    type : 2,
                    maxmin : true,
                    shadeClose : true,
                    end : function() {
                        table.reload('deptTable');
                    }
                });
            } else if (event === 'del') {
                layer.confirm("你确定删除数据吗？", {
                    icon : 3,
                    title : '提示'
                }, function(index) {
                    var id = obj.data.id;
                    ajaxJsonRequest("DELETE", '<%=basePath%>api/department/' + data.id, null, function(data) {
                        layer.close(index);
                        handlerResult(data, function() {
                            parent.layer.msg("删除成功", {icon: 6});
                            table.reload('deptTable');
                        });
                    });
                }, function(index) {
                    layer.close(index);
                });
            }
        });
    });
    </script>
</body>
</html>