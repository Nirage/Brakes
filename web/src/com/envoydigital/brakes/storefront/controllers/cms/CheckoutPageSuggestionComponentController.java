package com.envoydigital.brakes.storefront.controllers.cms;

import com.envoydigital.brakes.core.model.components.CheckoutPageSuggestionComponentModel;
import com.envoydigital.brakes.facades.BrakesProductFacade;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.cms.AbstractCMSComponentController;
import de.hybris.platform.commercefacades.order.CartFacade;
import de.hybris.platform.commercefacades.product.ProductOption;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.servicelayer.i18n.I18NService;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Controller("CheckoutPageSuggestionComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.CheckoutPageSuggestionComponent)
public class CheckoutPageSuggestionComponentController extends AbstractCMSComponentController<CheckoutPageSuggestionComponentModel> {

    protected static final List<ProductOption> PRODUCT_OPTIONS = Arrays.asList(ProductOption.BASIC, ProductOption.CART,
            ProductOption.ADDITIONAL_PRICE_ATTR, ProductOption.PRICE, ProductOption.BRAKESPRODUCTDETAILS, ProductOption.PRODCT_TILE_ICONS);

    private static final String SUGGESTION_MISSING_ANYTHING_TYPE = "missing-anything";
    private static final String SUGGESTION_BEST_SELLERS_TYPE = "best-sellers";

    @Resource(name = "cartFacade")
    private CartFacade cartFacade;

    @Resource(name = "defaultBrakesProductFacade")
    private BrakesProductFacade brakesProductFacade;

    @Resource
    private MessageSource messageSource;

    @Resource
    private I18NService i18NService;

    @Override
    protected void fillModel(HttpServletRequest request, Model model, CheckoutPageSuggestionComponentModel component) {
        if (cartFacade.hasSessionCart())
        {
            List<ProductData> productSuggestions = new ArrayList<>();
            if(isValueValid(component.getOrdersAgeInDays()) && isValueValid(component.getMaximumNumberProducts())) {
                model.addAttribute("suggestionType", SUGGESTION_MISSING_ANYTHING_TYPE);
                model.addAttribute("title", messageSource.getMessage("checkout.page.suggestion.missing.anything.title",null, i18NService.getCurrentLocale()));
                model.addAttribute("subTitle", messageSource.getMessage("checkout.page.suggestion.missing.anything.sub.title",null, i18NService.getCurrentLocale()));
                List<ProductData> nonFilteredSuggestions = brakesProductFacade.getMostPurchasedProductsForCurrentB2BUnit(component.getOrdersAgeInDays(), component.getMaximumNumberProducts());
                productSuggestions.addAll(brakesProductFacade.filterProductDataForCheckoutSuggestions(nonFilteredSuggestions));
            }
            if(CollectionUtils.isEmpty(productSuggestions)) {
                model.addAttribute("suggestionType", SUGGESTION_BEST_SELLERS_TYPE);
                model.addAttribute("title", messageSource.getMessage("checkout.page.suggestion.best.seller.title",null, i18NService.getCurrentLocale()));
                model.addAttribute("subTitle", messageSource.getMessage("checkout.page.suggestion.best.seller.sub.title",null, i18NService.getCurrentLocale()));
                productSuggestions.addAll(brakesProductFacade.collectBestSellerProducts(component));
            }

            model.addAttribute("suggestions", productSuggestions);
            model.addAttribute("redirectTargetAfterAddToCart", "/checkout");
        }
    }


    private boolean isValueValid(Integer value) {
        return value != null && value > 0;
    }

    @Override
    protected String getView(CheckoutPageSuggestionComponentModel component) {
        return ControllerConstants.Views.Cms.ComponentPrefix + StringUtils.lowerCase(CheckoutPageSuggestionComponentModel._TYPECODE);
    }
}
