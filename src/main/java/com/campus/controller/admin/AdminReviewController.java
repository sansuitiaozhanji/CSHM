package com.campus.controller.admin;

import com.campus.entity.Review;
import com.campus.entity.User;
import com.campus.service.ReviewService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class AdminReviewController {

    private final ReviewService reviewService;

    public AdminReviewController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @GetMapping("/admin/reviews")
    public ModelAndView list(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return new ModelAndView("redirect:/login");
        }
        ModelAndView mv = new ModelAndView("admin/review-list");
        List<Review> reviews = reviewService.findAll();
        mv.addObject("reviews", reviews);
        return mv;
    }

    @PostMapping("/admin/reviews/{id}/toggle")
    public String toggleStatus(@PathVariable Long id, HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/login";
        }
        Review review = reviewService.findById(id);
        if (review == null) {
            attr.addFlashAttribute("error", "评价不存在");
            return "redirect:/admin/reviews";
        }
        Integer newStatus = review.getStatus() == 1 ? 0 : 1;
        String error = reviewService.updateStatus(id, newStatus, true);
        if (error != null) {
            attr.addFlashAttribute("error", error);
        } else {
            attr.addFlashAttribute("msg", "状态更新成功");
        }
        return "redirect:/admin/reviews";
    }

    @PostMapping("/admin/reviews/{id}/delete")
    public String delete(@PathVariable Long id, HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/login";
        }
        String error = reviewService.delete(id, user.getId(), true);
        if (error != null) {
            attr.addFlashAttribute("error", error);
        } else {
            attr.addFlashAttribute("msg", "删除成功");
        }
        return "redirect:/admin/reviews";
    }
}
