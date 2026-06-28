<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <nav class="mb-3">
        <a href="/message" class="text-decoration-none">
            <i class="bi bi-arrow-left"></i> 返回私信列表
        </a>
    </nav>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card">
                <div class="card-header">
                    <h6 class="mb-0"><i class="bi bi-chat-square-text"></i> 对话</h6>
                </div>
                <div class="card-body" style="max-height: 500px; overflow-y: auto;" id="messageArea">
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
                                <div class="p-2 rounded ${msg.senderId == currentUserId ? 'bg-primary text-white' : 'bg-light'}">
                                    ${msg.content}
                                </div>
                                <small class="text-muted d-block ${msg.senderId == currentUserId ? 'text-end' : ''}">
                                    ${msg.createdAt}
                                    <c:if test="${msg.senderId == currentUserId && msg.isRead == 1}">已读</c:if>
                                </small>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="card-footer">
                    <form method="post" action="/message/send">
                        <input type="hidden" name="sessionId" value="${sessionId}">
                        <input type="hidden" name="receiverId" value="${otherId}">
                        <div class="input-group">
                            <input type="text" class="form-control" name="content" placeholder="输入消息..." required maxlength="500" autofocus>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-send"></i> 发送
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="../common/footer.jsp" %>
