<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-box"></i> 我的商品</h2>
        <a href="/product/create" class="btn btn-primary">
            <i class="bi bi-plus-lg"></i> 发布商品
        </a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty msg}">
        <div class="alert alert-success">${msg}</div>
    </c:if>

    <c:if test="${empty products}">
        <div class="text-center py-5">
            <i class="bi bi-inbox" style="font-size: 4rem; color: #ccc;"></i>
            <p class="text-muted mt-3">还没有发布任何商品</p>
            <a href="/product/create" class="btn btn-primary">发布第一个商品</a>
        </div>
    </c:if>

    <c:if test="${not empty products}">
        <div class="row g-4">
            <c:forEach items="${products}" var="p">
                <div class="col-md-6 col-lg-4">
                    <div class="card h-100">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <h5 class="card-title mb-0">${p.title}</h5>
                                <span class="badge ${p.status == 1 ? 'bg-success' : p.status == 0 ? 'bg-warning' : p.status == 3 ? 'bg-danger' : 'bg-secondary'}">
                                        ${p.statusText}
                                </span>
                            </div>
                            <p class="card-text text-danger fw-bold fs-4">¥${p.price}</p>
                            <p class="card-text">
                                <small class="text-muted">${p.conditionText} · ${p.createdAtStr}</small>
                            </p>
                            <c:if test="${p.status == 3 && not empty p.rejectReason}">
                                <div class="alert alert-danger py-2 small">
                                    <i class="bi bi-exclamation-circle"></i> 驳回原因：${p.rejectReason}
                                </div>
                            </c:if>
                        </div>
                        <div class="card-footer bg-white border-top-0">
                            <div class="d-flex gap-2">
                                <a href="/product/${p.id}" class="btn btn-outline-primary btn-sm flex-grow-1">
                                    <i class="bi bi-eye"></i> 查看
                                </a>
                                <c:if test="${p.status != 1}">
                                    <a href="/product/edit/${p.id}" class="btn btn-outline-secondary btn-sm flex-grow-1">
                                        <i class="bi bi-pencil"></i> 编辑
                                    </a>
                                </c:if>
                            </div>
                            <div class="d-flex gap-2 mt-2">
                                <c:if test="${p.status == 0 || p.status == 2}">
                                    <form method="post" action="/product/toggle/${p.id}" class="flex-grow-1">
                                        <button type="submit" class="btn ${p.status == 0 ? 'btn-warning' : 'btn-success'} btn-sm w-100">
                                            <i class="bi bi-arrow-up-circle"></i> ${p.status == 0 ? '等待审核' : '上架'}
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${p.status == 1}">
                                    <form method="post" action="/product/toggle/${p.id}" class="flex-grow-1">
                                        <button type="submit" class="btn btn-secondary btn-sm w-100">
                                            <i class="bi bi-arrow-down-circle"></i> 下架
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${p.status == 3}">
                                    <form method="post" action="/product/resubmit/${p.id}" class="flex-grow-1">
                                        <button type="submit" class="btn btn-primary btn-sm w-100">
                                            <i class="bi bi-arrow-repeat"></i> 重新提交
                                        </button>
                                    </form>
                                </c:if>
                                <form method="post" action="/product/delete/${p.id}" class="flex-grow-1"
                                      onsubmit="return confirm('确定删除「${p.title}」？删除后不可恢复。')">
                                    <button type="submit" class="btn btn-outline-danger btn-sm w-100">
                                        <i class="bi bi-trash"></i> 删除
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</div>
<%@ include file="../common/footer.jsp" %>
