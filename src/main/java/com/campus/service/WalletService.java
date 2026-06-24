package com.campus.service;

import com.campus.entity.TransactionLog;
import com.campus.entity.User;
import com.campus.mapper.TransactionLogMapper;
import com.campus.mapper.UserMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
public class WalletService {

    private final UserMapper userMapper;
    private final TransactionLogMapper transactionLogMapper;

    public WalletService(UserMapper userMapper, TransactionLogMapper transactionLogMapper) {
        this.userMapper = userMapper;
        this.transactionLogMapper = transactionLogMapper;
    }

    public BigDecimal getBalance(Long userId) {
        User user = userMapper.findById(userId);
        return user != null ? user.getBalance() : BigDecimal.ZERO;
    }

    public List<TransactionLog> getTransactions(Long userId) {
        return transactionLogMapper.findByUserId(userId);
    }

    @Transactional
    public void initBalance(Long userId) {
        User user = userMapper.findById(userId);
        if (user == null) return;

        BigDecimal before = user.getBalance();
        BigDecimal amount = new BigDecimal("1000.00");
        BigDecimal after = before.add(amount);

        userMapper.updateBalance(userId, after);

        TransactionLog tlog = new TransactionLog();
        tlog.setUserId(userId);
        tlog.setType("INIT");
        tlog.setAmount(amount);
        tlog.setBalanceBefore(before);
        tlog.setBalanceAfter(after);
        tlog.setDescription("注册赠送初始余额");
        transactionLogMapper.insert(tlog);
    }

    @Transactional
    public String recharge(Long userId, BigDecimal amount) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return "充值金额必须大于0";
        }
        User user = userMapper.findById(userId);
        if (user == null) return "用户不存在";

        BigDecimal before = user.getBalance();
        BigDecimal after = before.add(amount);

        userMapper.updateBalance(userId, after);

        TransactionLog tlog = new TransactionLog();
        tlog.setUserId(userId);
        tlog.setType("RECHARGE");
        tlog.setAmount(amount);
        tlog.setBalanceBefore(before);
        tlog.setBalanceAfter(after);
        tlog.setDescription("管理员充值");
        transactionLogMapper.insert(tlog);

        return null;
    }
}
