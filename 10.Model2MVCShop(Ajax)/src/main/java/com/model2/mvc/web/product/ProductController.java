package com.model2.mvc.web.product;

import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.product.impl.ProductServiceImpl;

@Controller
@RequestMapping("/product/*")
public class ProductController {

	/// Field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;

	public ProductController() {
		System.out.println(this.getClass());
	}

	@Value("#{commonProperties['pageUnit']}")
	// @Value("#{commonProperties['pageUnit'] ?: 3}")
	int pageUnit;

	@Value("#{commonProperties['pageSize']}")
	// @Value("#{commonProperties['pageSize'] ?: 2}")
	int pageSize;

	
	//@RequestMapping("/addProduct.do")
	@RequestMapping( value="addProduct", method=RequestMethod.GET)
	public String addProduct() throws Exception {
		
		System.out.println("/product/addProduct : GET");
		
		return "redirect:/product/addProductView.jsp";
	}
	
	//@RequestMapping("/addProduct.do")
	@RequestMapping( value="addProduct", method=RequestMethod.POST)
	public String addProduct(@ModelAttribute("product") Product product, Model model) throws Exception {
		
		System.out.println("/product/addProduct : POST");

		//model.addAttribute("product", product);

		productService.insertProduct(product);

		return "/product/addProduct.jsp";
	}

	//@RequestMapping("/getProduct.do")
	@RequestMapping( value="getProduct", method=RequestMethod.GET)
	public String getProduct(@RequestParam("prodNo") int prodNo, Model model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		System.out.println("/product/getProduct : GET");
		
		/////////////////////// Cookie part ///////////////////////////////
		String history = "";

		Cookie[] cookies = request.getCookies();

		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				Cookie h = cookies[i];

				if (h.getName().equals("history")) {

					history = h.getValue();
					System.out.println(history);
				}
			}
		}
		history += request.getParameter("prodNo") + ",";

		Cookie cookie = new Cookie("history", history);
		
		//System.out.println(cookie.getValue());

		cookie.setPath("/");

		response.addCookie(cookie);
		
		/////////////////////// Cookie part ////////////////////////////
		//Business Logic
		Product product = productService.getProduct(prodNo);

		model.addAttribute("product", product);

		request.setAttribute("product", product);

		System.out.println(":: getProduct Method에서 불러온 menu :: " + request.getParameter("menu"));

		if (request.getParameter("menu") == null) {
			return "forward:/product/getProduct.jsp";
		}

		if (request.getParameter("menu").equals("search")) {
			return "forward:/product/getProduct.jsp";

		} else {
			return "forward:/product/updateProduct.jsp";
		}

		// return "forward:/product/getProduct.jsp";
	}

	//@RequestMapping("/updateProductView.do")
	@RequestMapping( value="updateProduct", method=RequestMethod.GET)
	public String updateProduct(@RequestParam("prodNo") int prodNo, Model model) throws Exception {

		System.out.println("/product/updateProduct : GET");

		Product product = productService.getProduct(prodNo);

		model.addAttribute("product", product);

		return "forward:/product/updateProduct.jsp";
	}

	//@RequestMapping("/updateProduct.do")
	@RequestMapping( value="updateProduct", method=RequestMethod.POST)
	public String updateProduct(@ModelAttribute("product") Product product, Model model)
			throws Exception {

		System.out.println("/product/updateProduct : POST");

		productService.updateProduct(product);

		model.addAttribute("product", product);
		

		return "redirect:/product/getProduct?prodNo=" + product.getProdNo();
	}

	//@RequestMapping("/listProduct.do")
	@RequestMapping( value="listProduct")
	public String listProduct(@ModelAttribute("search") Search search, Model model, HttpServletRequest request, @RequestParam("menu") String menu)
			throws Exception {

		System.out.println("/product/listProduct : GET / POST");

		if (search.getCurrentPage() == 0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);

		Map<String, Object> map = productService.getProductList(search);

		Page resultPage = new Page(search.getCurrentPage(), ((Integer) map.get("totalCount")).intValue(), pageUnit,
				pageSize);
		System.out.println(resultPage);

		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		model.addAttribute("menu", menu);
		
		return "forward:/product/listProduct.jsp";
	}

}
