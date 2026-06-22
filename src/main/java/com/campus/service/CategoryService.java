package com.campus.service;

import com.campus.entity.Category;
import com.campus.mapper.CategoryMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryService {

    private final CategoryMapper categoryMapper;

    public CategoryService(CategoryMapper categoryMapper) {
        this.categoryMapper = categoryMapper;
    }

    public List<Category> findAll() {
        return categoryMapper.findAll();
    }

    public Category findById(Long id) {
        return categoryMapper.findById(id);
    }
}
