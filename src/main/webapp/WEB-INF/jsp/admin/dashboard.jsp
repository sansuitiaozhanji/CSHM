<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <h3 class="mb-4"><i class="bi bi-speedometer2"></i> 数据统计</h3>

    <div class="row g-4 mb-4">
        <div class="col-md-6 col-lg-4">
            <div class="card bg-primary text-white shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title mb-1">用户总数</h6>
                            <h2 class="mb-0">${totalUsers}</h2>
                        </div>
                        <i class="bi bi-people fs-1 opacity-50"></i>
                    </div>
                    <small class="opacity-75">启用 ${activeUsers} / 禁用 ${disabledUsers}</small>
                </div>
            </div>
        </div>
        <div class="col-md-6 col-lg-4">
            <div class="card bg-success text-white shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title mb-1">商品总数</h6>
                            <h2 class="mb-0">${totalProducts}</h2>
                        </div>
                        <i class="bi bi-box-seam fs-1 opacity-50"></i>
                    </div>
                    <small class="opacity-75">已上架 ${onlineProducts} / 待审核 ${pendingProducts}</small>
                </div>
            </div>
        </div>
        <div class="col-md-6 col-lg-4">
            <div class="card bg-info text-white shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title mb-1">订单总数</h6>
                            <h2 class="mb-0">${totalOrders}</h2>
                        </div>
                        <i class="bi bi-receipt fs-1 opacity-50"></i>
                    </div>
                    <small class="opacity-75">成交率 ${completionRate}%</small>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-header"><h5 class="card-title mb-0">用户概览</h5></div>
                <div class="card-body">
                    <table class="table table-sm">
                        <tr><td>总注册用户</td><td class="fw-bold">${totalUsers}</td></tr>
                        <tr><td>正常用户</td><td class="text-success fw-bold">${activeUsers}</td></tr>
                        <tr><td>禁用用户</td><td class="text-danger fw-bold">${disabledUsers}</td></tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-header"><h5 class="card-title mb-0">商品概览</h5></div>
                <div class="card-body">
                    <table class="table table-sm">
                        <tr><td>商品总数</td><td class="fw-bold">${totalProducts}</td></tr>
                        <tr><td>已上架</td><td class="text-success fw-bold">${onlineProducts}</td></tr>
                        <tr><td>待审核</td><td class="text-warning fw-bold">${pendingProducts}</td></tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header"><h5 class="card-title mb-0">订单概览</h5></div>
                <div class="card-body">
                    <table class="table table-sm">
                        <tr>
                            <td>订单总数</td><td class="fw-bold">${totalOrders}</td>
                            <td>待付款</td><td class="text-warning fw-bold">${pendingPayOrders}</td>
                            <td>待自提</td><td class="text-info fw-bold">${pendingPickupOrders}</td>
                            <td>已完成</td><td class="text-success fw-bold">${completedOrders}</td>
                            <td>已取消</td><td class="text-muted fw-bold">${cancelledOrders}</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="../common/footer.jsp" %>
