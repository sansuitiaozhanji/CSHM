package com.campus.controller.admin;

import com.campus.service.StatsService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

@Controller
public class AdminStatsController {

    private final StatsService statsService;

    public AdminStatsController(StatsService statsService) {
        this.statsService = statsService;
    }

    @GetMapping("/admin")
    public ModelAndView dashboard() {
        Map<String, Object> stats = statsService.getDashboard();
        ModelAndView mv = new ModelAndView("admin/dashboard");
        mv.addAllObjects(stats);
        return mv;
    }

    @GetMapping("/admin/stats/data")
    @ResponseBody
    public Map<String, Object> statsData() {
        return statsService.getDashboard();
    }
}
