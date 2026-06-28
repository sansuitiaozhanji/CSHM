<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4><i class="bi bi-chat-dots"></i> 私信</h4>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty msg}">
        <div class="alert alert-success">${msg}</div>
    </c:if>

    <c:if test="${empty sessions}">
        <div class="text-center py-5">
            <i class="bi bi-chat-square-text" style="font-size: 4rem; color: #ccc;"></i>
            <p class="text-muted mt-3">暂无私信会话</p>
        </div>
    </c:if>

    <c:if test="${not empty sessions}">
        <div class="card">
            <div class="list-group list-group-flush">
                <c:forEach items="${sessions}" var="msg">
                    <a href="/message/${msg.sessionId}" class="list-group-item list-group-item-action p-3">
                        <div class="d-flex align-items-center">
                            <div class="me-3">
                                <c:choose>
                                    <c:when test="${msg.senderId == currentUserId}">
                                        <c:if test="${not empty msg.receiver.avatar}">
                                            <img src="${msg.receiver.avatar}" class="rounded-circle" style="width: 48px; height: 48px; object-fit: cover;">
                                        </c:if>
                                        <c:if test="${empty msg.receiver.avatar}">
                                            <div class="rounded-circle bg-secondary d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                                                <i class="bi bi-person text-white"></i>
                                            </div>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${not empty msg.sender.avatar}">
                                            <img src="${msg.sender.avatar}" class="rounded-circle" style="width: 48px; height: 48px; object-fit: cover;">
                                        </c:if>
                                        <c:if test="${empty msg.sender.avatar}">
                                            <div class="rounded-circle bg-secondary d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                                                <i class="bi bi-person text-white"></i>
                                            </div>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="flex-grow-1 min-width-0">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h6 class="mb-1">
                                        <c:choose>
                                            <c:when test="${msg.senderId == currentUserId}">
                                                ${msg.receiver.name}
                                            </c:when>
                                            <c:otherwise>
                                                ${msg.sender.name}
                                            </c:otherwise>
                                        </c:choose>
                                    </h6>
                                    <small class="text-muted">${msg.createdAtStr}</small>
                                </div>
                                <p class="mb-1 text-muted text-truncate">
                                    <c:if test="${msg.senderId == currentUserId}">我：</c:if>
                                    ${msg.content}
                                </p>
                                <c:if test="${msg.senderId != currentUserId && msg.isRead == 0}">
                                    <span class="badge bg-danger rounded-pill">未读</span>
                                </c:if>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </div>
    </c:if>
</div>
<script>
var evtSource = new EventSource('/message/stream');
evtSource.addEventListener('new-message', function() { location.reload(); });
</script>
<%@ include file="../common/footer.jsp" %>
