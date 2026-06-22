package com.campus.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class FileService {

    @Value("${file.upload-dir:uploads}")
    private String uploadDir;

    @Value("${file.access-url:/uploads}")
    private String accessUrl;

    public String upload(MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            throw new IOException("文件不能为空");
        }

        String originalFilename = file.getOriginalFilename();
        String extension = originalFilename != null ?
                originalFilename.substring(originalFilename.lastIndexOf(".")) : ".jpg";
        String newFilename = UUID.randomUUID().toString() + extension;

        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Path filePath = uploadPath.resolve(newFilename);
        Files.copy(file.getInputStream(), filePath);

        return accessUrl + "/" + newFilename;
    }
}
