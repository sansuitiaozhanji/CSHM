package com.campus.service;

import com.campus.entity.Log;
import com.campus.mapper.LogMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LogService {

    private final LogMapper logMapper;

    public LogService(LogMapper logMapper) {
        this.logMapper = logMapper;
    }

    public void log(Long userId, String actionType, String description, String ipAddress) {
        Log log = new Log();
        log.setUserId(userId);
        log.setActionType(actionType);
        log.setDescription(description);
        log.setIpAddress(ipAddress);
        logMapper.insert(log);
    }

    public List<Log> findAll(String keyword) {
        return logMapper.findAll(keyword);
    }

    public List<Log> findByUserId(Long userId) {
        return logMapper.findByUserId(userId);
    }
}
