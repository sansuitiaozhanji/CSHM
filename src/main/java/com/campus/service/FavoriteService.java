package com.campus.service;

import com.campus.entity.Favorite;
import com.campus.entity.Product;
import com.campus.mapper.FavoriteMapper;
import com.campus.mapper.ProductMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class FavoriteService {

    private final FavoriteMapper favoriteMapper;
    private final ProductMapper productMapper;

    public FavoriteService(FavoriteMapper favoriteMapper, ProductMapper productMapper) {
        this.favoriteMapper = favoriteMapper;
        this.productMapper = productMapper;
    }

    public List<Favorite> findByUserId(Long userId) {
        return favoriteMapper.findByUserId(userId);
    }

    public boolean isFavorited(Long userId, Long productId) {
        return favoriteMapper.findByUserIdAndProductId(userId, productId) != null;
    }

    @Transactional
    public String add(Long userId, Long productId) {
        Product product = productMapper.findById(productId);
        if (product == null) {
            return "商品不存在";
        }
        if (product.getStatus() != 1) {
            return "只能收藏已上架的商品";
        }
        if (product.getSellerId().equals(userId)) {
            return "不能收藏自己的商品";
        }

        // 检查是否已收藏
        Favorite existing = favoriteMapper.findByUserIdAndProductId(userId, productId);
        if (existing != null) {
            return "已经收藏过该商品";
        }

        Favorite favorite = new Favorite();
        favorite.setUserId(userId);
        favorite.setProductId(productId);

        favoriteMapper.insert(favorite);

        return null;
    }

    @Transactional
    public String remove(Long userId, Long productId) {
        Favorite existing = favoriteMapper.findByUserIdAndProductId(userId, productId);
        if (existing == null) {
            return "未收藏该商品";
        }
        favoriteMapper.deleteByUserIdAndProductId(userId, productId);
        return null;
    }

    @Transactional
    public String removeById(Long id, Long userId) {
        Favorite favorite = favoriteMapper.findById(id);
        if (favorite == null) {
            return "收藏不存在";
        }
        if (!favorite.getUserId().equals(userId)) {
            return "无权操作此收藏";
        }
        favoriteMapper.deleteById(id);
        return null;
    }
}
