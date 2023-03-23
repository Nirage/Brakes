package com.envoydigital.brakes.storefront.interceptors.beforeview;

import de.hybris.platform.acceleratorstorefrontcommons.interceptors.BeforeViewHandler;
import de.hybris.platform.servicelayer.user.UserService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.envoydigital.brakes.facades.cart.BrakesCartFacade;


/**
 * @author kuber.pant
 *
 */
public class BrakesDeliveryDateChecksBeforeViewHandler implements BeforeViewHandler
{
	private UserService userService;
	private BrakesCartFacade brakesCartFacade;


	@Override
	public void beforeView(final HttpServletRequest request, final HttpServletResponse response, final ModelAndView modelAndView)
			throws Exception
	{
		if (!userService.isAnonymousUser(userService.getCurrentUser()))
		{
			if (brakesCartFacade.checkDeliveryDate())
			{
				modelAndView.addObject("showDeliveryDateChangeMessage", Boolean.TRUE);
				if (brakesCartFacade.hasPricingChanged())
				{
					modelAndView.addObject("showPricingChangeMessage", Boolean.TRUE);
				}
			}
		}

	}

	/**
	 * @return the userService
	 */
	public UserService getUserService()
	{
		return userService;
	}

	/**
	 * @param userService
	 *           the userService to set
	 */
	public void setUserService(final UserService userService)
	{
		this.userService = userService;
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
	public void setBrakesCartFacade(final BrakesCartFacade brakesCartFacade)
	{
		this.brakesCartFacade = brakesCartFacade;
	}
}
