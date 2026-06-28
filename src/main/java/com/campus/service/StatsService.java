package com.campus.service;

import com.campus.mapper.OrderMapper;
import com.campus.mapper.ProductMapper;
import com.campus.mapper.UserMapper;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.Map;

@Service
public class StatsService {

    private final UserMapper userMapper;
    private final ProductMapper productMapper;
    private final OrderMapper orderMapper;

    public StatsService(UserMapper userMapper, ProductMapper productMapper, OrderMapper orderMapper) {
        this.userMapper = userMapper;
        this.productMapper = productMapper;
        this.orderMapper = orderMapper;
    }

    public Map<String, Object> getDashboard() {
        Map<String, Object> stats = new LinkedHashMap<>();

        long totalUsers = userMapper.countAll();
        long activeUsers = userMapper.countByStatus(1);
        long disabledUsers = userMapper.countByStatus(0);

        long totalProducts = productMapper.countForList(null, null);
        long pendingProducts = productMapper.countAll(0);
        long onlineProducts = productMapper.countAll(1);

        long totalOrders = orderMapper.countAll();
        long pendingPayOrders = orderMapper.countByStatus(0);
        long pendingPickupOrders = orderMapper.countByStatus(1);
        long completedOrders = orderMapper.countByStatus(2);
        long cancelledOrders = orderMapper.countByStatus(3);

        stats.put("totalUsers", totalUsers);
        stats.put("activeUsers", activeUsers);
        stats.put("disabledUsers", disabledUsers);
        stats.put("totalProducts", totalProducts);
        stats.put("pendingProducts", pendingProducts);
        stats.put("onlineProducts", onlineProducts);
        stats.put("totalOrders", totalOrders);
        stats.put("pendingPayOrders", pendingPayOrders);
        stats.put("pendingPickupOrders", pendingPickupOrders);
        stats.put("completedOrders", completedOrders);
        stats.put("cancelledOrders", cancelledOrders);

        long completedTotal = completedOrders + cancelledOrders;
        if (completedTotal > 0) {
            double rate = (double) completedOrders / completedTotal * 100;
            stats.put("completionRate", String.format("%.1f", rate));
        } else {
            stats.put("completionRate", "0.0");
        }

        return stats;
    }
}
