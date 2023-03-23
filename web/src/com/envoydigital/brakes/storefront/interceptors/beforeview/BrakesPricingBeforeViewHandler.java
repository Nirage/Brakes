package com.envoydigital.brakes.storefront.interceptors.beforeview;

import com.envoydigital.brakes.core.services.BrakesExternalPriceService;
import de.hybris.platform.acceleratorstorefrontcommons.interceptors.BeforeViewHandler;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class BrakesPricingBeforeViewHandler implements BeforeViewHandler {

    private BrakesExternalPriceService externalPriceService;

    @Override
    public void beforeView(final HttpServletRequest request, final HttpServletResponse response, final ModelAndView modelAndView) {
        modelAndView.addObject("ajaxPricingEnabled", getExternalPriceService().isAjaxPriceEnabled());
        modelAndView.addObject("searchTimePricingEnabled", getExternalPriceService().isSearchTimePriceEnabled());
    }

    protected BrakesExternalPriceService getExternalPriceService() {
        return externalPriceService;
    }

    @Required
    public void setExternalPriceService(BrakesExternalPriceService externalPriceService) {
        this.externalPriceService = externalPriceService;
    }
}
