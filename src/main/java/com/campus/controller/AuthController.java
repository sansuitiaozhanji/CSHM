package com.campus.controller;

import com.campus.entity.User;
import com.campus.service.UserService;
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

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/login")
    public ModelAndView loginPage() {
        return new ModelAndView("user/login");
    }

    @PostMapping("/login")
    public String login(@RequestParam String account, @RequestParam String password,
                        HttpSession session, RedirectAttributes attr) {
        User user = userService.login(account, password);
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
                           HttpSession session, RedirectAttributes attr) {
        if (!user.getPassword().equals(confirmPassword)) {
            attr.addFlashAttribute("error", "两次密码不一致");
            return "redirect:/register";
        }
        String err = userService.register(user);
        if (err != null) {
            attr.addFlashAttribute("error", err);
            return "redirect:/register";
        }
        session.setAttribute("user", user);
        session.setAttribute("role", user.getRole());
        return "redirect:/";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
