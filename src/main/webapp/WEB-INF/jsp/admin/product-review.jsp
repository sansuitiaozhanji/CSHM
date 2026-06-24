<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <h2 class="mb-4"><i class="bi bi-shield-check"></i> 商品审核</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty msg}">
        <div class="alert alert-success">${msg}</div>
    </c:if>

    <div class="card mb-4">
        <div class="card-body">
            <form method="get" class="row g-3">
                <div class="col-md-4">
                    <input type="text" class="form-control" name="keyword" placeholder="搜索商品标题" value="${keyword}">
                </div>
                <div class="col-md-3">
                    <select class="form-select" name="status">
                        <option value="">全部状态</option>
                        <option value="0" ${status == 0 ? 'selected' : ''}>待审核</option>
                        <option value="1" ${status == 1 ? 'selected' : ''}>已上架</option>
                        <option value="2" ${status == 2 ? 'selected' : ''}>已下架</option>
                        <option value="3" ${status == 3 ? 'selected' : ''}>审核驳回</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="bi bi-search"></i> 搜索
                    </button>
                </div>
                <div class="col-md-3">
                    <a href="/admin/products?status=0" class="btn btn-warning w-100">
                        <i class="bi bi-hourglass"></i> 待审核
                    </a>
                </div>
            </form>
        </div>
    </div>

    <c:if test="${empty products}">
        <div class="text-center py-5">
            <i class="bi bi-inbox" style="font-size: 4rem; color: #ccc;"></i>
            <p class="text-muted mt-3">暂无商品</p>
        </div>
    </c:if>

    <c:if test="${not empty products}">
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>商品</th>
                        <th>卖家</th>
                        <th>价格</th>
                        <th>状态</th>
                        <th>发布时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${products}" var="p">
                        <tr>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <a href="/product/${p.id}" class="text-decoration-none">${p.title}</a>
                                </div>
                            </td>
                            <td>
                                <div>${p.seller.name}</div>
                                <small class="text-muted">${p.seller.studentId}</small>
                            </td>
                            <td class="text-danger fw-bold">¥${p.price}</td>
                            <td>
                                <span class="badge ${p.status == 1 ? 'bg-success' : p.status == 0 ? 'bg-warning' : p.status == 3 ? 'bg-danger' : 'bg-secondary'}">
                                        ${p.statusText}
                                </span>
                            </td>
                            <td>${p.createdAt.toLocalDate()}</td>
                            <td>
                                <c:if test="${p.status == 0}">
                                    <form method="post" action="/admin/products/${p.id}/approve" class="d-inline">
                                        <button type="submit" class="btn btn-success btn-sm">
                                            <i class="bi bi-check-lg"></i> 通过
                                        </button>
                                    </form>
                                    <button type="button" class="btn btn-danger btn-sm"
                                            onclick="showRejectModal(${p.id})">
                                        <i class="bi bi-x-lg"></i> 驳回
                                    </button>
                                </c:if>
                                <c:if test="${p.status == 3}">
                                    <div class="small text-danger">驳回原因：${p.rejectReason}</div>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
</div>

<!-- 驳回原因模态框 -->
<div class="modal fade" id="rejectModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" id="rejectForm">
                <div class="modal-header">
                    <h5 class="modal-title">驳回审核</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">驳回原因 *</label>
                        <textarea class="form-control" name="reason" rows="3" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-danger">确认驳回</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function showRejectModal(id) {
    document.getElementById('rejectForm').action = '/admin/products/' + id + '/reject';
    new bootstrap.Modal(document.getElementById('rejectModal')).show();
}
</script>
<%@ include file="../common/footer.jsp" %>
