#校园二手交易平台 (CSHM)

一个为在校师生提供便捷二手物品发布、浏览和交易服务的完整校园二手交易系统。

## 项目简介

本项目采用前后端分离架构思想，后端基于 Spring Boot 框架构建，前端使用 JSP 模板引擎结合 Bootstrap，数据存储采用 MySQL 数据库。通过简洁的 Web 界面，用户可以轻松发布和购买二手商品，同时支持钱包、收藏、购物车、消息等丰富的交易辅助功能。

## 技术栈

| 分类 | 技术 |
|------|------|
| 后端 | Java 17, Spring Boot 2.7.x |
| ORM | MyBatis |
| 数据库 | MySQL 5.7+ |
| 前端 | JSP, Bootstrap 5 |
| 构建工具 | Maven 3.6+ |

## 功能特性

### 用户模块
- 用户注册与登录（学号账号体系）
- 个人资料管理
- 修改密码
- 钱包余额管理

### 商品模块
- 发布二手商品（支持多图上传）
- 商品列表浏览与搜索
- 商品详情查看
- 商品编辑与删除
- 商品分类筛选
- 商品上下架管理

### 交易模块
- 购物车功能
- 收藏夹功能
- 创建购买订单
- 订单确认与取消
- 订单完成确认
- 评价功能

### 消息模块
- 站内消息收发
- 消息详情查看

### 公告模块
- 系统公告发布
- 公告列表浏览
- 公告详情查看

### 管理员模块
- 用户管理（禁用/启用）
- 商品审核（批准/拒绝）
- 日志查看
- 数据统计面板

## 项目结构

```
src/
├── main/
│   ├── java/com/campus/
│   │   ├── common/              # 通用类
│   │   │   ├── PageResult.java # 分页结果封装
│   │   │   └── Result.java     # 统一响应结果
│   │   ├── config/             # 配置类
│   │   │   ├── LoginInterceptor.java  # 登录拦截器
│   │   │   └── WebMvcConfig.java       # Web MVC配置
│   │   ├── controller/         # 控制器
│   │   │   ├── AuthController.java    # 认证
│   │   │   ├── UserController.java     # 用户
│   │   │   ├── ProductController.java  # 商品
│   │   │   ├── OrderController.java    # 订单
│   │   │   ├── CartController.java      # 购物车
│   │   │   ├── FavoriteController.java # 收藏
│   │   │   ├── MessageController.java  # 消息
│   │   │   ├── AnnouncementController.java # 公告
│   │   │   ├── ReviewController.java    # 评价
│   │   │   ├── WalletController.java   # 钱包
│   │   │   └── admin/                  # 管理员控制器
│   │   ├── entity/             # 实体类
│   │   ├── mapper/              # MyBatis Mapper接口
│   │   └── service/             # 业务服务层
│   ├── resources/
│   │   ├── application.yaml    # 应用配置
│   │   └── mapper/             # MyBatis XML映射
│   └── webapp/
│       └── WEB-INF/jsp/        # JSP视图文件
└── sql/
    └── init.sql                 # 数据库初始化脚本
```

## 快速开始

### 环境要求

- JDK 17 或更高版本
- Maven 3.6+
- MySQL 5.7+

### 配置步骤

1. **创建数据库并导入数据**

```bash
mysql -u root -p < sql/init.sql
```

2. **修改数据库配置**

编辑 `src/main/resources/application.yaml`，修改数据库连接信息：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/campus_secondhand
    username: your_username
    password: your_password
```

3. **编译并运行**

```bash
./mvnw spring-boot:run
```

4. **访问应用**

- 前端地址：http://localhost:8080
- 默认管理员账号：`admin` / `admin123`

## 核心 API 路由

| 模块 | 路径 | 说明 |
|------|------|------|
| 认证 | `/login`, `/register`, `/logout` | 登录注册登出 |
| 用户 | `/profile` | 个人资料 |
| 商品 | `/product/*` | 商品 CRUD |
| 订单 | `/order/*`, `/my/orders/*` | 订单管理 |
| 购物车 | `/cart/*` | 购物车 |
| 收藏 | `/favorite/*` | 收藏夹 |
| 消息 | `/message/*` | 站内消息 |
| 公告 | `/announcement/*` | 系统公告 |
| 评价 | `/review/*` | 商品评价 |
| 钱包 | `/wallet` | 余额管理 |
| 管理 | `/admin/*` | 管理员功能 |

## 许可证

本项目基于 MIT 许可证开源。