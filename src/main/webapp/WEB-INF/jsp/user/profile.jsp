<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <h3 class="mb-4">个人中心</h3>

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

            <div class="card shadow-sm mb-4">
                <div class="card-header">
                    <h5 class="card-title mb-0">个人信息</h5>
                </div>
                <div class="card-body">
                    <form action="/profile/update" method="post">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label text-muted">用户名</label>
                                <input type="text" class="form-control" value="${user.username}" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted">钱包余额</label>
                                <input type="text" class="form-control fw-bold text-primary" value="¥${user.balance}" readonly>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">手机号</label>
                            <input type="text" class="form-control" id="phone" name="phone"
                                   value="${user.phone}" placeholder="请输入11位手机号" maxlength="11">
                        </div>
                        <button type="submit" class="btn btn-primary">保存修改</button>
                    </form>
                </div>
            </div>

            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="card-title mb-0">修改密码</h5>
                </div>
                <div class="card-body">
                    <form action="/profile/password" method="post" onsubmit="return checkPassword()">
                        <div class="mb-3">
                            <label for="oldPassword" class="form-label">原密码</label>
                            <input type="password" class="form-control" id="oldPassword" name="oldPassword"
                                   placeholder="请输入原密码" required>
                        </div>
                        <div class="mb-3">
                            <label for="newPassword" class="form-label">新密码</label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword"
                                   placeholder="至少6位新密码" required minlength="6">
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">确认新密码</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                   placeholder="请再次输入新密码" required minlength="6">
                        </div>
                        <button type="submit" class="btn btn-warning">修改密码</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
function checkPassword() {
    var pwd = document.getElementById('newPassword').value;
    var confirm = document.getElementById('confirmPassword').value;
    if (pwd !== confirm) {
        alert('两次密码不一致');
        return false;
    }
    return true;
}
</script>
<%@ include file="../common/footer.jsp" %>
