<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园二手交易平台</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .navbar-brand { font-weight: 700; }
        .main-content { min-height: calc(100vh - 120px); padding: 20px 0; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="/">
            <i class="bi bi-shop"></i> 校园二手交易
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/"><i class="bi bi-house"></i> 首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/announcement"><i class="bi bi-megaphone"></i> 公告</a>
                </li>
                <c:if test="${sessionScope.user != null}">
                    <li class="nav-item">
                        <a class="nav-link" href="/product/create"><i class="bi bi-plus-circle"></i> 发布商品</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/my/products"><i class="bi bi-box"></i> 我的发布</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/cart"><i class="bi bi-cart"></i> 购物车</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/my/orders/buy"><i class="bi bi-bag"></i> 我的购买</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/my/orders/sell"><i class="bi bi-truck"></i> 我的出售</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/my/favorites"><i class="bi bi-heart"></i> 我的收藏</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/wallet">
                            <i class="bi bi-wallet2"></i> 钱包
                            <span class="badge bg-light text-primary ms-1">¥${sessionScope.user.balance}</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/message">
                            <i class="bi bi-chat-dots"></i> 私信
                        </a>
                    </li>
                    <c:if test="${sessionScope.user.role == 1}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="bi bi-shield-lock"></i> 管理后台
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="/admin/reviews">评价管理</a></li>
                                <li><a class="dropdown-item" href="/admin">数据统计</a></li>
                                <li><a class="dropdown-item" href="/admin/users">用户管理</a></li>
                                <li><a class="dropdown-item" href="/admin/products">商品审核</a></li>
                                <li><a class="dropdown-item" href="/admin/content">内容管理</a></li>
                                <li><a class="dropdown-item" href="/admin/logs">操作日志</a></li>
                            </ul>
                        </li>
                    </c:if>
                </c:if>
            </ul>
            <ul class="navbar-nav">
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle"></i> ${sessionScope.user.username}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="/profile">个人中心</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="/logout">退出登录</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="/login"><i class="bi bi-box-arrow-in-right"></i> 登录</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/register"><i class="bi bi-person-plus"></i> 注册</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
<div class="main-content">
