package com.service;

import com.entity.Message;
import java.util.List;

public interface MessageService {
    List<Message> getUserMsg(Long receiverId, int pageNum, int pageSize);
    Message getMsgById(Long id);
    int sendMsg(Message message);
    int markRead(Long id);
    int deleteMsg(Long id);
}