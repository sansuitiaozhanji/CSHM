package com.campus.service;

import com.campus.entity.Order;
import com.campus.entity.Product;
import com.campus.mapper.OrderMapper;
import com.campus.mapper.ProductMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class OrderService {

    private final OrderMapper orderMapper;
    private final ProductMapper productMapper;
    private final WalletService walletService;

    public OrderService(OrderMapper orderMapper, ProductMapper productMapper, WalletService walletService) {
        this.orderMapper = orderMapper;
        this.productMapper = productMapper;
        this.walletService = walletService;
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

        Order order = new Order();
        order.setProductId(productId);
        order.setBuyerId(buyerId);
        order.setSellerId(product.getSellerId());
        order.setQuantity(1);
        order.setPrice(product.getPrice());
        order.setTotalPrice(product.getPrice());
        order.setRemark(remark);

        orderMapper.insert(order);

        // 下单后商品下架，防止重复购买
        productMapper.updateStatus(productId, 2, null);

        return null;
    }

    @Transactional
    public String pay(Long orderId, Long userId) {
        Order order = orderMapper.findById(orderId);
        if (order == null) {
            return "订单不存在";
        }
        if (!order.getBuyerId().equals(userId)) {
            return "无权操作此订单";
        }
        if (order.getStatus() != 0) {
            return "只有待付款状态的订单才能支付";
        }

        String err = walletService.pay(userId, orderId, order.getTotalPrice());
        if (err != null) {
            return err;
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
            return "只有待付款状态的订单才能取消";
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
            return "只有待自提状态的订单才能确认收货";
        }

        orderMapper.updateStatus(orderId, 2);

        // 卖家入账
        walletService.income(order.getSellerId(), orderId, order.getTotalPrice());

        return null;
    }
}
