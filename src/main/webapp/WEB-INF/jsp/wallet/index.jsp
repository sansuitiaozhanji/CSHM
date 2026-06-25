<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <h3 class="mb-4"><i class="bi bi-wallet2"></i> 我的钱包</h3>

    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card bg-primary text-white shadow-sm">
                <div class="card-body text-center">
                    <h6 class="card-title">当前余额</h6>
                    <h2 class="display-6 fw-bold">¥${balance}</h2>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-header">
            <h5 class="card-title mb-0">交易流水</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-light">
                        <tr>
                            <th>类型</th>
                            <th>金额</th>
                            <th>变动前</th>
                            <th>变动后</th>
                            <th>说明</th>
                            <th>时间</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${transactions}" var="t">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${t.type == 'INIT'}">
                                            <span class="badge bg-info">初始发放</span>
                                        </c:when>
                                        <c:when test="${t.type == 'RECHARGE'}">
                                            <span class="badge bg-success">充值</span>
                                        </c:when>
                                        <c:when test="${t.type == 'PAY'}">
                                            <span class="badge bg-warning">支出</span>
                                        </c:when>
                                        <c:when test="${t.type == 'INCOME'}">
                                            <span class="badge bg-primary">入账</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${t.type}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="${t.amount >= 0 ? 'text-success' : 'text-danger'} fw-bold">
                                    ${t.amount >= 0 ? '+' : ''}¥${t.amount}
                                </td>
                                <td>¥${t.balanceBefore}</td>
                                <td>¥${t.balanceAfter}</td>
                                <td>${t.description}</td>
                                <td>${t.createdAtStr}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty transactions}">
                            <tr><td colspan="6" class="text-center text-muted py-4">暂无交易记录</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<%@ include file="../common/footer.jsp" %>
