package com.campus.service;

import com.campus.entity.Carousel;
import com.campus.mapper.CarouselMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CarouselService {

    private final CarouselMapper carouselMapper;

    public CarouselService(CarouselMapper carouselMapper) {
        this.carouselMapper = carouselMapper;
    }

    public List<Carousel> findAll() {
        return carouselMapper.findAll();
    }

    public void save(Carousel carousel) {
        if (carousel.getId() != null) {
            carouselMapper.update(carousel);
        } else {
            carousel.setStatus(1);
            carouselMapper.insert(carousel);
        }
    }

    public void delete(Long id) {
        carouselMapper.deleteById(id);
    }
}
