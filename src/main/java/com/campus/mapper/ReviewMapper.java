package com.campus.mapper;

import com.campus.entity.Review;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ReviewMapper {

    Review findById(Long id);

    List<Review> findByProductId(Long productId);

    List<Review> findByUserId(Long userId);

    Review findByOrderId(Long orderId);

    List<Review> findAll();

    int insert(Review review);

    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    int deleteById(Long id);
}
