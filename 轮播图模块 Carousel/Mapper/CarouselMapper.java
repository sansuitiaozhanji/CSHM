package com.mapper;

import com.entity.Carousel;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface CarouselMapper {
    // 查询首页可用轮播（按排序降序）
    List<Carousel> selectValidCarousel();
    // 分页查询全部轮播
    List<Carousel> selectAll(@Param("offset") int offset, @Param("limit") int limit);
    // 根据ID查询
    Carousel selectById(Long id);
    // 新增
    int insert(Carousel carousel);
    // 修改
    int update(Carousel carousel);
    // 删除
    int deleteById(Long id);
}