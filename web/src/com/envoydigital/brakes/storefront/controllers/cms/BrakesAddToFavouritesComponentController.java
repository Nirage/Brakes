/*
 * [y] hybris Platform
 *
 * Copyright (c) 2018 SAP SE or an SAP affiliate company.  All rights reserved.
 *
 * This software is the confidential and proprietary information of SAP
 * ("Confidential Information"). You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms of the
 * license agreement you entered into with SAP.
 */
package com.envoydigital.brakes.storefront.controllers.cms;

import com.envoydigital.brakes.core.model.components.BrakesAddToFavouritesComponentModel;
import com.envoydigital.brakes.facades.wishlist.FavouritesFacade;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.commercefacades.product.data.ProductData;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;


/**
 * Controller for CMS BrakesAddToFavouritesComponent
 */
@Controller("BrakesAddToFavouritesComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.BrakesAddToFavouritesComponent)
@RequireHardLogIn
public class BrakesAddToFavouritesComponentController extends AbstractAcceleratorCMSComponentController<BrakesAddToFavouritesComponentModel> {
    public static final String HAS_PRODUCT_IN_FAVOURITES = "hasProductInFavourites";

    @Resource(name = "favouritesFacade")
    private FavouritesFacade favouritesFacade;

    @Override
    protected void fillModel(final HttpServletRequest request, final Model model, final BrakesAddToFavouritesComponentModel component) {
        ProductData productData = ( (ProductData) request.getAttribute ( "product" ) );
        if (productData != null)
            model.addAttribute ( HAS_PRODUCT_IN_FAVOURITES, favouritesFacade.hasFavouritesForProduct ( productData.getCode () ) );
    }
}
