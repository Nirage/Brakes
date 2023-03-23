package com.envoydigital.brakes.storefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.envoydigital.brakes.facades.BrakesCustomerFacade;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.ForgotpasswordForm;


/**
 * @author Haridaskpillai
 *
 */
@Controller
@RequestMapping(value = "/forgot-password")
public class ForgotPasswordPageController extends AbstractPageController
{

	private static final Logger LOG = LoggerFactory.getLogger(ForgotPasswordPageController.class);
	private static final String BREADCRUMBS_ATTR = "breadcrumbs";
	private static final String FORGOT_PASSWORD_CMS_PAGE = "forgotpassword";
	private static final String FORGOT_PASSWORD_CONFIRM_CMS_PAGE = "forgotpassword-confirm";

	@Resource(name = "brakesCustomerFacade")
	private BrakesCustomerFacade customerFacade;

	@RequestMapping(method = RequestMethod.GET)
	public String forgotPassword(final Model model, @ModelAttribute("forgotPasswordForm")
	final ForgotpasswordForm forgotPasswordForm, final BindingResult bindingResult, final HttpServletRequest request,
			final HttpServletResponse response) throws CMSItemNotFoundException
	{

		storeCmsPageInModel(model, getContentPageForLabelOrId(FORGOT_PASSWORD_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(FORGOT_PASSWORD_CMS_PAGE));
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);

		return ControllerConstants.Views.Pages.Account.AccountForgotPasswordPage;
	}

	@RequestMapping(method = RequestMethod.POST)
	public String forgotPasswordSubmit(final Model model, @ModelAttribute("forgotPasswordForm")
	final ForgotpasswordForm forgotPasswordForm, final BindingResult bindingResult, final HttpServletRequest request,
			final HttpServletResponse response) throws CMSItemNotFoundException
	{
		final String userName = StringUtils.trim(forgotPasswordForm.getUsername());
		try
		{
			customerFacade.forgottenPassword(userName);
		}
		catch (final UnknownIdentifierException unknownIdentifierException)
		{
			LOG.warn("Email: " + userName + " does not exist in the database.");
		}
		// logic to send forgot password email
		storeCmsPageInModel(model, getContentPageForLabelOrId(FORGOT_PASSWORD_CONFIRM_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(FORGOT_PASSWORD_CONFIRM_CMS_PAGE));
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);

		return ControllerConstants.Views.Pages.Account.AccountForgotPasswordPage;
	}

}
