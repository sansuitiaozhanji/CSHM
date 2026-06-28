package com.campus.mapper;

import com.campus.entity.User;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;

public interface UserMapper {

    User findById(Long id);

    User findByUsername(String username);

    User findByPhone(String phone);

    User findByAccount(String account);

    int insert(User user);

    int update(User user);

    int updatePassword(@Param("id") Long id, @Param("password") String password);

    int updateBalance(@Param("id") Long id, @Param("balance") BigDecimal balance);

    List<User> findAll(@Param("keyword") String keyword);

    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    long countAll();

    long countByStatus(@Param("status") Integer status);
}
