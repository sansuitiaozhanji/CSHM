package com.campus.service;

import com.campus.common.PageResult;
import com.campus.entity.Image;
import com.campus.entity.Product;
import com.campus.mapper.ImageMapper;
import com.campus.mapper.ProductMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ProductService {

    private final ProductMapper productMapper;
    private final ImageMapper imageMapper;

    public ProductService(ProductMapper productMapper, ImageMapper imageMapper) {
        this.productMapper = productMapper;
        this.imageMapper = imageMapper;
    }

    public Product findById(Long id) {
        Product product = productMapper.findById(id);
        if (product != null) {
            List<Image> images = imageMapper.findByProductId(id);
            product.setImages(images);
        }
        return product;
    }

    public PageResult<Product> findForList(String keyword, Long categoryId, int page, int size) {
        int offset = (page - 1) * size;
        List<Product> list = productMapper.findForList(keyword, categoryId, offset, size);
        long total = productMapper.countForList(keyword, categoryId);

        // 批量加载图片
        if (!list.isEmpty()) {
            List<Long> productIds = list.stream().map(Product::getId).collect(Collectors.toList());
            List<Image> allImages = imageMapper.findByProductIds(productIds);
            Map<Long, List<Image>> imageMap = allImages.stream()
                    .collect(Collectors.groupingBy(Image::getProductId));
            for (Product p : list) {
                p.setImages(imageMap.getOrDefault(p.getId(), new ArrayList<>()));
            }
        }

        return new PageResult<>(list, total, page, size);
    }

    public List<Product> findBySellerId(Long sellerId, Integer status) {
        return productMapper.findBySellerId(sellerId, status);
    }

    public List<Product> findAll(String keyword, Long categoryId, Integer status) {
        return productMapper.findAll(keyword, categoryId, status);
    }

    @Transactional
    public String create(Product product, List<String> imageUrls) {
        if (product.getTitle() == null || product.getTitle().isBlank()) {
            return "商品标题不能为空";
        }
        if (product.getTitle().length() > 100) {
            return "商品标题不能超过100字";
        }
        if (product.getCategoryId() == null) {
            return "请选择商品分类";
        }
        if (product.getPrice() == null) {
            return "请设置商品价格";
        }
        if (product.getCondition() == null) {
            return "请选择商品成色";
        }

        productMapper.insert(product);

        if (imageUrls != null && !imageUrls.isEmpty()) {
            List<Image> images = new ArrayList<>();
            for (int i = 0; i < imageUrls.size(); i++) {
                Image img = new Image();
                img.setProductId(product.getId());
                img.setUrl(imageUrls.get(i));
                img.setSortOrder(i);
                images.add(img);
            }
            imageMapper.batchInsert(images);
        }

        return null;
    }

    @Transactional
    public String update(Product product, List<String> imageUrls, Long userId) {
        Product existing = productMapper.findById(product.getId());
        if (existing == null) {
            return "商品不存在";
        }
        if (!existing.getSellerId().equals(userId)) {
            return "无权修改此商品";
        }
        if (existing.getStatus() == 1) {
            return "已上架商品请先下架后再修改";
        }

        if (product.getTitle() == null || product.getTitle().isBlank()) {
            return "商品标题不能为空";
        }
        if (product.getTitle().length() > 100) {
            return "商品标题不能超过100字";
        }
        if (product.getCategoryId() == null) {
            return "请选择商品分类";
        }
        if (product.getPrice() == null) {
            return "请设置商品价格";
        }
        if (product.getCondition() == null) {
            return "请选择商品成色";
        }

        product.setId(existing.getId());
        productMapper.update(product);

        if (imageUrls != null) {
            imageMapper.deleteByProductId(existing.getId());
            if (!imageUrls.isEmpty()) {
                List<Image> images = new ArrayList<>();
                for (int i = 0; i < imageUrls.size(); i++) {
                    Image img = new Image();
                    img.setProductId(existing.getId());
                    img.setUrl(imageUrls.get(i));
                    img.setSortOrder(i);
                    images.add(img);
                }
                imageMapper.batchInsert(images);
            }
        }

        return null;
    }

    public String toggleStatus(Long id, Long userId, boolean isAdmin) {
        Product product = productMapper.findById(id);
        if (product == null) {
            return "商品不存在";
        }
        if (!isAdmin && !product.getSellerId().equals(userId)) {
            return "无权操作此商品";
        }

        if (isAdmin) {
            // 管理员操作：审核通过或驳回在单独的方法中
            return "请使用审核功能";
        } else {
            // 卖家操作：上架或下架
            Integer newStatus = product.getStatus() == 1 ? 2 : 1;
            if (newStatus == 1 && product.getStatus() == 0) {
                return "商品正在审核中，无法上架";
            }
            if (newStatus == 1 && product.getStatus() == 3) {
                return "商品审核已驳回，请修改后重新提交审核";
            }
            productMapper.updateStatus(id, newStatus, null);
        }
        return null;
    }

    public String approve(Long id) {
        productMapper.updateStatus(id, 1, null);
        return null;
    }

    public String reject(Long id, String reason) {
        if (reason == null || reason.isBlank()) {
            return "请填写驳回原因";
        }
        productMapper.updateStatus(id, 3, reason);
        return null;
    }

    public String resubmit(Long id, Long userId) {
        Product product = productMapper.findById(id);
        if (product == null) {
            return "商品不存在";
        }
        if (!product.getSellerId().equals(userId)) {
            return "无权操作此商品";
        }
        if (product.getStatus() != 3) {
            return "只有审核驳回的商品才能重新提交";
        }
        productMapper.updateStatus(id, 0, null);
        return null;
    }

    @Transactional
    public String delete(Long id, Long userId) {
        Product product = productMapper.findById(id);
        if (product == null) {
            return "商品不存在";
        }
        if (!product.getSellerId().equals(userId)) {
            return "无权删除此商品";
        }
        // 软删除：标记为已删除(status=4)，保留图片和外键关联
        productMapper.updateStatus(id, 4, null);
        return null;
    }
}
