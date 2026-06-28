<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <c:if test="${order.buyerId == currentUserId}">
                    <a href="/my/orders/buy">我的购买</a>
                </c:if>
                <c:if test="${order.sellerId == currentUserId}">
                    <a href="/my/orders/sell">我的出售</a>
                </c:if>
            </li>
            <li class="breadcrumb-item active" aria-current="page">订单详情</li>
        </ol>
    </nav>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty msg}">
        <div class="alert alert-success">${msg}</div>
    </c:if>

    <div class="row">
        <div class="col-lg-8">
            <div class="card mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-receipt"></i> 订单信息</h5>
                    <span class="badge ${order.status == 0 ? 'bg-warning' : order.status == 1 ? 'bg-primary' : order.status == 2 ? 'bg-success' : 'bg-secondary'} fs-6">
                            ${order.statusText}
                    </span>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-sm-4"><strong>订单编号：</strong></div>
                        <div class="col-sm-8">#${order.id}</div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-sm-4"><strong>商品：</strong></div>
                        <div class="col-sm-8">
                            <c:if test="${not empty order.product}">
                                <a href="/product/${order.productId}" class="text-decoration-none">${order.product.title}</a>
                            </c:if>
                            <c:if test="${empty order.product}">
                                商品已下架
                            </c:if>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-sm-4"><strong>单价：</strong></div>
                        <div class="col-sm-8 text-danger fw-bold">¥${order.price}</div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-sm-4"><strong>数量：</strong></div>
                        <div class="col-sm-8">${order.quantity}</div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-sm-4"><strong>总价：</strong></div>
                        <div class="col-sm-8 text-danger fw-bold fs-4">¥${order.totalPrice}</div>
                    </div>
                    <c:if test="${not empty order.remark}">
                        <div class="row mb-3">
                            <div class="col-sm-4"><strong>备注：</strong></div>
                            <div class="col-sm-8">${order.remark}</div>
                        </div>
                    </c:if>
                    <div class="row mb-3">
                        <div class="col-sm-4"><strong>下单时间：</strong></div>
                        <div class="col-sm-8">${order.createdAtStr}</div>
                    </div>
                    <c:if test="${not empty order.completedAtStr}">
                        <div class="row mb-3">
                            <div class="col-sm-4"><strong>完成时间：</strong></div>
                            <div class="col-sm-8">${order.completedAtStr}</div>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="d-flex gap-2">
                <c:if test="${order.status == 0 && order.buyerId == currentUserId}">
                    <form method="post" action="/order/pay/${order.id}">
                        <button type="submit" class="btn btn-warning">
                            <i class="bi bi-credit-card"></i> 立即支付 ¥${order.totalPrice}
                        </button>
                    </form>
                    <form method="post" action="/order/cancel/${order.id}">
                        <button type="submit" class="btn btn-secondary" onclick="return confirm('确定要取消订单吗？')">
                            <i class="bi bi-x-circle"></i> 取消订单
                        </button>
                    </form>
                </c:if>
                <c:if test="${order.status == 1 && order.buyerId == currentUserId}">
                    <form method="post" action="/order/complete/${order.id}">
                        <button type="submit" class="btn btn-success" onclick="return confirm('确认已收到商品？卖家将收到款项。')">
                            <i class="bi bi-check2-circle"></i> 确认收货
                        </button>
                    </form>
                </c:if>
                <c:if test="${order.status == 2 && order.buyerId == currentUserId}">
                    <a href="/order/${order.id}/review" class="btn btn-primary">
                        <i class="bi bi-star"></i> 发表评价
                    </a>
                </c:if>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card mb-4">
                <div class="card-header">
                    <h6 class="mb-0"><i class="bi bi-person-badge"></i> 买家信息</h6>
                </div>
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <c:if test="${not empty order.buyer && not empty order.buyer.avatar}">
                            <img src="${order.buyer.avatar}" alt="头像" class="rounded-circle me-3" style="width: 48px; height: 48px; object-fit: cover;">
                        </c:if>
                        <c:if test="${empty order.buyer || empty order.buyer.avatar}">
                            <div class="rounded-circle me-3 bg-secondary d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                                <i class="bi bi-person text-white"></i>
                            </div>
                        </c:if>
                        <div>
                            <c:if test="${not empty order.buyer}">
                                <div class="fw-bold">${order.buyer.username}</div>
                                <c:if test="${order.sellerId == currentUserId && not empty order.buyer.phone}">
                                    <div class="small">手机：${order.buyer.phone}</div>
                                </c:if>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h6 class="mb-0"><i class="bi bi-person-badge"></i> 卖家信息</h6>
                </div>
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <c:if test="${not empty order.seller && not empty order.seller.avatar}">
                            <img src="${order.seller.avatar}" alt="头像" class="rounded-circle me-3" style="width: 48px; height: 48px; object-fit: cover;">
                        </c:if>
                        <c:if test="${empty order.seller || empty order.seller.avatar}">
                            <div class="rounded-circle me-3 bg-secondary d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                                <i class="bi bi-person text-white"></i>
                            </div>
                        </c:if>
                        <div>
                            <c:if test="${not empty order.seller}">
                                <div class="fw-bold">${order.seller.username}</div>
                                <c:if test="${order.buyerId == currentUserId && not empty order.seller.phone}">
                                    <div class="small">手机：${order.seller.phone}</div>
                                </c:if>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="../common/footer.jsp" %>
