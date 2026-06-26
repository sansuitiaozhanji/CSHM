package com.campus.entity;

import java.time.LocalDateTime;

public class Review {
    private Long id;
    private Long orderId;
    private Long productId;
    private Long userId;
    private Integer rating;
    private String content;
    private Integer status;
    private LocalDateTime createdAt;

    // 关联字段（非数据库字段）
    private Order order;
    private Product product;
    private User user;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }
    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public Order getOrder() { return order; }
    public void setOrder(Order order) { this.order = order; }
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    // 辅助方法：获取状态描述
    public String getStatusText() {
        if (status == null) return "";
        return switch (status) {
            case 0 -> "隐藏";
            case 1 -> "显示";
            default -> "";
        };
    }

    // 辅助方法：获取星级显示
    public String getRatingStars() {
        if (rating == null) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 5; i++) {
            if (i < rating) {
                sb.append("★");
            } else {
                sb.append("☆");
            }
        }
        return sb.toString();
    }
}
