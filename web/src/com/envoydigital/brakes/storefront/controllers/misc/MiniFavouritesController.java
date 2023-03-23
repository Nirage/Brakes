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
package com.envoydigital.brakes.storefront.controllers.misc;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.servicelayer.services.CMSComponentService;

import java.util.List;
import java.util.Optional;

import javax.annotation.Resource;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.envoydigital.brakes.core.model.components.BrakesMiniFavouritesComponentModel;
import com.envoydigital.brakes.facades.wishlist.FavouritesFacade;
import com.envoydigital.brakes.facades.wishlist.data.FavouritesData;
import com.envoydigital.brakes.facades.wishlist.data.MiniFavouritesPageData;


/**
 * Controller for MiniFavourites functionality which is not specific to a page.
 */
@Controller
public class MiniFavouritesController extends AbstractController {
    /**
     * We use this suffix pattern because of an issue with Spring 3.1 where a Uri value is incorrectly extracted if it
     * contains on or more '.' characters. Please see https://jira.springsource.org/browse/SPR-6164 for a discussion on
     * the issue and future resolution.
     */
    private static final String COMPONENT_UID_PATH_VARIABLE_PATTERN = "{componentUid:.*}";

    @Resource(name = "favouritesFacade")
    private FavouritesFacade favouritesFacade;

    @Resource(name = "cmsComponentService")
    private CMSComponentService cmsComponentService;


    @ResponseBody
    @RequestMapping(value = "/favourites/rollover/" + COMPONENT_UID_PATH_VARIABLE_PATTERN, method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String> rolloverMiniFavouritesPopup(@PathVariable final String componentUid, final Model model)
            throws CMSItemNotFoundException {
        final BrakesMiniFavouritesComponentModel component = cmsComponentService.getSimpleCMSComponent ( componentUid );

        final List<FavouritesData> favourites = favouritesFacade.getFavourites ( component.getShownFavouritesCount () );

        final Integer numberOfFavourites = Optional.ofNullable ( favourites ).map ( List::size ).orElse ( 0 );

        final MiniFavouritesPageData miniFavouritesPageData = new MiniFavouritesPageData ();
        miniFavouritesPageData.setFavourites ( favourites );
        miniFavouritesPageData.setNumberOfFavourites ( numberOfFavourites );

        if (numberOfFavourites < component.getShownFavouritesCount ())
		{
			miniFavouritesPageData.setNumberShowing ( numberOfFavourites );
		}
		else
		{
			miniFavouritesPageData.setNumberShowing ( Integer.valueOf ( component.getShownFavouritesCount () ) );
		}


        return new ResponseEntity ( miniFavouritesPageData, HttpStatus.OK );
    }


	@ResponseBody
	@RequestMapping(value = "/favourites/rollover", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> rolloverMiniFavourites(final Model model) throws CMSItemNotFoundException
	{

		final List<FavouritesData> favourites = favouritesFacade.getFavourites(-1);

		final Integer numberOfFavourites = Optional.ofNullable(favourites).map(List::size).orElse(0);

		final MiniFavouritesPageData miniFavouritesPageData = new MiniFavouritesPageData();
		miniFavouritesPageData.setFavourites(favourites);
		miniFavouritesPageData.setNumberOfFavourites(numberOfFavourites);

		return new ResponseEntity(miniFavouritesPageData, HttpStatus.OK);
	}
}