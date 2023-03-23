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

import com.envoydigital.brakes.core.util.BrakesCoreUtils;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.servicelayer.services.CMSComponentService;
import de.hybris.platform.commercefacades.user.UserFacade;
import de.hybris.platform.servicelayer.config.ConfigurationService;
import de.hybris.platform.servicelayer.i18n.I18NService;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.envoydigital.brakes.core.model.components.BrakesAddToFavouritesComponentModel;
import com.envoydigital.brakes.core.services.BrakesWishlist2Service;
import com.envoydigital.brakes.facades.wishlist.FavouritesFacade;
import com.envoydigital.brakes.facades.wishlist.data.AddToFavouriteResponseData;
import com.envoydigital.brakes.facades.wishlist.data.FavouriteModificationData;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.QuickAddItemToFavouriteForm;
import com.envoydigital.brakes.storefront.forms.validation.QuickAddFavouriteItemValidator;


/**
 * Controller for Add to Favourites functionality.
 */
@Controller
public class AddToFavouritesController extends AbstractController
{
	private static final String COMPONENT_UID_PATH_VARIABLE_PATTERN = "{componentUid:.*}";
	private static final String PRODUCT_CODE_UID_PATH_VARIABLE_PATTERN = "{productCode:.*}";
	private static final String FAVOURITE_UID_PATH_VARIABLE_PATTERN = "{favouriteUid:.*}";
	private static final String MAX_WISHLIST_LIMIT = "wishlist.maximum.limit";

	private static final Logger LOG = Logger.getLogger(AddToFavouritesController.class);

	@Resource(name = "favouritesFacade")
	private FavouritesFacade favouritesFacade;

	@Resource(name = "cmsComponentService")
	private CMSComponentService cmsComponentService;

	@Resource
	private QuickAddFavouriteItemValidator quickAddFavouriteItemValidator;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Resource(name = "i18nService")
	private I18NService i18nService;

	@Resource(name = "configurationService")
	private ConfigurationService configurationService;

	@Resource(name = "userFacade")
	private UserFacade userFacade;

	@RequestMapping(value = "/favourites/rollover/add/" + COMPONENT_UID_PATH_VARIABLE_PATTERN + "/"
			+ PRODUCT_CODE_UID_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
	public String addFavouritesPopup(@PathVariable
	final String componentUid, @PathVariable
	final String productCode, final Model model) throws CMSItemNotFoundException
	{

		if (userFacade.isAnonymousUser())
		{
			return REDIRECT_PREFIX + "/isAnonymousUser";
		}
		final BrakesAddToFavouritesComponentModel component = (BrakesAddToFavouritesComponentModel) cmsComponentService
				.getSimpleCMSComponent(componentUid);

		final AddToFavouriteResponseData response = favouritesFacade.getFavouritesWithSelected(productCode);
		if (response != null)
		{
			model.addAttribute("response", response);
			model.addAttribute("limitWishlist", configurationService.getConfiguration().getProperty(MAX_WISHLIST_LIMIT));
			model.addAttribute("numberOfFavourites", response.getNumberofFavourites());
			if (response.getNumberofFavourites() < component.getScrollableFavouritesCount())
			{
				model.addAttribute("numberShowing", Integer.valueOf(response.getNumberofFavourites()));
			}
			else
			{
				model.addAttribute("numberShowing", Integer.valueOf(component.getScrollableFavouritesCount()));
			}
		}

		return ControllerConstants.Views.Fragments.Favourites.AddToFavouritesPopup;
	}

	@RequestMapping(value = "/favourites/add/" + FAVOURITE_UID_PATH_VARIABLE_PATTERN + "/"
			+ PRODUCT_CODE_UID_PATH_VARIABLE_PATTERN, method = RequestMethod.POST, produces = "application/json")
	@ResponseBody
	@RequireHardLogIn
	public ResponseEntity addToFavourites(@PathVariable
	final String favouriteUid, @PathVariable
	final String productCode, final Model model)
	{
		try
		{
			final FavouriteModificationData favouriteModificationData = favouritesFacade.addToFavourites(favouriteUid, productCode);
			return new ResponseEntity(favouriteModificationData, HttpStatus.OK);

		}
		catch (final Exception e)
		{
			LOG.error(e.getMessage());
			return new ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@RequestMapping(value = "/isAnonymousUser", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public String isAnonymousUser()
	{
		return "{\"redirect\":\"true\",\"redirect_url\":\"/sign-in\"}";
	}


	@RequestMapping(value = "/favourites/quickAdd", method = RequestMethod.POST)
	@ResponseBody
	@RequireHardLogIn
	public ResponseEntity quickAddToFavourites(final QuickAddItemToFavouriteForm quickAddItemToFavouriteForm,
			final BindingResult bindingResult, final Model model)
	{
		return prepareQuickAddToFavourites(quickAddItemToFavouriteForm, bindingResult, model);
	}

	private ResponseEntity prepareQuickAddToFavourites(final QuickAddItemToFavouriteForm quickAddItemToFavouriteForm,
			final BindingResult bindingResult, final Model model)
	{
		// validating favourite uid, product code and qty as per the rules
		quickAddFavouriteItemValidator.validate(quickAddItemToFavouriteForm, bindingResult);
		if (bindingResult.hasErrors())
		{
			final FavouriteModificationData modificationData = createFavouriteModificationData(
					quickAddItemToFavouriteForm.getFavouriteUid(), bindingResult.getFieldError().getCode());
			return new ResponseEntity(modificationData, HttpStatus.OK);
		}
		else
		{
			try
			{
				final FavouriteModificationData modificationData = favouritesFacade
						.addToFavourites(BrakesCoreUtils.decrypt(quickAddItemToFavouriteForm.getFavouriteUid()), quickAddItemToFavouriteForm.getProductCode());
				if (BrakesWishlist2Service.SUCCESS.equals(modificationData.getStatusCode()))
				{
					modificationData.setStatusMessage(
							messageSource.getMessage("favourite.quickadd.success", null, i18nService.getCurrentLocale()));
				}
				else if (BrakesWishlist2Service.AVAILABLE.equals(modificationData.getStatusCode()))
				{
					modificationData.setStatusMessage(
							messageSource.getMessage("error.favourite.item.available", null, i18nService.getCurrentLocale()));
				}

				return new ResponseEntity(modificationData, HttpStatus.OK);
			}
			catch (final Exception e)
			{
				LOG.error(e.getMessage());
				return new ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}
	}

	private FavouriteModificationData createFavouriteModificationData(final String uid, final String code)
	{
		final FavouriteModificationData modificationData = new FavouriteModificationData();
		modificationData.setStatusCode(BrakesWishlist2Service.FAILED);
		modificationData.setUid(uid);
		modificationData.setStatusMessage(messageSource.getMessage(code, null, i18nService.getCurrentLocale()));
		return modificationData;
	}

	@RequestMapping(value = "/favourites/saveCartAsFavourite", method = RequestMethod.POST)
	@ResponseBody
	@RequireHardLogIn
	public ResponseEntity quickAddToFavourites(@RequestParam
	final String favouriteUid, @RequestParam
	final String cartCode, final Model model)
	{

		final String decryptedFavouriteUid = BrakesCoreUtils.decrypt(favouriteUid);
		boolean added = favouritesFacade.saveCartAsFavourite(decryptedFavouriteUid, cartCode);
		return new ResponseEntity(added, HttpStatus.OK);

	}


}
