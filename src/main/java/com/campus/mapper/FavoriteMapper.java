package com.campus.mapper;

import com.campus.entity.Favorite;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface FavoriteMapper {

    Favorite findById(Long id);

    List<Favorite> findByUserId(Long userId);

    Favorite findByUserIdAndProductId(@Param("userId") Long userId, @Param("productId") Long productId);

    int insert(Favorite favorite);

    int deleteById(Long id);

    int deleteByUserIdAndProductId(@Param("userId") Long userId, @Param("productId") Long productId);
}
