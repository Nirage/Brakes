package com.envoydigital.brakes.storefront.controllers.cms;

import de.hybris.platform.category.model.CategoryModel;
import de.hybris.platform.core.model.product.ProductModel;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.envoydigital.brakes.core.model.AmplienceCMSComponentModel;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;


/**
 * Controller for CMS AmplienceCMSComponentController
 *
 */
@Controller("AmplienceCMSComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.AmplienceCMSComponent)
public class AmplienceCMSComponentController extends AbstractAcceleratorCMSComponentController<AmplienceCMSComponentModel>
{


	@Override
	protected void fillModel(final HttpServletRequest request, final Model model, final AmplienceCMSComponentModel component)
	{
		final CategoryModel currentCategory = getRequestContextData(request).getCategory();

		final ProductModel currentProduct = getRequestContextData(request).getProduct();

		if (currentCategory != null && StringUtils.isBlank(component.getAmplienceSlotId()))
		{
			component.setAmplienceSlotId(currentCategory.getAmplienceSlotId());
		}
		else if (currentProduct != null && StringUtils.isBlank(component.getAmplienceSlotId()))
		{
			component.setAmplienceSlotId(currentProduct.getAmplienceSlotId());
		}
		model.addAttribute("amplienceSlotId", component.getAmplienceSlotId());
	}

}
