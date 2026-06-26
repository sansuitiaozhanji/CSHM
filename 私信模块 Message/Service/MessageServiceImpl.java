package com.service.impl;

import com.entity.Message;
import com.mapper.MessageMapper;
import com.service.MessageService;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.List;

@Service
public class MessageServiceImpl implements MessageService {
    @Resource
    private MessageMapper messageMapper;

    @Override
    public List<Message> getUserMsg(Long receiverId, int pageNum, int pageSize) {
        int offset = (pageNum-1)*pageSize;
        return messageMapper.selectByReceiver(receiverId, offset, pageSize);
    }

    @Override
    public Message getMsgById(Long id) {
        return messageMapper.selectById(id);
    }

    @Override
    public int sendMsg(Message message) {
        return messageMapper.insert(message);
    }

    @Override
    public int markRead(Long id) {
        return messageMapper.updateRead(id);
    }

    @Override
    public int deleteMsg(Long id) {
        return messageMapper.delete(id);
    }
}