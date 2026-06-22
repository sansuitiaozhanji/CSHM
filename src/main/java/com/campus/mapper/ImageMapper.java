package com.campus.mapper;

import com.campus.entity.Image;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ImageMapper {

    Image findById(Long id);

    List<Image> findByProductId(Long productId);

    List<Image> findByProductIds(List<Long> productIds);

    int insert(Image image);

    int batchInsert(@Param("images") List<Image> images);

    int deleteByProductId(Long productId);

    int deleteById(Long id);
}
