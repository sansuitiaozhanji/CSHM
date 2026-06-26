package com.controller;

import com.entity.Message;
import com.service.MessageService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/message")
public class MessageController {
    @Resource
    private MessageService messageService;

    // 私信列表
    @RequestMapping("/list")
    public String msgList(HttpServletRequest req, Model model){
        // 模拟当前登录用户ID，实际从session取
        Long loginUserId = 1L;
        int pageNum = 1;
        String pageStr = req.getParameter("pageNum");
        if(pageStr != null) pageNum = Integer.parseInt(pageStr);
        List<Message> msgList = messageService.getUserMsg(loginUserId, pageNum, 10);
        model.addAttribute("msgList", msgList);
        model.addAttribute("pageNum", pageNum);
        return "message/list";
    }

    // 私信详情，同时标记已读
    @RequestMapping("/detail")
    public String msgDetail(Long id, Model model){
        messageService.markRead(id);
        Message msg = messageService.getMsgById(id);
        model.addAttribute("msg", msg);
        return "message/detail";
    }
}