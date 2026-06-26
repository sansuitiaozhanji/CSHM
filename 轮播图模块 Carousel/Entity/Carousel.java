package com.entity;

import java.util.Date;

public class Carousel {
    private Long id;
    private String imgUrl;      // 图片地址
    private String jumpUrl;     // 跳转链接
    private Integer sortNum;    // 排序权重
    private Date validStart;    // 生效时间
    private Date validEnd;      // 失效时间
    private Integer status;     // 0下架 1展示
    private Date createTime;

    // 无参、全参构造
    public Carousel(){}
    public Carousel(Long id, String imgUrl, String jumpUrl, Integer sortNum, Date validStart, Date validEnd, Integer status, Date createTime) {
        this.id = id;
        this.imgUrl = imgUrl;
        this.jumpUrl = jumpUrl;
        this.sortNum = sortNum;
        this.validStart = validStart;
        this.validEnd = validEnd;
        this.status = status;
        this.createTime = createTime;
    }

    // getter & setter
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getImgUrl() { return imgUrl; }
    public void setImgUrl(String imgUrl) { this.imgUrl = imgUrl; }
    public String getJumpUrl() { return jumpUrl; }
    public void setJumpUrl(String jumpUrl) { this.jumpUrl = jumpUrl; }
    public Integer getSortNum() { return sortNum; }
    public void setSortNum(Integer sortNum) { this.sortNum = sortNum; }
    public Date getValidStart() { return validStart; }
    public void setValidStart(Date validStart) { this.validStart = validStart; }
    public Date getValidEnd() { return validEnd; }
    public void setValidEnd(Date validEnd) { this.validEnd = validEnd; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}