-- =============================================================
-- 校园二手交易平台 — 数据库初始化脚本（简化版）
-- 数据库：MySQL 8.0+
-- 字符集：utf8mb4
-- 表数量：13
-- =============================================================

CREATE DATABASE IF NOT EXISTS campus_secondhand
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE campus_secondhand;

-- =============================================================
-- 1. 用户表（user）
-- =============================================================
DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
    `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '用户 ID',
    `username`   VARCHAR(50)  NOT NULL COMMENT '用户名（字母开头，字母数字混合）',
    `password`   VARCHAR(255) NOT NULL COMMENT 'BCrypt 加密密码',
    `phone`      VARCHAR(20)  NOT NULL COMMENT '手机号',
    `avatar`     VARCHAR(255) DEFAULT NULL COMMENT '头像 URL',
    `balance`    DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '虚拟余额',
    `role`       TINYINT      NOT NULL DEFAULT 0 COMMENT '0-普通用户，1-管理员',
    `status`     TINYINT      NOT NULL DEFAULT 1 COMMENT '0-禁用，1-启用',
    `created_at` DATETIME     NOT NULL COMMENT '注册时间',
    `updated_at` DATETIME     NOT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`),
    UNIQUE KEY `uk_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- =============================================================
-- 2. 分类表（category）
-- =============================================================
DROP TABLE IF EXISTS `category`;

CREATE TABLE `category` (
    `id`         BIGINT      NOT NULL AUTO_INCREMENT COMMENT '分类 ID',
    `name`       VARCHAR(50) NOT NULL COMMENT '分类名称',
    `sort_order` INT         DEFAULT 0 COMMENT '排序权重',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分类表';

-- =============================================================
-- 3. 商品表（product）
-- =============================================================
DROP TABLE IF EXISTS `product`;

CREATE TABLE `product` (
    `id`              BIGINT        NOT NULL AUTO_INCREMENT COMMENT '商品 ID',
    `seller_id`       BIGINT        NOT NULL COMMENT '卖家 ID',
    `category_id`     BIGINT        NOT NULL COMMENT '分类 ID',
    `title`           VARCHAR(100)  NOT NULL COMMENT '商品标题',
    `description`     TEXT          COMMENT '商品描述',
    `price`           DECIMAL(10,2) NOT NULL COMMENT '价格',
    `condition`       TINYINT       NOT NULL COMMENT '1-全新，2-九五新，3-八五新，4-七成新及以下',
    `pickup_location` VARCHAR(255)  DEFAULT NULL COMMENT '自提地点',
    `pickup_time`     VARCHAR(100)  DEFAULT NULL COMMENT '可交易时间',
    `status`          TINYINT       NOT NULL DEFAULT 0 COMMENT '0-待审核，1-已上架，2-已下架，3-审核驳回，4-已删除',
    `is_hot`          TINYINT       NOT NULL DEFAULT 0 COMMENT '0-否，1-热门推荐',
    `reject_reason`   VARCHAR(255)  DEFAULT NULL COMMENT '驳回原因',
    `created_at`      DATETIME      NOT NULL COMMENT '发布时间',
    `updated_at`      DATETIME      NOT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_seller_id` (`seller_id`),
    KEY `idx_category_id` (`category_id`),
    KEY `idx_status` (`status`),
    KEY `idx_created_at` (`created_at`),
    KEY `idx_title` (`title`),
    CONSTRAINT `fk_product_seller` FOREIGN KEY (`seller_id`) REFERENCES `user` (`id`),
    CONSTRAINT `fk_product_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品表';

-- =============================================================
-- 4. 图片表（image）
-- =============================================================
DROP TABLE IF EXISTS `image`;

CREATE TABLE `image` (
    `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '图片 ID',
    `product_id` BIGINT       NOT NULL COMMENT '商品 ID',
    `url`        VARCHAR(255) NOT NULL COMMENT '图片路径',
    `sort_order` INT          DEFAULT 0 COMMENT '排序',
    `created_at` DATETIME     NOT NULL COMMENT '上传时间',
    PRIMARY KEY (`id`),
    KEY `idx_product_id` (`product_id`),
    CONSTRAINT `fk_image_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图片表';

-- =============================================================
-- 5. 订单表（order）
-- =============================================================
DROP TABLE IF EXISTS `order`;

CREATE TABLE `order` (
    `id`           BIGINT        NOT NULL AUTO_INCREMENT COMMENT '订单 ID',
    `product_id`   BIGINT        NOT NULL COMMENT '商品 ID',
    `buyer_id`     BIGINT        NOT NULL COMMENT '买家 ID',
    `seller_id`    BIGINT        NOT NULL COMMENT '卖家 ID',
    `quantity`     INT           NOT NULL DEFAULT 1 COMMENT '数量',
    `price`        DECIMAL(10,2) NOT NULL COMMENT '成交单价',
    `total_price`  DECIMAL(10,2) NOT NULL COMMENT '总价',
    `status`       TINYINT       NOT NULL DEFAULT 0 COMMENT '0-待付款，1-待自提，2-已完成，3-已取消',
    `created_at`   DATETIME      NOT NULL COMMENT '创建时间',
    `updated_at`   DATETIME      NOT NULL COMMENT '更新时间',
    `completed_at` DATETIME      DEFAULT NULL COMMENT '完成时间',
    PRIMARY KEY (`id`),
    KEY `idx_buyer_id` (`buyer_id`),
    KEY `idx_seller_id` (`seller_id`),
    KEY `idx_product_id` (`product_id`),
    KEY `idx_status` (`status`),
    KEY `idx_created_at` (`created_at`),
    CONSTRAINT `fk_order_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
    CONSTRAINT `fk_order_buyer` FOREIGN KEY (`buyer_id`) REFERENCES `user` (`id`),
    CONSTRAINT `fk_order_seller` FOREIGN KEY (`seller_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';

-- =============================================================
-- 6. 购物车表（cart）
-- =============================================================
DROP TABLE IF EXISTS `cart`;

CREATE TABLE `cart` (
    `id`         BIGINT   NOT NULL AUTO_INCREMENT COMMENT '购物车项 ID',
    `user_id`    BIGINT   NOT NULL COMMENT '用户 ID',
    `product_id` BIGINT   NOT NULL COMMENT '商品 ID',
    `quantity`   INT      NOT NULL DEFAULT 1 COMMENT '数量',
    `created_at` DATETIME NOT NULL COMMENT '加入时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_product` (`user_id`, `product_id`),
    CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_cart_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='购物车表';

-- =============================================================
-- 7. 收藏表（favorite）
-- =============================================================
DROP TABLE IF EXISTS `favorite`;

CREATE TABLE `favorite` (
    `id`         BIGINT   NOT NULL AUTO_INCREMENT COMMENT '收藏 ID',
    `user_id`    BIGINT   NOT NULL COMMENT '用户 ID',
    `product_id` BIGINT   NOT NULL COMMENT '商品 ID',
    `created_at` DATETIME NOT NULL COMMENT '收藏时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_product` (`user_id`, `product_id`),
    CONSTRAINT `fk_favorite_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_favorite_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='收藏表';

-- =============================================================
-- 8. 私信表（message）
-- =============================================================
DROP TABLE IF EXISTS `message`;

CREATE TABLE `message` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '消息 ID',
    `session_id`  VARCHAR(64)  NOT NULL COMMENT '会话 ID',
    `sender_id`   BIGINT       NOT NULL COMMENT '发送者 ID',
    `receiver_id` BIGINT       NOT NULL COMMENT '接收者 ID',
    `content`     TEXT         NOT NULL COMMENT '消息内容',
    `is_read`     TINYINT      NOT NULL DEFAULT 0 COMMENT '0-未读，1-已读',
    `created_at`  DATETIME     NOT NULL COMMENT '发送时间',
    PRIMARY KEY (`id`),
    KEY `idx_session_id` (`session_id`),
    KEY `idx_sender_id` (`sender_id`),
    KEY `idx_receiver_id` (`receiver_id`),
    CONSTRAINT `fk_message_sender` FOREIGN KEY (`sender_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_message_receiver` FOREIGN KEY (`receiver_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='私信表';

-- =============================================================
-- 9. 评价表（review）
-- =============================================================
DROP TABLE IF EXISTS `review`;

CREATE TABLE `review` (
    `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '评价 ID',
    `order_id`   BIGINT       NOT NULL COMMENT '订单 ID',
    `product_id` BIGINT       NOT NULL COMMENT '商品 ID',
    `user_id`    BIGINT       NOT NULL COMMENT '评价人 ID',
    `rating`     TINYINT      NOT NULL COMMENT '评分 1-5',
    `content`    TEXT         COMMENT '评价内容',
    `status`     TINYINT      NOT NULL DEFAULT 1 COMMENT '0-隐藏，1-显示',
    `created_at` DATETIME     NOT NULL COMMENT '评价时间',
    PRIMARY KEY (`id`),
    KEY `idx_product_id` (`product_id`),
    KEY `idx_order_id` (`order_id`),
    CONSTRAINT `fk_review_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_review_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='评价表';

-- =============================================================
-- 10. 公告表（announcement）
-- =============================================================
DROP TABLE IF EXISTS `announcement`;

CREATE TABLE `announcement` (
    `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '公告 ID',
    `title`      VARCHAR(200) NOT NULL COMMENT '公告标题',
    `content`    TEXT         NOT NULL COMMENT '公告内容',
    `type`       TINYINT      NOT NULL DEFAULT 0 COMMENT '0-系统公告，1-交易须知，2-资讯',
    `status`     TINYINT      NOT NULL DEFAULT 1 COMMENT '0-草稿，1-已发布',
    `created_at` DATETIME     NOT NULL COMMENT '创建时间',
    `updated_at` DATETIME     NOT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_type` (`type`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公告表';

-- =============================================================
-- 11. 轮播图表（carousel）
-- =============================================================
DROP TABLE IF EXISTS `carousel`;

CREATE TABLE `carousel` (
    `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '轮播图 ID',
    `image_url`  VARCHAR(255) NOT NULL COMMENT '图片 URL',
    `link_url`   VARCHAR(255) DEFAULT NULL COMMENT '跳转链接',
    `title`      VARCHAR(100) DEFAULT NULL COMMENT '标题',
    `sort_order` INT          DEFAULT 0 COMMENT '排序',
    `status`     TINYINT      NOT NULL DEFAULT 1 COMMENT '0-隐藏，1-显示',
    `created_at` DATETIME     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='轮播图表';

-- =============================================================
-- 12. 操作日志表（log）
-- =============================================================
DROP TABLE IF EXISTS `log`;

CREATE TABLE `log` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '日志 ID',
    `user_id`     BIGINT       DEFAULT NULL COMMENT '用户 ID（游客为 NULL）',
    `action_type` VARCHAR(50)  NOT NULL COMMENT '操作类型',
    `description` VARCHAR(500) DEFAULT NULL COMMENT '操作描述',
    `ip_address`  VARCHAR(50)  DEFAULT NULL COMMENT '操作 IP',
    `created_at`  DATETIME     NOT NULL COMMENT '操作时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_created_at` (`created_at`),
    CONSTRAINT `fk_log_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';

-- =============================================================
-- 13. 交易流水表（transaction_log）
-- =============================================================
DROP TABLE IF EXISTS `transaction_log`;

CREATE TABLE `transaction_log` (
    `id`             BIGINT        NOT NULL AUTO_INCREMENT COMMENT '流水 ID',
    `user_id`        BIGINT        NOT NULL COMMENT '用户 ID',
    `order_id`       BIGINT        DEFAULT NULL COMMENT '关联订单 ID',
    `type`           VARCHAR(20)   NOT NULL COMMENT 'RECHARGE/PAY/INCOME/REFUND/INIT',
    `amount`         DECIMAL(10,2) NOT NULL COMMENT '变动金额',
    `balance_before` DECIMAL(10,2) NOT NULL COMMENT '变动前余额',
    `balance_after`  DECIMAL(10,2) NOT NULL COMMENT '变动后余额',
    `description`    VARCHAR(255)  DEFAULT NULL COMMENT '备注',
    `created_at`     DATETIME      NOT NULL COMMENT '变动时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_order_id` (`order_id`),
    CONSTRAINT `fk_tlog_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_tlog_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='交易流水表';

-- =============================================================
-- 初始数据
-- =============================================================

-- 分类
INSERT INTO `category` (`name`, `sort_order`) VALUES
    ('教材教辅',   1),
    ('电子产品',   2),
    ('生活用品',   3),
    ('服饰鞋包',   4),
    ('体育用品',   5),
    ('其他',      99);

-- 管理员（用户名 admin，密码 admin123）
INSERT INTO `user` (`username`, `password`, `phone`, `balance`, `role`, `status`, `created_at`, `updated_at`)
VALUES ('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        '13800000000', 0.00, 1, 1, NOW(), NOW());
