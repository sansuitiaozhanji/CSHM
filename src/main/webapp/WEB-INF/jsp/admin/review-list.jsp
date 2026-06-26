<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/admin/dashboard">管理后台</a></li>
            <li class="breadcrumb-item active" aria-current="page">评价管理</li>
        </ol>
    </nav>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty msg}">
        <div class="alert alert-success">${msg}</div>
    </c:if>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4><i class="bi bi-star-half"></i> 评价管理</h4>
    </div>

    <c:if test="${empty reviews}">
        <div class="text-center py-5">
            <i class="bi bi-inbox" style="font-size: 4rem; color: #ccc;"></i>
            <p class="text-muted mt-3">暂无评价</p>
        </div>
    </c:if>

    <c:if test="${not empty reviews}">
        <div class="card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>用户</th>
                                <th>商品</th>
                                <th>评分</th>
                                <th>内容</th>
                                <th>状态</th>
                                <th>时间</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${reviews}" var="review">
                                <tr>
                                    <td>${review.id}</td>
                                    <td>
                                        <c:if test="${not empty review.user}">
                                            <div class="d-flex align-items-center">
                                                <c:if test="${not empty review.user.avatar}">
                                                    <img src="${review.user.avatar}" class="rounded-circle me-2" style="width: 32px; height: 32px;">
                                                </c:if>
                                                <span>${review.user.name}</span>
                                            </div>
                                        </c:if>
                                        <c:if test="${empty review.user}">
                                            -
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${not empty review.product}">
                                            <a href="/product/${review.productId}" class="text-decoration-none">${review.product.title}</a>
                                        </c:if>
                                        <c:if test="${empty review.product}">
                                            -
                                        </c:if>
                                    </td>
                                    <td>
                                        <span class="text-warning">${review.ratingStars}</span>
                                    </td>
                                    <td style="max-width: 200px;">
                                        <span class="text-truncate d-inline-block" style="max-width: 180px;">${review.content}</span>
                                    </td>
                                    <td>
                                        <span class="badge ${review.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                            ${review.statusText}
                                        </span>
                                    </td>
                                    <td><small>${review.createdAt}</small></td>
                                    <td>
                                        <form method="post" action="/admin/reviews/${review.id}/toggle" style="display:inline;">
                                            <button type="submit" class="btn btn-sm btn-outline-warning">
                                                ${review.status == 1 ? '隐藏' : '显示'}
                                            </button>
                                        </form>
                                        <form method="post" action="/admin/reviews/${review.id}/delete" style="display:inline;" onsubmit="return confirm('确定删除吗？');">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                删除
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </c:if>
</div>
<%@ include file="../common/footer.jsp" %>
