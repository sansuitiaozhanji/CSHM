package com.campus.controller;

import com.campus.entity.Order;
import com.campus.entity.User;
import com.campus.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @GetMapping("/my/orders/buy")
    public ModelAndView buyList(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }
        ModelAndView mv = new ModelAndView("order/buy-list");
        List<Order> orders = orderService.findByBuyerId(user.getId());
        mv.addObject("orders", orders);
        return mv;
    }

    @GetMapping("/my/orders/sell")
    public ModelAndView sellList(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }
        ModelAndView mv = new ModelAndView("order/sell-list");
        List<Order> orders = orderService.findBySellerId(user.getId());
        mv.addObject("orders", orders);
        return mv;
    }

    @GetMapping("/order/{id}")
    public ModelAndView detail(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }
        Order order = orderService.findById(id);
        if (order == null) {
            ModelAndView mv = new ModelAndView("redirect:/my/orders/buy");
            mv.addObject("error", "订单不存在");
            return mv;
        }
        // 验证权限
        if (!order.getBuyerId().equals(user.getId()) && !order.getSellerId().equals(user.getId())) {
            ModelAndView mv = new ModelAndView("redirect:/my/orders/buy");
            mv.addObject("error", "无权查看此订单");
            return mv;
        }
        ModelAndView mv = new ModelAndView("order/detail");
        mv.addObject("order", order);
        mv.addObject("currentUserId", user.getId());
        return mv;
    }

    @PostMapping("/order/create")
    public String create(@RequestParam Long productId,
                         @RequestParam(required = false) String remark,
                         HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        String error = orderService.create(productId, user.getId(), remark);
        if (error != null) {
            attr.addFlashAttribute("error", error);
            return "redirect:/product/" + productId;
        }
        attr.addFlashAttribute("msg", "下单成功，请等待卖家确认");
        return "redirect:/my/orders/buy";
    }

    @PostMapping("/order/confirm/{id}")
    public String confirm(@PathVariable Long id, HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        String error = orderService.confirm(id, user.getId());
        if (error != null) {
            attr.addFlashAttribute("error", error);
        } else {
            attr.addFlashAttribute("msg", "订单已确认");
        }
        return "redirect:/order/" + id;
    }

    @PostMapping("/order/cancel/{id}")
    public String cancel(@PathVariable Long id, HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
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
        if (user == null) {
            return "redirect:/login";
        }
        String error = orderService.complete(id, user.getId());
        if (error != null) {
            attr.addFlashAttribute("error", error);
        } else {
            attr.addFlashAttribute("msg", "订单已完成");
        }
        return "redirect:/order/" + id;
    }
}
