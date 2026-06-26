package com.campus.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        Object user = session.getAttribute("user");
        String path = request.getRequestURI();
        String method = request.getMethod();

        // 游客可访问的 GET 请求路径
        if ("GET".equalsIgnoreCase(method)) {
            if (path.equals("/") || path.startsWith("/product") || path.startsWith("/announcement")) {
                return true;
            }
        }

        // 需要登录
        if (user == null) {
            response.sendRedirect("/login");
            return false;
        }

        // 管理员路径校验
        if (path.startsWith("/admin")) {
            Object roleObj = session.getAttribute("role");
            int role = roleObj != null ? (int) roleObj : 0;
            if (role != 1) {
                response.sendError(403);
                return false;
            }
        }

        return true;
    }
}
