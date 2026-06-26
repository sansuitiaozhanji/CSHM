package com.entity;

import java.util.Date;

public class Announcement {
    private Long id;
    private String title;
    private String content;
    private Integer isTop; //0普通 1置顶
    private Integer status;//0下架 1正常
    private Date publishTime;
    private Long createAdmin;
    private Date createTime;

    // 构造、getter/setter
    public Announcement(){}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Integer getIsTop() { return isTop; }
    public void setIsTop(Integer isTop) { this.isTop = isTop; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public Date getPublishTime() { return publishTime; }
    public void setPublishTime(Date publishTime) { this.publishTime = publishTime; }
    public Long getCreateAdmin() { return createAdmin; }
    public void setCreateAdmin(Long createAdmin) { this.createAdmin = createAdmin; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}