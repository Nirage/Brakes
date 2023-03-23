package com.envoydigital.brakes.brakesaddon.strategy.impl;

import de.hybris.platform.acceleratorstorefrontcommons.constants.WebConstants;
import de.hybris.platform.acceleratorstorefrontcommons.strategy.impl.DefaultCartRestorationStrategy;
import de.hybris.platform.commerceservices.order.CommerceCartRestorationException;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Required;

import com.envoydigital.brakes.facades.cart.BrakesCartFacade;


/**
 * @author kuber.pant
 *
 */
public class DefaultBrakesCartRestorationStrategy extends DefaultCartRestorationStrategy
{
	private static final Logger LOG = Logger.getLogger(DefaultBrakesCartRestorationStrategy.class);
	private BrakesCartFacade brakesCartFacade;
	public static final String INVALID_DELIVERY_DATE = "invalidDeliveryDate";
	public static final String PRICING_CHANGED = "pricingChanged";
	public static final String MODIFICATIONS = "modifications";

	@Override
	public void restoreCart(final HttpServletRequest request)
	{
		if (!getCartFacade().hasEntries())
		{
			getSessionService().setAttribute(WebConstants.CART_RESTORATION_SHOW_MESSAGE, Boolean.TRUE);
			try
			{
				getSessionService().setAttribute(WebConstants.CART_RESTORATION, getBrakesCartFacade().restoreSavedCart());
				final boolean invalidDeliveryDate = getBrakesCartFacade().checkDeliveryDate();
				getSessionService().setAttribute(INVALID_DELIVERY_DATE, invalidDeliveryDate);
				//				final boolean priceChanged = brakesCartFacade.hasPricingChanged();
				//				if (priceChanged)
				//				{
				//					getSessionService().setAttribute(PRICING_CHANGED, priceChanged);
				//				}

				//Validate the cart
				//				List<CartModificationData> modifications = new ArrayList<>();
				//				try
				//				{
				//					modifications = getCartFacade().validateCartData();
				//					getSessionService().setAttribute(MODIFICATIONS, modifications);
				//				}
				//				catch (final CommerceCartModificationException e)
				//				{
				//					LOG.error("Failed to validate cart", e);
				//				}

			}
			catch (final CommerceCartRestorationException e)
			{
				if (LOG.isDebugEnabled())
				{
					LOG.debug(e);
				}
				getSessionService().setAttribute(WebConstants.CART_RESTORATION_ERROR_STATUS,
						WebConstants.CART_RESTORATION_ERROR_STATUS);
			}
		}
	}


	/**
	 * @return the brakesCartFacade
	 */
	public BrakesCartFacade getBrakesCartFacade()
	{
		return brakesCartFacade;
	}


	/**
	 * @param brakesCartFacade
	 *           the brakesCartFacade to set
	 */
	@Required
	public void setBrakesCartFacade(final BrakesCartFacade brakesCartFacade)
	{
		this.brakesCartFacade = brakesCartFacade;
	}
}
