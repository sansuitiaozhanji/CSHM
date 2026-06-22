package com.campus.mapper;

import com.campus.entity.Product;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ProductMapper {

    Product findById(Long id);

    List<Product> findByIds(List<Long> ids);

    List<Product> findAll(@Param("keyword") String keyword,
                          @Param("categoryId") Long categoryId,
                          @Param("status") Integer status);

    List<Product> findBySellerId(@Param("sellerId") Long sellerId,
                                  @Param("status") Integer status);

    List<Product> findForList(@Param("keyword") String keyword,
                               @Param("categoryId") Long categoryId,
                               @Param("offset") int offset,
                               @Param("size") int size);

    long countForList(@Param("keyword") String keyword,
                      @Param("categoryId") Long categoryId);

    int insert(Product product);

    int update(Product product);

    int updateStatus(@Param("id") Long id, @Param("status") Integer status,
                     @Param("rejectReason") String rejectReason);

    int deleteById(Long id);
}
