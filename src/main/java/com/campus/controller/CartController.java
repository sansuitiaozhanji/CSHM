package com.campus.controller;

import com.campus.common.Result;
import com.campus.entity.Cart;
import com.campus.entity.User;
import com.campus.service.CartService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.List;

@Controller
public class CartController {

    private final CartService cartService;

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    @GetMapping("/cart")
    public ModelAndView cart(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }
        ModelAndView mv = new ModelAndView("cart/list");
        List<Cart> carts = cartService.findByUserId(user.getId());
        BigDecimal total = cartService.getTotalPrice(user.getId());
        mv.addObject("carts", carts);
        mv.addObject("total", total);
        return mv;
    }

    @PostMapping("/cart/add")
    @ResponseBody
    public Result add(@RequestParam Long productId,
                      @RequestParam(defaultValue = "1") Integer quantity,
                      HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        String error = cartService.add(user.getId(), productId, quantity);
        if (error != null) {
            return Result.error(400, error);
        }
        return Result.success("加入购物车成功");
    }

    @PostMapping("/cart/update/{id}")
    @ResponseBody
    public Result update(@PathVariable Long id,
                         @RequestParam Integer quantity,
                         HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        String error = cartService.updateQuantity(id, user.getId(), quantity);
        if (error != null) {
            return Result.error(400, error);
        }
        return Result.success("更新成功");
    }

    @PostMapping("/cart/remove/{id}")
    public String remove(@PathVariable Long id, HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        String error = cartService.remove(id, user.getId());
        if (error != null) {
            attr.addFlashAttribute("error", error);
        } else {
            attr.addFlashAttribute("msg", "删除成功");
        }
        return "redirect:/cart";
    }

    @PostMapping("/cart/clear")
    public String clear(HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        String error = cartService.clear(user.getId());
        if (error != null) {
            attr.addFlashAttribute("error", error);
        } else {
            attr.addFlashAttribute("msg", "清空成功");
        }
        return "redirect:/cart";
    }
}
