package com.campus.controller.admin;

import com.campus.entity.Announcement;
import com.campus.entity.Carousel;
import com.campus.entity.Product;
import com.campus.service.AnnouncementService;
import com.campus.service.CarouselService;
import com.campus.service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class AdminContentController {

    private final AnnouncementService announcementService;
    private final CarouselService carouselService;
    private final ProductService productService;

    public AdminContentController(AnnouncementService announcementService,
                                  CarouselService carouselService,
                                  ProductService productService) {
        this.announcementService = announcementService;
        this.carouselService = carouselService;
        this.productService = productService;
    }

    @GetMapping("/admin/content")
    public ModelAndView index() {
        ModelAndView mv = new ModelAndView("admin/content");
        mv.addObject("announcements", announcementService.findAll());
        mv.addObject("carousels", carouselService.findAll());
        mv.addObject("products", productService.findAll(null, null, 1));
        return mv;
    }

    @PostMapping("/admin/content/announcement/save")
    public String saveAnnouncement(Announcement announcement, RedirectAttributes attr) {
        if (announcement.getTitle() == null || announcement.getTitle().isBlank()) {
            attr.addFlashAttribute("error", "公告标题不能为空");
            return "redirect:/admin/content";
        }
        announcementService.save(announcement);
        attr.addFlashAttribute("msg", announcement.getId() != null ? "公告已更新" : "公告已发布");
        return "redirect:/admin/content";
    }

    @PostMapping("/admin/content/announcement/{id}/delete")
    public String deleteAnnouncement(@PathVariable Long id, RedirectAttributes attr) {
        announcementService.delete(id);
        attr.addFlashAttribute("msg", "公告已删除");
        return "redirect:/admin/content";
    }

    @PostMapping("/admin/content/carousel/save")
    public String saveCarousel(Carousel carousel, RedirectAttributes attr) {
        if (carousel.getImageUrl() == null || carousel.getImageUrl().isBlank()) {
            attr.addFlashAttribute("error", "轮播图URL不能为空");
            return "redirect:/admin/content";
        }
        carouselService.save(carousel);
        attr.addFlashAttribute("msg", carousel.getId() != null ? "轮播图已更新" : "轮播图已添加");
        return "redirect:/admin/content";
    }

    @PostMapping("/admin/content/carousel/{id}/delete")
    public String deleteCarousel(@PathVariable Long id, RedirectAttributes attr) {
        carouselService.delete(id);
        attr.addFlashAttribute("msg", "轮播图已删除");
        return "redirect:/admin/content";
    }
}
