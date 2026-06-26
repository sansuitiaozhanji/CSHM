package com.controller;

import com.entity.Announcement;
import com.service.AnnouncementService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/announcement")
public class AnnouncementController {
    @Resource
    private AnnouncementService announcementService;

    // 公告列表页
    @RequestMapping("/list")
    public String list(HttpServletRequest req, Model model){
        int pageNum = 1;
        String pageStr = req.getParameter("pageNum");
        if(pageStr != null) pageNum = Integer.parseInt(pageStr);
        List<Announcement> data = announcementService.getPage(pageNum, 10);
        model.addAttribute("annList", data);
        model.addAttribute("pageNum", pageNum);
        return "announcement/list";
    }

    // 公告详情
    @RequestMapping("/detail")
    public String detail(Long id, Model model){
        Announcement ann = announcementService.getById(id);
        model.addAttribute("ann", ann);
        return "announcement/detail";
    }
}