<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">首页</a></li>
            <li class="breadcrumb-item active" aria-current="page">我的收藏</li>
        </ol>
    </nav>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty msg}">
        <div class="alert alert-success">${msg}</div>
    </c:if>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4><i class="bi bi-heart"></i> 我的收藏</h4>
    </div>

    <c:if test="${empty favorites}">
        <div class="text-center py-5">
            <i class="bi bi-heart" style="font-size: 4rem; color: #ccc;"></i>
            <p class="text-muted mt-3">暂无收藏商品</p>
            <a href="/" class="btn btn-primary">去逛逛</a>
        </div>
    </c:if>

    <c:if test="${not empty favorites}">
        <div class="row g-4">
            <c:forEach items="${favorites}" var="fav">
                <div class="col-md-6 col-lg-4 col-xl-3">
                    <div class="card h-100 shadow-sm">
                        <c:if test="${not empty fav.product}">
                            <a href="/product/${fav.productId}" class="text-decoration-none text-dark">
                                <div class="position-relative">
                                    <c:if test="${not empty fav.product.firstImageUrl}">
                                        <img src="${fav.product.firstImageUrl}" class="card-img-top" alt="${fav.product.title}" style="height: 200px; object-fit: cover;">
                                    </c:if>
                                    <c:if test="${empty fav.product.firstImageUrl}">
                                        <div class="d-flex align-items-center justify-content-center bg-light" style="height: 200px;">
                                            <i class="bi bi-image text-secondary" style="font-size: 3rem;"></i>
                                        </div>
                                    </c:if>
                                    <c:if test="${fav.product.status != 1}">
                                        <div class="position-absolute top-0 start-0 m-2">
                                            <span class="badge bg-secondary">已下架</span>
                                        </div>
                                    </c:if>
                                </div>
                                <div class="card-body">
                                    <h6 class="card-title text-truncate">${fav.product.title}</h6>
                                    <p class="card-text text-danger fw-bold mb-0">¥${fav.product.price}</p>
                                </div>
                            </a>
                            <div class="card-footer bg-white border-top-0">
                                <form method="post" action="/favorite/${fav.id}/delete" style="display:inline;">
                                    <button type="submit" class="btn btn-outline-danger btn-sm w-100">
                                        <i class="bi bi-heartbreak"></i> 取消收藏
                                    </button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</div>
<%@ include file="../common/footer.jsp" %>
