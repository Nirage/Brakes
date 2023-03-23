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

import com.envoydigital.brakes.core.model.components.CheckoutPageSuggestionComponentModel;
import com.envoydigital.brakes.facades.BrakesProductFacade;
import com.envoydigital.brakes.facades.data.PaymentCardStatus;
import de.hybris.platform.acceleratorfacades.flow.impl.SessionOverrideCheckoutFlowFacade;
import de.hybris.platform.acceleratorfacades.order.AcceleratorCheckoutFacade;
import de.hybris.platform.acceleratorservices.controllers.page.PageType;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.consent.data.ConsentCookieData;
import de.hybris.platform.acceleratorstorefrontcommons.constants.WebConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractCheckoutController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.acceleratorstorefrontcommons.forms.ConsentForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.GuestRegisterForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.PlaceOrderForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.UpdateQuantityForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.VoucherForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.validation.GuestRegisterValidator;
import de.hybris.platform.acceleratorstorefrontcommons.security.AutoLoginStrategy;
import de.hybris.platform.acceleratorstorefrontcommons.strategy.CustomerConsentDataStrategy;
import de.hybris.platform.b2bcommercefacades.company.data.B2BUnitData;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.contents.components.AbstractCMSComponentModel;
import de.hybris.platform.cms2.model.contents.contentslot.ContentSlotModel;
import de.hybris.platform.cms2.model.pages.AbstractPageModel;
import de.hybris.platform.cms2.servicelayer.services.CMSContentSlotService;
import de.hybris.platform.cms2.servicelayer.services.CMSSiteService;
import de.hybris.platform.commercefacades.consent.ConsentFacade;
import de.hybris.platform.commercefacades.coupon.data.CouponData;
import de.hybris.platform.commercefacades.order.CheckoutFacade;
import de.hybris.platform.commercefacades.order.OrderFacade;
import de.hybris.platform.commercefacades.order.data.CartData;
import de.hybris.platform.commercefacades.order.data.CartModificationData;
import de.hybris.platform.commercefacades.order.data.OrderData;
import de.hybris.platform.commercefacades.order.data.OrderEntryData;
import de.hybris.platform.commercefacades.product.ProductOption;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commercefacades.voucher.exceptions.VoucherOperationException;
import de.hybris.platform.commerceservices.customer.DuplicateUidException;
import de.hybris.platform.commerceservices.order.CommerceCartModificationException;
import de.hybris.platform.commerceservices.util.ResponsiveUtils;
import de.hybris.platform.core.model.order.OrderModel;
import de.hybris.platform.order.CartService;
import de.hybris.platform.order.InvalidCartException;
import de.hybris.platform.servicelayer.exceptions.ModelNotFoundException;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import de.hybris.platform.servicelayer.session.SessionService;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.WebUtils;

import com.envoydigital.brakes.facades.BrakesB2BCheckoutFacade;
import com.envoydigital.brakes.facades.BrakesB2BOrderFacade;
import com.envoydigital.brakes.facades.BrakesB2BUnitFacade;
import com.envoydigital.brakes.facades.cart.BrakesCartFacade;
import com.envoydigital.brakes.facades.cart.BrakesSaveCartFacade;
import com.envoydigital.brakes.facades.coupons.BrakesCouponFacade;
import com.envoydigital.brakes.facades.payment.BrakesPaymentFacade;
import com.envoydigital.brakes.facades.user.BrakesB2BCustomerFacade;
import com.envoydigital.brakes.payment.constants.BrakespaymentcoreConstants;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.PurchaseOrderForm;
import com.envoydigital.brakes.storefront.forms.validation.PurchaseOrderNoValidator;
import com.fasterxml.jackson.databind.ObjectMapper;



/**
 * CheckoutController
 */
@Controller
@RequestMapping(value = "/checkout")
public class CheckoutController extends AbstractCheckoutController
{
	private static final Logger LOG = Logger.getLogger(CheckoutController.class);

	private static final String CHECKOUT_CMS_PAGE = "checkoutPage";

	private static final String PRE_CHECKOUT_CMS_PAGE = "preCheckoutPage";

	/**
	 * We use this suffix pattern because of an issue with Spring 3.1 where a Uri value is incorrectly extracted if it
	 * contains on or more '.' characters. Please see https://jira.springsource.org/browse/SPR-6164 for a discussion on
	 * the issue and future resolution.
	 */
	private static final String ORDER_CODE_PATH_VARIABLE_PATTERN = "{orderCode:.*}";

	private static final String CHECKOUT_ORDER_CONFIRMATION_CMS_PAGE_LABEL = "orderConfirmation";
	private static final String CONTINUE_URL_KEY = "continueUrl";
	private static final String CONSENT_FORM_GLOBAL_ERROR = "consent.form.global.error";
	private static final String VOUCHER_NOT_ELIGIBLE_MESSAGE_SHOWN = "messageShown";
	private static final String COUPON_NOT_VALID = "couponNotValid";


	@Resource(name = "productFacade")
	private BrakesProductFacade productFacade;

	@Resource(name = "orderFacade")
	private OrderFacade orderFacade;

	@Resource(name = "checkoutFacade")
	private CheckoutFacade checkoutFacade;

	@Resource(name = "guestRegisterValidator")
	private GuestRegisterValidator guestRegisterValidator;

	@Resource(name = "autoLoginStrategy")
	private AutoLoginStrategy autoLoginStrategy;

	@Resource(name = "consentFacade")
	protected ConsentFacade consentFacade;

	@Resource(name = "customerConsentDataStrategy")
	protected CustomerConsentDataStrategy customerConsentDataStrategy;

	@Resource(name = "defaultBrakesCartFacade")
	protected BrakesCartFacade brakesCartFacade;

	@Resource(name = "brakesB2BUnitFacade")
	private BrakesB2BUnitFacade brakesB2BUnitFacade;


	@Resource(name = "purchaseOrderNoValidator")
	private PurchaseOrderNoValidator purchaseOrderNoValidator;

	@Resource(name = "saveCartFacade")
	private BrakesSaveCartFacade brakesSaveCartFacade;

	@Resource(name = "b2bOrderFacade")
	private BrakesB2BOrderFacade b2bOrderFacade;

	@Resource(name = "defaultBrakesAcceleratorCheckoutFacade")
	private AcceleratorCheckoutFacade brakesAcceleratorCheckoutFacade;

	@Resource(name = "b2bCheckoutFacade")
	private BrakesB2BCheckoutFacade b2bCheckoutFacade;

	@Resource(name = "sessionService")
	private SessionService sessionService;

	@Resource(name = "cmsSiteService")
	private CMSSiteService cmsSiteService;

	@Resource(name = "cartService")
	private CartService cartService;

	@Resource(name = "brakesPaymentFacade")
	private BrakesPaymentFacade brakesPaymentFacade;

	@Resource(name = "voucherFacade")
	private BrakesCouponFacade brakesCouponFacade;

	@Resource(name = "b2bCustomerFacade")
	private BrakesB2BCustomerFacade b2bCustomerFacade;

	@Resource(name = "cmsContentSlotService")
	private CMSContentSlotService cmsContentSlotService;

	@ExceptionHandler(ModelNotFoundException.class)
	public String handleModelNotFoundException(final ModelNotFoundException exception, final HttpServletRequest request)
	{
		request.setAttribute("message", exception.getMessage());
		return FORWARD_PREFIX + "/404";
	}

	@RequestMapping(method = RequestMethod.GET, value = "/step-one")
	@RequireHardLogIn
	public String preCheckout(final RedirectAttributes redirectModel, final Model model) throws CMSItemNotFoundException
	{
		if (getCheckoutFlowFacade().hasValidCart())
		{
			if (validateCart(redirectModel))
			{
				return REDIRECT_PREFIX + "/cart";
			}
			else
			{
				return setUpPreCheckOutPage(model);

			}
		}

		LOG.info("Missing, empty or unsupported cart");

		// No session cart or empty session cart. Bounce back to the cart page.
		return REDIRECT_PREFIX + "/cart";
	}

	private String setUpPreCheckOutPage(Model model) throws CMSItemNotFoundException {

		if(!checkMissingOrBestSellerIsAvailable()) {
			return REDIRECT_PREFIX + "/checkout";
		}
		storeCmsPageInModel(model, getContentPageForLabelOrId(PRE_CHECKOUT_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(PRE_CHECKOUT_CMS_PAGE));
		return ControllerConstants.Views.Pages.Checkout.PreCheckoutPage;
	}

	private boolean checkMissingOrBestSellerIsAvailable() {
		ContentSlotModel productReferenceSlot = cmsContentSlotService.getContentSlotForId("ProductReferenceSlot-preCheckoutPage");
		Iterator<AbstractCMSComponentModel> itrCmsComponent = productReferenceSlot.getCmsComponents().iterator();
		while(itrCmsComponent.hasNext()) {
			AbstractCMSComponentModel cmsComponent = itrCmsComponent.next();
			if(cmsComponent instanceof CheckoutPageSuggestionComponentModel) {
				CheckoutPageSuggestionComponentModel preCheckoutPageSuggestion = (CheckoutPageSuggestionComponentModel) cmsComponent;
				List<ProductData> missingAnySuggestionsNonFiltered = productFacade.getMostPurchasedProductsForCurrentB2BUnit(preCheckoutPageSuggestion.getOrdersAgeInDays(), preCheckoutPageSuggestion.getMaximumNumberProducts());
				if (CollectionUtils.isEmpty(productFacade.filterProductDataForCheckoutSuggestions(missingAnySuggestionsNonFiltered)) && CollectionUtils.isEmpty(productFacade.collectBestSellerProducts(preCheckoutPageSuggestion))){
					return false;
				}
			}
		}

		return true;
	}

	@RequestMapping(method = RequestMethod.GET)
	@RequireHardLogIn
	public String checkout(final RedirectAttributes redirectModel, final Model model) throws CMSItemNotFoundException
	{
		if (getCheckoutFlowFacade().hasValidCart())
		{
			if (validateCart(redirectModel))
			{
				return REDIRECT_PREFIX + "/cart";
			}
			else
			{
				checkoutFacade.prepareCartForCheckout();
				//will set the delivery address to cart
				if (brakesCartFacade.isb2cCart(cartService.getSessionCart()))
				{
					checkoutFacade.setDefaultDeliveryAddressForCheckout();
				}
				if (brakesPaymentFacade.isPaymentEnabled())
				{
					b2bCheckoutFacade.setPaymentInfoIfAvailable();
				}
				return setUpCheckOutPage(model);

			}
		}

		LOG.info("Missing, empty or unsupported cart");

		// No session cart or empty session cart. Bounce back to the cart page.
		return REDIRECT_PREFIX + "/cart";
	}


	private String setUpCheckOutPage(final Model model) throws CMSItemNotFoundException
	{
		sessionService.removeAttribute(BrakespaymentcoreConstants.PAYMENT_REDIRECTION_SESSION_ATTRIBUTE);
		final B2BUnitData currentB2BUnit = brakesB2BUnitFacade.getCurrentB2BUnit();
		final CartData cartData = getCartFacade().getSessionCartWithEntryOrdering(false);

		createProductList(model, cartData);
		final boolean isPaymentEnabled = brakesPaymentFacade.isPaymentEnabled();
		model.addAttribute("isPaymentEnabled", isPaymentEnabled);
		if (isPaymentEnabled)
		{
			model.addAttribute("paymentCardStatus", brakesPaymentFacade.getPaymentCardStatus(false));
		}

		model.addAttribute("cartLargeQuantity",
				getConfigurationService().getConfiguration().getInt("cart.large.quantity.value", 100));
		model.addAttribute("cartMaximumQuantity", brakesCartFacade.getCartMaximumQuantity(cmsSiteService.getCurrentSite()));
		model.addAttribute("currentB2BUnit", currentB2BUnit);
		model.addAttribute("isCheckoutPage", Boolean.TRUE);


		final PurchaseOrderForm purchaseOrderForm = new PurchaseOrderForm();
		purchaseOrderForm.setCustomerPOFormat(currentB2BUnit.getCustomerPOFormat());
		purchaseOrderForm.setPurchaseOrderNumber(cartData.getPurchaseOrderNumber());
		model.addAttribute("purchaseOrderForm", purchaseOrderForm);

		final VoucherForm voucherForm = new VoucherForm();
		model.addAttribute("voucherForm", voucherForm);


		final PlaceOrderForm placeOrderForm = new PlaceOrderForm();
		placeOrderForm.setTermsCheck(Boolean.TRUE);

		final boolean couponEnabled = brakesCouponFacade.couponEnabledForCurrentAccount();
		if (couponEnabled)
		{
			model.addAttribute("vouchers", brakesCouponFacade.getUnusedCouponsForCurrentAccount());
			model.addAttribute("appliedCoupon", brakesCouponFacade.getAppliedCouponForCurrentCart());
		}

		model.addAttribute("placeOrderForm", placeOrderForm);

		if(!brakesCartFacade.isb2cCart(cartService.getSessionCart())){

		    model.addAttribute("missingOrBestSellerAvailable",checkMissingOrBestSellerIsAvailable());
		}

		return ControllerConstants.Views.Pages.Checkout.CheckoutPage;
	}

	protected void createProductList(final Model model, final CartData cartData) throws CMSItemNotFoundException
	{
		createProductEntryList(model, cartData);

		storeCmsPageInModel(model, getContentPageForLabelOrId(CHECKOUT_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(CHECKOUT_CMS_PAGE));
	}

	protected void createProductEntryList(final Model model, final CartData cartData)
	{
		final boolean hasPickUpCartEntries = false;
		if (cartData.getEntries() != null && !cartData.getEntries().isEmpty())
		{
			for (final OrderEntryData entry : cartData.getEntries())
			{
				final UpdateQuantityForm uqf = new UpdateQuantityForm();
				uqf.setQuantity(entry.getQuantity());
				model.addAttribute("updateQuantityForm" + entry.getEntryNumber(), uqf);
			}
		}
		model.addAttribute("cartData", cartData);
	}


	@RequestMapping(value = "/setPurchaseOrderNo")
	@RequireHardLogIn
	@ResponseBody
	public ResponseEntity<String> setPurchaseOrderNo(@ModelAttribute("purchaseOrderForm")
	final PurchaseOrderForm purchaseOrderForm, final BindingResult bindingResult)
			throws CMSItemNotFoundException, InvalidCartException, CommerceCartModificationException
	{

		getPurchaseOrderNoValidator().validate(purchaseOrderForm, bindingResult);
		if (bindingResult.hasErrors())
		{
			final String errorMessage = getMessageSource().getMessage(bindingResult.getAllErrors().get(0).getCode(), null,
					getI18nService().getCurrentLocale());
			return new ResponseEntity<String>(errorMessage, HttpStatus.BAD_REQUEST);
		}

		brakesCartFacade.setPurchaseOrderNumber(purchaseOrderForm.getPurchaseOrderNumber());
		return new ResponseEntity<String>(HttpStatus.OK);
	}



	@RequestMapping(value = "/placeOrder")
	@RequireHardLogIn
	public String placeOrder(@ModelAttribute("placeOrderForm")
	final PlaceOrderForm placeOrderForm, final Model model, final HttpServletRequest request,
			final RedirectAttributes redirectModel) throws CMSItemNotFoundException, // NOSONAR
			InvalidCartException, CommerceCartModificationException, VoucherOperationException {
		if (!getBrakesAcceleratorCheckoutFacade().hasValidCart())
		{
			return REDIRECT_PREFIX + "/cart";
		}

		//Validate the cart
		if (validateCart(redirectModel))
		{
			// Invalid cart. Bounce back to the cart page.
			return REDIRECT_PREFIX + "/cart";
		}
		final boolean invalidDeliveryDate = brakesCartFacade.checkInvalidDeliveryDate();
		if (invalidDeliveryDate)
		{
			redirectModel.addFlashAttribute("invalidDeliveryDate", invalidDeliveryDate);
			return REDIRECT_PREFIX + "/checkout";
		}

		if(!brakesCartFacade.isb2cCart(cartService.getSessionCart()) && brakesPaymentFacade.isPaymentEnabled()) {
			PaymentCardStatus paymentCardStatus = brakesPaymentFacade.getPaymentCardStatus(false);
			if(PaymentCardStatus.NOT_ADDED_BUT_MANDATORY.equals(paymentCardStatus)) {
				return REDIRECT_PREFIX + "/checkout";
			}
		}


		//b2c customers should be redirected to Payment page
		if (BooleanUtils.isTrue(getCmsSiteService().getCurrentSite().getPaymentEnabled()))
		{
			sessionService.setAttribute(BrakespaymentcoreConstants.PAYMENT_REDIRECTION_SESSION_ATTRIBUTE, Boolean.TRUE);
			return REDIRECT_PREFIX + "/checkout/payment-iframe";
		}



		if (brakesCouponFacade.couponEnabledForCurrentAccount())
		{
			final String appliedVoucherCode = brakesCouponFacade.getAppliedVoucherForCurrentCart();
			boolean voucherIsEligible = true;
			if(null != appliedVoucherCode) {
				voucherIsEligible = brakesCartFacade.cartEligibleForVoucher(appliedVoucherCode).isEligible();
				if (!voucherIsEligible) {
					brakesCouponFacade.releaseVoucher(appliedVoucherCode);
				}
			}

			if (StringUtils.isNotEmpty(appliedVoucherCode) && sessionService.getAttribute(VOUCHER_NOT_ELIGIBLE_MESSAGE_SHOWN) == null
					&& !voucherIsEligible)
			{
				redirectModel.addFlashAttribute("eligibleforvoucher", Boolean.FALSE);
				sessionService.setAttribute(VOUCHER_NOT_ELIGIBLE_MESSAGE_SHOWN, true);
				return REDIRECT_PREFIX + "/checkout";
			}

			sessionService.removeAttribute(VOUCHER_NOT_ELIGIBLE_MESSAGE_SHOWN);
			final List<CouponData> coupons = brakesCouponFacade.getEligibleCouponsForCurrentCart();

			if (StringUtils.isEmpty(appliedVoucherCode) && b2bCustomerFacade.showVoucherMessage()
					&& CollectionUtils.isNotEmpty(coupons))
			{
				redirectModel.addFlashAttribute("voucherPopUp", Boolean.TRUE);
				redirectModel.addFlashAttribute("eligVoucherCode", coupons.get(0).getCouponCode());
				b2bCustomerFacade.updateVoucherMessageTime();
				return REDIRECT_PREFIX + "/checkout";
			}
		}


		final OrderModel orderModel;
		try
		{
			orderModel = b2bCheckoutFacade.placeOrderQuitely();
			LOG.info("Order Placed:::: Code:: " + orderModel.getCode());
			LOG.info("User::" + orderModel.getUser() != null ? orderModel.getUser().getUid() : "");
			LOG.info("Unit::" + orderModel.getUnit() != null ? orderModel.getUnit().getUid() : "");
		}
		catch (final Exception e)
		{
			LOG.error("Failed to place Order", e);
			GlobalMessages.addErrorMessage(model, "checkout.placeOrder.failed");
			return REDIRECT_PREFIX + "/checkout";
		}

		getBrakesSaveCartFacade().setMostRecentCart();
		return redirectToOrderConfirmationPage(orderModel);
	}

	protected String redirectToOrderConfirmationPage(final OrderModel orderModel)
	{
		return REDIRECT_URL_ORDER_CONFIRMATION
				+ (getCheckoutCustomerStrategy().isAnonymousCheckout() ? orderModel.getGuid() : orderModel.getCode());
	}

	@RequestMapping(value = "/orderConfirmation/" + ORDER_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
	@RequireHardLogIn
	public String orderConfirmation(@PathVariable("orderCode")
	final String orderCode, final HttpServletRequest request, final Model model, final RedirectAttributes redirectModel)
			throws CMSItemNotFoundException
	{
		SessionOverrideCheckoutFlowFacade.resetSessionOverrides();
		return processOrderCode(orderCode, model, request, redirectModel);
	}


	@RequestMapping(value = "/orderConfirmation/" + ORDER_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.POST)
	public String orderConfirmation(final GuestRegisterForm form, final BindingResult bindingResult, final Model model,
			final HttpServletRequest request, final HttpServletResponse response, final RedirectAttributes redirectModel)
			throws CMSItemNotFoundException
	{
		return processRegisterGuestUserRequest(form, bindingResult, model, request, response, redirectModel);
	}

	protected String processRegisterGuestUserRequest(final GuestRegisterForm form, final BindingResult bindingResult,
			final Model model, final HttpServletRequest request, final HttpServletResponse response,
			final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		if (bindingResult.hasErrors())
		{
			form.setTermsCheck(false);
			GlobalMessages.addErrorMessage(model, "form.global.error");
			return processOrderCode(form.getOrderCode(), model, request, redirectModel);
		}
		try
		{
			getCustomerFacade().changeGuestToCustomer(form.getPwd(), form.getOrderCode());
			//getAutoLoginStrategy().login(getCustomerFacade().getCurrentCustomer().getUid(), form.getPwd(), request, response);
			getSessionService().removeAttribute(WebConstants.ANONYMOUS_CHECKOUT);
		}
		catch (final DuplicateUidException e)
		{
			// User already exists
			LOG.warn("guest registration failed: " + e);
			form.setTermsCheck(false);
			model.addAttribute(new GuestRegisterForm());
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
					"guest.checkout.existingaccount.register.error", new Object[]
					{ form.getUid() });
			return REDIRECT_PREFIX + request.getHeader("Referer");
		}

		// Consent form data
		try
		{
			final ConsentForm consentForm = form.getConsentForm();
			if (consentForm != null && consentForm.getConsentGiven())
			{
				getConsentFacade().giveConsent(consentForm.getConsentTemplateId(), consentForm.getConsentTemplateVersion());
			}
		}
		catch (final Exception e)
		{
			LOG.error("Error occurred while creating consents during registration", e);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, CONSENT_FORM_GLOBAL_ERROR);
		}

		// save anonymous-consent cookies as ConsentData
		final Cookie cookie = WebUtils.getCookie(request, WebConstants.ANONYMOUS_CONSENT_COOKIE);
		if (cookie != null)
		{
			try
			{
				final ObjectMapper mapper = new ObjectMapper();
				final List<ConsentCookieData> consentCookieDataList = Arrays.asList(mapper.readValue(
						URLDecoder.decode(cookie.getValue(), StandardCharsets.UTF_8.displayName()), ConsentCookieData[].class));
				consentCookieDataList.stream().filter(consentData -> WebConstants.CONSENT_GIVEN.equals(consentData.getConsentState()))
						.forEach(consentData -> consentFacade.giveConsent(consentData.getTemplateCode(),
								Integer.valueOf(consentData.getTemplateVersion())));
			}
			catch (final UnsupportedEncodingException e)
			{
				LOG.error(String.format("Cookie Data could not be decoded : %s", cookie.getValue()), e);
			}
			catch (final IOException e)
			{
				LOG.error("Cookie Data could not be mapped into the Object", e);
			}
			catch (final Exception e)
			{
				LOG.error("Error occurred while creating Anonymous cookie consents", e);
			}
		}

		customerConsentDataStrategy.populateCustomerConsentDataInSession();

		return REDIRECT_PREFIX + "/";
	}

	protected String processOrderCode(final String orderCode, final Model model, final HttpServletRequest request,
			final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		final OrderData orderDetails;

		try
		{
			orderDetails = orderFacade.getOrderDetailsForCode(orderCode);
		}
		catch (final UnknownIdentifierException e)
		{
			LOG.warn("Attempted to load an order confirmation that does not exist or is not visible. Redirect to home page.");
			return REDIRECT_PREFIX + ROOT;
		}

		//addRegistrationConsentDataToModel(model);

		//		if (orderDetails.isGuestCustomer() && !StringUtils.substringBefore(orderDetails.getUser().getUid(), "|")
		//				.equals(getSessionService().getAttribute(WebConstants.ANONYMOUS_CHECKOUT_GUID)))
		//		{
		//			return getCheckoutRedirectUrl();
		//		}

		if (orderDetails.getEntries() != null && !orderDetails.getEntries().isEmpty())
		{
			for (final OrderEntryData entry : orderDetails.getEntries())
			{
				final String productCode = entry.getProduct().getCode();
				final ProductData product = productFacade.getProductForCodeAndOptions(productCode,
						Arrays.asList(ProductOption.BASIC, ProductOption.CATEGORIES));
				entry.setProduct(product);
			}
		}
		b2bOrderFacade.reverseOrderEntries(orderDetails);
		model.addAttribute("orderCode", orderCode);
		model.addAttribute("orderData", orderDetails);
		model.addAttribute("allItems", orderDetails.getEntries());
		model.addAttribute("pageType", PageType.ORDERCONFIRMATION.name());

		//		final List<CouponData> giftCoupons = orderDetails.getAppliedOrderPromotions().stream()
		//				.filter(x -> CollectionUtils.isNotEmpty(x.getGiveAwayCouponCodes())).flatMap(p -> p.getGiveAwayCouponCodes().stream())
		//				.collect(Collectors.toList());
		//		model.addAttribute("giftCoupons", giftCoupons);

		//processEmailAddress(model, orderDetails);

		final String continueUrl = (String) getSessionService().getAttribute(WebConstants.CONTINUE_URL);
		model.addAttribute(CONTINUE_URL_KEY, (continueUrl != null && !continueUrl.isEmpty()) ? continueUrl : ROOT);

		final AbstractPageModel cmsPage = getContentPageForLabelOrId(CHECKOUT_ORDER_CONFIRMATION_CMS_PAGE_LABEL);
		storeCmsPageInModel(model, cmsPage);
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(CHECKOUT_ORDER_CONFIRMATION_CMS_PAGE_LABEL));
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);

		if (ResponsiveUtils.isResponsive())
		{
			return getViewForPage(model);
		}

		return ControllerConstants.Views.Pages.Checkout.CheckoutConfirmationPage;
	}

	@Override
	protected boolean validateCart(final RedirectAttributes redirectModel)
	{
		final boolean invalidDeliveryDate = brakesCartFacade.checkDeliveryDate();

		boolean priceChanged = false;
		if (invalidDeliveryDate)
		{
			redirectModel.addFlashAttribute("invalidDeliveryDate", invalidDeliveryDate);
			priceChanged = brakesCartFacade.hasPricingChanged();
			if (priceChanged)
			{
				redirectModel.addFlashAttribute("priceChanged", priceChanged);
			}

		}
		//Validate the cart
		List<CartModificationData> modifications = new ArrayList<>();
		try
		{
			modifications = getCartFacade().validateCartData();
		}
		catch (final CommerceCartModificationException e)
		{
			LOG.error("Failed to validate cart", e);
		}
		if ((!modifications.isEmpty() && doesntContainInvalidCoupon(modifications)) || priceChanged || invalidDeliveryDate)
		{
			redirectModel.addFlashAttribute("validationData", modifications);
			// Invalid cart. Bounce back to the cart page.
			return true;
		}
		return false;
	}

	private boolean doesntContainInvalidCoupon(List<CartModificationData> cartModifications)
	{
		for (CartModificationData modification: cartModifications)
		{
			if (StringUtils.contains(modification.getStatusCode(),COUPON_NOT_VALID))
			{
				return false;
			}
		}
		return true;
	}

	protected void processEmailAddress(final Model model, final OrderData orderDetails)
	{
		final String uid;

		if (orderDetails.isGuestCustomer() && !model.containsAttribute("guestRegisterForm"))
		{
			final GuestRegisterForm guestRegisterForm = new GuestRegisterForm();
			guestRegisterForm.setOrderCode(orderDetails.getGuid());
			uid = orderDetails.getPaymentInfo().getBillingAddress().getEmail();
			guestRegisterForm.setUid(uid);
			model.addAttribute(guestRegisterForm);
		}
		else
		{
			uid = orderDetails.getUser().getUid();
		}
		model.addAttribute("email", uid);
	}

	/**
	 * @return the purchaseOrderNoValidator
	 */
	public PurchaseOrderNoValidator getPurchaseOrderNoValidator()
	{
		return purchaseOrderNoValidator;
	}

	/**
	 * @param purchaseOrderNoValidator
	 *           the purchaseOrderNoValidator to set
	 */
	public void setPurchaseOrderNoValidator(final PurchaseOrderNoValidator purchaseOrderNoValidator)
	{
		this.purchaseOrderNoValidator = purchaseOrderNoValidator;
	}

	/**
	 * @return the brakesSaveCartFacade
	 */
	public BrakesSaveCartFacade getBrakesSaveCartFacade()
	{
		return brakesSaveCartFacade;
	}

	/**
	 * @param brakesSaveCartFacade
	 *           the brakesSaveCartFacade to set
	 */
	public void setBrakesSaveCartFacade(final BrakesSaveCartFacade brakesSaveCartFacade)
	{
		this.brakesSaveCartFacade = brakesSaveCartFacade;
	}

	protected AcceleratorCheckoutFacade getBrakesAcceleratorCheckoutFacade()
	{
		return brakesAcceleratorCheckoutFacade;
	}

}
