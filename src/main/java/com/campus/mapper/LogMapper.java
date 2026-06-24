package com.campus.mapper;

import com.campus.entity.Log;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface LogMapper {

    int insert(Log log);

    List<Log> findAll(@Param("keyword") String keyword);

    List<Log> findByUserId(@Param("userId") Long userId);

    List<Log> findByActionType(@Param("actionType") String actionType);
}
