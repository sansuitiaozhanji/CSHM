package com.mapper;

import com.entity.Message;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface MessageMapper {
    // 查询用户收到的私信
    List<Message> selectByReceiver(@Param("receiverId")Long receiverId, @Param("offset")int offset, @Param("limit")int limit);
    Message selectById(Long id);
    int insert(Message message);
    // 标记已读
    int updateRead(Long id);
    int delete(Long id);
}