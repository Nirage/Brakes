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

import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.Breadcrumb;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractLoginPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.acceleratorstorefrontcommons.forms.LoginForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.RegisterForm;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.AbstractPageModel;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import de.hybris.platform.commercefacades.user.UserFacade;

import java.util.Collections;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.envoydigital.brakes.storefront.controllers.ControllerConstants;


/**
 * Login Controller. Handles login and register for the account flow.
 */
@Controller
@RequestMapping(value = "/sign-in")
public class LoginPageController extends AbstractLoginPageController
{
	@Resource(name = "userFacade")
	private UserFacade userFacade;

	public static final String REDIRECT_PREFIX = "redirect:";

	private static final String SPRING_SECURITY_LAST_PASSWORD = "SPRING_SECURITY_LAST_PASSWORD";
	private static final String SPRING_SECURITY_CUSTOMER_LOCKED = "SPRING_SECURITY_CUSTOMER_LOCKED";
	private HttpSessionRequestCache httpSessionRequestCache;

	@Override
	protected String getView()
	{
		return ControllerConstants.Views.Pages.Account.SimpleCustomerDialogPage;
	}

	@Override
	protected String getSuccessRedirect(final HttpServletRequest request, final HttpServletResponse response)
	{
		if (httpSessionRequestCache.getRequest(request, response) != null)
		{
			return httpSessionRequestCache.getRequest(request, response).getRedirectUrl();
		}
		return "/";
	}

	@Override
	protected AbstractPageModel getCmsPage() throws CMSItemNotFoundException
	{
		return getContentPageForLabelOrId("login");
	}


	@Resource(name = "httpSessionRequestCache")
	public void setHttpSessionRequestCache(final HttpSessionRequestCache accHttpSessionRequestCache)
	{
		this.httpSessionRequestCache = accHttpSessionRequestCache;
	}

	@ModelAttribute("hasStrippedDownHeader")
	public boolean getHasStrippedDownHeader()
	{
		return true;
	}

	@ModelAttribute("hasStrippedDownFooter")
	public boolean getHasStrippedDownFooter()
	{
		return true;
	}

	@RequestMapping(method = RequestMethod.GET)
	public String doLogin(@RequestHeader(value = "referer", required = false) final String referer,
			@RequestParam(value = "error", defaultValue = "false") final boolean loginError,
			@RequestParam(value = "dcError", defaultValue = "false") final boolean dcError, final Model model,
			@ModelAttribute("loginForm") final LoginForm loginForm, final BindingResult bindingResult,
			final HttpServletRequest request, final HttpServletResponse response) throws CMSItemNotFoundException
	{
		final HttpSession session = request.getSession();

		if (!loginError)
		{
			storeReferer(referer, request, response);
		}

		if (!userFacade.isAnonymousUser())
		{
			return REDIRECT_PREFIX + "/";
		}

		return getDefaultLoginPage(loginError,dcError, session, model, bindingResult);
	}

	protected void storeReferer(final String referer, final HttpServletRequest request, final HttpServletResponse response)
	{
		if (StringUtils.isNotBlank(referer) && !StringUtils.endsWith(referer, "/sign-in")
				&& StringUtils.contains(referer, request.getServerName()))
		{
			httpSessionRequestCache.saveRequest(request, response);
		}
	}

	@RequestMapping(value = "/register", method = RequestMethod.POST)
	public String doRegister(@RequestHeader(value = "referer", required = false) final String referer, final RegisterForm form,
			final BindingResult bindingResult, final Model model, final HttpServletRequest request,
			final HttpServletResponse response, final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		getRegistrationValidator().validate(form, bindingResult);
		return processRegisterUserRequest(referer, form, bindingResult, model, request, response, redirectModel);
	}



	private String getDefaultLoginPage(final boolean loginError, final boolean dcError, final HttpSession session, final Model model,
			final BindingResult bindingResult) throws CMSItemNotFoundException
	{
		final String view = getDefaultLoginPage(loginError, session, model);
		if (loginError)
		{
			final boolean isCustomerLocked = session.getAttribute(SPRING_SECURITY_CUSTOMER_LOCKED) instanceof Boolean ? (Boolean) session
					.getAttribute(SPRING_SECURITY_CUSTOMER_LOCKED) : false;
			if (isCustomerLocked)
			{
				session.removeAttribute(SPRING_SECURITY_CUSTOMER_LOCKED);
			}
			model.addAttribute("loginError", Boolean.valueOf(loginError));
			addErrorMessageDependentOnLoginError(isCustomerLocked, dcError, model, bindingResult);
		}

		return view;
	}

	@Override
	protected String getDefaultLoginPage(final boolean loginError, final HttpSession session, final Model model)
			throws CMSItemNotFoundException
	{
		final LoginForm loginForm = (LoginForm) model.asMap().get("loginForm");

		final String username = (String) session.getAttribute(SPRING_SECURITY_LAST_USERNAME);
		if (username != null)
		{
			session.removeAttribute(SPRING_SECURITY_LAST_USERNAME);
		}
		final String password = (String) session.getAttribute(SPRING_SECURITY_LAST_PASSWORD);

		if (password != null)
		{
			session.removeAttribute(SPRING_SECURITY_LAST_PASSWORD);
		}

		loginForm.setJ_username(username);
		loginForm.setJ_password(password);
		storeCmsPageInModel(model, getCmsPage());
		setUpMetaDataForContentPage(model, (ContentPageModel) getCmsPage());
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.INDEX_NOFOLLOW);

		addRegistrationConsentDataToModel(model);

		final Breadcrumb loginBreadcrumbEntry = new Breadcrumb("#", getMessageSource().getMessage("header.link.login", null,
				"header.link.login", getI18nService().getCurrentLocale()), null);
		model.addAttribute("breadcrumbs", Collections.singletonList(loginBreadcrumbEntry));


		return getView();
	}


	private void addErrorMessageDependentOnLoginError(final boolean isCustomerLocked, final boolean dcError, final Model model,
			final BindingResult bindingResult)
	{
		if(dcError)
		{
			GlobalMessages.addErrorMessage(model, "login.error.invalid.dc");
		} else if (isCustomerLocked)  {
			GlobalMessages.addErrorMessage(model, "login.error.credentials.incorrect.locked");
		} else {
			GlobalMessages.addErrorMessage(model, "login.error.credentials.incorrect.nonlocked");
		}
	}



}
