# 校园二手交易平台 (CSHM)

校园二手交易平台是一个基于 Spring Boot + MyBatis 的校园二手物品交易系统，为在校师生提供便捷的二手物品发布、浏览和交易服务。

## 项目简介

本项目是一个完整的校园二手交易平台，采用前后端分离架构思想，后端使用 Spring Boot 框架，前端使用 JSP 模板引擎，数据存储采用 MySQL 数据库。

## 技术栈

- **后端**: Java 17, Spring Boot
- **ORM**: MyBatis
- **数据库**: MySQL
- **前端**: JSP + Bootstrap
- **构建工具**: Maven

## 功能特性

### 用户模块
- 用户注册与登录
- 个人资料管理
- 查看发布商品列表

### 商品模块
- 发布二手商品
- 商品列表浏览
- 商品详情查看
- 商品编辑与删除
- 商品分类筛选

### 订单模块
- 购买订单管理
- 卖出订单管理

### 管理员模块
- 用户管理
- 商品审核
- 数据统计面板

## 项目结构

```
src/
├── main/
│   ├── java/com/campus/
│   │   ├── common/          # 通用类（Result, PageResult）
│   │   ├── config/          # 配置类
│   │   ├── controller/      # 控制器
│   │   │   ├── admin/       # 管理员控制器
│   │   │   ├── AuthController.java
│   │   │   ├── CategoryController.java
│   │   │   ├── OrderController.java
│   │   │   ├── ProductController.java
│   │   │   └── UserController.java
│   │   ├── entity/          # 实体类
│   │   ├── mapper/          # MyBatis Mapper 接口
│   │   └── service/         # 业务服务层
│   ├── resources/
│   │   ├── application.yaml # 配置文件
│   │   └── mapper/          # MyBatis XML 映射文件
│   └── webapp/
│       └── WEB-INF/jsp/    # JSP 视图文件
└── sql/
    └── campus_secondhand.sql # 数据库初始化脚本
```

## 快速开始

### 环境要求

- JDK 17+
- Maven 3.6+
- MySQL 5.7+

### 配置步骤

1. 创建数据库并导入 SQL 脚本：
```bash
mysql -u root -p < sql/campus_secondhand.sql
```

2. 修改数据库配置（`src/main/resources/application.yaml`）：
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/campus_secondhand
    username: your_username
    password: your_password
```

3. 编译运行：
```bash
./mvnw spring-boot:run
```

4. 访问应用：
- 前端：http://localhost:8080
- 默认管理员账号：admin / admin123

## 核心 API

| 模块 | 路径 | 说明 |
|------|------|------|
| 认证 | `/api/auth/*` | 登录注册 |
| 用户 | `/api/user/*` | 用户管理 |
| 商品 | `/api/product/*` | 商品 CRUD |
| 分类 | `/api/category/*` | 商品分类 |
| 订单 | `/api/order/*` | 订单管理 |
| 管理 | `/api/admin/*` | 管理员功能 |

## 许可证

本项目基于 MIT 许可证开源。