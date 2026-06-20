package com.campus.mapper;

import com.campus.entity.Category;
import java.util.List;

public interface CategoryMapper {

    Category findById(Long id);

    Category findByName(String name);

    List<Category> findAll();

    int insert(Category category);

    int update(Category category);

    int deleteById(Long id);
}
