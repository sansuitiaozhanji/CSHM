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

    @Transactional
    public String pay(Long userId, Long orderId, BigDecimal amount) {
        User user = userMapper.findById(userId);
        if (user == null) return "用户不存在";
        if (user.getBalance().compareTo(amount) < 0) {
            return "余额不足，请联系管理员充值";
        }

        BigDecimal before = user.getBalance();
        BigDecimal after = before.subtract(amount);

        userMapper.updateBalance(userId, after);

        TransactionLog tlog = new TransactionLog();
        tlog.setUserId(userId);
        tlog.setOrderId(orderId);
        tlog.setType("PAY");
        tlog.setAmount(amount.negate());
        tlog.setBalanceBefore(before);
        tlog.setBalanceAfter(after);
        tlog.setDescription("订单支付 #" + orderId);
        transactionLogMapper.insert(tlog);

        return null;
    }

    @Transactional
    public void income(Long userId, Long orderId, BigDecimal amount) {
        User user = userMapper.findById(userId);
        if (user == null) return;

        BigDecimal before = user.getBalance();
        BigDecimal after = before.add(amount);

        userMapper.updateBalance(userId, after);

        TransactionLog tlog = new TransactionLog();
        tlog.setUserId(userId);
        tlog.setOrderId(orderId);
        tlog.setType("INCOME");
        tlog.setAmount(amount);
        tlog.setBalanceBefore(before);
        tlog.setBalanceAfter(after);
        tlog.setDescription("订单入账 #" + orderId);
        transactionLogMapper.insert(tlog);
    }

    @Transactional
    public void refund(Long userId, Long orderId, BigDecimal amount) {
        User user = userMapper.findById(userId);
        if (user == null) return;

        BigDecimal before = user.getBalance();
        BigDecimal after = before.add(amount);

        userMapper.updateBalance(userId, after);

        TransactionLog tlog = new TransactionLog();
        tlog.setUserId(userId);
        tlog.setOrderId(orderId);
        tlog.setType("REFUND");
        tlog.setAmount(amount);
        tlog.setBalanceBefore(before);
        tlog.setBalanceAfter(after);
        tlog.setDescription("订单退款 #" + orderId);
        transactionLogMapper.insert(tlog);
    }
}
