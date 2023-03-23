
package com.envoydigital.brakes.storefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractCheckoutController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.core.model.order.OrderModel;
import de.hybris.platform.order.InvalidCartException;
import de.hybris.platform.payment.model.PaymentTransactionModel;
import de.hybris.platform.servicelayer.exceptions.ModelNotFoundException;
import de.hybris.platform.servicelayer.session.SessionService;

import java.math.BigDecimal;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.envoydigital.brakes.facades.BrakesB2BCheckoutFacade;
import com.envoydigital.brakes.facades.b2c.checkout.BrakesPayPageCheckoutFacade;
import com.envoydigital.brakes.facades.cart.BrakesSaveCartFacade;
import com.envoydigital.brakes.payment.constants.BrakespaymentcoreConstants;
import com.envoydigital.brakes.payment.exception.PayPageClientException;
import com.envoydigital.brakes.payment.service.BrakesPaymentService;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;



/**
 * CheckoutController
 */
@Controller
@RequestMapping(value = "/checkout")
public class BrakesPaymentCheckoutController extends AbstractCheckoutController
{
	private static final org.slf4j.Logger LOG = LoggerFactory.getLogger(BrakesPaymentCheckoutController.class);

	@Resource(name = "brakesPaymentService")
	private BrakesPaymentService brakesPaymentService;

	@Resource(name = "b2bCheckoutFacade")
	private BrakesB2BCheckoutFacade b2bCheckoutFacade;

	@Resource(name = "saveCartFacade")
	private BrakesSaveCartFacade brakesSaveCartFacade;

	@Resource(name = "sessionService")
	private SessionService sessionService;

	@Resource(name = "brakesPayPageCheckoutFacade")
	private BrakesPayPageCheckoutFacade brakesPayPageCheckoutFacade;

	protected static final String MULTI_CHECKOUT_IFRAME_PAGE = "checkoutIframePage";
	protected static final String CHECKOUT_URL = "/checkout";
	protected static final String CHECKOUT_ERROR_URL = "/checkout/error";

	@ExceptionHandler(ModelNotFoundException.class)

	public String handleModelNotFoundException(final ModelNotFoundException exception, final HttpServletRequest request)
	{
		request.setAttribute("message", exception.getMessage());
		return FORWARD_PREFIX + "/404";
	}

	@RequestMapping(value = "/order-completion", method = RequestMethod.GET)
	@RequireHardLogIn
	public String orderCompletion(final RedirectAttributes redirectModel, final Model model, final HttpServletRequest request)
			throws CMSItemNotFoundException
	{
		final Map<String, String[]> requestMap = request.getParameterMap();
		LOG.info("Request map on order completion {}", requestMap);

		//Enable this to lock cart before opening IFrame
		//		try
		//		{
		//			brakesPayPageCheckoutFacade.restoreSessionCart();
		//		}
		//		catch (final InvalidCartException exp)
		//		{
		//			LOG.info("Invalid cart  {}", exp.getMessage());
		//		}
		if (!brakesPayPageCheckoutFacade.validateSessionCart(requestMap))
		{
			//Invalid cart redirect back to checkout page
			return returnWithErrorMessgae();
		}

		final PaymentTransactionModel paymentTransactionModel = brakesPayPageCheckoutFacade.createPaymentTransaction(requestMap,
				Boolean.FALSE);
		if (paymentTransactionModel == null)
		{
			//Transaction failed show error message
			final String errorMessageCode = brakesPayPageCheckoutFacade.getErrorCode(requestMap);
			LOG.error("error message {}", errorMessageCode);
			//return to checkout page with the error message
			return returnWithErrorMessgae();

		}

		final OrderModel orderModel = placeOrder();
		if (orderModel == null)
		{
			return returnWithErrorMessgae();
		}
		brakesSaveCartFacade.setMostRecentCart();
		return REDIRECT_PREFIX + getOrderConfirmationUrl(orderModel);
	}



	/**
	 * @param model
	 * @param baseURL
	 * @param errorMessageCode
	 * @return
	 */
	private String returnWithErrorMessgae()
	{
		return REDIRECT_PREFIX + CHECKOUT_ERROR_URL;
	}

	@RequestMapping(value = "/error", method = RequestMethod.GET)
	@RequireHardLogIn
	public String getErrorPage(final RedirectAttributes redirectModel, final Model model, final HttpServletRequest request)
			throws CMSItemNotFoundException
	{
		storeCmsPageInModel(model, getContentPageForLabelOrId(MULTI_CHECKOUT_IFRAME_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(MULTI_CHECKOUT_IFRAME_PAGE));
		model.addAttribute("metaRobots", "noindex,nofollow");
		return ControllerConstants.Views.Pages.MultiStepCheckout.CheckoutPayPageErrorPage;
	}

	protected String getOrderConfirmationUrl(final OrderModel orderModel)
	{
		return "/checkout/orderConfirmation/"
				+ (getCheckoutCustomerStrategy().isAnonymousCheckout() ? orderModel.getGuid() : orderModel.getCode());
	}

	@RequestMapping(value = "/payment-iframe", method = RequestMethod.GET)
	@RequireHardLogIn
	public String getIFrameURLReal(final RedirectAttributes redirectModel, final Model model) throws CMSItemNotFoundException
	{
		if (sessionService.getAttribute(BrakespaymentcoreConstants.PAYMENT_REDIRECTION_SESSION_ATTRIBUTE) == null || validateCart(redirectModel))
		{
			//Enable this to lock cart before opening IFrame
			//restoreCart();
			LOG.error("Missing, empty or unsupported cart");
			GlobalMessages.addErrorMessage(model, "checkout.placeOrder.failed");
			return REDIRECT_PREFIX + CHECKOUT_URL;
		}
		//Check if order is not already authorised with the same amount
		final BigDecimal amount = brakesPayPageCheckoutFacade.getAlreadyAuthorisedAmountForCart();
		boolean appendToCart = false;
		if (amount != null)
		{
			if (brakesPayPageCheckoutFacade.isCartFullyAuthorised(amount))
			{
				final boolean useNotification = true;
				//place order
				final String baseURL = brakesPayPageCheckoutFacade.getSiteURL();
				final PaymentTransactionModel paymentTransactionModel = brakesPayPageCheckoutFacade.createPaymentTransaction(null,
						useNotification);
				if (paymentTransactionModel == null)
				{
					//Transaction failed show error message
					//return to checkout page with the error message
					return returnWithErrorMessgae();

				}
				final OrderModel orderModel = placeOrder();
				if (orderModel != null)
				{
				return REDIRECT_PREFIX + "/checkout/orderConfirmation/"
						+ (getCheckoutCustomerStrategy().isAnonymousCheckout() ? orderModel.getGuid() : orderModel.getCode());
				}

			}
			else
			{
				//Check if order is authorised with different amount, then append a, b, c... with order code
				appendToCart = true;
			}
		}


		String token = null;
		try
		{
			token = brakesPayPageCheckoutFacade.getPaymentToken(appendToCart);
		}
		catch (final PayPageClientException e)
		{
			LOG.error(e.getMessage());
			return REDIRECT_PREFIX + CHECKOUT_URL;
		}
		model.addAttribute("iframeURL", brakesPayPageCheckoutFacade.getPaymentURL(token));
		//Enable this to lock cart before opening IFrame
		//		try
		//		{
		//			brakesPayPageCheckoutFacade.lockSessionCart();
		//		}
		//		catch (final InvalidCartException e)
		//		{
		//			LOG.info("Invalid cart  {}", e.getMessage());
		//		}

		storeCmsPageInModel(model, getContentPageForLabelOrId(MULTI_CHECKOUT_IFRAME_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(MULTI_CHECKOUT_IFRAME_PAGE));
		model.addAttribute("metaRobots", "noindex,nofollow");
		sessionService.removeAttribute(BrakespaymentcoreConstants.PAYMENT_REDIRECTION_SESSION_ATTRIBUTE);
		return ControllerConstants.Views.Pages.MultiStepCheckout.CheckoutPayPagePaymentPage;

	}

	/**
	 * @return
	 */
	private OrderModel placeOrder()
	{
		OrderModel orderModel = null;
		try
		{
			orderModel = b2bCheckoutFacade.placeOrderQuitely();
			if (orderModel != null)
			{
				LOG.info("Order Placed:::: Code:: " + orderModel.getCode());
				LOG.info("User::" + orderModel.getUser() != null ? orderModel.getUser().getUid() : "");
				LOG.info("Unit::" + orderModel.getUnit() != null ? orderModel.getUnit().getUid() : "");
			}
		}
		catch (final Exception e)
		{
			LOG.error("error while placing order {}", e.getMessage());
		}
		return orderModel;
	}

	/**
	 *
	 */
	private void restoreCart()
	{
		try
		{
			brakesPayPageCheckoutFacade.restoreSessionCart();
		}
		catch (final InvalidCartException exp)
		{
			LOG.info("Invalid cart  {}", exp.getMessage());
		}
	}

}
