package com.campus.controller;

import com.campus.entity.User;
import com.campus.service.WalletService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class WalletController {

    private final WalletService walletService;

    public WalletController(WalletService walletService) {
        this.walletService = walletService;
    }

    @GetMapping("/wallet")
    public ModelAndView index(HttpSession session) {
        User user = (User) session.getAttribute("user");
        ModelAndView mv = new ModelAndView("wallet/index");
        mv.addObject("balance", walletService.getBalance(user.getId()));
        mv.addObject("transactions", walletService.getTransactions(user.getId()));
        return mv;
    }
}
