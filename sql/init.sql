-- =============================================================
-- 校园二手交易平台 — 数据库初始化脚本
-- 版本：v2.0（适配课程任务书全部功能）
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
--    存储平台所有用户（游客注册后成为注册用户）
-- =============================================================
DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
    `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '用户 ID',
    `student_id` VARCHAR(20)  NOT NULL COMMENT '学号',
    `name`       VARCHAR(50)  NOT NULL COMMENT '真实姓名',
    `email`      VARCHAR(100) NOT NULL COMMENT '学校邮箱',
    `password`   VARCHAR(255) NOT NULL COMMENT 'BCrypt 加密密码',
    `phone`      VARCHAR(20)  DEFAULT NULL COMMENT '联系电话',
    `avatar`     VARCHAR(255) DEFAULT NULL COMMENT '头像 URL',
    `balance`    DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '虚拟余额（注册赠送 1000 元）',
    `role`       TINYINT      NOT NULL DEFAULT 0 COMMENT '角色：0-普通用户，1-管理员',
    `status`     TINYINT      NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `created_at` DATETIME     NOT NULL COMMENT '注册时间',
    `updated_at` DATETIME     NOT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_student_id` (`student_id`),
    UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';


-- =============================================================
-- 2. 分类表（category）
--    存储商品分类的枚举数据
-- =============================================================
DROP TABLE IF EXISTS `category`;

CREATE TABLE `category` (
    `id`         BIGINT      NOT NULL AUTO_INCREMENT COMMENT '分类 ID',
    `name`       VARCHAR(50) NOT NULL COMMENT '分类名称',
    `sort_order` INT         DEFAULT 0 COMMENT '排序权重（越小越靠前）',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分类表';


-- =============================================================
-- 3. 商品表（product）
--    存储用户发布的二手商品信息
-- =============================================================
DROP TABLE IF EXISTS `product`;

CREATE TABLE `product` (
    `id`              BIGINT        NOT NULL AUTO_INCREMENT COMMENT '商品 ID',
    `seller_id`       BIGINT        NOT NULL COMMENT '卖家 ID（FK → user.id）',
    `category_id`     BIGINT        NOT NULL COMMENT '分类 ID（FK → category.id）',
    `title`           VARCHAR(100)  NOT NULL COMMENT '商品标题',
    `description`     TEXT          COMMENT '商品描述',
    `price`           DECIMAL(10,2) NOT NULL COMMENT '价格（元）',
    `condition`       TINYINT       NOT NULL COMMENT '成色：1-全新，2-九五新，3-八五新，4-七成新及以下',
    `pickup_location` VARCHAR(255)  DEFAULT NULL COMMENT '自提地点',
    `pickup_time`     VARCHAR(100)  DEFAULT NULL COMMENT '可交易时间',
    `status`          TINYINT       NOT NULL DEFAULT 0 COMMENT '状态：0-待审核，1-已上架，2-已下架，3-审核驳回，4-已删除',
    `is_hot`          TINYINT       NOT NULL DEFAULT 0 COMMENT '是否热门推荐：0-否，1-是',
    `reject_reason`   VARCHAR(255)  DEFAULT NULL COMMENT '审核驳回原因',
    `created_at`      DATETIME      NOT NULL COMMENT '发布时间',
    `updated_at`      DATETIME      NOT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_seller_id` (`seller_id`),
    KEY `idx_category_id` (`category_id`),
    KEY `idx_status` (`status`),
    KEY `idx_created_at` (`created_at`),
    KEY `idx_title` (`title`),
    CONSTRAINT `fk_product_seller` FOREIGN KEY (`seller_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `fk_product_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品表';


-- =============================================================
-- 4. 图片表（image）
--    存储商品图片的路径信息
-- =============================================================
DROP TABLE IF EXISTS `image`;

CREATE TABLE `image` (
    `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '图片 ID',
    `product_id` BIGINT       NOT NULL COMMENT '所属商品 ID（FK → product.id）',
    `url`        VARCHAR(255) NOT NULL COMMENT '图片 URL/存储路径',
    `sort_order` INT          DEFAULT 0 COMMENT '排序顺序（首图设为 0）',
    `created_at` DATETIME     NOT NULL COMMENT '上传时间',
    PRIMARY KEY (`id`),
    KEY `idx_product_id` (`product_id`),
    CONSTRAINT `fk_image_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图片表';


-- =============================================================
-- 5. 订单表（order）
--    存储买家发起的购买订单及交易状态
--    ⚠️ order 是 MySQL 保留字，使用时需加反引号
-- =============================================================
DROP TABLE IF EXISTS `order`;

CREATE TABLE `order` (
    `id`           BIGINT        NOT NULL AUTO_INCREMENT COMMENT '订单 ID',
    `product_id`   BIGINT        NOT NULL COMMENT '商品 ID（FK → product.id）',
    `buyer_id`     BIGINT        NOT NULL COMMENT '买家 ID（FK → user.id）',
    `seller_id`    BIGINT        NOT NULL COMMENT '卖家 ID（FK → user.id）',
    `quantity`     INT           NOT NULL DEFAULT 1 COMMENT '数量',
    `price`        DECIMAL(10,2) NOT NULL COMMENT '成交单价（下单时的商品价格）',
    `total_price`  DECIMAL(10,2) NOT NULL COMMENT '总价（price × quantity）',
    `status`       TINYINT       NOT NULL DEFAULT 0 COMMENT '状态：0-待付款，1-待自提，2-已完成，3-已取消',
    `created_at`   DATETIME      NOT NULL COMMENT '创建时间',
    `updated_at`   DATETIME      NOT NULL COMMENT '更新时间',
    `completed_at` DATETIME      DEFAULT NULL COMMENT '完成时间',
    PRIMARY KEY (`id`),
    KEY `idx_buyer_id` (`buyer_id`),
    KEY `idx_seller_id` (`seller_id`),
    KEY `idx_product_id` (`product_id`),
    KEY `idx_status` (`status`),
    KEY `idx_created_at` (`created_at`),
    CONSTRAINT `fk_order_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `fk_order_buyer` FOREIGN KEY (`buyer_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `fk_order_seller` FOREIGN KEY (`seller_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';


-- =============================================================
-- 6. 购物车表（cart）
--    存储用户加入购物车的商品
-- =============================================================
DROP TABLE IF EXISTS `cart`;

CREATE TABLE `cart` (
    `id`         BIGINT   NOT NULL AUTO_INCREMENT COMMENT '购物车项 ID',
    `user_id`    BIGINT   NOT NULL COMMENT '用户 ID（FK → user.id）',
    `product_id` BIGINT   NOT NULL COMMENT '商品 ID（FK → product.id）',
    `quantity`   INT      NOT NULL DEFAULT 1 COMMENT '数量',
    `created_at` DATETIME NOT NULL COMMENT '加入时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_product` (`user_id`, `product_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_product_id` (`product_id`),
    CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT `fk_cart_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='购物车表';


-- =============================================================
-- 7. 收藏表（favorite）
--    存储用户收藏的商品
-- =============================================================
DROP TABLE IF EXISTS `favorite`;

CREATE TABLE `favorite` (
    `id`         BIGINT   NOT NULL AUTO_INCREMENT COMMENT '收藏 ID',
    `user_id`    BIGINT   NOT NULL COMMENT '用户 ID（FK → user.id）',
    `product_id` BIGINT   NOT NULL COMMENT '商品 ID（FK → product.id）',
    `created_at` DATETIME NOT NULL COMMENT '收藏时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_product` (`user_id`, `product_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_product_id` (`product_id`),
    CONSTRAINT `fk_favorite_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT `fk_favorite_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='收藏表';


-- =============================================================
-- 8. 私信表（message）
--    存储买卖双方站内私信消息
-- =============================================================
DROP TABLE IF EXISTS `message`;

CREATE TABLE `message` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '消息 ID',
    `session_id`  VARCHAR(64)  NOT NULL COMMENT '会话 ID（由双方 user_id 组合生成）',
    `sender_id`   BIGINT       NOT NULL COMMENT '发送者 ID（FK → user.id）',
    `receiver_id` BIGINT       NOT NULL COMMENT '接收者 ID（FK → user.id）',
    `content`     TEXT         NOT NULL COMMENT '消息内容',
    `is_read`     TINYINT      NOT NULL DEFAULT 0 COMMENT '是否已读：0-未读，1-已读',
    `created_at`  DATETIME     NOT NULL COMMENT '发送时间',
    PRIMARY KEY (`id`),
    KEY `idx_session_id` (`session_id`),
    KEY `idx_sender_id` (`sender_id`),
    KEY `idx_receiver_id` (`receiver_id`),
    KEY `idx_created_at` (`created_at`),
    CONSTRAINT `fk_message_sender` FOREIGN KEY (`sender_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT `fk_message_receiver` FOREIGN KEY (`receiver_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='私信表';


-- =============================================================
-- 9. 评价表（review）
--    存储买家对商品的评价（评分 + 文字）
-- =============================================================
DROP TABLE IF EXISTS `review`;

CREATE TABLE `review` (
    `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '评价 ID',
    `order_id`   BIGINT       NOT NULL COMMENT '订单 ID（FK → order.id）',
    `product_id` BIGINT       NOT NULL COMMENT '商品 ID（FK → product.id）',
    `user_id`    BIGINT       NOT NULL COMMENT '评价人 ID（FK → user.id）',
    `rating`     TINYINT      NOT NULL COMMENT '评分：1-5 星',
    `content`    TEXT         COMMENT '评价内容',
    `status`     TINYINT      NOT NULL DEFAULT 1 COMMENT '状态：0-隐藏，1-显示',
    `created_at` DATETIME     NOT NULL COMMENT '评价时间',
    PRIMARY KEY (`id`),
    KEY `idx_product_id` (`product_id`),
    KEY `idx_order_id` (`order_id`),
    KEY `idx_user_id` (`user_id`),
    CONSTRAINT `fk_review_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT `fk_review_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='评价表';


-- =============================================================
-- 10. 公告表（announcement）
--     存储系统公告、交易须知、校园资讯
-- =============================================================
DROP TABLE IF EXISTS `announcement`;

CREATE TABLE `announcement` (
    `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '公告 ID',
    `title`      VARCHAR(200) NOT NULL COMMENT '公告标题',
    `content`    TEXT         NOT NULL COMMENT '公告内容',
    `type`       TINYINT      NOT NULL DEFAULT 0 COMMENT '类型：0-系统公告，1-交易须知，2-资讯',
    `status`     TINYINT      NOT NULL DEFAULT 1 COMMENT '状态：0-草稿，1-已发布',
    `created_at` DATETIME     NOT NULL COMMENT '创建时间',
    `updated_at` DATETIME     NOT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_type` (`type`),
    KEY `idx_status` (`status`),
    KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公告表';


-- =============================================================
-- 11. 轮播图表（carousel）
--     存储首页轮播图片
-- =============================================================
DROP TABLE IF EXISTS `carousel`;

CREATE TABLE `carousel` (
    `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '轮播图 ID',
    `image_url`  VARCHAR(255) NOT NULL COMMENT '图片 URL',
    `link_url`   VARCHAR(255) DEFAULT NULL COMMENT '点击跳转链接',
    `title`      VARCHAR(100) DEFAULT NULL COMMENT '图片标题',
    `sort_order` INT          DEFAULT 0 COMMENT '排序顺序',
    `status`     TINYINT      NOT NULL DEFAULT 1 COMMENT '状态：0-隐藏，1-显示',
    `created_at` DATETIME     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_sort_order` (`sort_order`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='轮播图表';


-- =============================================================
-- 12. 操作日志表（log）
--     存储系统操作日志（登录/退出/管理员操作等）
-- =============================================================
DROP TABLE IF EXISTS `log`;

CREATE TABLE `log` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '日志 ID',
    `user_id`     BIGINT       DEFAULT NULL COMMENT '操作用户 ID（FK → user.id，游客为 NULL）',
    `action_type` VARCHAR(50)  NOT NULL COMMENT '操作类型：LOGIN, LOGOUT, REGISTER, ADMIN_ACTION 等',
    `description` VARCHAR(500) DEFAULT NULL COMMENT '操作描述',
    `ip_address`  VARCHAR(50)  DEFAULT NULL COMMENT '操作 IP',
    `created_at`  DATETIME     NOT NULL COMMENT '操作时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_action_type` (`action_type`),
    KEY `idx_created_at` (`created_at`),
    CONSTRAINT `fk_log_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';


-- =============================================================
-- 13. 交易流水表（transaction_log）
--     存储用户虚拟余额的变动记录
-- =============================================================
DROP TABLE IF EXISTS `transaction_log`;

CREATE TABLE `transaction_log` (
    `id`             BIGINT        NOT NULL AUTO_INCREMENT COMMENT '流水 ID',
    `user_id`        BIGINT        NOT NULL COMMENT '用户 ID（FK → user.id）',
    `order_id`       BIGINT        DEFAULT NULL COMMENT '关联订单 ID（FK → order.id，充值等为 NULL）',
    `type`           VARCHAR(20)   NOT NULL COMMENT '类型：RECHARGE-充值, PAY-支付, INCOME-入账, INIT-初始发放',
    `amount`         DECIMAL(10,2) NOT NULL COMMENT '变动金额（正数为收入，负数为支出）',
    `balance_before` DECIMAL(10,2) NOT NULL COMMENT '变动前余额',
    `balance_after`  DECIMAL(10,2) NOT NULL COMMENT '变动后余额',
    `description`    VARCHAR(255)  DEFAULT NULL COMMENT '备注说明',
    `created_at`     DATETIME      NOT NULL COMMENT '变动时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_order_id` (`order_id`),
    KEY `idx_type` (`type`),
    KEY `idx_created_at` (`created_at`),
    CONSTRAINT `fk_transaction_log_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT `fk_transaction_log_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='交易流水表';


-- =============================================================
-- 初始数据
-- =============================================================

-- 分类初始数据（6 个基础分类）
INSERT INTO `category` (`name`, `sort_order`) VALUES
    ('教材教辅',   1),
    ('电子产品',   2),
    ('生活用品',   3),
    ('服饰鞋包',   4),
    ('体育用品',   5),
    ('其他',      99);

-- 管理员初始账号
-- 密码：admin123（BCrypt 加密）
-- 注意：该密文由 BCrypt 算法对明文 "admin123" 生成，可在 Spring Boot 启动后验证
--       如 BCrypt 密文不匹配，请先在应用中通过注册接口创建管理员并复制其密文
INSERT INTO `user` (`student_id`, `name`, `email`, `password`, `balance`, `role`, `status`, `created_at`, `updated_at`)
VALUES ('admin', '系统管理员', 'admin@campus.edu',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        0.00, 1, 1, NOW(), NOW());

-- =============================================================
-- 建表完成
-- 表数量：13
-- 执行顺序：user → category → product → image → order
--           → cart → favorite → message → review
--           → announcement → carousel → log → transaction_log
-- =============================================================
