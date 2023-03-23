/**
 *
 */
package com.envoydigital.brakes.storefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.Breadcrumb;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractRegisterPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.AbstractPageModel;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import de.hybris.platform.commercefacades.user.data.BrakesOrderingAccountData;
import de.hybris.platform.util.Config;

import java.util.Collections;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Validator;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.envoydigital.brakes.facades.BrakesCustomerFacade;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.LinkBrakesOrderingAccountForm;


/**
 * @author maheshroyal
 *
 */
@Controller
@RequestMapping("/register-existing-registration")
public class BrakesLinkAccountRegisterPageController extends AbstractRegisterPageController
{

	@Resource(name = "httpSessionRequestCache")
	private HttpSessionRequestCache httpSessionRequestCache;
	private static final String FORM_GLOBAL_ERROR = "form.global.error";

	@Resource(name = "brakesLinkAccountFormValidator")
	private Validator formValidator;

	@Resource(name = "brakesCustomerFacade")
	private BrakesCustomerFacade brakesCustomerFacade;

	private static final String REDIRECT_CONF = "/register-existing-confirmation";
	private static final Integer ACCNT_THRESHOLD = Config.getInt("trading.account.numbers.threshold", 5);


	@RequestMapping(method = RequestMethod.GET)
	public String doRegister(final Model model) throws CMSItemNotFoundException
	{
		model.addAttribute("maxCounter", ACCNT_THRESHOLD);
		return getLinkBrakesOrderingAccountPage(model);
	}


	@RequestMapping(method = RequestMethod.POST)
	public String processRegistration(final LinkBrakesOrderingAccountForm form, final BindingResult bindingResult,
			final Model model, final HttpServletRequest request, final HttpServletResponse response,
			final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		formValidator.validate(form, bindingResult);
		if (bindingResult.hasErrors())
		{
			//form.setTermsCheck(false);
			model.addAttribute(form);
			GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
			return handleRegistrationError(model);
		}

		final BrakesOrderingAccountData accountData = new BrakesOrderingAccountData();
		accountData.setFirstName(form.getFirstName());
		accountData.setLastName(form.getLastName());
		accountData.setEmail(form.getEmail());
		accountData.setPostCode(form.getPostCode());
		accountData.setTradingName(form.getTradingName());


		accountData.setAccountNumber(form.getAccountNumbers());

		brakesCustomerFacade.linkBrakesOrderingAccount(accountData);

		return REDIRECT_PREFIX + getSuccessRedirect(request, response);
	}

	@Override
	protected AbstractPageModel getCmsPage() throws CMSItemNotFoundException
	{
		return getContentPageForLabelOrId("link-orderingAccount-register");
	}


	@Override
	protected String getSuccessRedirect(final HttpServletRequest request, final HttpServletResponse response)
	{
		//		if (httpSessionRequestCache.getRequest(request, response) != null)
		//		{
		//			return httpSessionRequestCache.getRequest(request, response).getRedirectUrl();
		//		}
		return REDIRECT_CONF;
	}


	@Override
	protected String getView()
	{
		return ControllerConstants.Views.Pages.Account.AccountRegisterPage;
	}

	protected String getLinkBrakesOrderingAccountPage(final Model model) throws CMSItemNotFoundException
	{
		storeCmsPageInModel(model, getCmsPage());
		setUpMetaDataForContentPage(model, (ContentPageModel) getCmsPage());
		final Breadcrumb loginBreadcrumbEntry = new Breadcrumb("#",
				getMessageSource().getMessage("header.link.login", null, getI18nService().getCurrentLocale()), null);
		model.addAttribute("breadcrumbs", Collections.singletonList(loginBreadcrumbEntry));
		model.addAttribute("registerBrakesOrderingAccountForm", new LinkBrakesOrderingAccountForm());
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
		return getView();
	}

}
