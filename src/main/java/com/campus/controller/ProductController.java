package com.campus.controller;

import com.campus.common.PageResult;
import com.campus.common.Result;
import com.campus.entity.Category;
import com.campus.entity.Product;
import com.campus.entity.User;
import com.campus.service.CarouselService;
import com.campus.service.CategoryService;
import com.campus.service.FileService;
import com.campus.service.ProductService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class ProductController {

    private final ProductService productService;
    private final CategoryService categoryService;
    private final FileService fileService;
    private final CarouselService carouselService;

    public ProductController(ProductService productService, CategoryService categoryService,
                             FileService fileService, CarouselService carouselService) {
        this.productService = productService;
        this.categoryService = categoryService;
        this.fileService = fileService;
        this.carouselService = carouselService;
    }

    @GetMapping("/")
    public ModelAndView index(@RequestParam(required = false) String keyword,
                              @RequestParam(required = false) Long categoryId,
                              @RequestParam(defaultValue = "1") int page) {
        ModelAndView mv = new ModelAndView("index");
        int size = 12;
        PageResult<Product> pageResult = productService.findForList(keyword, categoryId, page, size);
        List<Category> categories = categoryService.findAll();
        mv.addObject("pageResult", pageResult);
        mv.addObject("categories", categories);
        mv.addObject("keyword", keyword);
        mv.addObject("categoryId", categoryId);
        mv.addObject("carousels", carouselService.findActive());
        return mv;
    }

    @GetMapping("/product/{id}")
    public ModelAndView detail(@PathVariable Long id) {
        ModelAndView mv = new ModelAndView("product/detail");
        Product product = productService.findById(id);
        if (product == null) {
            mv.setViewName("redirect:/");
            mv.addObject("error", "商品不存在");
            return mv;
        }
        mv.addObject("product", product);
        return mv;
    }

    @GetMapping("/product/create")
    public ModelAndView createForm(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }
        ModelAndView mv = new ModelAndView("product/create");
        mv.addObject("categories", categoryService.findAll());
        return mv;
    }

    @PostMapping("/product/create")
    public String create(Product product, @RequestParam(required = false) List<String> imageUrls,
                         HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        product.setSellerId(user.getId());
        String error = productService.create(product, imageUrls);
        if (error != null) {
            attr.addFlashAttribute("error", error);
            attr.addFlashAttribute("product", product);
            return "redirect:/product/create";
        }
        attr.addFlashAttribute("msg", "商品发布成功，请等待审核");
        return "redirect:/my/products";
    }

    @GetMapping("/product/edit/{id}")
    public ModelAndView editForm(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }
        Product product = productService.findById(id);
        if (product == null || !product.getSellerId().equals(user.getId())) {
            ModelAndView mv = new ModelAndView("redirect:/my/products");
            mv.addObject("error", "商品不存在或无权编辑");
            return mv;
        }
        ModelAndView mv = new ModelAndView("product/edit");
        mv.addObject("product", product);
        mv.addObject("categories", categoryService.findAll());
        return mv;
    }

    @PostMapping("/product/edit/{id}")
    public String edit(@PathVariable Long id, Product product,
                       @RequestParam(required = false) List<String> imageUrls,
                       HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        product.setId(id);
        String error = productService.update(product, imageUrls, user.getId());
        if (error != null) {
            attr.addFlashAttribute("error", error);
            return "redirect:/product/edit/" + id;
        }
        attr.addFlashAttribute("msg", "商品更新成功");
        return "redirect:/my/products";
    }

    @PostMapping("/product/toggle/{id}")
    public String toggleStatus(@PathVariable Long id, HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        String error = productService.toggleStatus(id, user.getId(), false);
        if (error != null) {
            attr.addFlashAttribute("error", error);
        } else {
            attr.addFlashAttribute("msg", "状态更新成功");
        }
        return "redirect:/my/products";
    }

    @PostMapping("/product/resubmit/{id}")
    public String resubmit(@PathVariable Long id, HttpSession session, RedirectAttributes attr) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        String error = productService.resubmit(id, user.getId());
        if (error != null) {
            attr.addFlashAttribute("error", error);
        } else {
            attr.addFlashAttribute("msg", "已重新提交审核");
        }
        return "redirect:/my/products";
    }

    @GetMapping("/my/products")
    public ModelAndView myProducts(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }
        ModelAndView mv = new ModelAndView("product/my-list");
        List<Product> products = productService.findBySellerId(user.getId(), null);
        mv.addObject("products", products);
        return mv;
    }

    @PostMapping("/api/upload")
    @ResponseBody
    public Result upload(@RequestParam("file") MultipartFile file) {
        try {
            String url = fileService.upload(file);
            return Result.success(url);
        } catch (Exception e) {
            return Result.error(500, "上传失败：" + e.getMessage());
        }
    }
}
