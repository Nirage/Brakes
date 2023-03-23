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

import com.envoydigital.brakes.core.enums.FavouriteComponentType;
import com.envoydigital.brakes.core.model.components.FavouriteGridComponentModel;
import com.envoydigital.brakes.facades.wishlist.data.FavouritesData;
import com.envoydigital.brakes.facades.wishlist.impl.FavouritesSearchPageEvaluator;
import com.envoydigital.brakes.facades.search.impl.SearchContext;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.core.servicelayer.data.SearchPageData;
import de.hybris.platform.servicelayer.search.paginated.constants.SearchConstants;
import de.hybris.platform.wishlist2.model.Wishlist2Model;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Collections;


/**
 * Controller for CMS FavouriteGridComponent.
 */
@Controller("FavouriteGridComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.FavouriteGridComponent)
@RequireHardLogIn
public class FavouriteGridComponentController extends AbstractAcceleratorCMSComponentController<FavouriteGridComponentModel> {


    private static final Logger LOG = Logger.getLogger ( FavouriteGridComponentController.class );

    @Resource(name = "favouritesSearchPageEvaluator")
    private FavouritesSearchPageEvaluator favouritesSearchPageEvaluator;

    @Override
    protected void fillModel(final HttpServletRequest request, final Model model, final FavouriteGridComponentModel component) {
        SearchContext.ShowMode showMode = SearchContext.ShowMode.valueOf ( StringUtils.defaultIfEmpty ( (String) request.getAttribute ( "show" ), "Page" ) );
        int page = NumberUtils.toInt ( (String) request.getAttribute ( "pageNumber" ), 0 );

        SearchPageData<FavouritesData> searchPageData = performFavouritesResultPage ( page, component.getComponentType (), showMode );

        model.addAttribute ( "favouritesPageData", searchPageData );
    }

    protected SearchPageData<FavouritesData> performFavouritesResultPage(final int page, final FavouriteComponentType type, final SearchContext.ShowMode showMode) {
        // Will be prioritized by rank
        SearchContext searchContext = new SearchContext ( null, page, type, showMode, Collections.singletonMap ( Wishlist2Model.RANK, SearchConstants.ASCENDING ) );
        return favouritesSearchPageEvaluator.doSearch (searchContext);
    }


}
