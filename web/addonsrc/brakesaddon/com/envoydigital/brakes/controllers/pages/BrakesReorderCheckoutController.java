/**
 *
 */
package com.envoydigital.brakes.controllers.pages;

import com.envoydigital.brakes.facades.BrakesB2BOrderFacade;
import com.envoydigital.brakes.facades.utils.BrakesAmendOrderSessionUtils;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.b2bacceleratoraddon.controllers.pages.checkout.ReorderCheckoutController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commercefacades.order.CartFacade;
import de.hybris.platform.commerceservices.order.CommerceCartModificationException;
import de.hybris.platform.order.InvalidCartException;

import java.text.ParseException;
import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.envoydigital.brakes.facades.BrakesB2BCheckoutFacade;
import com.envoydigital.brakes.facades.unavailable.data.UnavailableProductData;


/**
 * @author Sridhar
 *
 */
public class BrakesReorderCheckoutController extends ReorderCheckoutController
{
	private static final Logger LOG = Logger.getLogger(BrakesReorderCheckoutController.class);
	public static final String REDIRECT_PREFIX = "redirect:";
	private static final String REDIRECT_ORDER_LIST_URL = REDIRECT_PREFIX + "/my-account/orders/";
	private static final String REDIRECT_CART_URL = REDIRECT_PREFIX + "/cart";

	@Resource(name = "b2bCheckoutFacade")
	private BrakesB2BCheckoutFacade b2bCheckoutFacade;

	@Resource(name = "cartFacade")
	private CartFacade cartFacade;

	@Resource(name = "b2bOrderFacade")
	private BrakesB2BOrderFacade orderFacade;

	@Resource(name = "brakesAmendOrderSessionUtils")
	private BrakesAmendOrderSessionUtils brakesAmendOrderSessionUtils;


	public String reorder(@RequestParam(value = "orderCode") final String orderCode, final RedirectAttributes redirectModel)
			throws CMSItemNotFoundException, InvalidCartException, ParseException, CommerceCartModificationException
	{
		try {
			processReOrder(orderCode, redirectModel);
			if(brakesAmendOrderSessionUtils.isAmendingOrderSession()) {
				orderFacade.removeAmendOrder(orderCode);
				brakesAmendOrderSessionUtils.releaseAmendOrderSession();
			}
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "order.reorder.message.products.added.to.basket");
		}
		catch (final IllegalArgumentException e)
		{
			LOG.error(String.format("Unable to reorder %s", orderCode), e);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "order.reorder.error", null);
			return REDIRECT_ORDER_LIST_URL;
		}
		return REDIRECT_CART_URL;
	}

	@RequestMapping(value = "/order-history/reorder", method = { RequestMethod.PUT, RequestMethod.POST })
	@RequireHardLogIn
	public String reorderFromOrderHistory(@RequestParam(value = "orderCode") final String orderCode, final RedirectAttributes redirectModel) throws CommerceCartModificationException {

		try
		{
			processReOrder(orderCode, redirectModel);
			if(brakesAmendOrderSessionUtils.isAmendingOrderSession()) {
				orderFacade.removeAmendOrder(orderCode);
				brakesAmendOrderSessionUtils.releaseAmendOrderSession();
			}
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "order.reorder.message.products.added.to.basket");
		}
		catch (final IllegalArgumentException e)
		{
			LOG.error(String.format("Unable to reorder %s", orderCode), e);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "order.reorder.error", null);
		}

		return REDIRECT_CART_URL;
	}

	/**
	 * Processing reOrder
	 *
	 * @param orderCode
	 * @param redirectModel
	 * @throws CommerceCartModificationException
	 */
	private void processReOrder(final String orderCode, final RedirectAttributes redirectModel) throws CommerceCartModificationException {
			// create a cart from the order and set it as session cart.
			final List<UnavailableProductData> unavailableProducts = b2bCheckoutFacade
					.createCartFromOrderAndReturnUnavailableProducts(orderCode);
			//GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "basket.created.with.existing.order");
			redirectModel.addFlashAttribute("unavailableProducts", unavailableProducts);
			redirectModel.addFlashAttribute("reOrderedSuccess", true);
	}

}
