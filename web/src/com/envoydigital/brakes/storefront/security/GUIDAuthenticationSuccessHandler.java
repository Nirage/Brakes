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
package com.envoydigital.brakes.storefront.security;

import de.hybris.platform.acceleratorstorefrontcommons.security.GUIDCookieStrategy;
import de.hybris.platform.commercefacades.customer.CustomerFacade;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Required;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.envoydigital.brakes.facades.user.BrakesUserFacade;


/**
 * Default implementation of {@link AuthenticationSuccessHandler}
 */
public class GUIDAuthenticationSuccessHandler implements AuthenticationSuccessHandler
{
	private GUIDCookieStrategy guidCookieStrategy;
	private AuthenticationSuccessHandler authenticationSuccessHandler;
	private BrakesUserFacade brakesUserFacade;
	private CustomerFacade customerFacade;
	private static String LOGIN_FAILED_URL = "/sign-in?error=true";
	private static String LOGIN_FAILED_DC_PARAM = "&dcError=true";

	@Override
	public void onAuthenticationSuccess(final HttpServletRequest request, final HttpServletResponse response,
			final Authentication authentication) throws IOException, ServletException
	{
		getGuidCookieStrategy().setCookie(request, response);
		if (!getBrakesUserFacade().hasValidDistributionChannel(getCustomerFacade().getCurrentCustomerUid()))
		{
			invalidateSessionAndRedirect(request, response, LOGIN_FAILED_URL+LOGIN_FAILED_DC_PARAM);
		}else if(!(getBrakesUserFacade().isUserValidForCurrentSite()))
		{
			invalidateSessionAndRedirect(request, response, LOGIN_FAILED_URL);
		}
		else
		{
			getAuthenticationSuccessHandler().onAuthenticationSuccess(request, response, authentication);
		}

	}

	protected void invalidateSessionAndRedirect(final HttpServletRequest request, final HttpServletResponse response,
			final String redirectUrl) throws IOException
	{
		SecurityContextHolder.getContext().setAuthentication(null);
		request.getSession().invalidate();
		response.sendRedirect(request.getContextPath() + redirectUrl);
	}


	protected GUIDCookieStrategy getGuidCookieStrategy()
	{
		return guidCookieStrategy;
	}

	/**
	 * @param guidCookieStrategy
	 *           the guidCookieStrategy to set
	 */
	@Required
	public void setGuidCookieStrategy(final GUIDCookieStrategy guidCookieStrategy)
	{
		this.guidCookieStrategy = guidCookieStrategy;
	}

	protected AuthenticationSuccessHandler getAuthenticationSuccessHandler()
	{
		return authenticationSuccessHandler;
	}

	/**
	 * @param authenticationSuccessHandler
	 *           the authenticationSuccessHandler to set
	 */
	@Required
	public void setAuthenticationSuccessHandler(final AuthenticationSuccessHandler authenticationSuccessHandler)
	{
		this.authenticationSuccessHandler = authenticationSuccessHandler;
	}

	/**
	 * @return the brakesUserFacade
	 */
	public BrakesUserFacade getBrakesUserFacade()
	{
		return brakesUserFacade;
	}

	/**
	 * @param brakesUserFacade
	 *           the brakesUserFacade to set
	 */
	public void setBrakesUserFacade(final BrakesUserFacade brakesUserFacade)
	{
		this.brakesUserFacade = brakesUserFacade;
	}

	/**
	 * @return the customerFacade
	 */
	public CustomerFacade getCustomerFacade()
	{
		return customerFacade;
	}

	/**
	 * @param customerFacade
	 *           the customerFacade to set
	 */
	public void setCustomerFacade(final CustomerFacade customerFacade)
	{
		this.customerFacade = customerFacade;
	}


}
