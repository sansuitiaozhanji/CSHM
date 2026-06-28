<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <h2 class="mb-4"><i class="bi bi-plus-circle"></i> 发布商品</h2>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty msg}">
                <div class="alert alert-success">${msg}</div>
            </c:if>

            <form method="post" action="/product/create">
                <div class="mb-3">
                    <label class="form-label">商品标题 *</label>
                    <input type="text" class="form-control" name="title" required maxlength="100"
                           value="${product.title}">
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">分类 *</label>
                        <select class="form-select" name="categoryId" required>
                            <option value="">请选择</option>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat.id}" ${product.categoryId == cat.id ? 'selected' : ''}>
                                        ${cat.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">价格 (元) *</label>
                        <input type="number" step="0.01" class="form-control" name="price" required
                               value="${product.price}">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">成色 *</label>
                    <div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="condition" value="1"
                                   ${product.condition == 1 ? 'checked' : ''}>
                            <label class="form-check-label">全新</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="condition" value="2"
                                   ${product.condition == 2 ? 'checked' : ''}>
                            <label class="form-check-label">九五新</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="condition" value="3"
                                   ${product.condition == 3 ? 'checked' : ''}>
                            <label class="form-check-label">八五新</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="condition" value="4"
                                   ${product.condition == 4 ? 'checked' : ''}>
                            <label class="form-check-label">七成新及以下</label>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">商品描述</label>
                    <textarea class="form-control" name="description" rows="5">${product.description}</textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">商品图片</label>
                    <div class="border rounded p-3">
                        <div id="imageList" class="row g-3 mb-3"></div>
                        <div class="input-group">
                            <input type="file" class="form-control" id="imageInput" accept="image/*">
                            <button type="button" class="btn btn-outline-secondary" onclick="uploadImage()">
                                <i class="bi bi-upload"></i> 上传
                            </button>
                        </div>
                        <div class="form-text">支持多张图片，第一张将作为封面</div>
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg"></i> 提交发布
                    </button>
                    <a href="/my/products" class="btn btn-outline-secondary">取消</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
let imageCount = 0;

function uploadImage() {
    const input = document.getElementById('imageInput');
    if (input.files.length === 0) {
        alert('请选择文件');
        return;
    }

    const formData = new FormData();
    formData.append('file', input.files[0]);

    fetch('/api/upload', {
        method: 'POST',
        body: formData
    })
    .then(res => res.json())
    .then(data => {
        if (data.code === 200) {
            addImage(data.data);
            input.value = '';
        } else {
            alert(data.message);
        }
    })
    .catch(err => {
        alert('上传失败：' + err);
    });
}

function addImage(url) {
    const div = document.createElement('div');
    div.className = 'col-md-4';
    div.innerHTML =
        '<div class="position-relative">' +
        '<img src="' + url + '" class="img-fluid rounded">' +
        '<input type="hidden" name="imageUrls" value="' + url + '">' +
        '<button type="button" class="btn btn-danger btn-sm position-absolute top-0 end-0 m-1" onclick="this.parentElement.parentElement.remove()">' +
        '<i class="bi bi-x-lg"></i>' +
        '</button>' +
        '</div>';
    document.getElementById('imageList').appendChild(div);
}
</script>
<%@ include file="../common/footer.jsp" %>
