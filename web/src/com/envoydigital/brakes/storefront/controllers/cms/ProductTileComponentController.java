package com.envoydigital.brakes.storefront.controllers.cms;

import de.hybris.platform.acceleratorfacades.productcarousel.ProductCarouselFacade;
import de.hybris.platform.commercefacades.product.data.ProductData;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.envoydigital.brakes.core.model.components.ProductTileComponentModel;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;


@Controller("ProductTileComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.ProductTileComponent)
public class ProductTileComponentController extends AbstractAcceleratorCMSComponentController<ProductTileComponentModel>
{

	@Resource(name = "productCarouselFacade")
	private ProductCarouselFacade productCarouselFacade;

	@Override
	protected void fillModel(final HttpServletRequest request, final Model model, final ProductTileComponentModel component)
	{
		final List<ProductData> products = collectLinkedProducts(component);
		model.addAttribute("productData", products);
		model.addAttribute("itemsPerPage", component.getItemsPerPage());
		model.addAttribute("title", component.getTitle());
	}

	protected List<ProductData> collectLinkedProducts(final ProductTileComponentModel component)
	{
		return productCarouselFacade.collectProducts(component);
	}
}
