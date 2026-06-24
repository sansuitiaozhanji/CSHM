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
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/profile")
    public ModelAndView profile(HttpSession session) {
        User sessionUser = (User) session.getAttribute("user");
        User user = userService.findById(sessionUser.getId());
        ModelAndView mv = new ModelAndView("user/profile");
        mv.addObject("user", user);
        return mv;
    }

    @PostMapping("/profile/update")
    public String updateProfile(User param, HttpSession session, RedirectAttributes attr) {
        User sessionUser = (User) session.getAttribute("user");
        param.setId(sessionUser.getId());
        String err = userService.updateProfile(param);
        if (err != null) {
            attr.addFlashAttribute("error", err);
            return "redirect:/profile";
        }
        User updated = userService.findById(sessionUser.getId());
        session.setAttribute("user", updated);
        attr.addFlashAttribute("msg", "个人信息更新成功");
        return "redirect:/profile";
    }

    @PostMapping("/profile/password")
    public String updatePassword(@RequestParam String oldPassword,
                                 @RequestParam String newPassword,
                                 @RequestParam String confirmPassword,
                                 HttpSession session, RedirectAttributes attr) {
        if (!newPassword.equals(confirmPassword)) {
            attr.addFlashAttribute("error", "两次密码不一致");
            return "redirect:/profile";
        }
        User sessionUser = (User) session.getAttribute("user");
        String err = userService.updatePassword(sessionUser.getId(), oldPassword, newPassword);
        if (err != null) {
            attr.addFlashAttribute("error", err);
            return "redirect:/profile";
        }
        attr.addFlashAttribute("msg", "密码修改成功，请重新登录");
        return "redirect:/logout";
    }
}
