package com.campus.mapper;

import com.campus.entity.Message;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MessageMapper {

    Message findById(Long id);

    List<Message> findBySessionId(@Param("sessionId") String sessionId);

    List<Message> findSessionsByUserId(@Param("userId") Long userId);

    int insert(Message message);

    int markAsRead(@Param("sessionId") String sessionId, @Param("userId") Long userId);

    int countUnread(@Param("userId") Long userId);
}
