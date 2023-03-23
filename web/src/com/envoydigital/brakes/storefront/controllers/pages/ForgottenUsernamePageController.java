package com.envoydigital.brakes.storefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.AbstractPageModel;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import de.hybris.platform.commercefacades.user.data.CustomerData;

import java.util.List;

import javax.annotation.Resource;
import javax.validation.Valid;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.envoydigital.brakes.facades.user.BrakesB2BCustomerFacade;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.ForgottenUsernameForm;

@Controller
@RequestMapping(value = "/forgot-username")
public class ForgottenUsernamePageController extends AbstractPageController
{

	private static final String REDIRECT_TO_CONFIRMATION_PAGE = "redirect:/forgot-username-confirmation";
	private static final String REDIRECT_TO_ERROR_PAGE = "redirect:/forgot-username-error";

	@Resource
	private BrakesB2BCustomerFacade brakesB2BCustomerFacade;

	@RequestMapping(method = RequestMethod.GET)
	public String showPage(@ModelAttribute("forgottenUsernameForm") final ForgottenUsernameForm forgottenUsernameForm,
			final Model model) throws CMSItemNotFoundException
	{
		preparePage(model);
		return getView();
	}

	@RequestMapping(method = RequestMethod.POST)
	public String processForgottenUsernameForm(
			@Valid @ModelAttribute("forgottenUsernameForm") final ForgottenUsernameForm forgottenUsernameForm,
			final BindingResult bindingResult, final Model model) throws CMSItemNotFoundException
	{
		String returnTarget = StringUtils.EMPTY;
		if (bindingResult.hasErrors())
		{
			reject(forgottenUsernameForm, bindingResult);
			preparePage(model);
			returnTarget = getView();
		}
		else
		{
			String emailAddress = StringUtils.trim(forgottenUsernameForm
					.getEmailAddress());
			final List<CustomerData> b2bCustomersPerEmail = brakesB2BCustomerFacade.getB2BCustomersPerEmail(emailAddress);

			if (b2bCustomersPerEmail.size() == 1)
			{
				for (final CustomerData customerData : b2bCustomersPerEmail)
				{
					brakesB2BCustomerFacade.forgottenUsername(customerData.getUid());
				}
			}

			returnTarget = determineRedirectTarget(b2bCustomersPerEmail);
		}
		return returnTarget;
	}

	private void preparePage(final Model model) throws CMSItemNotFoundException
	{
		storeCmsPageInModel(model, getCmsPage());
		setUpMetaDataForContentPage(model, (ContentPageModel) getCmsPage());
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.INDEX_NOFOLLOW);
	}

	private void reject(final ForgottenUsernameForm forgottenUsernameForm, final BindingResult bindingResult)
	{
		if (StringUtils.isBlank(forgottenUsernameForm.getEmailAddress()))
		{
			bindingResult.rejectValue("emailAddress", getSiteUid() + ".error.empty.forgottenUsernameForm_emailAddress");
		}
		else
		{
			bindingResult.rejectValue("emailAddress", getSiteUid() + ".error.invalid.forgottenUsernameForm_emailAddress");
		}
	}

	private String determineRedirectTarget(final List<CustomerData> b2bCustomersPerEmail)
	{
		String redirectTarget = StringUtils.EMPTY;
		if (b2bCustomersPerEmail.size() > 1)
		{
			redirectTarget = REDIRECT_TO_ERROR_PAGE;
		}
		else if (containsOneNotEnabledB2BCustomer(b2bCustomersPerEmail))
		{
			redirectTarget = REDIRECT_TO_ERROR_PAGE;
		}
		else if (b2bCustomersPerEmail.size() <= 1)
		{
			redirectTarget = REDIRECT_TO_CONFIRMATION_PAGE;
		}
		else
		{
			redirectTarget = REDIRECT_TO_ERROR_PAGE;
		}
		return redirectTarget;
	}

	private boolean containsOneNotEnabledB2BCustomer(final List<CustomerData> b2bCustomers)
	{
		boolean result = false;
		if (b2bCustomers.size() == 1)
		{
			final CustomerData b2bCustomer = b2bCustomers.get(0);
			result = !(b2bCustomer.isActive());
		}
		return result;
	}

	private AbstractPageModel getCmsPage() throws CMSItemNotFoundException
	{
		return getContentPageForLabelOrId("forgottenUsernamePage");
	}

	private String getView()
	{
		return ControllerConstants.Views.Pages.Account.SimpleCustomerDialogPage;
	}

}
