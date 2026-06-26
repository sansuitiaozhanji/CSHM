package com.campus.service;

import com.campus.entity.Order;
import com.campus.entity.Review;
import com.campus.mapper.OrderMapper;
import com.campus.mapper.ReviewMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ReviewService {

    private final ReviewMapper reviewMapper;
    private final OrderMapper orderMapper;

    public ReviewService(ReviewMapper reviewMapper, OrderMapper orderMapper) {
        this.reviewMapper = reviewMapper;
        this.orderMapper = orderMapper;
    }

    public Review findById(Long id) {
        return reviewMapper.findById(id);
    }

    public List<Review> findByProductId(Long productId) {
        return reviewMapper.findByProductId(productId);
    }

    public List<Review> findByUserId(Long userId) {
        return reviewMapper.findByUserId(userId);
    }

    public Review findByOrderId(Long orderId) {
        return reviewMapper.findByOrderId(orderId);
    }

    public List<Review> findAll() {
        return reviewMapper.findAll();
    }

    @Transactional
    public String create(Long orderId, Long userId, Integer rating, String content) {
        Order order = orderMapper.findById(orderId);
        if (order == null) {
            return "订单不存在";
        }
        if (!order.getBuyerId().equals(userId)) {
            return "无权操作此订单";
        }
        if (order.getStatus() != 2) {
            return "只有已完成的订单才能评价";
        }

        // 检查是否已评价过
        Review existing = reviewMapper.findByOrderId(orderId);
        if (existing != null) {
            return "该订单已评价过";
        }

        // 验证评分范围
        if (rating == null || rating < 1 || rating > 5) {
            return "评分必须在1-5之间";
        }

        Review review = new Review();
        review.setOrderId(orderId);
        review.setProductId(order.getProductId());
        review.setUserId(userId);
        review.setRating(rating);
        review.setContent(content);

        reviewMapper.insert(review);

        return null;
    }

    @Transactional
    public String updateStatus(Long id, Integer status, boolean isAdmin) {
        if (!isAdmin) {
            return "无权操作";
        }
        Review review = reviewMapper.findById(id);
        if (review == null) {
            return "评价不存在";
        }
        reviewMapper.updateStatus(id, status);
        return null;
    }

    @Transactional
    public String delete(Long id, Long userId, boolean isAdmin) {
        Review review = reviewMapper.findById(id);
        if (review == null) {
            return "评价不存在";
        }
        if (!isAdmin && !review.getUserId().equals(userId)) {
            return "无权操作此评价";
        }
        reviewMapper.deleteById(id);
        return null;
    }
}
