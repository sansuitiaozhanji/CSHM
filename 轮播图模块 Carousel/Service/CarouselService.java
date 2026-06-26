package com.service;

import com.entity.Carousel;
import java.util.List;

public interface CarouselService {
    List<Carousel> getHomeCarousel();
    List<Carousel> getCarouselPage(int pageNum, int pageSize);
    Carousel getById(Long id);
    int add(Carousel carousel);
    int edit(Carousel carousel);
    int delete(Long id);
}