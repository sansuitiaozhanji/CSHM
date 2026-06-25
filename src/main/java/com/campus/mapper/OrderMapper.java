package com.campus.mapper;

import com.campus.entity.Order;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OrderMapper {

    Order findById(Long id);

    List<Order> findByBuyerId(Long buyerId);

    List<Order> findBySellerId(Long sellerId);

    Order findActiveByProductId(Long productId);

    List<Order> findByProductId(Long productId);

    int insert(Order order);

    int update(Order order);

    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    int deleteById(Long id);
}
