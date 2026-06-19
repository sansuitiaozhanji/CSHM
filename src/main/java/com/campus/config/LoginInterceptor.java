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

        if (user == null) {
            response.sendRedirect("/login");
            return false;
        }

        String path = request.getRequestURI();
        if (path.startsWith("/admin")) {
            try {
                Object roleObj = session.getAttribute("role");
                int role = roleObj != null ? (int) roleObj : 0;
                if (role != 1) {
                    response.sendError(403);
                    return false;
                }
            } catch (Exception e) {
                response.sendError(403);
                return false;
            }
        }

        return true;
    }
}
