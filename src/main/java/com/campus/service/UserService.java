package com.campus.service;

import com.campus.entity.User;
import com.campus.mapper.UserMapper;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class UserService {

    private final UserMapper userMapper;
    private final WalletService walletService;
    private final LogService logService;

    public UserService(UserMapper userMapper, WalletService walletService, LogService logService) {
        this.userMapper = userMapper;
        this.walletService = walletService;
        this.logService = logService;
    }

    public String register(User user, String ip) {
        if (user.getStudentId() == null || user.getStudentId().isBlank()) {
            return "学号不能为空";
        }
        if (user.getName() == null || user.getName().isBlank()) {
            return "姓名不能为空";
        }
        if (user.getEmail() == null || !user.getEmail().matches("^[\\w.+-]+@[\\w-]+\\.edu\\.cn$")) {
            return "邮箱格式不正确，需为学校邮箱（@xx.edu.cn）";
        }
        if (user.getPassword() == null || user.getPassword().length() < 6) {
            return "密码不能少于6位";
        }
        if (userMapper.findByStudentId(user.getStudentId()) != null) {
            return "该学号已被注册";
        }
        if (userMapper.findByEmail(user.getEmail()) != null) {
            return "该邮箱已被注册";
        }

        user.setPassword(BCrypt.hashpw(user.getPassword(), BCrypt.gensalt()));
        user.setBalance(BigDecimal.ZERO);
        user.setRole(0);
        user.setStatus(1);
        userMapper.insert(user);

        walletService.initBalance(user.getId());
        logService.log(user.getId(), "REGISTER", "用户 " + user.getName() + " 注册成功", ip);

        return null;
    }

    public User login(String account, String password, String ip) {
        if (account == null || account.isBlank() || password == null || password.isBlank()) {
            return null;
        }
        User user = userMapper.findByAccount(account);
        if (user == null) {
            return null;
        }
        if (user.getStatus() == 0) {
            logService.log(user.getId(), "LOGIN_FAIL", "账号 " + user.getStudentId() + " 已被禁用，登录失败", ip);
            return null;
        }
        if (!BCrypt.checkpw(password, user.getPassword())) {
            logService.log(user.getId(), "LOGIN_FAIL", "用户 " + user.getStudentId() + " 密码错误", ip);
            return null;
        }
        logService.log(user.getId(), "LOGIN", "用户 " + user.getStudentId() + " 登录成功", ip);
        return user;
    }

    public User findById(Long id) {
        return userMapper.findById(id);
    }

    public String updateProfile(User user) {
        if (user.getName() == null || user.getName().isBlank()) {
            return "姓名不能为空";
        }
        userMapper.update(user);
        return null;
    }

    public String updatePassword(Long id, String oldPassword, String newPassword) {
        if (newPassword == null || newPassword.length() < 6) {
            return "新密码不能少于6位";
        }
        User user = userMapper.findById(id);
        if (user == null || !BCrypt.checkpw(oldPassword, user.getPassword())) {
            return "原密码不正确";
        }
        userMapper.updatePassword(id, BCrypt.hashpw(newPassword, BCrypt.gensalt()));
        return null;
    }

    public List<User> findAllUsers(String keyword) {
        return userMapper.findAll(keyword);
    }

    public void toggleUserStatus(Long id) {
        User user = userMapper.findById(id);
        if (user != null) {
            int newStatus = user.getStatus() == 1 ? 0 : 1;
            userMapper.updateStatus(id, newStatus);
        }
    }
}
