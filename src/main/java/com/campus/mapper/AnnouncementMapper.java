package com.campus.mapper;

import com.campus.entity.Announcement;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface AnnouncementMapper {

    Announcement findById(Long id);

    List<Announcement> findAll();

    List<Announcement> findPublished(@Param("type") Integer type);

    int insert(Announcement announcement);

    int update(Announcement announcement);

    int deleteById(Long id);
}
