package com.campus.service;

import com.campus.entity.Announcement;
import com.campus.mapper.AnnouncementMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AnnouncementService {

    private final AnnouncementMapper announcementMapper;

    public AnnouncementService(AnnouncementMapper announcementMapper) {
        this.announcementMapper = announcementMapper;
    }

    public List<Announcement> findAll() {
        return announcementMapper.findAll();
    }

    public Announcement findById(Long id) {
        return announcementMapper.findById(id);
    }

    public void save(Announcement announcement) {
        if (announcement.getId() != null) {
            announcementMapper.update(announcement);
        } else {
            announcement.setStatus(1);
            announcementMapper.insert(announcement);
        }
    }

    public void delete(Long id) {
        announcementMapper.deleteById(id);
    }
}
