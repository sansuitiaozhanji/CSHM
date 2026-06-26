<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/my/orders/buy">我的购买</a></li>
            <li class="breadcrumb-item"><a href="/order/${order.id}">订单详情</a></li>
            <li class="breadcrumb-item active" aria-current="page">发表评价</li>
        </ol>
    </nav>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty msg}">
        <div class="alert alert-success">${msg}</div>
    </c:if>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-star"></i> 发表评价</h5>
                </div>
                <div class="card-body">
                    <div class="card mb-4 bg-light">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="me-3">
                                    <span class="fw-bold">商品：</span>
                                    <a href="/product/${order.productId}" class="text-decoration-none">${order.product.title}</a>
                                </div>
                            </div>
                            <div class="mt-2">
                                <span class="fw-bold">价格：</span>
                                <span class="text-danger fw-bold">¥${order.price}</span>
                            </div>
                        </div>
                    </div>

                    <form method="post">
                        <div class="mb-4">
                            <label class="form-label fw-bold">评分 <span class="text-danger">*</span></label>
                            <div class="rating-select">
                                <div class="btn-group" role="group">
                                    <input type="radio" class="btn-check" name="rating" id="rating1" value="1" required>
                                    <label class="btn btn-outline-warning" for="rating1">★☆☆☆☆</label>
                                    <input type="radio" class="btn-check" name="rating" id="rating2" value="2">
                                    <label class="btn btn-outline-warning" for="rating2">★★☆☆☆</label>
                                    <input type="radio" class="btn-check" name="rating" id="rating3" value="3">
                                    <label class="btn btn-outline-warning" for="rating3">★★★☆☆</label>
                                    <input type="radio" class="btn-check" name="rating" id="rating4" value="4">
                                    <label class="btn btn-outline-warning" for="rating4">★★★★☆</label>
                                    <input type="radio" class="btn-check" name="rating" id="rating5" value="5">
                                    <label class="btn btn-outline-warning" for="rating5">★★★★★</label>
                                </div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">评价内容</label>
                            <textarea class="form-control" name="content" rows="5" placeholder="说说你的购买体验..." maxlength="500"></textarea>
                            <div class="form-text text-muted">最多500字</div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle"></i> 提交评价
                            </button>
                            <a href="/order/${order.id}" class="btn btn-outline-secondary">
                                取消
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="../common/footer.jsp" %>
