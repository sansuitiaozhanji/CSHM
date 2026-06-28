<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="common/header.jsp" %>
<div class="container py-4">
    <div class="text-center py-4 mb-4">
        <h1 class="display-5 fw-bold">校园二手交易平台</h1>
        <p class="lead text-muted">在这里发现校园好物，让闲置流转起来</p>
    </div>

    <!-- 轮播图 -->
    <c:if test="${not empty carousels}">
        <div id="heroCarousel" class="carousel slide mb-4" data-bs-ride="carousel">
            <div class="carousel-indicators">
                <c:forEach items="${carousels}" var="carousel" varStatus="s">
                    <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="${s.index}"
                            class="${s.first ? 'active' : ''}" aria-current="${s.first ? 'true' : ''}"
                            aria-label="Slide ${s.index + 1}"></button>
                </c:forEach>
            </div>
            <div class="carousel-inner rounded shadow">
                <c:forEach items="${carousels}" var="carousel" varStatus="s">
                    <div class="carousel-item ${s.first ? 'active' : ''}">
                        <c:if test="${not empty carousel.linkUrl}">
                            <a href="${carousel.linkUrl}" target="_blank">
                                <img src="${carousel.imageUrl}" class="d-block w-100"
                                     style="height: 350px; object-fit: cover;" alt="${carousel.title}">
                            </a>
                        </c:if>
                        <c:if test="${empty carousel.linkUrl}">
                            <img src="${carousel.imageUrl}" class="d-block w-100"
                                 style="height: 350px; object-fit: cover;" alt="${carousel.title}">
                        </c:if>
                        <c:if test="${not empty carousel.title}">
                            <div class="carousel-caption d-none d-md-block">
                                <h5>${carousel.title}</h5>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
            <c:if test="${carousels.size() > 1}">
                <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">上一张</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">下一张</span>
                </button>
            </c:if>
        </div>
    </c:if>

    <!-- 搜索和筛选 -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" class="row g-3">
                <div class="col-md-8">
                    <div class="input-group">
                        <input type="text" class="form-control" name="keyword" placeholder="搜索商品..." value="${keyword}">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-search"></i> 搜索
                        </button>
                    </div>
                </div>
                <div class="col-md-4">
                    <select class="form-select" name="categoryId" onchange="this.form.submit()">
                        <option value="">全部分类</option>
                        <c:forEach items="${categories}" var="cat">
                            <option value="${cat.id}" ${categoryId == cat.id ? 'selected' : ''}>
                                    ${cat.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </form>
        </div>
    </div>

    <!-- 商品列表 -->
    <c:if test="${empty pageResult.list}">
        <div class="text-center py-5">
            <i class="bi bi-inbox" style="font-size: 4rem; color: #ccc;"></i>
            <p class="text-muted mt-3">暂无商品</p>
        </div>
    </c:if>

    <c:if test="${not empty pageResult.list}">
        <div class="row g-4">
            <c:forEach items="${pageResult.list}" var="p">
                <div class="col-md-6 col-lg-4 col-xl-3">
                    <a href="/product/${p.id}" class="text-decoration-none text-dark">
                        <div class="card h-100 product-card shadow-sm">
                            <div class="position-relative">
                                <c:choose>
                                    <c:when test="${not empty p.firstImageUrl}">
                                        <img src="${p.firstImageUrl}" class="card-img-top"
                                             style="height: 200px; object-fit: cover;">
                                    </c:when>
                                    <c:when test="${not empty p.images}">
                                        <img src="${p.images[0].url}" class="card-img-top"
                                             style="height: 200px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="bg-light d-flex align-items-center justify-content-center"
                                             style="height: 200px;">
                                            <span class="text-muted"><i class="bi bi-image fs-1"></i></span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title text-truncate">${p.title}</h5>
                                <p class="card-text text-danger fs-4 fw-bold mb-1">¥${p.price}</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">
                                        <i class="bi bi-tag"></i> ${p.category.name}
                                    </small>
                                    <small class="text-muted">${p.conditionText}</small>
                                </div>
                            </div>
                            <div class="card-footer bg-white border-top-0">
                                <div class="d-flex justify-content-between align-items-center text-muted small">
                                    <span><i class="bi bi-person"></i> ${p.seller.name}</span>
                                    <span><i class="bi bi-calendar"></i> ${p.createdAtStr}</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>

        <!-- 分页 -->
        <c:if test="${pageResult.totalPages > 1}">
            <nav class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${pageResult.page <= 1 ? 'disabled' : ''}">
                        <a class="page-link" href="?keyword=${keyword}&categoryId=${categoryId}&page=${pageResult.page - 1}">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                    <c:forEach begin="1" end="${pageResult.totalPages}" var="i">
                        <li class="page-item ${pageResult.page == i ? 'active' : ''}">
                            <a class="page-link" href="?keyword=${keyword}&categoryId=${categoryId}&page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${pageResult.page >= pageResult.totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="?keyword=${keyword}&categoryId=${categoryId}&page=${pageResult.page + 1}">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </c:if>
</div>

<style>
.product-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.15) !important;
    transition: all 0.2s;
}
</style>
<%@ include file="common/footer.jsp" %>
