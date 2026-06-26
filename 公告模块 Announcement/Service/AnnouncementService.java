package com.service;

import com.entity.Announcement;
import java.util.List;

public interface AnnouncementService {
    List<Announcement> getFrontAnnouncement();
    List<Announcement> getPage(int pageNum, int pageSize);
    Announcement getById(Long id);
    int add(Announcement announcement);
    int edit(Announcement announcement);
    int delete(Long id);
}