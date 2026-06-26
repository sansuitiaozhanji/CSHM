package com.service.impl;

import com.entity.Announcement;
import com.mapper.AnnouncementMapper;
import com.service.AnnouncementService;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.List;

@Service
public class AnnouncementServiceImpl implements AnnouncementService {
    @Resource
    private AnnouncementMapper announcementMapper;

    @Override
    public List<Announcement> getFrontAnnouncement() {
        return announcementMapper.selectFrontList();
    }

    @Override
    public List<Announcement> getPage(int pageNum, int pageSize) {
        int offset = (pageNum-1)*pageSize;
        return announcementMapper.selectAll(offset, pageSize);
    }

    @Override
    public Announcement getById(Long id) {
        return announcementMapper.selectById(id);
    }

    @Override
    public int add(Announcement announcement) {
        return announcementMapper.insert(announcement);
    }

    @Override
    public int edit(Announcement announcement) {
        return announcementMapper.update(announcement);
    }

    @Override
    public int delete(Long id) {
        return announcementMapper.delete(id);
    }
}