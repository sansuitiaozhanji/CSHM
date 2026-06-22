package com.campus.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class Product {
    private Long id;
    private Long sellerId;
    private Long categoryId;
    private String title;
    private String description;
    private BigDecimal price;
    private Integer condition;
    private Integer status;
    private String rejectReason;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 关联字段（非数据库字段）
    private User seller;
    private Category category;
    private List<Image> images;
    private String firstImageUrl;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getSellerId() { return sellerId; }
    public void setSellerId(Long sellerId) { this.sellerId = sellerId; }
    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public Integer getCondition() { return condition; }
    public void setCondition(Integer condition) { this.condition = condition; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public String getRejectReason() { return rejectReason; }
    public void setRejectReason(String rejectReason) { this.rejectReason = rejectReason; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    public User getSeller() { return seller; }
    public void setSeller(User seller) { this.seller = seller; }
    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }
    public List<Image> getImages() { return images; }
    public void setImages(List<Image> images) { this.images = images; }
    public String getFirstImageUrl() { return firstImageUrl; }
    public void setFirstImageUrl(String firstImageUrl) { this.firstImageUrl = firstImageUrl; }

    // 辅助方法：获取成色描述
    public String getConditionText() {
        if (condition == null) return "";
        return switch (condition) {
            case 1 -> "全新";
            case 2 -> "九五新";
            case 3 -> "八五新";
            case 4 -> "七成新及以下";
            default -> "";
        };
    }

    // 辅助方法：获取状态描述
    public String getStatusText() {
        if (status == null) return "";
        return switch (status) {
            case 0 -> "待审核";
            case 1 -> "已上架";
            case 2 -> "已下架";
            case 3 -> "审核驳回";
            default -> "";
        };
    }
}
