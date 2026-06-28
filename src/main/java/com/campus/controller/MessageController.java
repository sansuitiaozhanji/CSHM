package com.campus.controller;

import com.campus.common.Result;
import com.campus.entity.Message;
import com.campus.entity.User;
import com.campus.service.MessageService;
import com.campus.service.SseService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;

@Controller
public class MessageController {

    private final MessageService messageService;
    private final SseService sseService;

    public MessageController(MessageService messageService, SseService sseService) {
        this.messageService = messageService;
        this.sseService = sseService;
    }

    @GetMapping("/message")
    public ModelAndView sessions(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return new ModelAndView("redirect:/login");
        ModelAndView mv = new ModelAndView("message/list");
        List<Message> sessions = messageService.findSessionsByUserId(user.getId());
        mv.addObject("sessions", sessions);
        mv.addObject("currentUserId", user.getId());
        return mv;
    }

    @GetMapping("/message/{sessionId}")
    public ModelAndView detail(@PathVariable String sessionId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return new ModelAndView("redirect:/login");
        String[] ids = sessionId.split("_");
        if (ids.length != 2) return new ModelAndView("redirect:/message");
        Long id1 = Long.parseLong(ids[0]);
        Long id2 = Long.parseLong(ids[1]);
        if (!user.getId().equals(id1) && !user.getId().equals(id2)) {
            return new ModelAndView("redirect:/message");
        }

        messageService.markAsRead(sessionId, user.getId());

        ModelAndView mv = new ModelAndView("message/detail");
        List<Message> messages = messageService.findBySessionId(sessionId);
        mv.addObject("messages", messages);
        mv.addObject("sessionId", sessionId);
        mv.addObject("currentUserId", user.getId());
        Long otherId = user.getId().equals(id1) ? id2 : id1;
        mv.addObject("otherId", otherId);
        return mv;
    }

    @PostMapping("/message/send")
    @ResponseBody
    public Result send(@RequestParam String sessionId,
                       @RequestParam Long receiverId,
                       @RequestParam String content,
                       HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return Result.error(401, "未登录");
        String error = messageService.send(user.getId(), receiverId, content);
        if (error != null) return Result.error(400, error);
        return Result.success("发送成功");
    }

    @GetMapping("/message/stream")
    @ResponseBody
    public SseEmitter stream(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            SseEmitter emitter = new SseEmitter(0L);
            emitter.complete();
            return emitter;
        }
        return sseService.subscribe(user.getId());
    }
}
