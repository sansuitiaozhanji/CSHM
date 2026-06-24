<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <nav class="mb-4">
        <a href="/" class="text-decoration-none">
            <i class="bi bi-arrow-left"></i> 返回首页
        </a>
    </nav>

    <div class="row">
        <div class="col-lg-6 mb-4">
            <c:if test="${not empty product.images}">
                <div id="productCarousel" class="carousel slide" data-bs-ride="carousel">
                    <div class="carousel-inner rounded shadow">
                        <c:forEach items="${product.images}" var="img" varStatus="s">
                            <div class="carousel-item ${s.first ? 'active' : ''}">
                                <img src="${img.url}" class="d-block w-100" style="height: 400px; object-fit: cover;">
                            </div>
                        </c:forEach>
                    </div>
                    <c:if test="${product.images.size() > 1}">
                        <button class="carousel-control-prev" type="button" data-bs-target="#productCarousel" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon"></span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#productCarousel" data-bs-slide="next">
                            <span class="carousel-control-next-icon"></span>
                        </button>
                    </c:if>
                </div>
                <div class="d-flex gap-2 mt-2">
                    <c:forEach items="${product.images}" var="img" varStatus="s">
                        <img src="${img.url}" class="img-thumbnail" style="width: 80px; height: 80px; object-fit: cover; cursor: pointer;"
                             onclick="document.querySelector('#productCarousel .carousel-item.active').classList.remove('active');
                                      document.querySelectorAll('#productCarousel .carousel-item')[${s.index}].classList.add('active');">
                    </c:forEach>
                </div>
            </c:if>
            <c:if test="${empty product.images}">
                <div class="bg-light rounded d-flex align-items-center justify-content-center" style="height: 400px;">
                    <span class="text-muted"><i class="bi bi-image" style="font-size: 4rem;"></i></span>
                </div>
            </c:if>
        </div>

        <div class="col-lg-6">
            <h2 class="mb-3">${product.title}</h2>

            <div class="d-flex align-items-center gap-2 mb-3">
                <span class="badge bg-secondary">${product.category.name}</span>
                <span class="badge bg-info">${product.conditionText}</span>
            </div>

            <div class="text-danger fs-1 fw-bold mb-4">
                ¥${product.price}
            </div>

            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title d-flex align-items-center gap-2">
                        <i class="bi bi-person-circle"></i> 卖家信息
                    </h5>
                    <div class="row">
                        <div class="col-sm-4"><strong>姓名：</strong></div>
                        <div class="col-sm-8">${product.seller.name}</div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4"><strong>学号：</strong></div>
                        <div class="col-sm-8">${product.seller.studentId}</div>
                    </div>
                    <c:if test="${not empty product.seller.phone}">
                        <div class="row">
                            <div class="col-sm-4"><strong>联系电话：</strong></div>
                            <div class="col-sm-8">${product.seller.phone}</div>
                        </div>
                    </c:if>
                </div>
            </div>

            <c:if test="${not empty product.description}">
                <div class="mb-4">
                    <h5><i class="bi bi-file-text"></i> 商品描述</h5>
                    <p class="text-muted">${product.description}</p>
                </div>
            </c:if>

            <c:if test="${not empty sessionScope.user && sessionScope.user.id != product.sellerId && product.status == 1}">
                <form method="post" action="/order/create">
                    <input type="hidden" name="productId" value="${product.id}">
                    <div class="mb-3">
                        <label for="remark" class="form-label">备注（可选）</label>
                        <input type="text" class="form-control" id="remark" name="remark" placeholder="可以填写联系方式或其他需求">
                    </div>
                    <button type="submit" class="btn btn-primary btn-lg w-100">
                        <i class="bi bi-cart"></i> 立即购买
                    </button>
                </form>
            </c:if>
            <c:if test="${product.status != 1 && not empty sessionScope.user && sessionScope.user.id != product.sellerId}">
                <button class="btn btn-secondary btn-lg w-100" disabled>
                    ${product.statusText}
                </button>
            </c:if>
            <c:if test="${empty sessionScope.user}">
                <a href="/login" class="btn btn-outline-primary btn-lg w-100">
                    登录后购买
                </a>
            </c:if>
        </div>
    </div>
</div>
<%@ include file="../common/footer.jsp" %>
