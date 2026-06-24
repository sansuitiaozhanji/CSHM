package com.campus.controller.admin;

import com.campus.service.LogService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class AdminLogController {

    private final LogService logService;

    public AdminLogController(LogService logService) {
        this.logService = logService;
    }

    @GetMapping("/admin/logs")
    public ModelAndView list(@RequestParam(required = false, defaultValue = "") String keyword) {
        ModelAndView mv = new ModelAndView("admin/log-list");
        mv.addObject("logs", logService.findAll(keyword));
        mv.addObject("keyword", keyword);
        return mv;
    }
}
