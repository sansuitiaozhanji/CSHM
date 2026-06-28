<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>

<style>
.chat-wrapper {
    display: flex;
    flex-direction: column;
    height: calc(100vh - 56px);
}
.chat-header {
    flex-shrink: 0;
    padding: 12px 20px;
    border-bottom: 1px solid #dee2e6;
    background: #fff;
}
.chat-messages {
    flex: 1;
    overflow-y: auto;
    padding: 16px 20px;
    background: #f5f6fa;
}
.chat-footer {
    flex-shrink: 0;
    padding: 12px 20px;
    border-top: 1px solid #dee2e6;
    background: #fff;
}
</style>

<div class="chat-wrapper">
    <div class="chat-header">
        <a href="/message" class="text-decoration-none me-3">
            <i class="bi bi-arrow-left"></i> 返回
        </a>
        <i class="bi bi-chat-square-text"></i>
    </div>

    <div class="chat-messages" id="messageArea">
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <c:if test="${empty messages}">
            <div class="text-center py-4 text-muted">
                <p>暂无消息，发送第一条消息吧</p>
            </div>
        </c:if>
        <c:forEach items="${messages}" var="msg">
            <div class="d-flex mb-3 ${msg.senderId == currentUserId ? 'justify-content-end' : ''}">
                <div style="max-width: 70%;">
                    <c:if test="${msg.senderId != currentUserId}">
                        <small class="text-muted">
                            <c:if test="${not empty msg.sender}">${msg.sender.name}</c:if>
                        </small>
                    </c:if>
                    <div class="p-2 rounded ${msg.senderId == currentUserId ? 'bg-primary text-white' : 'bg-white border'}">
                        ${msg.content}
                    </div>
                    <small class="text-muted d-block ${msg.senderId == currentUserId ? 'text-end' : ''}">
                        ${msg.createdAtStr}
                        <c:if test="${msg.senderId == currentUserId && msg.isRead == 1}">已读</c:if>
                    </small>
                </div>
            </div>
        </c:forEach>
    </div>

    <div class="chat-footer">
        <div class="input-group">
            <input type="text" class="form-control" id="msgInput" placeholder="输入消息..." maxlength="500" autofocus
                   onkeydown="if(event.key === 'Enter') sendMessage()">
            <button type="button" class="btn btn-primary" onclick="sendMessage()">
                <i class="bi bi-send"></i> 发送
            </button>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var area = document.getElementById('messageArea');
    area.scrollTop = area.scrollHeight;
});

var evtSource = new EventSource('/message/stream');
evtSource.addEventListener('new-message', function() { location.reload(); });

function sendMessage() {
    var input = document.getElementById('msgInput');
    var content = input.value.trim();
    if (!content) return;
    fetch('/message/send', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'sessionId=${sessionId}&receiverId=${otherId}&content=' + encodeURIComponent(content)
    })
    .then(r => r.json())
    .then(data => {
        if (data.code === 200) {
            input.value = '';
            location.reload();
        } else {
            alert(data.message);
        }
    });
}
</script>
<%@ include file="../common/footer.jsp" %>
