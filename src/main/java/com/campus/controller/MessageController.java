package com.campus.controller;

import com.campus.entity.Message;
import com.campus.entity.User;
import com.campus.service.MessageService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class MessageController {

    private final MessageService messageService;

    public MessageController(MessageService messageService) {
        this.messageService = messageService;
    }

    @GetMapping("/message")
    public ModelAndView sessions(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }
        ModelAndView mv = new ModelAndView("message/list");
        List<Message> sessions = messageService.findSessionsByUserId(user.getId());
        mv.addObject("sessions", sessions);
        mv.addObject("currentUserId", user.getId());
        return mv;
    }

    @GetMapping("/message/{sessionId}")
    public ModelAndView detail(@PathVariable String sessionId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }
        // 验证会话权限
        String[] ids = sessionId.split("_");
        if (ids.length != 2) {
            return new ModelAndView("redirect:/message");
        }
        Long id1 = Long.parseLong(ids[0]);
        Long id2 = Long.parseLong(ids[1]);
        if (!user.getId().equals(id1) && !user.getId().equals(id2)) {
            return new ModelAndView("redirect:/message");
        }

        // 标记已读
        messageService.markAsRead(sessionId, user.getId());

        ModelAndView mv = new ModelAndView("message/detail");
        List<Message> messages = messageService.findBySessionId(sessionId);
        mv.addObject("messages", messages);
        mv.addObject("sessionId", sessionId);
        mv.addObject("currentUserId", user.getId());
        // 获取对方用户信息
        Long otherId = user.getId().equals(id1) ? id2 : id1;
        mv.addObject("otherId", otherId);
        return mv;
    }

    @PostMapping("/message/send")
    public String send(@RequestParam String sessionId,
                       @RequestParam Long receiverId,
                       @RequestParam String content,
                       HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        String error = messageService.send(user.getId(), receiverId, content);
        if (error != null) {
            attr.addFlashAttribute("error", error);
        }
        return "redirect:/message/" + sessionId;
    }
}
