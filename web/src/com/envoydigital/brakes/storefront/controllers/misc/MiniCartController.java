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

import de.hybris.platform.acceleratorcms.model.components.MiniCartComponentModel;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import de.hybris.platform.b2bcommercefacades.company.data.B2BUnitData;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.servicelayer.services.CMSComponentService;
import de.hybris.platform.cms2.servicelayer.services.CMSSiteService;
import de.hybris.platform.commercefacades.order.data.CartData;
import de.hybris.platform.commercefacades.product.data.PriceData;
import de.hybris.platform.commercefacades.storesession.StoreSessionFacade;
import de.hybris.platform.commercefacades.user.UserFacade;
import de.hybris.platform.servicelayer.config.ConfigurationService;
import de.hybris.platform.util.Config;

import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.envoydigital.brakes.facades.BrakesB2BUnitFacade;
import com.envoydigital.brakes.facades.cart.BrakesCartFacade;
import com.envoydigital.brakes.facades.cart.BrakesSaveCartFacade;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.QuickOrderForm;
import com.envoydigital.brakes.storefront.util.EnhancedXssFilterUtil;


/**
 * Controller for MiniCart functionality which is not specific to a page.
 */
@Controller
public class MiniCartController extends AbstractController
{
	/**
	 * We use this suffix pattern because of an issue with Spring 3.1 where a Uri value is incorrectly extracted if it
	 * contains on or more '.' characters. Please see https://jira.springsource.org/browse/SPR-6164 for a discussion on
	 * the issue and future resolution.
	 */
	private static final String TOTAL_DISPLAY_PATH_VARIABLE_PATTERN = "{totalDisplay:.*}";
	private static final String COMPONENT_UID_PATH_VARIABLE_PATTERN = "{componentUid:.*}";
	private static final String CART = "cart";
	private static final String SAVE_CART_COUNT_FOR_CURRENT_USER = "saveCartCountForCurrntUser";
	private static final String USER_BASKET_MAX_LIMIT = "brakes.user.basket.max.limit";


	@Resource(name = "userFacade")
	private UserFacade userFacade;

	@Resource(name = "saveCartFacade")
	private BrakesSaveCartFacade saveCartFacade;

	@Resource(name = "cartFacade")
	private BrakesCartFacade cartFacade;

	@Resource(name = "cmsComponentService")
	private CMSComponentService cmsComponentService;

	@Resource(name = "configurationService")
	private ConfigurationService configurationService;

	@Resource(name = "brakesB2BUnitFacade")
	private BrakesB2BUnitFacade brakesB2BUnitFacade;

	@Resource(name = "storeSessionFacade")
	private StoreSessionFacade storeSessionFacade;

	@Resource(name = "cmsSiteService")
	private CMSSiteService cmsSiteService;

	@RequestMapping(value = "/cart/miniCart/" + TOTAL_DISPLAY_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
	public String getMiniCart(@PathVariable
	final String totalDisplay, final Model model)
	{
		final CartData cartData = cartFacade.getMiniCart();
		model.addAttribute("totalPrice", cartData.getTotalPrice());
		model.addAttribute("subTotal", cartData.getSubTotal());
		if (cartData.getDeliveryCost() != null)
		{
			final PriceData withoutDelivery = cartData.getDeliveryCost();
			withoutDelivery.setValue(cartData.getTotalPrice().getValue().subtract(cartData.getDeliveryCost().getValue()));
			model.addAttribute("totalNoDelivery", withoutDelivery);
		}
		else
		{
			model.addAttribute("totalNoDelivery", cartData.getTotalPrice());
		}
		model.addAttribute("totalItems", cartData.getTotalItems());
		model.addAttribute("totalDisplay", totalDisplay);
		return ControllerConstants.Views.Fragments.Cart.MiniCartPanel;
	}

	@RequestMapping(value = "/cart/miniCart/details", method = RequestMethod.GET)
	@RequireHardLogIn
	public String getMiniCartWithCompletEntrySet(
			@RequestParam(value = "unavailableProductsFlag", required = false, defaultValue = "false")
			final boolean unavailableProductsFlag, final Model model)
	{

		final CartData cart = cartFacade.getSessionCartWithEntryOrdering(true);
		final B2BUnitData currentB2BUnit = brakesB2BUnitFacade.getCurrentB2BUnit();

		if (null != cart)
		{
			boolean showCreateNewBasket = false;

			final Integer saveCartCountForCurrntUser = saveCartFacade.getSavedCartsCountForCurrentUserAndUnit();
			if (saveCartCountForCurrntUser < Config.getInt(USER_BASKET_MAX_LIMIT, 10))
			{
				showCreateNewBasket = true;
			}
			model.addAttribute("unavailableProductsFlag", unavailableProductsFlag);
			model.addAttribute("savedCarts", saveCartFacade.getSavedCartsForCurrentUserAndUnit());
			model.addAttribute("currentB2BUnit", currentB2BUnit);
			model.addAttribute("currentCurrency", storeSessionFacade.getCurrentCurrency());
			model.addAttribute(new QuickOrderForm());
			model.addAttribute("showCreateNewBasket", showCreateNewBasket);
			model.addAttribute(CART, cart);
			model.addAttribute(SAVE_CART_COUNT_FOR_CURRENT_USER, saveCartCountForCurrntUser);
			model.addAttribute("cartLargeQuantity",
					configurationService.getConfiguration().getInt("cart.large.quantity.value", 100));
			model.addAttribute("cartMaximumQuantity", cartFacade.getCartMaximumQuantity(cmsSiteService.getCurrentSite()));
		}
		return ControllerConstants.Views.Fragments.Cart.MiniCartDetails;
	}


	@RequestMapping(value = "/cart/rollover/" + COMPONENT_UID_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
	public String rolloverMiniCartPopup(@PathVariable
	final String componentUid, final Model model) throws CMSItemNotFoundException
	{
		final String sanitizedComponentUid = EnhancedXssFilterUtil.filter(componentUid);
		final CartData cartData = cartFacade.getSessionCart();
		model.addAttribute("cartData", cartData);

		final MiniCartComponentModel component = (MiniCartComponentModel) cmsComponentService
				.getSimpleCMSComponent(sanitizedComponentUid);

		final List entries = cartData.getEntries();
		if (entries != null)
		{
			Collections.reverse(entries);
			model.addAttribute("entries", entries);

			model.addAttribute("numberItemsInCart", Integer.valueOf(entries.size()));
			model.addAttribute("forceEnableCheckout", CollectionUtils.isNotEmpty(cartData.getRootGroups()));
			if (entries.size() < component.getShownProductCount())
			{
				model.addAttribute("numberShowing", Integer.valueOf(entries.size()));
			}
			else
			{
				model.addAttribute("numberShowing", Integer.valueOf(component.getShownProductCount()));
			}
		}
		model.addAttribute("lightboxBannerComponent", component.getLightboxBannerComponent());

		return ControllerConstants.Views.Fragments.Cart.CartPopup;
	}
}
