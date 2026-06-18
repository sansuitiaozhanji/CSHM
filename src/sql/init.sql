-- =============================================================
-- 校园二手交易平台 — 数据库初始化脚本
-- 版本：v1.0
-- 数据库：MySQL 8.0+
-- 字符集：utf8mb4
-- =============================================================

-- 创建数据库（如已存在则跳过）
CREATE DATABASE IF NOT EXISTS campus_secondhand
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE campus_secondhand;

-- =============================================================
-- 1. 用户表（user）
--    存储平台所有用户（买家、卖家、管理员）的账号信息
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
    `id`            BIGINT        NOT NULL AUTO_INCREMENT COMMENT '商品 ID',
    `seller_id`     BIGINT        NOT NULL COMMENT '卖家 ID（FK → user.id）',
    `category_id`   BIGINT        NOT NULL COMMENT '分类 ID（FK → category.id）',
    `title`         VARCHAR(100)  NOT NULL COMMENT '商品标题',
    `description`   TEXT          COMMENT '商品描述',
    `price`         DECIMAL(10,2) NOT NULL COMMENT '价格（元）',
    `condition`     TINYINT       NOT NULL COMMENT '成色：1-全新，2-九五新，3-八五新，4-七成新及以下',
    `status`        TINYINT       NOT NULL DEFAULT 0 COMMENT '状态：0-待审核，1-已上架，2-已下架，3-审核驳回',
    `reject_reason` VARCHAR(255)  DEFAULT NULL COMMENT '审核驳回原因',
    `created_at`    DATETIME      NOT NULL COMMENT '发布时间',
    `updated_at`    DATETIME      NOT NULL COMMENT '更新时间',
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
--    存储买家发起的购买意向及其交易状态
--    ⚠️ order 是 MySQL 保留字，建表及使用时需加反引号
-- =============================================================
DROP TABLE IF EXISTS `order`;

CREATE TABLE `order` (
    `id`           BIGINT        NOT NULL AUTO_INCREMENT COMMENT '订单 ID',
    `product_id`   BIGINT        NOT NULL COMMENT '商品 ID（FK → product.id）',
    `buyer_id`     BIGINT        NOT NULL COMMENT '买家 ID（FK → user.id）',
    `seller_id`    BIGINT        NOT NULL COMMENT '卖家 ID（FK → user.id）',
    `status`       TINYINT       NOT NULL DEFAULT 0 COMMENT '状态：0-待确认，1-进行中，2-已完成，3-已取消',
    `price`        DECIMAL(10,2) NOT NULL COMMENT '成交价（下单时的商品价格）',
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
-- 6. 初始数据
-- =============================================================

-- 6.1 分类初始数据
INSERT INTO `category` (`name`, `sort_order`) VALUES
    ('教材教辅',   1),
    ('电子产品',   2),
    ('生活用品',   3),
    ('服饰鞋包',   4),
    ('体育用品',   5),
    ('其他',      99);

-- 6.2 管理员初始账号
-- 密码：admin123（BCrypt 加密）
-- BCrypt 密文由 Spring Security 的 BCryptPasswordEncoder 生成
-- 注意：实际使用时，应先启动 Spring Boot 应用，通过注册接口创建管理员账号，
--       或使用下方密文（该密文对应明文 "admin123"，由标准 BCrypt 算法生成）
INSERT INTO `user` (`student_id`, `name`, `email`, `password`, `role`, `status`, `created_at`, `updated_at`)
VALUES ('admin', '系统管理员', 'admin@campus.edu',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        1, 1, NOW(), NOW());

-- =============================================================
-- 建表完成
-- 执行顺序：user → category → product → image → order
-- 依赖说明：order 表依赖 user 和 product，建议最后创建
-- =============================================================
