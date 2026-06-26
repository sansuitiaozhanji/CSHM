package com.campus.service;

import com.campus.entity.Order;
import com.campus.entity.Product;
import com.campus.mapper.OrderMapper;
import com.campus.mapper.ProductMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
public class OrderService {

    private final OrderMapper orderMapper;
    private final ProductMapper productMapper;

    public OrderService(OrderMapper orderMapper, ProductMapper productMapper) {
        this.orderMapper = orderMapper;
        this.productMapper = productMapper;
    }

    public Order findById(Long id) {
        return orderMapper.findById(id);
    }

    public List<Order> findByBuyerId(Long buyerId) {
        return orderMapper.findByBuyerId(buyerId);
    }

    public List<Order> findBySellerId(Long sellerId) {
        return orderMapper.findBySellerId(sellerId);
    }

    @Transactional
    public String create(Long productId, Long buyerId, String remark) {
        Product product = productMapper.findById(productId);
        if (product == null) {
            return "商品不存在";
        }
        if (product.getStatus() != 1) {
            return "商品未上架，无法购买";
        }
        if (product.getSellerId().equals(buyerId)) {
            return "不能购买自己的商品";
        }

        // 检查是否有活跃订单
        Order activeOrder = orderMapper.findActiveByProductId(productId);
        if (activeOrder != null) {
            return "该商品已有进行中的订单";
        }

        Order order = new Order();
        order.setProductId(productId);
        order.setBuyerId(buyerId);
        order.setSellerId(product.getSellerId());
        order.setQuantity(1);
        order.setPrice(product.getPrice());
        order.setTotalPrice(product.getPrice());
        order.setRemark(remark);

        orderMapper.insert(order);

        // 商品自动下架
        productMapper.updateStatus(productId, 2, null);

        return null;
    }

    @Transactional
    public String confirm(Long orderId, Long userId) {
        Order order = orderMapper.findById(orderId);
        if (order == null) {
            return "订单不存在";
        }
        if (!order.getSellerId().equals(userId)) {
            return "无权操作此订单";
        }
        if (order.getStatus() != 0) {
            return "只有待确认状态的订单才能确认";
        }

        orderMapper.updateStatus(orderId, 1);
        return null;
    }

    @Transactional
    public String cancel(Long orderId, Long userId) {
        Order order = orderMapper.findById(orderId);
        if (order == null) {
            return "订单不存在";
        }
        if (!order.getBuyerId().equals(userId) && !order.getSellerId().equals(userId)) {
            return "无权操作此订单";
        }
        if (order.getStatus() != 0) {
            return "只有待确认状态的订单才能取消";
        }

        orderMapper.updateStatus(orderId, 3);

        // 商品重新上架
        productMapper.updateStatus(order.getProductId(), 1, null);

        return null;
    }

    @Transactional
    public String complete(Long orderId, Long userId) {
        Order order = orderMapper.findById(orderId);
        if (order == null) {
            return "订单不存在";
        }
        if (!order.getBuyerId().equals(userId)) {
            return "无权操作此订单";
        }
        if (order.getStatus() != 1) {
            return "只有进行中状态的订单才能完成";
        }

        orderMapper.updateStatus(orderId, 2);
        return null;
    }
}
