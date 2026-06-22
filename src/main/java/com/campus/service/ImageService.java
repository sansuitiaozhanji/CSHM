package com.campus.service;

import com.campus.entity.Image;
import com.campus.mapper.ImageMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ImageService {

    private final ImageMapper imageMapper;

    public ImageService(ImageMapper imageMapper) {
        this.imageMapper = imageMapper;
    }

    public Image findById(Long id) {
        return imageMapper.findById(id);
    }

    public List<Image> findByProductId(Long productId) {
        return imageMapper.findByProductId(productId);
    }
}
