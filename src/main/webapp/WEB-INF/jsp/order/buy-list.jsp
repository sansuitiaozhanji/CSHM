<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-bag"></i> 我的购买</h2>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty msg}">
        <div class="alert alert-success">${msg}</div>
    </c:if>

    <c:if test="${empty orders}">
        <div class="text-center py-5">
            <i class="bi bi-inbox" style="font-size: 4rem; color: #ccc;"></i>
            <p class="text-muted mt-3">还没有任何订单</p>
            <a href="/" class="btn btn-primary">去逛逛</a>
        </div>
    </c:if>

    <c:if test="${not empty orders}">
        <div class="row g-4">
            <c:forEach items="${orders}" var="o">
                <div class="col-md-6 col-lg-4">
                    <div class="card h-100">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <h5 class="card-title mb-0">${o.product.title}</h5>
                                <span class="badge ${o.status == 0 ? 'bg-warning' : o.status == 1 ? 'bg-primary' : o.status == 2 ? 'bg-success' : 'bg-secondary'}">
                                        ${o.statusText}
                                </span>
                            </div>
                            <p class="card-text text-danger fw-bold fs-4">¥${o.price}</p>
                            <p class="card-text">
                                <small class="text-muted">卖家：${o.seller.name} · ${o.createdAt.toLocalDate()}</small>
                            </p>
                        </div>
                        <div class="card-footer bg-white border-top-0">
                            <a href="/order/${o.id}" class="btn btn-primary btn-sm w-100">
                                <i class="bi bi-eye"></i> 查看详情
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</div>
<%@ include file="../common/footer.jsp" %>
