package com.campus.controller.admin;

import com.campus.entity.Product;
import com.campus.entity.User;
import com.campus.service.ProductService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminProductController {

    private final ProductService productService;

    public AdminProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/products")
    public ModelAndView productList(@RequestParam(required = false) String keyword,
                                    @RequestParam(required = false) Integer status,
                                    HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return new ModelAndView("redirect:/login");
        }
        ModelAndView mv = new ModelAndView("admin/product-review");
        List<Product> products = productService.findAll(keyword, null, status);
        mv.addObject("products", products);
        mv.addObject("keyword", keyword);
        mv.addObject("status", status);
        return mv;
    }

    @PostMapping("/products/{id}/approve")
    public String approve(@PathVariable Long id, HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/login";
        }
        String error = productService.approve(id);
        if (error != null) {
            attr.addFlashAttribute("error", error);
        } else {
            attr.addFlashAttribute("msg", "审核通过");
        }
        return "redirect:/admin/products";
    }

    @PostMapping("/products/{id}/reject")
    public String reject(@PathVariable Long id, @RequestParam String reason,
                         HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/login";
        }
        String error = productService.reject(id, reason);
        if (error != null) {
            attr.addFlashAttribute("error", error);
        } else {
            attr.addFlashAttribute("msg", "已驳回");
        }
        return "redirect:/admin/products";
    }
}
