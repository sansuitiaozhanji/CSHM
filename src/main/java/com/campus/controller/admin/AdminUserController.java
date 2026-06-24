package com.campus.controller.admin;

import com.campus.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class AdminUserController {

    private final UserService userService;

    public AdminUserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/admin/users")
    public ModelAndView list(@RequestParam(required = false, defaultValue = "") String keyword) {
        ModelAndView mv = new ModelAndView("admin/user-list");
        mv.addObject("users", userService.findAllUsers(keyword));
        mv.addObject("keyword", keyword);
        return mv;
    }

    @PostMapping("/admin/users/{id}/toggle")
    public String toggle(@PathVariable Long id) {
        userService.toggleUserStatus(id);
        return "redirect:/admin/users";
    }
}
