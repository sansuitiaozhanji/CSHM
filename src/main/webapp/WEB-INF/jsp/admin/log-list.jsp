<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <h3 class="mb-4"><i class="bi bi-journal-text"></i> 操作日志</h3>

    <div class="card shadow-sm">
        <div class="card-body">
            <form action="/admin/logs" method="get" class="row g-3 mb-4">
                <div class="col-md-4">
                    <input type="text" class="form-control" name="keyword"
                           placeholder="搜索操作类型或描述" value="${keyword}">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary">搜索</button>
                    <a href="/admin/logs" class="btn btn-outline-secondary">重置</a>
                </div>
            </form>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>用户ID</th>
                            <th>操作类型</th>
                            <th>描述</th>
                            <th>IP地址</th>
                            <th>操作时间</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${logs}" var="log">
                            <tr>
                                <td>${log.id}</td>
                                <td>${log.userId != null ? log.userId : '-'}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${log.actionType == 'LOGIN'}">
                                            <span class="badge bg-success">登录</span>
                                        </c:when>
                                        <c:when test="${log.actionType == 'LOGOUT'}">
                                            <span class="badge bg-secondary">退出</span>
                                        </c:when>
                                        <c:when test="${log.actionType == 'REGISTER'}">
                                            <span class="badge bg-info">注册</span>
                                        </c:when>
                                        <c:when test="${log.actionType == 'LOGIN_FAIL'}">
                                            <span class="badge bg-warning">登录失败</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-primary">${log.actionType}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${log.description}</td>
                                <td>${log.ipAddress}</td>
                                <td>${log.createdAtStr}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty logs}">
                            <tr><td colspan="6" class="text-center text-muted py-4">暂无日志记录</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<%@ include file="../common/footer.jsp" %>
