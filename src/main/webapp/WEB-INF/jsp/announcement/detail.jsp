<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <c:if test="${empty announcement}">
        <div class="text-center py-5">
            <p class="text-muted">公告不存在或已被删除</p>
            <a href="/announcement" class="btn btn-primary">返回公告列表</a>
        </div>
    </c:if>

    <c:if test="${not empty announcement}">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/">首页</a></li>
                <li class="breadcrumb-item"><a href="/announcement">公告资讯</a></li>
                <li class="breadcrumb-item active">${announcement.title}</li>
            </ol>
        </nav>

        <div class="card shadow-sm">
            <div class="card-body p-4">
                <h2 class="mb-3">${announcement.title}</h2>
                <div class="text-muted mb-4">
                    <span class="badge bg-info me-2">${announcement.typeStr}</span>
                    <small><i class="bi bi-clock"></i> ${announcement.createdAtStr}</small>
                </div>
                <hr>
                <div class="content" style="white-space:pre-wrap;line-height:1.8;">
                    ${announcement.content}
                </div>
            </div>
        </div>
    </c:if>
</div>
<%@ include file="../common/footer.jsp" %>
