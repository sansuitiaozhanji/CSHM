package com.campus.controller;

import com.campus.entity.Order;
import com.campus.entity.User;
import com.campus.service.OrderService;
import com.campus.service.WalletService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.List;

@Controller
public class OrderController {

    private final OrderService orderService;
    private final WalletService walletService;

    public OrderController(OrderService orderService, WalletService walletService) {
        this.orderService = orderService;
        this.walletService = walletService;
    }

    @GetMapping("/my/orders/buy")
    public ModelAndView buyList(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return new ModelAndView("redirect:/login");
        ModelAndView mv = new ModelAndView("order/buy-list");
        mv.addObject("orders", orderService.findByBuyerId(user.getId()));
        return mv;
    }

    @GetMapping("/my/orders/sell")
    public ModelAndView sellList(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return new ModelAndView("redirect:/login");
        ModelAndView mv = new ModelAndView("order/sell-list");
        mv.addObject("orders", orderService.findBySellerId(user.getId()));
        return mv;
    }

    @GetMapping("/order/{id}")
    public ModelAndView detail(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return new ModelAndView("redirect:/login");
        Order order = orderService.findById(id);
        if (order == null) {
            return new ModelAndView("redirect:/my/orders/buy");
        }
        if (!order.getBuyerId().equals(user.getId()) && !order.getSellerId().equals(user.getId())) {
            return new ModelAndView("redirect:/my/orders/buy");
        }
        ModelAndView mv = new ModelAndView("order/detail");
        mv.addObject("order", order);
        mv.addObject("currentUserId", user.getId());
        mv.addObject("balance", walletService.getBalance(user.getId()));
        return mv;
    }

    @PostMapping("/order/create")
    public String create(@RequestParam Long productId,
                         @RequestParam(required = false) String remark,
                         HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        String error = orderService.create(productId, user.getId(), remark);
        if (error != null) {
            attr.addFlashAttribute("error", error);
            return "redirect:/product/" + productId;
        }
        attr.addFlashAttribute("msg", "下单成功，请尽快支付");
        return "redirect:/my/orders/buy";
    }

    @PostMapping("/order/pay/{id}")
    public String pay(@PathVariable Long id, HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        String error = orderService.pay(id, user.getId());
        if (error != null) {
            attr.addFlashAttribute("error", error);
        } else {
            attr.addFlashAttribute("msg", "支付成功，请与卖家联系自提");
        }
        return "redirect:/order/" + id;
    }

    @PostMapping("/order/cancel/{id}")
    public String cancel(@PathVariable Long id, HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        String error = orderService.cancel(id, user.getId());
        if (error != null) {
            attr.addFlashAttribute("error", error);
        } else {
            attr.addFlashAttribute("msg", "订单已取消");
        }
        return "redirect:/order/" + id;
    }

    @PostMapping("/order/complete/{id}")
    public String complete(@PathVariable Long id, HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        String error = orderService.complete(id, user.getId());
        if (error != null) {
            attr.addFlashAttribute("error", error);
        } else {
            attr.addFlashAttribute("msg", "确认收货成功，交易完成");
        }
        return "redirect:/order/" + id;
    }
}
