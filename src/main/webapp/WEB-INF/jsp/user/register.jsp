<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/header.jsp" %>
<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <h3 class="text-center mb-4">用户注册</h3>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <form action="/register" method="post" onsubmit="return validateForm()">
                        <div class="mb-3">
                            <label for="username" class="form-label">用户名 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="username" name="username"
                                   placeholder="以字母开头，3-20位字母或数字" value="${param.username}" required
                                   pattern="[a-zA-Z][a-zA-Z0-9]{2,19}" maxlength="20">
                            <div class="form-text">以字母开头，3-20位字母或数字组合</div>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">手机号 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="phone" name="phone"
                                   placeholder="请输入11位手机号" value="${param.phone}" required
                                   pattern="\d{11}" maxlength="11">
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">密码 <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="password" name="password"
                                   placeholder="至少6位密码" required minlength="6">
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">确认密码 <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                   placeholder="请再次输入密码" required minlength="6">
                        </div>
                        <button type="submit" class="btn btn-primary w-100">注册</button>
                    </form>
                    <div class="text-center mt-3">
                        <span class="text-muted">已有账号？</span>
                        <a href="/login">立即登录</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
function validateForm() {
    var pwd = document.getElementById('password').value;
    var confirm = document.getElementById('confirmPassword').value;
    if (pwd !== confirm) {
        alert('两次密码不一致');
        return false;
    }
    if (pwd.length < 6) {
        alert('密码不能少于6位');
        return false;
    }
    return true;
}
</script>
<%@ include file="../common/footer.jsp" %>
