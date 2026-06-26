<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>公告列表</title></head>
<body>
    <h2>公告管理</h2>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>标题</th>
            <th>是否置顶</th>
            <th>发布时间</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        <c:forEach items="${annList}" var="a">
            <tr>
                <td>${a.id}</td>
                <td>${a.title}</td>
                <td>${a.isTop == 1 ? "置顶" : "普通"}</td>
                <td>${a.publishTime}</td>
                <td>${a.status ==1 ? "正常" : "下架"}</td>
                <td><a href="${pageContext.request.contextPath}/announcement/detail?id=${a.id}">查看</a></td>
            </tr>
        </c:forEach>
    </table>
    <div>
        <a href="list?pageNum=${pageNum-1}">上一页</a>
        当前${pageNum}页
        <a href="list?pageNum=${pageNum+1}">下一页</a>
    </div>
</body>
</html>