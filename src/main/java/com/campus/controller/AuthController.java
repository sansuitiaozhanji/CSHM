package com.campus.controller;

import com.campus.entity.User;
import com.campus.service.LogService;
import com.campus.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AuthController {

    private final UserService userService;
    private final LogService logService;

    public AuthController(UserService userService, LogService logService) {
        this.userService = userService;
        this.logService = logService;
    }

    @GetMapping("/login")
    public ModelAndView loginPage() {
        return new ModelAndView("user/login");
    }

    @PostMapping("/login")
    public String login(@RequestParam String account, @RequestParam String password,
                        HttpSession session, HttpServletRequest request, RedirectAttributes attr) {
        String ip = request.getRemoteAddr();
        User user = userService.login(account, password, ip);
        if (user == null) {
            attr.addFlashAttribute("error", "账号或密码错误，或账号已被禁用");
            return "redirect:/login";
        }
        session.setAttribute("user", user);
        session.setAttribute("role", user.getRole());
        return "redirect:/";
    }

    @GetMapping("/register")
    public ModelAndView registerPage() {
        return new ModelAndView("user/register");
    }

    @PostMapping("/register")
    public String register(User user, @RequestParam String confirmPassword,
                           HttpSession session, HttpServletRequest request, RedirectAttributes attr) {
        if (!user.getPassword().equals(confirmPassword)) {
            attr.addFlashAttribute("error", "两次密码不一致");
            return "redirect:/register";
        }
        String ip = request.getRemoteAddr();
        String err = userService.register(user, ip);
        if (err != null) {
            attr.addFlashAttribute("error", err);
            return "redirect:/register";
        }
        session.setAttribute("user", user);
        session.setAttribute("role", user.getRole());
        return "redirect:/";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, HttpServletRequest request) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            logService.log(user.getId(), "LOGOUT", "用户 " + user.getUsername() + " 退出登录", request.getRemoteAddr());
        }
        session.invalidate();
        return "redirect:/login";
    }
}
