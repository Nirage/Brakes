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
package com.envoydigital.brakes.storefront.controllers.pages;

import com.envoydigital.brakes.core.data.DeliveryCalendarData;
import com.envoydigital.brakes.facades.BrakesB2BOrderFacade;
import com.envoydigital.brakes.facades.BrakesB2BUnitFacade;
import com.envoydigital.brakes.facades.BrakesDeliveryCalendarFacade;
import com.envoydigital.brakes.facades.cart.BrakesSaveCartFacade;
import com.envoydigital.brakes.facades.constants.BrakesFacadesConstants;
import com.envoydigital.brakes.facades.coupon.CartEligibleData;
import com.envoydigital.brakes.facades.coupons.BrakesCouponFacade;
import com.envoydigital.brakes.facades.exception.AmendOrderDeletedException;
import com.envoydigital.brakes.facades.promotions.data.PotentialPromotionData;
import com.envoydigital.brakes.facades.user.BrakesUserFacade;
import com.envoydigital.brakes.facades.utils.BrakesAmendOrderSessionUtils;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.DeliveryCalendarForm;
import com.envoydigital.brakes.storefront.forms.QuickOrderForm;
import com.envoydigital.brakes.storefront.forms.validation.QuickOrderValidator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import de.hybris.platform.acceleratorfacades.cart.action.CartEntryAction;
import de.hybris.platform.acceleratorfacades.cart.action.CartEntryActionFacade;
import de.hybris.platform.acceleratorfacades.cart.action.exceptions.CartEntryActionException;
import de.hybris.platform.acceleratorfacades.csv.CsvFacade;
import de.hybris.platform.acceleratorfacades.flow.impl.SessionOverrideCheckoutFlowFacade;
import de.hybris.platform.acceleratorservices.controllers.page.PageType;
import de.hybris.platform.acceleratorservices.enums.CheckoutFlowEnum;
import de.hybris.platform.acceleratorservices.enums.CheckoutPciOptionEnum;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.ResourceBreadcrumbBuilder;
import de.hybris.platform.acceleratorstorefrontcommons.constants.WebConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractCartPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.acceleratorstorefrontcommons.forms.AddToCartForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.UpdateQuantityForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.VoucherForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.validation.SaveCartFormValidator;
import de.hybris.platform.acceleratorstorefrontcommons.util.XSSFilterUtil;
import de.hybris.platform.b2bcommercefacades.company.data.B2BUnitData;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.servicelayer.services.CMSSiteService;
import de.hybris.platform.commercefacades.order.data.*;
import de.hybris.platform.commercefacades.product.ProductFacade;
import de.hybris.platform.commercefacades.product.ProductOption;
import de.hybris.platform.commercefacades.product.data.PriceData;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commercefacades.quote.data.QuoteData;
import de.hybris.platform.commercefacades.storesession.StoreSessionFacade;
import de.hybris.platform.commercefacades.voucher.exceptions.VoucherOperationException;
import de.hybris.platform.commerceservices.order.CommerceCartModificationException;
import de.hybris.platform.commerceservices.order.CommerceSaveCartException;
import de.hybris.platform.core.model.order.AbstractOrderEntryModel;
import de.hybris.platform.enumeration.EnumerationService;
import de.hybris.platform.order.CartService;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import de.hybris.platform.servicelayer.session.SessionService;
import de.hybris.platform.site.BaseSiteService;
import de.hybris.platform.util.Config;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StreamUtils;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.io.IOException;
import java.io.StringWriter;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


/**
 * Controller for cart page
 */
@Controller
@RequestMapping(value = "/cart")
public class CartPageController extends AbstractCartPageController
{
	private static final Logger LOGGER = Logger.getLogger(CartPageController.class);
	public static final String SHOW_CHECKOUT_STRATEGY_OPTIONS = "storefront.show.checkout.flows";
	public static final String ERROR_MSG_TYPE = "errorMsg";
	public static final String SUCCESSFUL_MODIFICATION_CODE = "success";
	public static final String VOUCHER_FORM = "voucherForm";
	public static final String SITE_QUOTES_ENABLED = "site.quotes.enabled.";
	private static final String CART_CHECKOUT_ERROR = "cart.checkout.error";
	private static final String CART = "cart";
	private static final String SAVE_CART_COUNT_FOR_CURRENT_USER = "saveCartCountForCurrntUser";
	private static final String ACTION_CODE_PATH_VARIABLE_PATTERN = "{actionCode:.*}";

	private static final String REDIRECT_CART_URL = REDIRECT_PREFIX + "/cart";
	private static final String REDIRECT_CHECKOUT_URL = REDIRECT_PREFIX + "/checkout";
	private static final String REDIRECT_HOMEPAGE_URL = REDIRECT_PREFIX + "/";
	private static final String REDIRECT_QUOTE_EDIT_URL = REDIRECT_PREFIX + "/quote/%s/edit/";
	private static final String REDIRECT_QUOTE_VIEW_URL = REDIRECT_PREFIX + "/my-account/my-quotes/%s/";
	private static final String USER_BASKET_MAX_LIMIT = "brakes.user.basket.max.limit";
	private static final String CART_ENTRY_QTY_UPDATE = "update";
	private static final String SHOW_PRODUCT_ALREADY_EXIST_IN_CART_WARNING = "isProductAlreadyExistInCart";
	private static final String SHOW_QTY_MAX_LIMIT_EXCEEDED_WARNING = "isQtyMaxLimitExceeded";
	public static final String TOTAL_ITEMS = "totalItems";
	public static final String DATE_FORMAT = "yyyy-MM-dd";
	private static final String PROMOTIONS_DELIVERYDATE_CHANGE = "cart.promotions.delivery.date.change";
	private static final String VOUCHER_ERROR_MSG = "voucherErrorMsg";
	private static final String VOUCHER_SUCCESS_MSG = "voucherSuccessMsg";
	private static final String VOUCHER_WARNING_MSG = "voucherWarningMsg";


	private static final Logger LOG = Logger.getLogger(CartPageController.class);

	@Resource(name = "simpleBreadcrumbBuilder")
	private ResourceBreadcrumbBuilder resourceBreadcrumbBuilder;

	@Resource(name = "enumerationService")
	private EnumerationService enumerationService;

	@Resource(name = "productVariantFacade")
	private ProductFacade productFacade;

	@Resource(name = "saveCartFacade")
	private BrakesSaveCartFacade saveCartFacade;

	@Resource(name = "saveCartFormValidator")
	private SaveCartFormValidator saveCartFormValidator;

	@Resource(name = "csvFacade")
	private CsvFacade csvFacade;

	@Resource(name = "voucherFacade")
	private BrakesCouponFacade couponFacade;

	@Resource(name = "baseSiteService")
	private BaseSiteService baseSiteService;

	@Resource(name = "cartEntryActionFacade")
	private CartEntryActionFacade cartEntryActionFacade;

	@Resource(name = "brakesUserFacade")
	private BrakesUserFacade brakesUserFacade;
	@Resource(name = "brakesB2BUnitFacade")
	private BrakesB2BUnitFacade brakesB2BUnitFacade;

	@Resource(name = "quickOrderValidator")
	private QuickOrderValidator quickOrderValidator;

	@Resource(name = "cartFacade")
	private com.envoydigital.brakes.facades.cart.BrakesCartFacade brakesCartFacade;

	@Resource(name = "storeSessionFacade")
	private StoreSessionFacade storeSessionFacade;

	@Resource(name = "cartService")
	private CartService cartService;

	@Resource(name = "cmsSiteService")
	private CMSSiteService cmsSiteService;

	@Resource
	BrakesDeliveryCalendarFacade brakesDeliveryCalendarFacade;

	@Resource(name = "b2bOrderFacade")
	private BrakesB2BOrderFacade orderFacade;

	@Resource
	private SessionService sessionService;

	@Resource(name = "brakesAmendOrderSessionUtils")
	private BrakesAmendOrderSessionUtils brakesAmendOrderSessionUtils;

	@ModelAttribute("showCheckoutStrategies")
	public boolean isCheckoutStrategyVisible()
	{
		return getSiteConfigService().getBoolean(SHOW_CHECKOUT_STRATEGY_OPTIONS, false);
	}

	@RequestMapping(method = RequestMethod.GET)
	public String showCart(@RequestParam(value = "unavailableProductsFlag", required = false, defaultValue = "false")
	final boolean unavailableProductsFlag, final Model model, final RedirectAttributes redirectModel)
			throws CMSItemNotFoundException
	{
		model.addAttribute("quickOrderForm", new QuickOrderForm());
		model.addAttribute("unavailableProductsFlag", unavailableProductsFlag);
		DeliveryCalendarData deliveryCalendar = brakesDeliveryCalendarFacade.getDeliveryCalendar();
		if(null != deliveryCalendar && null != deliveryCalendar.getSelectedDate()
		  && null != cartService.getSessionCart() && null != cartService.getSessionCart().getDeliveryDate()
		  && !cartService.getSessionCart().getDeliveryDate().equals(deliveryCalendar.getSelectedDate())) {
			brakesCartFacade.setDeliveryDate(deliveryCalendar.getSelectedDate());
		}
		return prepareCartUrl(model);
	}

	@RequestMapping(value = "/quickOrder", method = RequestMethod.POST)
	@RequireHardLogIn
	public String quickOrder(final QuickOrderForm quickOrderForm, final RedirectAttributes redirectModel,
			@RequestParam("changeQuantity")
			final String changeQuantity, @RequestParam("isCheckoutPage")
			final boolean isCheckoutPage, final BindingResult bindingResult,
			@RequestParam(value = "steppedCheckout", defaultValue = "false")  final Boolean steppedCheckout, Model model) throws CMSItemNotFoundException
	{
		return prepareQuickOrder(quickOrderForm, redirectModel, changeQuantity, bindingResult, model, isCheckoutPage, steppedCheckout);

	}

	@RequestMapping(value = "/notLoggedIn", method = RequestMethod.GET)
	public String showCartActionUserNotLoggedInBefore(final Model model) throws CMSItemNotFoundException
	{
		if (brakesUserFacade.currentUserHasSessionCart())
		{
			return prepareCartUrl(model);
		}
		else
		{
			return REDIRECT_HOMEPAGE_URL;
		}
	}

	protected String prepareCartUrl(final Model model) throws CMSItemNotFoundException
	{
		final B2BUnitData currentB2BUnit = brakesB2BUnitFacade.getCurrentB2BUnit();

		model.addAttribute("savedCarts", saveCartFacade.getSavedCartsForCurrentUserAndUnit());
		model.addAttribute("cartLargeQuantity",
				getConfigurationService().getConfiguration().getInt("cart.large.quantity.value", 100));
		model.addAttribute("cartMaximumQuantity", brakesCartFacade.getCartMaximumQuantity(cmsSiteService.getCurrentSite()));
		model.addAttribute("currentB2BUnit", currentB2BUnit);


		prepareDataForPage(model);

		return ControllerConstants.Views.Pages.Cart.CartPage;
	}

	//	protected Optional<String> getQuoteUrl()
	//	{
	//		final QuoteData quoteData = getCartFacade().getSessionCart().getQuoteData();
	//
	//		return quoteData != null ? (QuoteState.BUYER_OFFER.equals(quoteData.getState())
	//				? Optional.of(String.format(REDIRECT_QUOTE_VIEW_URL, urlEncode(quoteData.getCode())))
	//				: Optional.of(String.format(REDIRECT_QUOTE_EDIT_URL, urlEncode(quoteData.getCode())))) : Optional.empty();
	//	}

	/**
	 * Handle the '/cart/checkout' request url. This method checks to see if the cart is valid before allowing the
	 * checkout to begin. Note that this method does not require the user to be authenticated and therefore allows us to
	 * validate that the cart is valid without first forcing the user to login. The cart will be checked again once the
	 * user has logged in.
	 *
	 * @return The page to redirect to
	 */
	@RequestMapping(value = "/checkout", method = RequestMethod.GET)
	@RequireHardLogIn
	public String cartCheck(final RedirectAttributes redirectModel) throws CommerceCartModificationException
	{
		SessionOverrideCheckoutFlowFacade.resetSessionOverrides();

		if (!getCartFacade().hasEntries())
		{
			LOG.info("Missing or empty cart");

			// No session cart or empty session cart. Bounce back to the cart page.
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "basket.error.checkout.empty.cart",
					null);
			return REDIRECT_CART_URL;
		}

		if (validateCart(redirectModel))
		{
			return REDIRECT_CART_URL;
		}

		// Redirect to the start of the checkout flow to begin the checkout process
		// We just redirect to the generic '/checkout' page which will actually select
		// the checkout flow
		// to use. The customer is not necessarily logged in on this request, but will
		// be forced to login
		// when they arrive on the '/checkout' page.
		return REDIRECT_PREFIX + "/checkout";
	}

	@RequestMapping(value = "/getProductVariantMatrix", method = RequestMethod.GET)
	public String getProductVariantMatrix(@RequestParam("productCode")
	final String productCode, @RequestParam(value = "readOnly", required = false, defaultValue = "false")
	final String readOnly, final Model model)
	{

		final ProductData productData = productFacade.getProductForCodeAndOptions(productCode,
				Arrays.asList(ProductOption.BASIC, ProductOption.CATEGORIES, ProductOption.VARIANT_MATRIX_BASE,
						ProductOption.VARIANT_MATRIX_PRICE, ProductOption.VARIANT_MATRIX_MEDIA, ProductOption.VARIANT_MATRIX_STOCK,
						ProductOption.VARIANT_MATRIX_URL));

		model.addAttribute("product", productData);
		model.addAttribute("readOnly", Boolean.valueOf(readOnly));

		return ControllerConstants.Views.Fragments.Cart.ExpandGridInCart;
	}

	// This controller method is used to allow the site to force the visitor through
	// a specified checkout flow.
	// If you only have a static configured checkout flow then you can remove this
	// method.
	@RequestMapping(value = "/checkout/select-flow", method = RequestMethod.GET)
	@RequireHardLogIn
	public String initCheck(final RedirectAttributes redirectModel, @RequestParam(value = "flow", required = false)
	final String flow, @RequestParam(value = "pci", required = false)
	final String pci) throws CommerceCartModificationException
	{
		SessionOverrideCheckoutFlowFacade.resetSessionOverrides();

		if (!getCartFacade().hasEntries())
		{
			LOG.info("Missing or empty cart");

			// No session cart or empty session cart. Bounce back to the cart page.
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "basket.error.checkout.empty.cart",
					null);
			return REDIRECT_CART_URL;
		}

		// Override the Checkout Flow setting in the session
		if (StringUtils.isNotBlank(flow))
		{
			final CheckoutFlowEnum checkoutFlow = enumerationService.getEnumerationValue(CheckoutFlowEnum.class,
					StringUtils.upperCase(flow));
			SessionOverrideCheckoutFlowFacade.setSessionOverrideCheckoutFlow(checkoutFlow);
		}

		// Override the Checkout PCI setting in the session
		if (StringUtils.isNotBlank(pci))
		{
			final CheckoutPciOptionEnum checkoutPci = enumerationService.getEnumerationValue(CheckoutPciOptionEnum.class,
					StringUtils.upperCase(pci));
			SessionOverrideCheckoutFlowFacade.setSessionOverrideSubscriptionPciOption(checkoutPci);
		}

		// Redirect to the start of the checkout flow to begin the checkout process
		// We just redirect to the generic '/checkout' page which will actually select
		// the checkout flow
		// to use. The customer is not necessarily logged in on this request, but will
		// be forced to login
		// when they arrive on the '/checkout' page.
		return REDIRECT_PREFIX + "/checkout";
	}

	@RequestMapping(value = "/entrygroups/{groupNumber}", method = RequestMethod.POST)
	public String removeGroup(@PathVariable("groupNumber")
	final Integer groupNumber, final Model model, final RedirectAttributes redirectModel)
	{
		final CartModificationData cartModification;
		try
		{
			cartModification = getCartFacade().removeEntryGroup(groupNumber);
			if (cartModification != null && !StringUtils.isEmpty(cartModification.getStatusMessage()))
			{
				GlobalMessages.addErrorMessage(model, cartModification.getStatusMessage());
			}
		}
		catch (final CommerceCartModificationException e)
		{
			LOG.error(e.getMessage(), e);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "basket.error.entrygroup.remove",
					new Object[]
					{ groupNumber });
		}
		return REDIRECT_CART_URL;
	}

	@RequestMapping(value = "/update", method = RequestMethod.POST)
	@ResponseBody
	@RequireHardLogIn
	public ResponseEntity<OrderEntryData> updateCartQuantities(@RequestParam("entryNumber")

	final long entryNumber, final Model model, @Valid
	final AddToCartForm form, @RequestParam("productCartQty")
	final long qty, @RequestParam(value = "productPostPrice", required = false)
	final BigDecimal productPostPrice,
	@RequestParam(value = "productCodePost", required = false) final String productCodePost,
	final BindingResult bindingResult, final HttpServletRequest request,
	final RedirectAttributes redirectModel) throws CMSItemNotFoundException  {

		if (bindingResult.hasErrors())
		{
			for (final ObjectError error : bindingResult.getAllErrors())
			{
				if ("typeMismatch".equals(error.getCode()))
				{
					GlobalMessages.addErrorMessage(model, "basket.error.quantity.invalid");
				}
				else
				{
					GlobalMessages.addErrorMessage(model, error.getDefaultMessage());
				}
			}
		}else if(brakesAmendOrderSessionUtils.isAmendingOrderSession()) {
			try {
				OrderEntryData orderEntryData = orderFacade.modifyingAmendOrderEntries(productCodePost, qty, sessionService.getAttribute(BrakesFacadesConstants.AMENDING_ORDER_CODE));
				List<OrderEntryData> amendOrderEntries = sessionService.getAttribute(BrakesFacadesConstants.AMENDING_ORDER_ENTRIES);
				Optional<OrderEntryData> updatedEntryOpt = amendOrderEntries.stream().filter(entry -> entry.getProduct().getCode().equals(productCodePost)).findFirst();
				if(updatedEntryOpt.isPresent()) {
					updatedEntryOpt.get().setQuantity(orderEntryData.getQuantity());
				}
				return new ResponseEntity(orderEntryData, HttpStatus.OK);
			} catch (AmendOrderDeletedException e) {
				LOG.warn("Couldn't update product with the entry number: " + entryNumber + ".", e);
			}
		} else if (getCartFacade().hasEntries() && !brakesAmendOrderSessionUtils.isAmendingOrderSession()) {
			try
			{

				final CartModificationData cartModification = getCartFacade().updateCartEntry(entryNumber, qty);

				//For sending base price value to gtm
				if (qty == 0)
				{
					final PriceData priceData = new PriceData();
					priceData.setValue(productPostPrice);
					cartModification.getEntry().setBasePrice(priceData);
				}

				return new ResponseEntity(cartModification.getEntry(), HttpStatus.OK);
			} catch (final CommerceCartModificationException ex) {
				LOG.warn("Couldn't update product with the entry number: " + entryNumber + ".", ex);
			}
		}

		// if could not update cart, display cart/quote page again with error
		return new ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR);
	}

	@RequestMapping(value = "/update-and-reload", method = RequestMethod.POST)
	@RequireHardLogIn
	public RedirectView updateCartQuantitiesAndReload(@RequestHeader(value = "referer", required = false)
	final String referer, @RequestParam("entryNumber")
	final long entryNumber, final Model model, @Valid
	final AddToCartForm form, @RequestParam(value = "productPostPrice", required = false)
	final BigDecimal productPostPrice, @RequestParam("productCartQty")
	final long qty, final BindingResult bindingResult, final HttpServletRequest request, final RedirectAttributes redirectModel)
			throws CMSItemNotFoundException
	{
		if (bindingResult.hasErrors())
		{
			for (final ObjectError error : bindingResult.getAllErrors())
			{
				if ("typeMismatch".equals(error.getCode()))
				{
					GlobalMessages.addErrorMessage(model, "basket.error.quantity.invalid");
				}
				else
				{
					GlobalMessages.addErrorMessage(model, error.getDefaultMessage());
				}
			}
		}
		else if (getCartFacade().hasEntries())
		{
			try
			{
				final CartModificationData cartModification = getCartFacade().updateCartEntry(entryNumber, qty);
				redirectModel.addFlashAttribute("gaEvent", true);
				redirectModel.addFlashAttribute("gaAction", "basket");
				redirectModel.addFlashAttribute("gaLabel", cartModification.getEntry().getProduct().getName());
				redirectModel.addFlashAttribute("qty", Math.abs(cartModification.getQuantityAdded()));

				if (cartModification.getQuantityAdded() > 0)
				{
					redirectModel.addFlashAttribute("gaCategory", "add to basket");
					redirectModel.addFlashAttribute("productCode", cartModification.getEntry().getProduct().getCode());
				}
				else if (cartModification.getQuantityAdded() < 0)
				{
					redirectModel.addFlashAttribute("productPrice", productPostPrice);
					redirectModel.addFlashAttribute("gaCategory", "remove from basket");
					redirectModel.addFlashAttribute("removedProduct", cartModification.getEntry().getProduct());
				}

				if (qty == 0)
				{

					GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "basket.page.message.remove");
				}
			}
			catch (final CommerceCartModificationException ex)
			{
				LOG.warn("Couldn't update product with the entry number: " + entryNumber + ".", ex);
			}
		}

		return new RedirectView(referer, true);

	}

	@Override
	protected void prepareDataForPage(final Model model) throws CMSItemNotFoundException
	{
		super.prepareDataForPage(model);
		boolean showCreateNewBasket = false;
		if (!model.containsAttribute(VOUCHER_FORM))
		{
			model.addAttribute(VOUCHER_FORM, new VoucherForm());
		}
		final Integer saveCartCountForCurrntUser = saveCartFacade.getSavedCartsCountForCurrentUserAndUnit();

		if (saveCartCountForCurrntUser < Config.getInt(USER_BASKET_MAX_LIMIT, 10))
		{
			showCreateNewBasket = true;
		}
		if (brakesCartFacade.isb2cCart(cartService.getSessionCart()))
		{
			showCreateNewBasket = false;
		}
		// Because DefaultSiteConfigService.getProperty() doesn't set default boolean
		// value for undefined property,
		// this property key was generated to use Config.getBoolean() method
		//final String siteQuoteProperty = SITE_QUOTES_ENABLED.concat(getBaseSiteService().getCurrentBaseSite().getUid());
		model.addAttribute("showCreateNewBasket", showCreateNewBasket);
		//model.addAttribute("siteQuoteEnabled", Config.getBoolean(siteQuoteProperty, Boolean.FALSE));
		model.addAttribute(WebConstants.BREADCRUMBS_KEY, resourceBreadcrumbBuilder.getBreadcrumbs("breadcrumb.cart"));
		model.addAttribute("pageType", PageType.CART.name());
		model.addAttribute("savedCartCount", saveCartCountForCurrntUser);
	}

	@Override
	protected void createProductEntryList(final Model model, final CartData cartData)
	{
		super.createProductEntryList(model, cartData);
		model.addAttribute(TOTAL_ITEMS, Optional.ofNullable(cartData.getTotalUnitCount()).orElse(Integer.valueOf(0)));
	}


	protected void addFlashMessage(final UpdateQuantityForm form, final HttpServletRequest request,
			final RedirectAttributes redirectModel, final CartModificationData cartModification)
	{
		if (cartModification.getQuantity() == form.getQuantity().longValue())
		{
			// Success

			if (cartModification.getQuantity() == 0)
			{
				// Success in removing entry
				GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "basket.page.message.remove");
			}
			else
			{
				// Success in update quantity
				GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "basket.page.message.update");
			}
		}
		else if (cartModification.getQuantity() > 0)
		{
			// Less than successful
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
					"basket.page.message.update.reducedNumberOfItemsAdded.lowStock", new Object[]
					{ XSSFilterUtil.filter(cartModification.getEntry().getProduct().getName()),
							Long.valueOf(cartModification.getQuantity()), form.getQuantity(),
							request.getRequestURL().append(cartModification.getEntry().getProduct().getUrl()) });
		}
		else
		{
			// No more stock available
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
					"basket.page.message.update.reducedNumberOfItemsAdded.noStock", new Object[]
					{ XSSFilterUtil.filter(cartModification.getEntry().getProduct().getName()),
							request.getRequestURL().append(cartModification.getEntry().getProduct().getUrl()) });
		}
	}

	@SuppressWarnings("boxing")
	@ResponseBody
	@RequestMapping(value = "/updateMultiD", method = RequestMethod.POST)
	public CartData updateCartQuantitiesMultiD(@RequestParam("entryNumber")
	final Integer entryNumber, @RequestParam("productCode")
	final String productCode, final Model model, @Valid
	final UpdateQuantityForm form, final BindingResult bindingResult)
	{
		if (bindingResult.hasErrors())
		{
			for (final ObjectError error : bindingResult.getAllErrors())
			{
				if ("typeMismatch".equals(error.getCode()))
				{
					GlobalMessages.addErrorMessage(model, "basket.error.quantity.invalid");
				}
				else
				{
					GlobalMessages.addErrorMessage(model, error.getDefaultMessage());
				}
			}
		}
		else
		{
			try
			{
				final CartModificationData cartModification = getCartFacade()
						.updateCartEntry(getOrderEntryData(form.getQuantity(), productCode, entryNumber));
				if (cartModification.getStatusCode().equals(SUCCESSFUL_MODIFICATION_CODE))
				{
					GlobalMessages.addMessage(model, GlobalMessages.CONF_MESSAGES_HOLDER, cartModification.getStatusMessage(), null);
				}
				else if (!model.containsAttribute(ERROR_MSG_TYPE))
				{
					GlobalMessages.addMessage(model, GlobalMessages.ERROR_MESSAGES_HOLDER, cartModification.getStatusMessage(), null);
				}
			}
			catch (final CommerceCartModificationException ex)
			{
				LOG.warn("Couldn't update product with the entry number: " + entryNumber + ".", ex);
			}

		}
		return getCartFacade().getSessionCart();
	}

	@SuppressWarnings("boxing")
	protected OrderEntryData getOrderEntryData(final long quantity, final String productCode, final Integer entryNumber)
	{
		final OrderEntryData orderEntry = new OrderEntryData();
		orderEntry.setQuantity(quantity);
		orderEntry.setProduct(new ProductData());
		orderEntry.getProduct().setCode(productCode);
		orderEntry.setEntryNumber(entryNumber);
		return orderEntry;
	}

	@RequireHardLogIn
	@RequestMapping(value = "/updateDeliveryDate", method = RequestMethod.POST)
	public String updateDeliveryDate(final DeliveryCalendarForm delCalForm, final BindingResult bindingResult, // NOSONAR
			final RedirectAttributes redirectModel)
	{
		brakesCartFacade.setDeliveryDate(getDeliveryDateFromString(delCalForm.getDeliveryDate()));

		if (validateCart(redirectModel))
		{
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, CART_CHECKOUT_ERROR, null);
			return REDIRECT_CART_URL;
		}
		if (brakesCartFacade.hasPromotionalProduct())
		{
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.INFO_MESSAGES_HOLDER, PROMOTIONS_DELIVERYDATE_CHANGE, null);
		}
		return REDIRECT_CART_URL;
	}

	@RequestMapping(value = "/save", method = RequestMethod.GET)
	@RequireHardLogIn
	public String saveCart(final RedirectAttributes redirectModel) throws CommerceSaveCartException
	{
		try
		{
			final CommerceSaveCartResultData saveCartData = saveCartFacade.saveCart();
			final CartData cart = getCartFacade().getSessionCart();
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "basket.save.cart.on.success",
					new Object[]
					{ cart.getCode() });
		}
		catch (final CommerceSaveCartException csce)
		{
			LOG.error(csce.getMessage(), csce);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "basket.save.cart.on.error");
		}

		return REDIRECT_CART_URL;
	}

	@RequestMapping(value = "/save/returnMiniCartDetails", method = RequestMethod.GET)
	@RequireHardLogIn
	public RedirectView saveCartAndReturnCartDetails(@RequestHeader(value = "referer", required = false)
	final String referer, final HttpServletRequest request, final HttpServletResponse response, final Model model,
			final RedirectAttributes redirectModel) throws CommerceSaveCartException, IOException
	{
		CartData cart = null;
		try
		{
			//creating new saved basket
			final CommerceSaveCartResultData saveCartData = saveCartFacade.saveCart();
			// returning Cart with Entry Ordering as per the ticket
			cart = getCartFacade().getSessionCartWithEntryOrdering(true);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "basket.save.cart.on.success",
					new Object[]
					{ cart.getCode() });
		}
		catch (final CommerceSaveCartException csce)
		{
			LOG.error(csce.getMessage(), csce);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "basket.save.cart.on.error", null);

		}

		return new RedirectView(referer);

	}

	@RequestMapping(value = "miniCart/quickOrder", method = RequestMethod.POST)
	@RequireHardLogIn
	public String addProductAsCartEntry(@RequestParam(value = "unavailableProductsFlag", required = false, defaultValue = "false")
	final boolean unavailableProductsFlag, final QuickOrderForm quickOrderForm, final RedirectAttributes redirectModel,
			@RequestParam("changeQuantity")
			final String changeQuantity, final BindingResult bindingResult, final Model model) throws CMSItemNotFoundException
	{

		model.addAttribute("unavailableProductsFlag", unavailableProductsFlag);
		// validating product code and qty as per the rules
		quickOrderValidator.validate(quickOrderForm, bindingResult);
		if (bindingResult.hasErrors())
		{
			return getMiniCartDetails(model, quickOrderForm);
		}
		else
		{
			long qty = quickOrderForm.getQty().longValue();

			// checking product already exist in cart or not
			final AbstractOrderEntryModel entry = brakesCartFacade.getCartEntryForProductCode(quickOrderForm.getProductCode());

			if (null != entry)
			{
				// if product already added to cart and 'changeQuantity' is empty showing
				// warning popup
				if (StringUtils.isEmpty(changeQuantity))
				{
					model.addAttribute(SHOW_PRODUCT_ALREADY_EXIST_IN_CART_WARNING, true);
					return getMiniCartDetails(model, quickOrderForm);
				}

				/*
				 * if product already added to cart and 'changeQuantity=add/replace' then updating entry with new quantity .
				 * if changeQuantity=add then oldEntryQty+newQty = summ will be added to new entry or if
				 * changeQuantity=replace then replacing entry qty with new qty which is provided by customer
				 */
				if (CART_ENTRY_QTY_UPDATE.equalsIgnoreCase(changeQuantity))
				{
					qty = entry.getQuantity() + quickOrderForm.getQty().longValue();

					if (qty > brakesCartFacade.getCartMaximumQuantity(cmsSiteService.getCurrentSite()))
					{
						// if qty exceeds more than limit after adding old entry qty then showing
						// warning popup
						model.addAttribute(SHOW_QTY_MAX_LIMIT_EXCEEDED_WARNING, true);
						return getMiniCartDetails(model, quickOrderForm);
					}
				}

				try
				{
					// updating cart entry qty
					final CartModificationData cartModification = getCartFacade().updateCartEntry(entry.getEntryNumber(), qty);
					setAddToCartGaAttributesToModel(model, cartModification);
					GlobalMessages.addMessage(model, GlobalMessages.INFO_MESSAGES_HOLDER, "basket.entry.qty.update", null);

					return getMiniCartDetails(model, quickOrderForm);
				}
				catch (final CommerceCartModificationException ex)
				{
					LOG.warn("Couldn't update product with the entry number: " + entry.getEntryNumber() + ".", ex);
					GlobalMessages.addMessage(model, GlobalMessages.ERROR_MESSAGES_HOLDER, "error.basket.entry.qty.update", null);
				}



			}
			else
			{
				if (qty > brakesCartFacade.getCartMaximumQuantity(cmsSiteService.getCurrentSite()))
				{
					// if qty exceeds more than limit after adding old entry qty then showing
					// warning popup
					model.addAttribute(SHOW_QTY_MAX_LIMIT_EXCEEDED_WARNING, true);
					return getMiniCartDetails(model, quickOrderForm);
				}

				try
				{
					// adding products to the cart
					final CartModificationData cartModification = getCartFacade().addToCart(quickOrderForm.getProductCode(), qty);
					setAddToCartGaAttributesToModel(model, cartModification);
					GlobalMessages.addMessage(model, GlobalMessages.INFO_MESSAGES_HOLDER, "basket.added.new.entry", null);

				}
				catch (final CommerceCartModificationException | UnknownIdentifierException ex)
				{
					GlobalMessages.addMessage(model, GlobalMessages.ERROR_MESSAGES_HOLDER, "basket.error.adding.entry", null);

				}
			}
		}


		return getMiniCartDetails(model, quickOrderForm);

	}

	private void setAddToCartGaAttributesToModel(final Model model, final CartModificationData cartModification)
	{

		final ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		try
		{
			final String cartModificationJson = ow.writeValueAsString(cartModification);
			model.addAttribute("cartModificationJson", cartModificationJson);
		}
		catch (final JsonProcessingException e)
		{
			LOG.debug("Exception in creating the cartModificationJson", e);
		}
	}

	String getMiniCartDetails(final Model model, final QuickOrderForm quickOrderForm)
	{
		final String miniCartDetails = ControllerConstants.Views.Fragments.Cart.MiniCartDetails;
		final B2BUnitData currentB2BUnit = brakesB2BUnitFacade.getCurrentB2BUnit();

		final CartData cart = getCartFacade().getSessionCartWithEntryOrdering(true);
		if (null != cart)
		{
			boolean showCreateNewBasket = false;

			final Integer saveCartCountForCurrntUser = saveCartFacade.getSavedCartsCountForCurrentUserAndUnit();
			if (saveCartCountForCurrntUser < Config.getInt(USER_BASKET_MAX_LIMIT, 10))
			{
				showCreateNewBasket = true;
			}
			model.addAttribute("quickOrderForm", quickOrderForm);
			model.addAttribute("showCreateNewBasket", showCreateNewBasket);
			model.addAttribute(CART, cart);
			model.addAttribute(SAVE_CART_COUNT_FOR_CURRENT_USER, saveCartCountForCurrntUser);
			model.addAttribute("cartLargeQuantity",
					getConfigurationService().getConfiguration().getInt("cart.large.quantity.value", 100));
			model.addAttribute("cartMaximumQuantity", brakesCartFacade.getCartMaximumQuantity(cmsSiteService.getCurrentSite()));
			model.addAttribute("savedCarts", saveCartFacade.getSavedCartsForCurrentUserAndUnit());
			model.addAttribute("currentB2BUnit", currentB2BUnit);
			model.addAttribute("currentCurrency", storeSessionFacade.getCurrentCurrency());
		}
		return miniCartDetails;

	}

	@RequestMapping(value = "/export", method = RequestMethod.GET, produces = "text/csv")
	public String exportCsvFile(final HttpServletResponse response, final RedirectAttributes redirectModel) throws IOException
	{
		response.setHeader("Content-Disposition", "attachment;filename=cart.csv");

		try (final StringWriter writer = new StringWriter())
		{
			try
			{
				final List<String> headers = new ArrayList<String>();
				headers.add(getMessageSource().getMessage("basket.export.cart.item.sku", null, getI18nService().getCurrentLocale()));
				headers.add(
						getMessageSource().getMessage("basket.export.cart.item.quantity", null, getI18nService().getCurrentLocale()));
				headers.add(getMessageSource().getMessage("basket.export.cart.item.name", null, getI18nService().getCurrentLocale()));
				headers
						.add(getMessageSource().getMessage("basket.export.cart.item.price", null, getI18nService().getCurrentLocale()));

				final CartData cartData = getCartFacade().getSessionCartWithEntryOrdering(false);
				csvFacade.generateCsvFromCart(headers, true, cartData, writer);

				StreamUtils.copy(writer.toString(), StandardCharsets.UTF_8, response.getOutputStream());
			}
			catch (final IOException e)
			{
				LOG.error(e.getMessage(), e);
				GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "basket.export.cart.error", null);

				return REDIRECT_CART_URL;
			}

		}

		return null;
	}

	@RequestMapping(value = "/voucher/apply", method = RequestMethod.POST)
	public String applyVoucherAction(@Valid
	final VoucherForm form, final BindingResult bindingResult, final RedirectAttributes redirectAttributes,
	@RequestParam(value = "steppedCheckout", defaultValue = "false")  final Boolean steppedCheckout)
	{
		try
		{
			checkAndReleaseVoucher();
			if (bindingResult.hasErrors())
			{
				redirectAttributes.addFlashAttribute(VOUCHER_ERROR_MSG, "text.voucher.apply.invalid.error");
				return REDIRECT_CHECKOUT_URL;
			}
			final CartEligibleData cartEligibleData = brakesCartFacade.cartEligibleForVoucher(form.getVoucherCode());
			if (!couponFacade.isCouponEligibleForCurrentAccount(form.getVoucherCode()))
			{
				redirectAttributes.addFlashAttribute(VOUCHER_ERROR_MSG, "text.voucher.apply.invalid.error");
			}
			else if (couponFacade.isVoucherExpired(form.getVoucherCode()))
			{
				redirectAttributes.addFlashAttribute(VOUCHER_ERROR_MSG, "text.voucher.apply.invalid.expired");
			}
			else if (!couponFacade.checkVoucherCode(form.getVoucherCode()))
			{
				redirectAttributes.addFlashAttribute(VOUCHER_ERROR_MSG, "text.voucher.apply.invalid.redeemed");
			}
			else if (!cartEligibleData.isEligible())
			{
				redirectAttributes.addFlashAttribute("voucherMinOrderValue", cartEligibleData.getMinimumOrderValue());
				redirectAttributes.addFlashAttribute(VOUCHER_WARNING_MSG, "text.voucher.apply.invalid.total.error");
			}
			else
			{
				couponFacade.applyVoucher(form.getVoucherCode());
				redirectAttributes.addFlashAttribute(VOUCHER_SUCCESS_MSG, "text.voucher.apply.applied.success");
			}
		}
		catch (final VoucherOperationException e)
		{
			redirectAttributes.addFlashAttribute(VOUCHER_ERROR_MSG, "text.voucher.apply.invalid.error");
			if (LOG.isDebugEnabled())
			{
				LOG.debug(e.getMessage(), e);
			}

		}

		if(Boolean.TRUE.equals(steppedCheckout)) {

			return REDIRECT_CHECKOUT_URL+"?steppedCheckout=true";
		}

		return REDIRECT_CHECKOUT_URL;
	}

	/**
	 *
	 * Release the applied voucher for the current cart
	 *
	 * @throws VoucherOperationException
	 */
	private void checkAndReleaseVoucher() throws VoucherOperationException {

		if (brakesCartFacade.cartHasAppliedVouchers())
		{
			couponFacade.releaseVoucher(couponFacade.getAppliedVoucherForCurrentCart());
		}
	}

	@RequestMapping(value = "/voucher/remove", method = RequestMethod.POST)
	public String removeVoucher(@Valid
	final VoucherForm form, final RedirectAttributes redirectModel)
	{
		try
		{
			couponFacade.releaseVoucher(form.getVoucherCode());
		}
		catch (final VoucherOperationException e)
		{
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "text.voucher.release.error",
					new Object[]
					{ form.getVoucherCode() });
			if (LOG.isDebugEnabled())
			{
				LOG.debug(e.getMessage(), e);
			}

		}
		return REDIRECT_CART_URL;
	}

	@Override
	public BaseSiteService getBaseSiteService()
	{
		return baseSiteService;
	}

	public void setBaseSiteService(final BaseSiteService baseSiteService)
	{
		this.baseSiteService = baseSiteService;
	}

	@RequestMapping(value = "/entry/execute/" + ACTION_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.POST)
	public String executeCartEntryAction(@PathVariable(value = "actionCode", required = true)
	final String actionCode, final RedirectAttributes redirectModel, @RequestParam("entryNumbers")
	final Long[] entryNumbers)
	{
		CartEntryAction action = null;

		try
		{
			action = CartEntryAction.valueOf(actionCode);
		}
		catch (final IllegalArgumentException e)
		{
			LOG.error(String.format("Unknown cart entry action %s", actionCode), e);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "basket.page.entry.unknownAction");
			return getCartPageRedirectUrl();
		}

		return performCartEntryActions(action, Arrays.asList(entryNumbers), redirectModel, Optional.empty(), Optional.empty());

	}

	@RequestMapping(value = "/clearCartItems", method = RequestMethod.POST)
	@RequireHardLogIn
	public RedirectView clearCartItems(@RequestHeader(value = "referer", required = false)
	final String referer, final RedirectAttributes redirectModel)
	{
		String returnTarget = StringUtils.EMPTY;
		final boolean calculated = brakesCartFacade.clearCartItems();
		if (calculated)
		{
			final CartData cart = getCartFacade().getSessionCart();
			redirectModel.addFlashAttribute("gaEvent", true);
			redirectModel.addFlashAttribute("gaAction", "Basket");
			redirectModel.addFlashAttribute("gaLabel", "Clear Basket");
			redirectModel.addFlashAttribute("gaCategory", "remove");
			redirectModel.addFlashAttribute("clearedCart", cart);

			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "basket.page.message.remove");
		}
		else
		{
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "basket.page.error.remove");
		}

		returnTarget = getCartPageRedirectUrl();
		return new RedirectView(referer);
	}

	private String performCartEntryActions(final CartEntryAction action, final List<Long> entryNumbers,
			final RedirectAttributes redirectModel, final Optional<String> customSuccessMessageKey,
			final Optional<String> customErrorMessageKey)
	{
		try
		{
			final Optional<String> redirectUrl = cartEntryActionFacade.executeAction(action, entryNumbers);
			final Optional<String> standardSuccessMessageKey = cartEntryActionFacade.getSuccessMessageKey(action);
			if (customSuccessMessageKey.isPresent())
			{
				GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, customSuccessMessageKey.get());
			}
			else if (standardSuccessMessageKey.isPresent())
			{
				GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, standardSuccessMessageKey.get());
			}
			if (redirectUrl.isPresent())
			{
				return redirectUrl.get();
			}
			else
			{
				return getCartPageRedirectUrl();
			}
		}
		catch (final CartEntryActionException e)
		{
			LOG.error(String.format("Failed to execute action %s", action), e);
			final Optional<String> standardErrorMessageKey = cartEntryActionFacade.getErrorMessageKey(action);
			if (customErrorMessageKey.isPresent())
			{
				GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, customErrorMessageKey.get());
			}
			else if (standardErrorMessageKey.isPresent())
			{
				GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, standardErrorMessageKey.get());
			}
			return getCartPageRedirectUrl();
		}
	}

	@RequestMapping(value = "/deleteCartAndRestore", method = RequestMethod.POST)
	@RequireHardLogIn
	public RedirectView deleteSessionCartAndRestore(@RequestHeader(value = "referer", required = false)
	final String referer, final RedirectAttributes redirectModel)
	{
		final CartData cart = getCartFacade().getSessionCart();
		redirectModel.addFlashAttribute("gaEvent", true);
		redirectModel.addFlashAttribute("gaAction", "Basket");
		redirectModel.addFlashAttribute("gaLabel", "Delete Basket");
		redirectModel.addFlashAttribute("gaCategory", "remove");
		redirectModel.addFlashAttribute("clearedCart", cart);

		getCartFacade().removeSessionCart();
		GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "basket.information.delete.successful");
		final CartData recentModifiedSavedCart = saveCartFacade.getMostRecentSavedCartForCurrentUser();
		if (recentModifiedSavedCart != null)
		{
			restoreSavedCart(recentModifiedSavedCart, redirectModel);
		}
		else
		{
			if (!getCartFacade().hasSessionCart())
			{
				//create empty cart
				brakesCartFacade.createEmptySessionCart();
			}

		}

		return new RedirectView(referer);
	}


	@RequestMapping(value = "/viewProducts/{entryNumber:.*}", method = RequestMethod.GET)
	@RequireHardLogIn
	@ResponseBody
	public PotentialPromotionData getPotentialPromoProducts(@PathVariable(value = "entryNumber", required = true)
	final Integer entryNumber)
	{

		if (entryNumber != null)
		{
			return brakesCartFacade.getPotentialPromoProducts(entryNumber);
		}

		return null;

	}

	private void restoreSavedCart(final CartData cartData, final RedirectAttributes redirectModel)
	{
		try
		{
			final CommerceSaveCartParameterData commerceSaveCartParameterData = new CommerceSaveCartParameterData();
			commerceSaveCartParameterData.setCartId(cartData.getCode());
			commerceSaveCartParameterData.setEnableHooks(true);
			saveCartFacade.restoreSavedCart(commerceSaveCartParameterData);
		}
		catch (final CommerceSaveCartException e)
		{
			LOG.error(e);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "basket.error.restoration.failed");
		}
	}

	protected String getCartPageRedirectUrl()
	{
		final QuoteData quoteData = getCartFacade().getSessionCart().getQuoteData();
		return quoteData != null ? String.format(REDIRECT_QUOTE_EDIT_URL, urlEncode(quoteData.getCode())) : REDIRECT_CART_URL;
	}

	private String prepareQuickOrder(final QuickOrderForm quickOrderForm, final RedirectAttributes redirectModel,
			final String changeQuantity, final BindingResult bindingResult, final Model model, final boolean isCheckoutPage, final Boolean steppedCheckout)
			throws CMSItemNotFoundException
	{
		// validating product code and qty as per the rules
		quickOrderValidator.validate(quickOrderForm, bindingResult);
		CartModificationData cartModification = null;
		if (bindingResult.hasErrors())
		{
			redirectModel.addFlashAttribute("org.springframework.validation.BindingResult.quickOrderForm", bindingResult);
			return getRedirectUrl(isCheckoutPage, steppedCheckout);
		}
		else
		{
			long qty = quickOrderForm.getQty().longValue();

			// checking product already exist in cart or not
			final AbstractOrderEntryModel entry = brakesCartFacade.getCartEntryForProductCode(quickOrderForm.getProductCode());

			if (null != entry)
			{
				// if product already added to cart and 'changeQuantity' is empty showing
				// warning popup
				if (StringUtils.isEmpty(changeQuantity))
				{
					redirectModel.addFlashAttribute(SHOW_PRODUCT_ALREADY_EXIST_IN_CART_WARNING, true);
					redirectModel.addFlashAttribute(quickOrderForm);
					return getRedirectUrl(isCheckoutPage, steppedCheckout);
				}

				/*
				 * if product already added to cart and 'changeQuantity=add/replace' then updating entry with new quantity .
				 * if changeQuantity=add then oldEntryQty+newQty = summ will be added to new entry or if
				 * changeQuantity=replace then replacing entry qty with new qty which is provided by customer
				 */
				if (CART_ENTRY_QTY_UPDATE.equalsIgnoreCase(changeQuantity))
				{
					qty = entry.getQuantity() + quickOrderForm.getQty().longValue();

					if (qty > brakesCartFacade.getCartMaximumQuantity(cmsSiteService.getCurrentSite()))
					{
						// if qty exceeds more than limit after adding old entry qty then showing
						// warning popup
						return showQuantityWarningPopup(redirectModel, quickOrderForm, isCheckoutPage, steppedCheckout);
					}
				}

				try
				{
					// updating cart entry qty
					cartModification = getCartFacade().updateCartEntry(entry.getEntryNumber(), qty);
					setFlashAttributesForGAOnQuickAdd(redirectModel, cartModification);
					GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "basket.entry.qty.update");
					return getRedirectUrl(isCheckoutPage, steppedCheckout);

				}
				catch (final CommerceCartModificationException ex)
				{
					LOG.warn("Couldn't update product with the entry number: " + entry.getEntryNumber() + ".", ex);
					GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
							"error.basket.entry.qty.update", null);
				}

			}
			else
			{
				if (qty > brakesCartFacade.getCartMaximumQuantity(cmsSiteService.getCurrentSite()))
				{
					// if qty exceeds more than limit after adding old entry qty then showing
					// warning popup
					return showQuantityWarningPopup(redirectModel, quickOrderForm, isCheckoutPage, steppedCheckout);
				}

				try
				{
					// adding products to the cart
					cartModification = getCartFacade().addToCart(quickOrderForm.getProductCode(), qty);
					GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "basket.added.new.entry");

				}
				catch (final CommerceCartModificationException | UnknownIdentifierException ex)
				{
					GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "basket.error.adding.entry",
							null);
				}
			}
		}

		setFlashAttributesForGAOnQuickAdd(redirectModel, cartModification);


		return getRedirectUrl(isCheckoutPage, steppedCheckout);
	}

	private void setFlashAttributesForGAOnQuickAdd(final RedirectAttributes redirectModel,
			final CartModificationData cartModification)
	{
		if (null != cartModification)
		{
			redirectModel.addFlashAttribute("gaEvent", true);
			redirectModel.addFlashAttribute("gaAction", "quick add");
			redirectModel.addFlashAttribute("gaLabel", cartModification.getEntry().getProduct().getName());
			redirectModel.addFlashAttribute("qty", Math.abs(cartModification.getQuantityAdded()));

			if (cartModification.getQuantityAdded() > 0)
			{
				redirectModel.addFlashAttribute("gaCategory", "add to basket");
				redirectModel.addFlashAttribute("productCode", cartModification.getEntry().getProduct().getCode());
			}
			else if (cartModification.getQuantityAdded() < 0)
			{
				redirectModel.addFlashAttribute("productPrice", cartModification.getEntry().getBasePrice().getValue());
				redirectModel.addFlashAttribute("gaCategory", "remove from basket");
				redirectModel.addFlashAttribute("removedProduct", cartModification.getEntry().getProduct());
			}
		}
	}

	String getRedirectUrl(final boolean isCheckoutPage, final Boolean steppedCheckout)
	{
		if (isCheckoutPage)
		{
			if(Boolean.TRUE.equals(steppedCheckout)) {

				return REDIRECT_CHECKOUT_URL+"?steppedCheckout=true";
			}

			return REDIRECT_CHECKOUT_URL;
		}
		else
		{
			return REDIRECT_CART_URL;
		}
	}

	String showQuantityWarningPopup(final RedirectAttributes redirectAttributes, final QuickOrderForm quickOrderForm,
			final boolean isCheckoutPage, final Boolean steppedCheckout)
	{
		redirectAttributes.addFlashAttribute(SHOW_QTY_MAX_LIMIT_EXCEEDED_WARNING, true);
		redirectAttributes.addFlashAttribute(quickOrderForm);
		return getRedirectUrl(isCheckoutPage, steppedCheckout);
	}

	protected Date getDeliveryDateFromString(final String deliveryDate)
	{
		final Locale currentLocale = getI18nService().getCurrentLocale();
		final String pattern = DATE_FORMAT;

		final SimpleDateFormat dateFormat = new SimpleDateFormat(pattern, currentLocale);
		try
		{
			return dateFormat.parse(deliveryDate);
		}
		catch (final ParseException e)
		{
			LOG.error("Error parsing date");
			return null;
		}
	}

	@Override
	protected boolean validateCart(final RedirectAttributes redirectModel)
	{
		final boolean invalidDeliveryDate = brakesCartFacade.checkDeliveryDate();
		boolean priceChanged = false;
		if (invalidDeliveryDate)
		{
			redirectModel.addFlashAttribute("invalidDeliveryDate", invalidDeliveryDate);
		}

		priceChanged = brakesCartFacade.hasPricingChanged();
		if (priceChanged)
		{
			redirectModel.addFlashAttribute("priceChanged", priceChanged);
		}

		//Validate the cart
		List<CartModificationData> modifications = new ArrayList<>();
		try
		{
			modifications = getCartFacade().validateCartData();
		}
		catch (final CommerceCartModificationException e)
		{
			LOGGER.error("Failed to validate cart", e);
		}
		if (!modifications.isEmpty() || invalidDeliveryDate)
		{
			redirectModel.addFlashAttribute("validationData", modifications);
			// Invalid cart. Bounce back to the cart page.
			return true;
		}
		return false;
	}
}
