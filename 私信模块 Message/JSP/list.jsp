<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>我的私信</title></head>
<body>
    <h2>私信列表</h2>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>发件人ID</th>
            <th>消息预览</th>
            <th>状态</th>
            <th>时间</th>
            <th>操作</th>
        </tr>
        <c:forEach items="${msgList}" var="m">
            <tr>
                <td>${m.id}</td>
                <td>${m.senderId}</td>
                <td>${m.content}</td>
                <td>${m.isRead == 0 ? "未读" : "已读"}</td>
                <td>${m.createTime}</td>
                <td><a href="${pageContext.request.contextPath}/message/detail?id=${m.id}">查看</a></td>
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