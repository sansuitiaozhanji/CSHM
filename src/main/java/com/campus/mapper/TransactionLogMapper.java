package com.campus.mapper;

import com.campus.entity.TransactionLog;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TransactionLogMapper {

    int insert(TransactionLog log);

    List<TransactionLog> findByUserId(@Param("userId") Long userId);
}
