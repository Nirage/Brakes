package com.envoydigital.brakes.storefront.controllers.cms;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.core.servicelayer.data.SearchPageData;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.envoydigital.brakes.core.model.components.RecentPurchasedProductItemsComponentModel;
import com.envoydigital.brakes.facades.BrakesProductFacade;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;


/**
 * Controller for Displaying Recent Purchased Products.
 */
@Controller("RecentPurchasedProductItemsComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.RecentPurchasedProductItemsComponent)
@RequireHardLogIn
public class RecentPurchasedProductItemsComponentController extends AbstractAcceleratorCMSComponentController<RecentPurchasedProductItemsComponentModel>
{

    private static final int MAX_NUMBER_PRODUCT_DEFAULT = 5;

	@Resource
	private BrakesProductFacade brakesProductFacade;

	@Override
    protected void fillModel(final HttpServletRequest request, final Model model, final RecentPurchasedProductItemsComponentModel component) {
        final int maxNumberOfProducts = component.getMaxNumberOfProducts() == null ? MAX_NUMBER_PRODUCT_DEFAULT : component.getMaxNumberOfProducts();
	    final SearchPageData<ProductData> searchPageData = brakesProductFacade.getRecentPurchasedProducts(ControllerConstants.RecentPurchasedProducts.PAGE_NUMBER_FIRST_PAGE,
				ControllerConstants.RecentPurchasedProducts.DEFAULT_WEEKS_IN_PAST,
                maxNumberOfProducts);
        if(searchPageData.getResults() != null) {
            model.addAttribute ( "productData", searchPageData.getResults() );
        }
    }
}
