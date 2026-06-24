package com.campus.mapper;

import com.campus.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {

    User findById(Long id);

    User findByStudentId(String studentId);

    User findByEmail(String email);

    User findByAccount(String account);

    int insert(User user);

    int update(User user);

    int updatePassword(@Param("id") Long id, @Param("password") String password);

    List<User> findAll(@Param("keyword") String keyword);

    int updateStatus(@Param("id") Long id, @Param("status") Integer status);
}
