<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <h3 class="mb-4">用户管理</h3>

    <c:if test="${not empty msg}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card shadow-sm">
        <div class="card-body">
            <form action="/admin/users" method="get" class="row g-3 mb-4">
                <div class="col-md-4">
                    <input type="text" class="form-control" name="keyword" placeholder="搜索学号、姓名或邮箱" value="${keyword}">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary">搜索</button>
                    <a href="/admin/users" class="btn btn-outline-secondary">重置</a>
                </div>
            </form>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>学号</th>
                            <th>姓名</th>
                            <th>邮箱</th>
                            <th>余额</th>
                            <th>角色</th>
                            <th>状态</th>
                            <th>注册时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${users}" var="u">
                            <tr>
                                <td>${u.id}</td>
                                <td>${u.studentId}</td>
                                <td>${u.name}</td>
                                <td>${u.email}</td>
                                <td class="fw-bold text-primary">¥${u.balance}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.role == 1}">
                                            <span class="badge bg-danger">管理员</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">普通用户</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.status == 1}">
                                            <span class="badge bg-success">启用</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">禁用</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${u.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td>
                                    <c:if test="${u.role != 1}">
                                        <form action="/admin/users/${u.id}/toggle" method="post" style="display:inline;">
                                            <c:choose>
                                                <c:when test="${u.status == 1}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger"
                                                            onclick="return confirm('确认禁用该用户？')">禁用</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="submit" class="btn btn-sm btn-outline-success"
                                                            onclick="return confirm('确认启用该用户？')">启用</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </form>
                                        <button type="button" class="btn btn-sm btn-outline-primary"
                                                data-bs-toggle="modal" data-bs-target="#rechargeModal${u.id}">
                                            充值
                                        </button>

                                        <div class="modal fade" id="rechargeModal${u.id}" tabindex="-1">
                                            <div class="modal-dialog modal-sm">
                                                <div class="modal-content">
                                                    <form action="/admin/users/${u.id}/recharge" method="post">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">余额充值</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <p>用户：${u.name} (${u.studentId})</p>
                                                            <p>当前余额：¥${u.balance}</p>
                                                            <div class="mb-3">
                                                                <label class="form-label">充值金额</label>
                                                                <input type="number" class="form-control" name="amount"
                                                                       step="0.01" min="0.01" required>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                                                            <button type="submit" class="btn btn-primary">确认充值</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty users}">
                            <tr><td colspan="9" class="text-center text-muted py-4">暂无用户数据</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<%@ include file="../common/footer.jsp" %>
