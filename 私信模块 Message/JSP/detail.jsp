<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>私信详情</title></head>
<body>
    <h3>私信详情</h3>
    <p>发件人ID：${msg.senderId}</p>
    <p>发送时间：${msg.createTime}</p>
    <p>消息内容：${msg.content}</p>
    <a href="${pageContext.request.contextPath}/message/list">返回私信列表</a>
</body>
</html>