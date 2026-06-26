<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>轮播图详情</title>
</head>
<body>
    <h3>轮播详情</h3>
    <p>ID：${carousel.id}</p>
    <p>图片地址：${carousel.imgUrl}</p>
    <p>跳转链接：${carousel.jumpUrl}</p>
    <p>排序权重：${carousel.sortNum}</p>
    <p>生效时间：${carousel.validStart}</p>
    <p>失效时间：${carousel.validEnd}</p>
    <p>状态：${carousel.status == 1 ? "展示" : "下架"}</p>
    <a href="${pageContext.request.contextPath}/home/carousel/list">返回列表</a>
</body>
</html>