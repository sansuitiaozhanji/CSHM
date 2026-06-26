package com.campus.controller;

import com.campus.common.Result;
import com.campus.entity.Favorite;
import com.campus.entity.User;
import com.campus.service.FavoriteService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class FavoriteController {

    private final FavoriteService favoriteService;

    public FavoriteController(FavoriteService favoriteService) {
        this.favoriteService = favoriteService;
    }

    @GetMapping("/my/favorites")
    public ModelAndView myFavorites(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }
        ModelAndView mv = new ModelAndView("favorite/list");
        List<Favorite> favorites = favoriteService.findByUserId(user.getId());
        mv.addObject("favorites", favorites);
        return mv;
    }

    @PostMapping("/favorite/add")
    @ResponseBody
    public Result add(@RequestParam Long productId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        String error = favoriteService.add(user.getId(), productId);
        if (error != null) {
            return Result.error(400, error);
        }
        return Result.success("收藏成功");
    }

    @PostMapping("/favorite/remove")
    @ResponseBody
    public Result remove(@RequestParam Long productId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        String error = favoriteService.remove(user.getId(), productId);
        if (error != null) {
            return Result.error(400, error);
        }
        return Result.success("取消收藏成功");
    }

    @PostMapping("/favorite/{id}/delete")
    public String delete(@PathVariable Long id, HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        String error = favoriteService.removeById(id, user.getId());
        if (error != null) {
            attr.addFlashAttribute("error", error);
        } else {
            attr.addFlashAttribute("msg", "取消收藏成功");
        }
        return "redirect:/my/favorites";
    }
}
