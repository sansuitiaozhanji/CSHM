package com.campus.service;

import com.campus.entity.Cart;
import com.campus.entity.Order;
import com.campus.entity.Product;
import com.campus.mapper.CartMapper;
import com.campus.mapper.OrderMapper;
import com.campus.mapper.ProductMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
public class CartService {

    private final CartMapper cartMapper;
    private final ProductMapper productMapper;
    private final OrderMapper orderMapper;

    public CartService(CartMapper cartMapper, ProductMapper productMapper, OrderMapper orderMapper) {
        this.cartMapper = cartMapper;
        this.productMapper = productMapper;
        this.orderMapper = orderMapper;
    }

    public List<Cart> findByUserId(Long userId) {
        return cartMapper.findByUserId(userId);
    }

    public BigDecimal getTotalPrice(Long userId) {
        List<Cart> carts = cartMapper.findByUserId(userId);
        BigDecimal total = BigDecimal.ZERO;
        for (Cart cart : carts) {
            if (cart.getProduct() != null && cart.getProduct().getStatus() == 1) {
                total = total.add(cart.getSubtotal());
            }
        }
        return total;
    }

    @Transactional
    public String add(Long userId, Long productId, Integer quantity) {
        Product product = productMapper.findById(productId);
        if (product == null) {
            return "商品不存在";
        }
        if (product.getStatus() != 1) {
            return "只能加入已上架的商品";
        }
        if (product.getSellerId().equals(userId)) {
            return "不能加入自己的商品";
        }
        if (quantity == null || quantity < 1) {
            quantity = 1;
        }

        // 检查是否已在购物车
        Cart existing = cartMapper.findByUserIdAndProductId(userId, productId);
        if (existing != null) {
            // 已存在，增加数量
            existing.setQuantity(existing.getQuantity() + quantity);
            cartMapper.update(existing);
        } else {
            // 新增
            Cart cart = new Cart();
            cart.setUserId(userId);
            cart.setProductId(productId);
            cart.setQuantity(quantity);
            cartMapper.insert(cart);
        }

        return null;
    }

    @Transactional
    public String updateQuantity(Long id, Long userId, Integer quantity) {
        Cart cart = cartMapper.findById(id);
        if (cart == null) {
            return "购物车项不存在";
        }
        if (!cart.getUserId().equals(userId)) {
            return "无权操作此购物车";
        }
        if (quantity == null || quantity < 1) {
            return "数量至少为1";
        }
        cartMapper.updateQuantity(id, quantity);
        return null;
    }

    @Transactional
    public String remove(Long id, Long userId) {
        Cart cart = cartMapper.findById(id);
        if (cart == null) {
            return "购物车项不存在";
        }
        if (!cart.getUserId().equals(userId)) {
            return "无权操作此购物车";
        }
        cartMapper.deleteById(id);
        return null;
    }

    @Transactional
    public String clear(Long userId) {
        cartMapper.deleteByUserId(userId);
        return null;
    }

    @Transactional
    public String checkout(Long userId) {
        List<Cart> carts = cartMapper.findByUserId(userId);
        if (carts.isEmpty()) {
            return "购物车为空";
        }

        for (Cart cart : carts) {
            Product product = cart.getProduct();
            if (product == null || product.getStatus() != 1) {
                return "商品「" + (product != null ? product.getTitle() : "未知") + "」已下架，请先移除";
            }
            if (product.getSellerId().equals(userId)) {
                return "不能购买自己的商品「" + product.getTitle() + "」";
            }

            Order order = new Order();
            order.setProductId(cart.getProductId());
            order.setBuyerId(userId);
            order.setSellerId(product.getSellerId());
            order.setQuantity(cart.getQuantity());
            order.setPrice(product.getPrice());
            order.setTotalPrice(product.getPrice().multiply(BigDecimal.valueOf(cart.getQuantity())));
            orderMapper.insert(order);

            productMapper.updateStatus(cart.getProductId(), 2, null);
        }

        cartMapper.deleteByUserId(userId);
        return null;
    }
}
