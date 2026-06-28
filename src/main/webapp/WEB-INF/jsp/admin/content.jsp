<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <h3 class="mb-4"><i class="bi bi-gear"></i> 内容管理</h3>

    <c:if test="${not empty msg}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row">
        <!-- 公告管理 -->
        <div class="col-lg-6 mb-4">
            <div class="card shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0"><i class="bi bi-megaphone"></i> 公告管理</h5>
                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#announcementModal">
                        <i class="bi bi-plus-lg"></i> 发布公告
                    </button>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>标题</th>
                                    <th>类型</th>
                                    <th>状态</th>
                                    <th>时间</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${announcements}" var="a">
                                    <tr>
                                        <td class="text-truncate" style="max-width:200px;">${a.title}</td>
                                        <td><span class="badge bg-info">${a.typeStr}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${a.status == 1}"><span class="badge bg-success">已发布</span></c:when>
                                                <c:otherwise><span class="badge bg-secondary">草稿</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><small>${a.createdAtStr}</small></td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-secondary"
                                                    onclick="editAnnouncement('${a.id}','${a.title}','${a.type}','${a.status}')">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <form action="/admin/content/announcement/${a.id}/delete" method="post" style="display:inline;">
                                                <button type="submit" class="btn btn-sm btn-outline-danger"
                                                        onclick="return confirm('确认删除该公告？')">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty announcements}">
                                    <tr><td colspan="5" class="text-center text-muted py-3">暂无公告</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- 轮播图管理 -->
        <div class="col-lg-6 mb-4">
            <div class="card shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0"><i class="bi bi-images"></i> 轮播图管理</h5>
                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#carouselModal">
                        <i class="bi bi-plus-lg"></i> 添加轮播图
                    </button>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>预览</th>
                                    <th>标题</th>
                                    <th>排序</th>
                                    <th>状态</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${carousels}" var="c">
                                    <tr>
                                        <td>
                                            <img src="${c.imageUrl}" style="width:60px;height:30px;object-fit:cover;border-radius:4px;">
                                        </td>
                                        <td class="text-truncate" style="max-width:120px;">${c.title}</td>
                                        <td>${c.sortOrder}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.status == 1}"><span class="badge bg-success">显示</span></c:when>
                                                <c:otherwise><span class="badge bg-secondary">隐藏</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-secondary"
                                                    onclick="editCarousel('${c.id}','${c.imageUrl}','${c.linkUrl}','${c.title}','${c.sortOrder}','${c.status}')">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <form action="/admin/content/carousel/${c.id}/delete" method="post" style="display:inline;">
                                                <button type="submit" class="btn btn-sm btn-outline-danger"
                                                        onclick="return confirm('确认删除该轮播图？')">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty carousels}">
                                    <tr><td colspan="5" class="text-center text-muted py-3">暂无轮播图</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 公告模态框 -->
<div class="modal fade" id="announcementModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="/admin/content/announcement/save" method="post">
                <input type="hidden" name="id" id="annId">
                <div class="modal-header">
                    <h5 class="modal-title" id="annTitle">发布公告</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">标题</label>
                        <input type="text" class="form-control" name="title" id="annTitleInput" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">内容</label>
                        <textarea class="form-control" name="content" id="annContent" rows="6" required></textarea>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">类型</label>
                            <select class="form-select" name="type" id="annType">
                                <option value="0">系统公告</option>
                                <option value="1">交易须知</option>
                                <option value="2">资讯</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">状态</label>
                            <select class="form-select" name="status" id="annStatus">
                                <option value="1">已发布</option>
                                <option value="0">草稿</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">保存</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 轮播图模态框 -->
<div class="modal fade" id="carouselModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="/admin/content/carousel/save" method="post">
                <input type="hidden" name="id" id="carId">
                <div class="modal-header">
                    <h5 class="modal-title" id="carTitle">添加轮播图</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">选择本地图片</label>
                        <input type="file" class="form-control" id="carImageFile" accept="image/*"
                               onchange="uploadCarouselImage()">
                        <div id="carUploadProgress" class="text-muted small mt-1 d-none">
                            <span class="spinner-border spinner-border-sm"></span> 上传中...
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">图片URL</label>
                        <div class="input-group">
                            <input type="text" class="form-control" name="imageUrl" id="carImageUrl"
                                   placeholder="选择本地图片自动填入，或手动输入URL" required>
                            <button type="button" class="btn btn-outline-secondary"
                                    onclick="document.getElementById('carImageFile').click()">
                                <i class="bi bi-folder2-open"></i>
                            </button>
                        </div>
                        <div id="carImagePreview" class="mt-2 d-none">
                            <img src="" style="width:100%;max-height:150px;object-fit:cover;border-radius:4px;">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">跳转链接（可选）</label>
                        <input type="text" class="form-control" name="linkUrl" id="carLinkUrl">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">标题</label>
                        <input type="text" class="form-control" name="title" id="carTitleInput">
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">排序</label>
                            <input type="number" class="form-control" name="sortOrder" id="carSortOrder" value="0">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">状态</label>
                            <select class="form-select" name="status" id="carStatus">
                                <option value="1">显示</option>
                                <option value="0">隐藏</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">保存</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function editAnnouncement(id, title, type, status) {
    document.getElementById('annId').value = id;
    document.getElementById('annTitleInput').value = title;
    document.getElementById('annType').value = type;
    document.getElementById('annStatus').value = status;
    new bootstrap.Modal(document.getElementById('announcementModal')).show();
}
function editCarousel(id, imageUrl, linkUrl, title, sortOrder, status) {
    document.getElementById('carId').value = id;
    document.getElementById('carImageUrl').value = imageUrl;
    document.getElementById('carLinkUrl').value = linkUrl || '';
    document.getElementById('carTitleInput').value = title || '';
    document.getElementById('carSortOrder').value = sortOrder;
    document.getElementById('carStatus').value = status;
    if (imageUrl) {
        document.getElementById('carImagePreview').classList.remove('d-none');
        document.getElementById('carImagePreview').querySelector('img').src = imageUrl;
    } else {
        document.getElementById('carImagePreview').classList.add('d-none');
    }
    document.getElementById('carImageFile').value = '';
    document.getElementById('carUploadProgress').classList.add('d-none');
    new bootstrap.Modal(document.getElementById('carouselModal')).show();
}

function uploadCarouselImage() {
    const fileInput = document.getElementById('carImageFile');
    const file = fileInput.files[0];
    if (!file) return;

    const formData = new FormData();
    formData.append('file', file);

    const progressEl = document.getElementById('carUploadProgress');
    progressEl.classList.remove('d-none');

    fetch('/api/upload', { method: 'POST', body: formData })
        .then(res => res.json())
        .then(data => {
            progressEl.classList.add('d-none');
            if (data.code === 200) {
                document.getElementById('carImageUrl').value = data.data;
                document.getElementById('carImagePreview').classList.remove('d-none');
                document.getElementById('carImagePreview').querySelector('img').src = data.data;
            } else {
                alert('上传失败：' + (data.message || '未知错误'));
            }
        })
        .catch(err => {
            progressEl.classList.add('d-none');
            alert('上传失败：' + err.message);
        });
}
</script>
<%@ include file="../common/footer.jsp" %>
