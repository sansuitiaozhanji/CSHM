package com.mapper;

import com.entity.Announcement;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface AnnouncementMapper {
    // 前台展示公告（置顶优先）
    List<Announcement> selectFrontList();
    // 后台分页
    List<Announcement> selectAll(@Param("offset")int offset,@Param("limit")int limit);
    Announcement selectById(Long id);
    int insert(Announcement announcement);
    int update(Announcement announcement);
    int delete(Long id);
}