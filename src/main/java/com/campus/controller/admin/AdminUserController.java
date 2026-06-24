package com.campus.controller.admin;

import com.campus.service.UserService;
import com.campus.service.WalletService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;

@Controller
public class AdminUserController {

    private final UserService userService;
    private final WalletService walletService;

    public AdminUserController(UserService userService, WalletService walletService) {
        this.userService = userService;
        this.walletService = walletService;
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

    @PostMapping("/admin/users/{id}/recharge")
    public String recharge(@PathVariable Long id,
                           @RequestParam BigDecimal amount,
                           RedirectAttributes attr) {
        String err = walletService.recharge(id, amount);
        if (err != null) {
            attr.addFlashAttribute("error", err);
        } else {
            attr.addFlashAttribute("msg", "充值成功");
        }
        return "redirect:/admin/users";
    }
}
