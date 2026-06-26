package com.campus.controller;

import com.campus.entity.Announcement;
import com.campus.service.AnnouncementService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class AnnouncementController {

    private final AnnouncementService announcementService;

    public AnnouncementController(AnnouncementService announcementService) {
        this.announcementService = announcementService;
    }

    @GetMapping("/announcement")
    public ModelAndView list() {
        ModelAndView mv = new ModelAndView("announcement/list");
        mv.addObject("announcements", announcementService.findAll());
        return mv;
    }

    @GetMapping("/announcement/{id}")
    public ModelAndView detail(@PathVariable Long id) {
        Announcement announcement = announcementService.findById(id);
        ModelAndView mv = new ModelAndView("announcement/detail");
        mv.addObject("announcement", announcement);
        return mv;
    }
}
