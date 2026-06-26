package com.campus.entity;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Announcement {
    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    private Long id;
    private String title;
    private String content;
    private Integer type;
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Integer getType() { return type; }
    public void setType(Integer type) { this.type = type; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getCreatedAtStr() { return createdAt != null ? createdAt.format(FMT) : ""; }
    public String getUpdatedAtStr() { return updatedAt != null ? updatedAt.format(FMT) : ""; }
    public String getTypeStr() {
        switch (type != null ? type : 0) {
            case 0: return "系统公告";
            case 1: return "交易须知";
            case 2: return "资讯";
            default: return "未知";
        }
    }
}
