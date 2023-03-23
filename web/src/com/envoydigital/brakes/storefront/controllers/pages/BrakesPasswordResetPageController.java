/**
 *
 */
package com.envoydigital.brakes.storefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.ResourceBreadcrumbBuilder;
import de.hybris.platform.acceleratorstorefrontcommons.constants.WebConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.acceleratorstorefrontcommons.security.AutoLoginStrategy;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commerceservices.customer.TokenInvalidatedException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.envoydigital.brakes.facades.user.BrakesB2BCustomerFacade;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.BrakesUpdatePwdForm;
import com.envoydigital.brakes.storefront.forms.validation.BrakesUpdatePasswordFormValidator;


/**
 * @author Lakshmi
 *
 */
@Controller
@RequestMapping("/create-password")
public class BrakesPasswordResetPageController extends AbstractPageController
{
	Logger LOG = Logger.getLogger(BrakesPasswordResetPageController.class);
	private static final String REDIRECT_HOME = "redirect:/";
	private static final String UPDATE_PWD_CMS_PAGE = "updatePassword";
	private static final String UPDATE_PWD_EXPIRY_CMS_PAGE = "updatePasswordExpiry";

	@Resource(name = "brakesUpdatePasswordFormValidator")
	private BrakesUpdatePasswordFormValidator updatePasswordFormValidator;

	@Resource(name = "b2bCustomerFacade")
	private BrakesB2BCustomerFacade b2bCustomerFacade;

	@Resource(name = "autoLoginStrategy")
	private AutoLoginStrategy autoLoginStrategy;

	@Resource(name = "simpleBreadcrumbBuilder")
	private ResourceBreadcrumbBuilder resourceBreadcrumbBuilder;

	@RequestMapping(method = RequestMethod.GET)
	public String getChangePassword(@RequestParam(required = false) final String token, final Model model)
			throws CMSItemNotFoundException
	{
		if (StringUtils.isBlank(token))
		{
			return REDIRECT_HOME;
		}

		if (Boolean.TRUE.equals(b2bCustomerFacade.isTokenExpired(token)))
		{
			storeCmsPageInModel(model, getContentPageForLabelOrId(UPDATE_PWD_EXPIRY_CMS_PAGE));
			setUpMetaDataForContentPage(model, getContentPageForLabelOrId(UPDATE_PWD_EXPIRY_CMS_PAGE));
			return ControllerConstants.Views.Pages.Password.PasswordResetExpiryPage;
		}

		final BrakesUpdatePwdForm form = new BrakesUpdatePwdForm();
		form.setToken(token);
		model.addAttribute(form);
		storeCmsPageInModel(model, getContentPageForLabelOrId(UPDATE_PWD_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(UPDATE_PWD_CMS_PAGE));
		model.addAttribute(WebConstants.BREADCRUMBS_KEY, resourceBreadcrumbBuilder.getBreadcrumbs("updatePwd.title"));
		return ControllerConstants.Views.Pages.Password.PasswordResetChangePage;
	}

	@RequestMapping(method = RequestMethod.POST)
	public String changePassword(@Valid final BrakesUpdatePwdForm form, final BindingResult bindingResult, final Model model,
			final RedirectAttributes redirectModel, final HttpServletRequest request, final HttpServletResponse response)
			throws CMSItemNotFoundException
	{
		getUpdatePasswordFormValidator().validate(form, bindingResult);
		if (bindingResult.hasErrors())
		{
			prepareErrorMessage(model, UPDATE_PWD_CMS_PAGE);
			return ControllerConstants.Views.Pages.Password.PasswordResetChangePage;
		}
		if (!StringUtils.isBlank(form.getToken()))
		{
			try
			{
				final String usename = b2bCustomerFacade.updatePasswordReturnUid(form.getToken(), form.getPwd());
				getAutoLoginStrategy().login(usename.toLowerCase(), form.getPwd(), request, response);
			}
			catch (final TokenInvalidatedException e)
			{
				//GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "updatePwd.token.invalidated");

				storeCmsPageInModel(model, getContentPageForLabelOrId(UPDATE_PWD_EXPIRY_CMS_PAGE));
				setUpMetaDataForContentPage(model, getContentPageForLabelOrId(UPDATE_PWD_EXPIRY_CMS_PAGE));
				return ControllerConstants.Views.Pages.Password.PasswordResetExpiryPage;
			}
			catch (final RuntimeException e)
			{
				if (LOG.isDebugEnabled())
				{
					LOG.debug(e);
				}
				//GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "updatePwd.token.invalid");

				storeCmsPageInModel(model, getContentPageForLabelOrId(UPDATE_PWD_EXPIRY_CMS_PAGE));
				setUpMetaDataForContentPage(model, getContentPageForLabelOrId(UPDATE_PWD_EXPIRY_CMS_PAGE));
				return ControllerConstants.Views.Pages.Password.PasswordResetExpiryPage;
			}
		}
		return REDIRECT_HOME;
	}

	/**
	 * Prepares the view to display an error message
	 *
	 * @throws CMSItemNotFoundException
	 */
	protected void prepareErrorMessage(final Model model, final String page) throws CMSItemNotFoundException
	{
		GlobalMessages.addErrorMessage(model, "form.global.error");
		storeCmsPageInModel(model, getContentPageForLabelOrId(page));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(page));
	}

	/**
	 * @return the resourceBreadcrumbBuilder
	 */
	public ResourceBreadcrumbBuilder getResourceBreadcrumbBuilder()
	{
		return resourceBreadcrumbBuilder;
	}

	/**
	 * @param resourceBreadcrumbBuilder
	 *           the resourceBreadcrumbBuilder to set
	 */
	public void setResourceBreadcrumbBuilder(final ResourceBreadcrumbBuilder resourceBreadcrumbBuilder)
	{
		this.resourceBreadcrumbBuilder = resourceBreadcrumbBuilder;
	}

	/**
	 * @return the updatePasswordFormValidator
	 */
	public BrakesUpdatePasswordFormValidator getUpdatePasswordFormValidator()
	{
		return updatePasswordFormValidator;
	}

	/**
	 * @param updatePasswordFormValidator
	 *           the updatePasswordFormValidator to set
	 */
	public void setUpdatePasswordFormValidator(final BrakesUpdatePasswordFormValidator updatePasswordFormValidator)
	{
		this.updatePasswordFormValidator = updatePasswordFormValidator;
	}

	/**
	 * @return the b2bCustomerFacade
	 */
	public BrakesB2BCustomerFacade getB2bCustomerFacade()
	{
		return b2bCustomerFacade;
	}

	/**
	 * @param b2bCustomerFacade
	 *           the b2bCustomerFacade to set
	 */
	public void setB2bCustomerFacade(final BrakesB2BCustomerFacade b2bCustomerFacade)
	{
		this.b2bCustomerFacade = b2bCustomerFacade;
	}

	/**
	 * @return the autoLoginStrategy
	 */
	public AutoLoginStrategy getAutoLoginStrategy()
	{
		return autoLoginStrategy;
	}

	/**
	 * @param autoLoginStrategy
	 *           the autoLoginStrategy to set
	 */
	public void setAutoLoginStrategy(final AutoLoginStrategy autoLoginStrategy)
	{
		this.autoLoginStrategy = autoLoginStrategy;
	}


}
