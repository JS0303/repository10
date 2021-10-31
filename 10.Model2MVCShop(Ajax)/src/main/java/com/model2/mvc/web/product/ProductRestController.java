package com.model2.mvc.web.product;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductService;

@RestController
@RequestMapping("/product/*")
public class ProductRestController {

	/// Field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	// setter Method 구현 않음

	public ProductRestController() {
		System.out.println(this.getClass());
	}

	@RequestMapping(value = "json/getProduct/{prodNo}", method = RequestMethod.GET)
	public Product getProduct(@PathVariable int prodNo, Model model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		System.out.println("/product/json/getProduct : GET");

/////////////////////// Cookie part ///////////////////////////////
		String history = "";

		Cookie[] cookies = request.getCookies();

		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				Cookie h = cookies[i];

				if (h.getName().equals("history")) {

					history = h.getValue();
					System.out.println("history :: "+history);
				}
			}
		}
		
		model.addAttribute("prodNo", prodNo);
		
		history += model.getAttribute("prodNo") + ",";

		Cookie cookie = new Cookie("history", history);

//System.out.println(cookie.getValue());

		cookie.setPath("/");

		response.addCookie(cookie);

/////////////////////// Cookie part ////////////////////////////

		// Business Logic
		
		
		request.setAttribute("prodNo", prodNo);
		
		return productService.getProduct(prodNo);

	}

	@RequestMapping(value = "json/insertProduct/{product}", method = RequestMethod.POST)
	public void insertProduct(@PathVariable Product product) throws Exception {

		System.out.println("/product/json/insertProduct : POST");

	}
}
