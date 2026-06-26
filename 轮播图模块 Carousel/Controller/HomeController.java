package com.controller;

import com.entity.Carousel;
import com.service.CarouselService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/home")
public class HomeController {
    @Resource
    private CarouselService carouselService;

    // 首页，加载轮播图
    @RequestMapping("/index")
    public String index(Model model){
        List<Carousel> carouselList = carouselService.getHomeCarousel();
        model.addAttribute("carouselList", carouselList);
        return "home/index";
    }

    // 轮播管理列表页
    @RequestMapping("/carousel/list")
    public String carouselList(HttpServletRequest req, Model model){
        String pageStr = req.getParameter("pageNum");
        int pageNum = 1;
        if(pageStr != null) pageNum = Integer.parseInt(pageStr);
        List<Carousel> pageData = carouselService.getCarouselPage(pageNum, 10);
        model.addAttribute("carouselList", pageData);
        model.addAttribute("pageNum", pageNum);
        return "carousel/list";
    }

    // 轮播详情
    @RequestMapping("/carousel/detail")
    public String carouselDetail(Long id, Model model){
        Carousel carousel = carouselService.getById(id);
        model.addAttribute("carousel", carousel);
        return "carousel/detail";
    }
}