<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">首页</a></li>
            <li class="breadcrumb-item active" aria-current="page">购物车</li>
        </ol>
    </nav>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty msg}">
        <div class="alert alert-success">${msg}</div>
    </c:if>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4><i class="bi bi-cart3"></i> 购物车</h4>
        <c:if test="${not empty carts}">
            <form method="post" action="/cart/clear" style="display:inline;" onsubmit="return confirm('确定清空购物车吗？');">
                <button type="submit" class="btn btn-outline-danger">
                    <i class="bi bi-trash"></i> 清空购物车
                </button>
            </form>
        </c:if>
    </div>

    <c:if test="${empty carts}">
        <div class="text-center py-5">
            <i class="bi bi-cart3" style="font-size: 4rem; color: #ccc;"></i>
            <p class="text-muted mt-3">购物车空空如也</p>
            <a href="/" class="btn btn-primary">去逛逛</a>
        </div>
    </c:if>

    <c:if test="${not empty carts}">
        <div class="row">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-body p-0">
                        <c:forEach items="${carts}" var="cart" varStatus="status">
                            <c:if test="${not empty cart.product}">
                                <div class="p-4 ${not status.first ? 'border-top' : ''}">
                                    <div class="d-flex">
                                        <div class="me-4">
                                            <a href="/product/${cart.productId}">
                                                <c:if test="${not empty cart.product.firstImageUrl}">
                                                    <img src="${cart.product.firstImageUrl}" alt="${cart.product.title}" style="width: 120px; height: 120px; object-fit: cover;">
                                                </c:if>
                                                <c:if test="${empty cart.product.firstImageUrl}">
                                                    <div class="d-flex align-items-center justify-content-center bg-light" style="width: 120px; height: 120px;">
                                                        <i class="bi bi-image text-secondary" style="font-size: 2rem;"></i>
                                                    </div>
                                                </c:if>
                                            </a>
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <h6 class="mb-1">
                                                        <a href="/product/${cart.productId}" class="text-decoration-none text-dark">
                                                            ${cart.product.title}
                                                        </a>
                                                    </h6>
                                                    <c:if test="${cart.product.status != 1}">
                                                        <span class="badge bg-warning">已下架</span>
                                                    </c:if>
                                                    <p class="text-danger fw-bold mb-2 mt-2">¥${cart.product.price}</p>
                                                    <c:if test="${cart.product.status == 1}">
                                                    </c:if>
                                                </div>
                                                <div class="text-end">
                                                    <p class="fw-bold mb-1">小计：<span class="text-danger">¥${cart.subtotal}</span></p>
                                                    <form method="post" action="/cart/remove/${cart.id}" style="display:inline;">
                                                        <button type="submit" class="btn btn-outline-danger btn-sm">
                                                            <i class="bi bi-trash"></i> 删除
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card sticky-top" style="top: 20px;">
                    <div class="card-header">
                        <h6 class="mb-0">订单汇总</h6>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">商品总计</span>
                            <span>¥${total}</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-4">
                            <span class="fw-bold">应付总额</span>
                            <span class="fw-bold text-danger fs-4">¥${total}</span>
                        </div>
                        <form method="post" action="/cart/checkout">
                            <button type="submit" class="btn btn-primary btn-lg w-100"
                                    onclick="return confirm('确认提交订单？总金额 ¥${total}')">
                                <i class="bi bi-check-circle"></i> 去结算
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</div>
<%@ include file="../common/footer.jsp" %>
