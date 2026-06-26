package com.campus.entity;

import java.time.LocalDateTime;

public class Favorite {
    private Long id;
    private Long userId;
    private Long productId;
    private LocalDateTime createdAt;

    // 关联字段（非数据库字段）
    private Product product;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
}
