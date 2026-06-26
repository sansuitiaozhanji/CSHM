package com.campus.controller;

import com.campus.entity.Order;
import com.campus.entity.Review;
import com.campus.entity.User;
import com.campus.service.OrderService;
import com.campus.service.ReviewService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class ReviewController {

    private final ReviewService reviewService;
    private final OrderService orderService;

    public ReviewController(ReviewService reviewService, OrderService orderService) {
        this.reviewService = reviewService;
        this.orderService = orderService;
    }

    @GetMapping("/order/{id}/review")
    public ModelAndView reviewForm(@PathVariable Long id, HttpSession session) {
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
        if (!order.getBuyerId().equals(user.getId())) {
            ModelAndView mv = new ModelAndView("redirect:/my/orders/buy");
            mv.addObject("error", "无权操作此订单");
            return mv;
        }
        if (order.getStatus() != 2) {
            ModelAndView mv = new ModelAndView("redirect:/order/" + id);
            mv.addObject("error", "只有已完成的订单才能评价");
            return mv;
        }
        Review existing = reviewService.findByOrderId(id);
        if (existing != null) {
            ModelAndView mv = new ModelAndView("redirect:/order/" + id);
            mv.addObject("error", "该订单已评价过");
            return mv;
        }
        ModelAndView mv = new ModelAndView("order/review");
        mv.addObject("order", order);
        return mv;
    }

    @PostMapping("/order/{id}/review")
    public String submitReview(@PathVariable Long id,
                               @RequestParam Integer rating,
                               @RequestParam String content,
                               HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        String error = reviewService.create(id, user.getId(), rating, content);
        if (error != null) {
            attr.addFlashAttribute("error", error);
            return "redirect:/order/" + id + "/review";
        }
        attr.addFlashAttribute("msg", "评价成功");
        return "redirect:/order/" + id;
    }
}
