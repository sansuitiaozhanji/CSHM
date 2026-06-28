package com.campus.service;

import com.campus.entity.Message;
import com.campus.mapper.MessageMapper;
import com.campus.mapper.UserMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class MessageService {

    private final MessageMapper messageMapper;
    private final UserMapper userMapper;
    private final SseService sseService;

    public MessageService(MessageMapper messageMapper, UserMapper userMapper, SseService sseService) {
        this.messageMapper = messageMapper;
        this.userMapper = userMapper;
        this.sseService = sseService;
    }

    public List<Message> findBySessionId(String sessionId) {
        return messageMapper.findBySessionId(sessionId);
    }

    public List<Message> findSessionsByUserId(Long userId) {
        return messageMapper.findSessionsByUserId(userId);
    }

    public int countUnread(Long userId) {
        return messageMapper.countUnread(userId);
    }

    public void markAsRead(String sessionId, Long userId) {
        messageMapper.markAsRead(sessionId, userId);
    }

    @Transactional
    public String send(Long senderId, Long receiverId, String content) {
        if (content == null || content.isBlank()) {
            return "消息内容不能为空";
        }
        if (senderId.equals(receiverId)) {
            return "不能给自己发消息";
        }
        if (userMapper.findById(receiverId) == null) {
            return "收件人不存在";
        }

        // 生成会话 ID（按 user_id 排序确保双方一致）
        String sessionId = senderId < receiverId
                ? senderId + "_" + receiverId
                : receiverId + "_" + senderId;

        Message message = new Message();
        message.setSessionId(sessionId);
        message.setSenderId(senderId);
        message.setReceiverId(receiverId);
        message.setContent(content);

        messageMapper.insert(message);

        // 通知接收方有新消息
        sseService.notify(receiverId);

        return null;
    }
}
