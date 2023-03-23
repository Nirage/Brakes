/**
 *
 */
package com.envoydigital.brakes.controllers.pages;

import com.envoydigital.brakes.facades.utils.BrakesAmendOrderSessionUtils;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.constants.WebConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.b2b.services.B2BOrderService;
import de.hybris.platform.basecommerce.enums.CancelReason;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.AbstractPageModel;
import de.hybris.platform.commercefacades.order.OrderFacade;
import de.hybris.platform.commercefacades.order.data.OrderData;
import de.hybris.platform.commerceservices.util.ResponsiveUtils;
import de.hybris.platform.core.model.order.OrderModel;
import de.hybris.platform.ordermanagementfacades.cancellation.data.OrderCancelEntryData;
import de.hybris.platform.ordermanagementfacades.cancellation.data.OrderCancelRequestData;
import de.hybris.platform.ordermanagementfacades.order.OmsOrderFacade;
import de.hybris.platform.orderselfserviceaddon.controllers.pages.CancelOrderPageController;
import de.hybris.platform.servicelayer.i18n.I18NService;
import de.hybris.platform.servicelayer.user.UserService;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.context.MessageSource;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.envoydigital.brakes.facades.oms.order.BrakesOmsOrderFacade;
/**
 * @author Sridhar
 *
 */
public class BrakesCancelOrderPageController extends CancelOrderPageController
{
	public static final String REDIRECT_PREFIX = "redirect:";
	private static final String REDIRECT_TO_ORDERS_HISTORY_PAGE = REDIRECT_PREFIX + "/my-account/orders";
	private static final String REDIRECT_TO_ORDER_DETAILS_PAGE = REDIRECT_PREFIX + "/my-account/order/";
	private static final String REDIRECT_TO_ORDER_CANCELLED_SUBMITTED_PAGE = REDIRECT_PREFIX + "/my-account/order/";

	private static final String CHECKOUT_ORDER_CANCELLATION_OOS_CMS_PAGE_LABEL = "orderAmendmentCancellation";
	private static final String CONTINUE_URL_KEY = "continueUrl";

	@Resource(name = "orderFacade")
	private OrderFacade orderFacade;

	@Resource(name = "omsOrderFacade")
	private OmsOrderFacade omsOrderFacade;

	@Resource(name = "brakesOmsOrderFacade")
	private BrakesOmsOrderFacade brakesOmsOrderFacade;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Resource(name = "i18nService")
	private I18NService i18nService;

	@Resource(name = "userService")
	private UserService userService;

	@Resource(name = "b2bOrderService")
	private B2BOrderService b2bOrderService;

	@Resource(name = "brakesAmendOrderSessionUtils")
	BrakesAmendOrderSessionUtils brakesAmendOrderSessionUtils;

	@RequireHardLogIn
	@RequestMapping(value = "/{orderCode:.*}/cancel/submit", method = RequestMethod.GET)
	public String submitCancelOrderPage(@PathVariable("orderCode") final String orderCode, final Model model,
			final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		// This will throw a runtime exception if the current customer or base store is not matching the passed.
		orderFacade.getOrderDetailsForCodeWithoutUser(orderCode);
		try
		{
			brakesOmsOrderFacade.cancleOrderAndReturnCancelRequestData(prepareOrderCancelRequestData(orderCode));
			brakesAmendOrderSessionUtils.releaseAmendOrderSession();

			return REDIRECT_TO_ORDER_CANCELLED_SUBMITTED_PAGE + orderCode + "/cancel/submit/success";
		}
		catch (final Exception exception)
		{
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "text.account.cancel.fail.generic");
			return REDIRECT_TO_ORDERS_HISTORY_PAGE;
		}
	}

	@RequireHardLogIn
	@RequestMapping(value = "/{orderCode:.*}/cancel/submit/success", method = RequestMethod.GET)
	public String cancelRequestSubmitted(@PathVariable("orderCode") final String orderCode, final Model model,
					 final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		final OrderData orderData = orderFacade.getOrderDetailsForCodeWithoutUser(orderCode);
		model.addAttribute("orderData", orderData);

		final String continueUrl = (String) getSessionService().getAttribute(WebConstants.CONTINUE_URL);
		model.addAttribute(CONTINUE_URL_KEY, (continueUrl != null && !continueUrl.isEmpty()) ? continueUrl : ROOT);

		final AbstractPageModel cmsPage = getContentPageForLabelOrId(CHECKOUT_ORDER_CANCELLATION_OOS_CMS_PAGE_LABEL);
		storeCmsPageInModel(model, cmsPage);
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(CHECKOUT_ORDER_CANCELLATION_OOS_CMS_PAGE_LABEL));
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);

		if (ResponsiveUtils.isResponsive())
		{
			return getViewForPage(model);
		}

		// We are reusing the template of the confirmation page
		return "pages/checkout/checkoutConfirmationLayoutPage";
	}

	/**
	 * It prepares the {@link OrderCancelRequestData} object by taking the order and list of order entry and cancel quantity
	 * and sets the user
	 *
	 * @param orderCode
	 *           which we want to request to cancel
	 * @return Populated {@link OrderCancelRequestData}
	 */
	protected OrderCancelRequestData prepareOrderCancelRequestData(final String orderCode)
	{
		final OrderCancelRequestData result = new OrderCancelRequestData();
		result.setOrderCode(orderCode);
		result.setEntries(prepareOrderCancelEntryData(b2bOrderService.getOrderForCode(orderCode)));
		return result;
	}

	/**
	 * It prepares a list of {@link OrderCancelEntryData} object to be set in the entries of {@link OrderCancelRequestData}
	 *
	 * @param order
	 *           list of order entry and cancel quantity
	 * @return list of {@link OrderCancelEntryData} representing the map of order entry and cancel quantity
	 */
	protected List<OrderCancelEntryData> prepareOrderCancelEntryData(final OrderModel order)
	{
		final List<OrderCancelEntryData> result = new ArrayList<>();

		order.getEntries().forEach((entry) -> {
			final OrderCancelEntryData orderCancelEntryData = new OrderCancelEntryData();
			orderCancelEntryData.setOrderEntryNumber(entry.getEntryNumber());
			orderCancelEntryData.setCancelQuantity(Long.valueOf(entry.getQuantity()));
			orderCancelEntryData.setCancelReason(CancelReason.CUSTOMERREQUEST);
			result.add(orderCancelEntryData);
		});
		return result;
	}

}
