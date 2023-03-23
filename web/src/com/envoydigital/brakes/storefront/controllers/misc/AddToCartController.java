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

import com.envoydigital.brakes.facades.BrakesB2BOrderFacade;
import com.envoydigital.brakes.facades.cart.BrakesFavouriteCartFacade;
import com.envoydigital.brakes.facades.constants.BrakesFacadesConstants;
import com.envoydigital.brakes.facades.exception.AmendOrderDeletedException;
import com.envoydigital.brakes.facades.order.data.FavouriteCartModificationData;
import com.envoydigital.brakes.facades.utils.BrakesAmendOrderSessionUtils;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import de.hybris.platform.acceleratorfacades.product.data.ProductWrapperData;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.acceleratorstorefrontcommons.forms.AddToCartForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.AddToCartOrderForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.AddToEntryGroupForm;
import de.hybris.platform.commercefacades.order.CartFacade;
import de.hybris.platform.commercefacades.order.converters.populator.GroupCartModificationListPopulator;
import de.hybris.platform.commercefacades.order.data.AddToCartParams;
import de.hybris.platform.commercefacades.order.data.CartModificationData;
import de.hybris.platform.commercefacades.order.data.OrderEntryData;
import de.hybris.platform.commercefacades.order.data.OrderHistoryData;
import de.hybris.platform.commercefacades.product.ProductFacade;
import de.hybris.platform.commercefacades.product.ProductOption;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commerceservices.order.CommerceCartModificationException;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import de.hybris.platform.servicelayer.session.SessionService;
import de.hybris.platform.util.Config;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.*;


/**
 * Controller for Add to Cart functionality which is not specific to a certain page.
 */
@Controller
public class AddToCartController extends AbstractController
{
	private static final String QUANTITY_ATTR = "quantity";
	private static final String TYPE_MISMATCH_ERROR_CODE = "typeMismatch";
	private static final String ERROR_MSG_TYPE = "errorMsg";
	private static final String QUANTITY_INVALID_BINDING_MESSAGE_KEY = "basket.error.quantity.invalid.binding";
	private static final String SHOWN_PRODUCT_COUNT = "brakesstorefront.storefront.minicart.shownProductCount";
	private static final String REDIRECT_CART_URL = REDIRECT_PREFIX + "/cart";
	private static final String FAVOURITE_UID_PATH_VARIABLE_PATTERN = "/{favouriteUid:.*}";

	private static final Logger LOG = Logger.getLogger(AddToCartController.class);

	@Resource(name = "cartFacade")
	private CartFacade cartFacade;

	@Resource
	private BrakesFavouriteCartFacade favouriteCartFacade;

	@Resource(name = "productVariantFacade")
	private ProductFacade productFacade;

	@Resource(name = "groupCartModificationListPopulator")
	private GroupCartModificationListPopulator groupCartModificationListPopulator;

	@Resource(name = "b2bOrderFacade")
	private BrakesB2BOrderFacade orderFacade;

	@Resource
	private SessionService sessionService;

	@Resource(name = "brakesAmendOrderSessionUtils")
	private BrakesAmendOrderSessionUtils brakesAmendOrderSessionUtils;


	@RequestMapping(value = "/cart/add", method = RequestMethod.POST, produces = "application/json")
	@ResponseBody
	@RequireHardLogIn
	public ResponseEntity<OrderEntryData> addToCart(@RequestParam("productCodePost")
	final String code, final Model model, @Valid
	final AddToCartForm form, final BindingResult bindingErrors)
	{
		ResponseEntity<OrderEntryData> responseEntity = null;
		final OrderEntryData cartEntry = null;
		if (bindingErrors.hasErrors())
		{
			responseEntity = new ResponseEntity(cartEntry, HttpStatus.BAD_REQUEST);
		}
		else if (form.getQty() <= 0)
		{
			responseEntity = new ResponseEntity(cartEntry, HttpStatus.BAD_REQUEST);
		}
		else
		{
			try
			{
				if(brakesAmendOrderSessionUtils.isAmendingOrderSession())
				{
					OrderEntryData orderEntryData = orderFacade.modifyingAmendOrderEntries(code, form.getQty(), sessionService.getAttribute(BrakesFacadesConstants.AMENDING_ORDER_CODE));
					List<OrderEntryData> amendOrderEntries = new ArrayList<>();
					amendOrderEntries.addAll(sessionService.getAttribute(BrakesFacadesConstants.AMENDING_ORDER_ENTRIES));
					amendOrderEntries.add(orderEntryData);
					sessionService.setAttribute(BrakesFacadesConstants.AMENDING_ORDER_ENTRIES, amendOrderEntries);
					responseEntity = new ResponseEntity(orderEntryData, HttpStatus.OK);
				}else {

					final CartModificationData cartModification = addToCartAndPrepareModel(code, form, model);
					responseEntity = new ResponseEntity(cartModification.getEntry(), HttpStatus.OK);
				}
			}
			catch (final CommerceCartModificationException ex)
			{
				logAndPrepareModelAfterCartModificationException(ex, model);
				responseEntity = new ResponseEntity(cartEntry, HttpStatus.INTERNAL_SERVER_ERROR);
			}
			catch (final UnknownIdentifierException ex)
			{
				logAndPrepareModelAfterUnknownIdentifierException(ex, model);
				responseEntity = new ResponseEntity(HttpStatus.FORBIDDEN);
			} catch (AmendOrderDeletedException e) {
				responseEntity = new ResponseEntity(cartEntry, HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}
		return responseEntity;
	}

	@RequestMapping(value = "/cart/add-and-reload", method = RequestMethod.POST, produces = "application/json")
	@RequireHardLogIn
	public String addToCartAndReload(final HttpServletRequest request, final Model model, @Valid
	final AddToCartForm form, final BindingResult bindingErrors, final RedirectAttributes redirectModel,
			@RequestParam(value = "gaActionSource", required = false)
			final String gaActionSource, @RequestHeader(value = "referer", required = false)
			final String referer)
	{
		final OrderEntryData cartEntry = null;
		final String code = request.getParameter("productCodePost");
		if (bindingErrors.hasErrors() || form.getQty() <= 0)
		{
			GlobalMessages.addErrorMessage(model, "basket.error.quantity.invalid");
		}
		else
		{
			try
			{
				final CartModificationData cartModificationData = addToCartAndPrepareModel(code, form, model);
				if (cartModificationData.getQuantityAdded() > 0)
				{
					redirectModel.addFlashAttribute("gaEvent", true);
					redirectModel.addFlashAttribute("gaCategory", "add to basket");
					redirectModel.addFlashAttribute("gaAction", gaActionSource);
					redirectModel.addFlashAttribute("gaLabel", cartModificationData.getEntry().getProduct().getName());
					redirectModel.addFlashAttribute("qty", cartModificationData.getQuantityAdded());
					redirectModel.addFlashAttribute("productCode", cartModificationData.getEntry().getProduct().getCode());
				}
			}
			catch (final CommerceCartModificationException ex)
			{
				logAndPrepareModelAfterCartModificationException(ex, model);
			}
			catch (final UnknownIdentifierException ex)
			{
				logAndPrepareModelAfterUnknownIdentifierException(ex, model);
			}
		}
		return "redirect:" + request.getHeader("Referer");
	}

	@RequestMapping(value = "/cart/notLoggedInAddAction", method = RequestMethod.GET)
	public String handleAddToCartNotLoggedIn(final HttpServletRequest httpServletRequest, final Model model, @Valid
	final AddToCartForm form, final BindingResult bindingErrors)
	{
		//link target for clicking on "Add", when the user is not logged in
		//just return the referer. Spring Securrity forces the user to log in,
		//when the link with the above URL is invoked
		return "redirect:" + httpServletRequest.getHeader("Referer");
	}

	protected String getViewWithBindingErrorMessages(final Model model, final BindingResult bindingErrors)
	{
		bindErrorMessages(model, bindingErrors);
		return ControllerConstants.Views.Fragments.Cart.AddToCartPopup;
	}

	private void bindErrorMessages(final Model model, final BindingResult bindingErrors)
	{
		for (final ObjectError error : bindingErrors.getAllErrors())
		{
			if (isTypeMismatchError(error))
			{
				model.addAttribute(ERROR_MSG_TYPE, QUANTITY_INVALID_BINDING_MESSAGE_KEY);
			}
			else
			{
				model.addAttribute(ERROR_MSG_TYPE, error.getDefaultMessage());
			}
		}
	}

	private CartModificationData addToCartAndPrepareModel(final String code, final AddToCartForm form, final Model model)
			throws CommerceCartModificationException
	{
		final CartModificationData cartModification = cartFacade.addToCart(code, form.getQty());
		model.addAttribute(QUANTITY_ATTR, Long.valueOf(cartModification.getQuantityAdded()));

		if (cartModification.getQuantityAdded() == 0L)
		{
			model.addAttribute(ERROR_MSG_TYPE, "basket.information.quantity.noItemsAdded." + cartModification.getStatusCode());
		}
		else if (cartModification.getQuantityAdded() < form.getQty())
		{
			model.addAttribute(ERROR_MSG_TYPE,
					"basket.information.quantity.reducedNumberOfItemsAdded." + cartModification.getStatusCode());
		}
		return cartModification;
	}

	private void logAndPrepareModelAfterCartModificationException(final CommerceCartModificationException ex, final Model model)
	{
		logDebugException(ex);
		model.addAttribute(ERROR_MSG_TYPE, "basket.error.occurred");
		model.addAttribute(QUANTITY_ATTR, Long.valueOf(0L));
	}

	private void logAndPrepareModelAfterUnknownIdentifierException(final UnknownIdentifierException ex, final Model model)
	{
		LOG.debug(String.format("Product could not be added to cart - %s", ex.getMessage()));
		model.addAttribute(ERROR_MSG_TYPE, "basket.error.occurred");
		model.addAttribute(QUANTITY_ATTR, Long.valueOf(0L));
	}

	protected boolean isTypeMismatchError(final ObjectError error)
	{
		return error.getCode().equals(TYPE_MISMATCH_ERROR_CODE);
	}

	@RequestMapping(value = "/cart/addGrid", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	public final String addGridToCart(@RequestBody
	final AddToCartOrderForm form, final Model model)
	{
		final Set<String> multidErrorMsgs = new HashSet<String>();
		final List<CartModificationData> modificationDataList = new ArrayList<CartModificationData>();

		for (final OrderEntryData cartEntry : form.getCartEntries())
		{
			if (!isValidProductEntry(cartEntry))
			{
				LOG.error("Error processing entry");
			}
			else if (!isValidQuantity(cartEntry))
			{
				multidErrorMsgs.add("basket.error.quantity.invalid");
			}
			else
			{
				final String errorMsg = addEntryToCart(modificationDataList, cartEntry, true);
				if (StringUtils.isNotEmpty(errorMsg))
				{
					multidErrorMsgs.add(errorMsg);
				}

			}
		}

		if (CollectionUtils.isNotEmpty(modificationDataList))
		{
			groupCartModificationListPopulator.populate(null, modificationDataList);

			model.addAttribute("modifications", modificationDataList);
		}

		if (CollectionUtils.isNotEmpty(multidErrorMsgs))
		{
			model.addAttribute("multidErrorMsgs", multidErrorMsgs);
		}

		model.addAttribute("numberShowing", Integer.valueOf(Config.getInt(SHOWN_PRODUCT_COUNT, 3)));


		return ControllerConstants.Views.Fragments.Cart.AddToCartPopup;
	}

	@RequestMapping(value = "/cart/addQuickOrder", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	public final String addQuickOrderToCart(@RequestBody
	final AddToCartOrderForm form, final Model model)
	{
		final List<CartModificationData> modificationDataList = new ArrayList();
		final List<ProductWrapperData> productWrapperDataList = new ArrayList();
		final int maxQuickOrderEntries = Config.getInt("brakesstorefront.quick.order.rows.max", 25);
		final int sizeOfCartEntries = CollectionUtils.size(form.getCartEntries());
		form.getCartEntries().stream().limit(Math.min(sizeOfCartEntries, maxQuickOrderEntries)).forEach(cartEntry -> {
			String errorMsg = StringUtils.EMPTY;
			final String sku = !isValidProductEntry(cartEntry) ? StringUtils.EMPTY : cartEntry.getProduct().getCode();
			if (StringUtils.isEmpty(sku))
			{
				errorMsg = "text.quickOrder.product.code.invalid";
			}
			else if (!isValidQuantity(cartEntry))
			{
				errorMsg = "text.quickOrder.product.quantity.invalid";
			}
			else
			{
				errorMsg = addEntryToCart(modificationDataList, cartEntry, false);
			}

			if (StringUtils.isNotEmpty(errorMsg))
			{
				productWrapperDataList.add(createProductWrapperData(sku, errorMsg));
			}
		});

		if (CollectionUtils.isNotEmpty(productWrapperDataList))
		{
			model.addAttribute("quickOrderErrorData", productWrapperDataList);
			model.addAttribute("quickOrderErrorMsg", "basket.quick.order.error");
		}

		if (CollectionUtils.isNotEmpty(modificationDataList))
		{
			model.addAttribute("modifications", modificationDataList);
		}

		return ControllerConstants.Views.Fragments.Cart.AddToCartPopup;
	}

	@RequireHardLogIn
	@ResponseBody
	@RequestMapping(value = "/cart/addFavourite", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	public final ResponseEntity addFavouriteToCart(@RequestParam
	final String favouriteUid, final Model model)
	{
		try
		{
			final FavouriteCartModificationData favouriteCartModificationData = favouriteCartFacade.addFavouriteToCart(favouriteUid);
			return new ResponseEntity(favouriteCartModificationData, HttpStatus.OK);

		}
		catch (final Exception e)
		{
			LOG.error("Exception while adding list to cart" + e.getMessage());
			return new ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@RequestMapping(value = "/entrygroups/cart/addToEntryGroup", method =
	{ RequestMethod.POST, RequestMethod.GET })
	public String addEntryGroupToCart(final Model model, @Valid
	final AddToEntryGroupForm form, final BindingResult bindingErrors)
	{
		if (bindingErrors.hasErrors())
		{
			return getViewWithBindingErrorMessages(model, bindingErrors);
		}
		final long qty = 1;
		try
		{
			final AddToCartParams addToCartParams = new AddToCartParams();
			addToCartParams.setEntryGroupNumbers(new HashSet(Collections.singletonList(form.getEntryGroupNumber())));
			addToCartParams.setProductCode(form.getProductCode());
			addToCartParams.setQuantity(qty);
			addToCartParams.setStoreId(null);
			final CartModificationData cartModification = cartFacade.addToCart(addToCartParams);
			model.addAttribute(QUANTITY_ATTR, Long.valueOf(cartModification.getQuantityAdded()));
			model.addAttribute("entry", cartModification.getEntry());
			model.addAttribute("cartCode", cartModification.getCartCode());

			if (cartModification.getQuantityAdded() == 0L)
			{
				model.addAttribute(ERROR_MSG_TYPE, "basket.information.quantity.noItemsAdded." + cartModification.getStatusCode());
			}
			else if (cartModification.getQuantityAdded() < qty)
			{
				model.addAttribute(ERROR_MSG_TYPE,
						"basket.information.quantity.reducedNumberOfItemsAdded." + cartModification.getStatusCode());
			}
		}
		catch (final CommerceCartModificationException ex)
		{
			logDebugException(ex);
			model.addAttribute(ERROR_MSG_TYPE, "basket.error.occurred");
			model.addAttribute(QUANTITY_ATTR, Long.valueOf(0L));
		}
		model.addAttribute("product",
				productFacade.getProductForCodeAndOptions(form.getProductCode(), Arrays.asList(ProductOption.BASIC)));

		return REDIRECT_PREFIX + "/cart";
	}

	protected ProductWrapperData createProductWrapperData(final String sku, final String errorMsg)
	{
		final ProductWrapperData productWrapperData = new ProductWrapperData();
		final ProductData productData = new ProductData();
		productData.setCode(sku);
		productWrapperData.setProductData(productData);
		productWrapperData.setErrorMsg(errorMsg);
		return productWrapperData;
	}

	protected void logDebugException(final Exception ex)
	{
		if (LOG.isDebugEnabled())
		{
			LOG.debug(ex);
		}
	}

	protected String addEntryToCart(final List<CartModificationData> modificationDataList, final OrderEntryData cartEntry,
			final boolean isReducedQtyError)
	{
		String errorMsg = StringUtils.EMPTY;
		try
		{
			final long qty = cartEntry.getQuantity().longValue();
			final CartModificationData cartModificationData = cartFacade.addToCart(cartEntry.getProduct().getCode(), qty);
			if (cartModificationData.getQuantityAdded() == 0L)
			{
				errorMsg = "basket.information.quantity.noItemsAdded." + cartModificationData.getStatusCode();
			}
			else if (cartModificationData.getQuantityAdded() < qty && isReducedQtyError)
			{
				errorMsg = "basket.information.quantity.reducedNumberOfItemsAdded." + cartModificationData.getStatusCode();
			}

			modificationDataList.add(cartModificationData);

		}
		catch (final CommerceCartModificationException ex)
		{
			errorMsg = "basket.error.occurred";
			logDebugException(ex);
		}
		return errorMsg;
	}

	protected boolean isValidProductEntry(final OrderEntryData cartEntry)
	{
		return cartEntry.getProduct() != null && StringUtils.isNotBlank(cartEntry.getProduct().getCode());
	}

	protected boolean isValidQuantity(final OrderEntryData cartEntry)
	{
		return cartEntry.getQuantity() != null && cartEntry.getQuantity().longValue() >= 1L;
	}
}
