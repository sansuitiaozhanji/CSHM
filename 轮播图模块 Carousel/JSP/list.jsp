<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>轮播图管理</title>
</head>
<body>
    <h3>轮播图列表</h3>
    <table border="1" cellpadding="5">
        <tr>
            <th>ID</th>
            <th>图片</th>
            <th>跳转链接</th>
            <th>排序</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        <c:forEach items="${carouselList}" var="item">
            <tr>
                <td>${item.id}</td>
                <td><img src="${item.imgUrl}" width="100"/></td>
                <td>${item.jumpUrl}</td>
                <td>${item.sortNum}</td>
                <td>${item.status == 1 ? "展示" : "下架"}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/home/carousel/detail?id=${item.id}">查看详情</a>
                </td>
            </tr>
        </c:forEach>
    </table>
    <div>
        <a href="${pageContext.request.contextPath}/home/carousel/list?pageNum=${pageNum-1}">上一页</a>
        <span>当前第${pageNum}页</span>
        <a href="${pageContext.request.contextPath}/home/carousel/list?pageNum=${pageNum+1}">下一页</a>
    </div>
</body>
</html>