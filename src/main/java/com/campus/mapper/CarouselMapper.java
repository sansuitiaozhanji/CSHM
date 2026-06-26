package com.campus.mapper;

import com.campus.entity.Carousel;

import java.util.List;

public interface CarouselMapper {

    Carousel findById(Long id);

    List<Carousel> findAll();

    List<Carousel> findActive();

    int insert(Carousel carousel);

    int update(Carousel carousel);

    int deleteById(Long id);
}
