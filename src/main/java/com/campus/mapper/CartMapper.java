package com.campus.mapper;

import com.campus.entity.Cart;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CartMapper {

    Cart findById(Long id);

    List<Cart> findByUserId(Long userId);

    Cart findByUserIdAndProductId(@Param("userId") Long userId, @Param("productId") Long productId);

    int insert(Cart cart);

    int update(Cart cart);

    int updateQuantity(@Param("id") Long id, @Param("quantity") Integer quantity);

    int deleteById(Long id);

    int deleteByUserId(Long userId);

    int deleteByUserIdAndProductId(@Param("userId") Long userId, @Param("productId") Long productId);
}
