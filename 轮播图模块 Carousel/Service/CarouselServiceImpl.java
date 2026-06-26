package com.service.impl;

import com.entity.Carousel;
import com.mapper.CarouselMapper;
import com.service.CarouselService;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.List;

@Service
public class CarouselServiceImpl implements CarouselService {
    @Resource
    private CarouselMapper carouselMapper;

    @Override
    public List<Carousel> getHomeCarousel() {
        return carouselMapper.selectValidCarousel();
    }

    @Override
    public List<Carousel> getCarouselPage(int pageNum, int pageSize) {
        int offset = (pageNum - 1) * pageSize;
        return carouselMapper.selectAll(offset, pageSize);
    }

    @Override
    public Carousel getById(Long id) {
        return carouselMapper.selectById(id);
    }

    @Override
    public int add(Carousel carousel) {
        return carouselMapper.insert(carousel);
    }

    @Override
    public int edit(Carousel carousel) {
        return carouselMapper.update(carousel);
    }

    @Override
    public int delete(Long id) {
        return carouselMapper.deleteById(id);
    }
}