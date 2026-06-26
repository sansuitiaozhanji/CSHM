<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>公告详情</title></head>
<body>
    <h2>${ann.title}</h2>
    <p>发布时间：${ann.publishTime}</p>
    <p>内容：${ann.content}</p>
    <a href="${pageContext.request.contextPath}/announcement/list">返回列表</a>
</body>
</html>