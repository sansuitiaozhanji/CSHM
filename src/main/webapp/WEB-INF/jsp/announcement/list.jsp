<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <h3 class="mb-4"><i class="bi bi-megaphone"></i> 公告资讯</h3>

    <c:if test="${empty announcements}">
        <div class="text-center py-5">
            <i class="bi bi-megaphone" style="font-size: 4rem; color: #ccc;"></i>
            <p class="text-muted mt-3">暂无公告</p>
        </div>
    </c:if>

    <c:if test="${not empty announcements}">
        <div class="list-group">
            <c:forEach items="${announcements}" var="a">
                <c:if test="${a.status == 1}">
                    <a href="/announcement/${a.id}" class="list-group-item list-group-item-action">
                        <div class="d-flex w-100 justify-content-between align-items-center">
                            <h5 class="mb-1">${a.title}</h5>
                            <div>
                                <span class="badge bg-info me-2">${a.typeStr}</span>
                                <small class="text-muted">${a.createdAtStr}</small>
                            </div>
                        </div>
                    </a>
                </c:if>
            </c:forEach>
        </div>
    </c:if>
</div>
<%@ include file="../common/footer.jsp" %>
