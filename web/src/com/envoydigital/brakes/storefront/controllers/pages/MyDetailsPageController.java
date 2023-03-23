package com.envoydigital.brakes.storefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.ResourceBreadcrumbBuilder;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractSearchPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.acceleratorstorefrontcommons.forms.VoucherForm;
import de.hybris.platform.b2bacceleratorfacades.customer.exception.InvalidPasswordException;
import de.hybris.platform.b2bcommercefacades.company.data.B2BUnitData;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commercefacades.user.data.CustomerData;
import de.hybris.platform.commercefacades.user.exceptions.PasswordMismatchException;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.envoydigital.brakes.facades.BrakesB2BUnitFacade;
import com.envoydigital.brakes.facades.coupons.BrakesCouponFacade;
import com.envoydigital.brakes.facades.payment.BrakesPaymentFacade;
import com.envoydigital.brakes.facades.user.BrakesB2BCustomerFacade;
import com.envoydigital.brakes.storefront.forms.BrakesUpdateProfileForm;
import com.envoydigital.brakes.storefront.forms.PaymentForm;
import com.envoydigital.brakes.storefront.forms.validation.BrakesUpdateProfileValidator;

import java.util.Collections;
import java.util.Comparator;
import java.util.Optional;


/**
 * Controller for My Details page
 *
 */
@Controller
@RequestMapping(value =
{ "/**/mydetails", "/**/my-details", "/Mybrakes-myaccount" })
public class MyDetailsPageController extends AbstractSearchPageController
{
	private static final Logger LOG = Logger.getLogger(MyDetailsPageController.class);
	private static final String UPDATE_PROFILE_CMS_PAGE = "update-profile";
	private static final String TEXT_ACCOUNT_PROFILE = "text.account.profile";
	private static final String BREADCRUMBS_ATTR = "breadcrumbs";
	private static final String REDIRECT_TO_UPDATE_PROFILE = REDIRECT_PREFIX + "/mybrakes/mydetails";
	private static final String REDIRECT_TO_UPDATE_PROFILE_CC = REDIRECT_PREFIX + "/mycountrychoice/mydetails";
	private static final String PROFILE_CURRENT_PASSWORD_INVALID = "profile.currentPassword.invalid";
	private static final String PROFILE_PASSWORD_NOT_MATCHED = "text.account.profile.passwordlNotMatched";
	private static final String PROFILE_NEW_PASSWORD_NOT_VALID = "error.invalid.newPassword";
	private static final String PROFILE_NEW_PASSWORD_INVALID = "profile.newPassword.invalid";
	private static final String PROFILE_EMAIL_UPADTED = "text.account.profile.emailUpdated";
	private static final String PROFILE_EMAIL_EXISTS = "text.account.profile.emailExists";
	private static final String PROFILE_CURRENT_EMAIL_INVALID = "profile.currentEmail.invalid";

	private static final String FORM_GLOBAL_ERROR = "form.global.error";
	private static final String PROFILE_ACCOUNT_UPDATED = "text.account.name.updated";

	@Resource(name = "brakesUpdateProfileValidator")
	private BrakesUpdateProfileValidator brakesUpdateProfileValidator;


	@Resource(name = "b2bCustomerFacade")
	private BrakesB2BCustomerFacade brakesB2BCustomerFacade;

	@Resource(name = "accountBreadcrumbBuilder")
	private ResourceBreadcrumbBuilder accountBreadcrumbBuilder;

	@Resource(name = "brakesPaymentFacade")
	private BrakesPaymentFacade brakesPaymentFacade;

	@Resource(name = "brakesB2BUnitFacade")
	private BrakesB2BUnitFacade brakesB2BUnitFacade;

	@Resource(name = "voucherFacade")
	private BrakesCouponFacade brakesCouponFacade;

	@RequestMapping(method = RequestMethod.GET)
	@RequireHardLogIn
	public String editProfile(final Model model) throws CMSItemNotFoundException
	{
		final CustomerData customerData = brakesB2BCustomerFacade.getCurrentCustomer();
		final BrakesUpdateProfileForm updateProfileForm = new BrakesUpdateProfileForm();
		updateProfileForm.setEmail(customerData.getEmail());
		model.addAttribute("updateProfileForm", updateProfileForm);
		storeCmsPageInModel(model, getContentPageForLabelOrId(UPDATE_PROFILE_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(UPDATE_PROFILE_CMS_PAGE));
		setUpPaymentData(model);
		setUpCouponData(model);
		model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(TEXT_ACCOUNT_PROFILE));
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
		model.addAttribute("customerData", customerData);
		return getViewForPage(model);
	}



	@RequestMapping(method = RequestMethod.POST)
	@RequireHardLogIn
	public String updateProfile(final BrakesUpdateProfileForm updateProfileForm, final BindingResult bindingResult,
			final Model model, final RedirectAttributes redirectAttributes) throws CMSItemNotFoundException
	{
		getBrakesUpdateProfileValidator().validate(updateProfileForm, bindingResult);

		String returnAction = REDIRECT_TO_UPDATE_PROFILE;

		if (getBaseSiteService().getCurrentBaseSite().getUid().equals("countryChoice"))
		{
			returnAction = REDIRECT_TO_UPDATE_PROFILE_CC;
		}

		storeCmsPageInModel(model, getContentPageForLabelOrId(UPDATE_PROFILE_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(UPDATE_PROFILE_CMS_PAGE));
		if (bindingResult.hasErrors())
		{
			setUpPaymentData(model);
			setUpCouponData(model);
			model.addAttribute("updateProfileForm", updateProfileForm);
			returnAction = setErrorMessagesAndCMSPage(model, UPDATE_PROFILE_CMS_PAGE, FORM_GLOBAL_ERROR);
		}
		else
		{
			if (StringUtils.isNotEmpty(updateProfileForm.getCurrentPassword())
					&& StringUtils.isNotEmpty(updateProfileForm.getNewPassword()))
			{
				try
				{
					brakesB2BCustomerFacade.changePassword(updateProfileForm.getCurrentPassword(), updateProfileForm.getNewPassword());
					GlobalMessages.addFlashMessage(redirectAttributes, GlobalMessages.CONF_MESSAGES_HOLDER,
							"text.account.profile.passwordlUpdated", null);
				}
				catch (final PasswordMismatchException | InvalidPasswordException localException)
				{
					model.addAttribute("updateProfileForm", updateProfileForm);


					if (localException instanceof PasswordMismatchException)
					{
						returnAction = setErrorMessagesAndCMSPage(model, UPDATE_PROFILE_CMS_PAGE, PROFILE_PASSWORD_NOT_MATCHED);
						bindingResult.rejectValue("currentPassword", PROFILE_CURRENT_PASSWORD_INVALID, new Object[] {},
								PROFILE_CURRENT_PASSWORD_INVALID);
					}

					if (localException instanceof InvalidPasswordException)
					{
						returnAction = setErrorMessagesAndCMSPage(model, UPDATE_PROFILE_CMS_PAGE, PROFILE_NEW_PASSWORD_NOT_VALID);
						bindingResult.rejectValue("currentPassword", PROFILE_NEW_PASSWORD_INVALID, new Object[] {},
								PROFILE_NEW_PASSWORD_INVALID);
					}
				}
			} else if(StringUtils.isNotEmpty(updateProfileForm.getAccountName()) && StringUtils.isNotEmpty(updateProfileForm.getSelectedAccountCode())) {
				if(brakesB2BUnitFacade.updateAccount(updateProfileForm.getSelectedAccountCode(), updateProfileForm.getAccountName())) {
					final Optional<B2BUnitData> anyB2bUnit = brakesB2BUnitFacade.getAssignedB2BUnits().stream()
							.filter(b2bUnit -> b2bUnit.getCode().equals(updateProfileForm.getSelectedAccountCode().trim())).findAny();
					redirectAttributes.addFlashAttribute("accountUpdated", anyB2bUnit.get());
				}
				
			}
			else
			{
				if (brakesB2BCustomerFacade.emailExists(updateProfileForm.getEmail()))
				{
					model.addAttribute("updateProfileForm", updateProfileForm);
					returnAction = setErrorMessagesAndCMSPage(model, UPDATE_PROFILE_CMS_PAGE, PROFILE_EMAIL_EXISTS);
					bindingResult.rejectValue("currentPassword", PROFILE_CURRENT_EMAIL_INVALID, new Object[] {},
							PROFILE_CURRENT_EMAIL_INVALID);
				}
				else
				{

					brakesB2BCustomerFacade.updateCustomerEmail(updateProfileForm.getEmail());
					GlobalMessages.addFlashMessage(redirectAttributes, GlobalMessages.CONF_MESSAGES_HOLDER, PROFILE_EMAIL_UPADTED,
							null);
				}
			}

		}

		setUpPaymentData(model);
		setUpCouponData(model);
		model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(TEXT_ACCOUNT_PROFILE));
		return returnAction;
	}

	protected String setErrorMessagesAndCMSPage(final Model model, final String cmsPageLabelOrId, final String errorMessageCode)
			throws CMSItemNotFoundException
	{
		final CustomerData customerData = brakesB2BCustomerFacade.getCurrentCustomer();
		model.addAttribute("customerData", customerData);
		GlobalMessages.addErrorMessage(model, errorMessageCode);
		storeCmsPageInModel(model, getContentPageForLabelOrId(cmsPageLabelOrId));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(cmsPageLabelOrId));
		model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(TEXT_ACCOUNT_PROFILE));
		return getViewForPage(model);
	}


	protected void setUpPaymentData(final Model model)
	{
		String selectedAccount = (String) model.asMap().get("selectedAccount");
		final PaymentForm paymentForm = new PaymentForm();
		final boolean addToAllAccount = Boolean.TRUE.equals(model.asMap().get("addToAllAccount"));
		if (addToAllAccount) {
			selectedAccount = Collections.min(brakesB2BUnitFacade.getPaymentEnabledB2BUnits(), new Comparator<B2BUnitData>() {
				@Override
				public int compare(B2BUnitData b2bUnit1, B2BUnitData b2bUnit2) {
					if (!StringUtils.isNumeric(b2bUnit1.getCode()) || !StringUtils.isNumeric(b2bUnit2.getCode())) {
						return 0;
					}
					return Integer.parseInt(b2bUnit1.getCode()) - Integer.parseInt(b2bUnit2.getCode());
				}
			}).getCode();
		} else {
			selectedAccount = StringUtils.isEmpty(selectedAccount) ? brakesB2BUnitFacade.getCurrentB2BUnit().getCode()
					: selectedAccount;
		}
		paymentForm.setSelectedAccount(selectedAccount);
		model.addAttribute("paymentForm", paymentForm);
		final boolean isPaymentEnabled = brakesPaymentFacade.isPaymentEnabled();
		model.addAttribute("isPaymentEnabled", isPaymentEnabled);
		if (isPaymentEnabled)
		{
			model.addAttribute("paymentCardStatus", brakesPaymentFacade.getPaymentCardStatus(false));
		}
		model.addAttribute("paymentInfoData", brakesPaymentFacade.getPaymentInfoForAccount(selectedAccount));
		model.addAttribute("b2bUnits", brakesB2BUnitFacade.getPaymentEnabledB2BUnits());
		model.addAttribute("assignedUnits", brakesB2BUnitFacade.getAssignedB2BUnits());
	}

	protected void setUpCouponData(final Model model)
	{
		final boolean couponEnabled = brakesCouponFacade.couponEnabledForCurrentAccount();
		if (couponEnabled)
		{
			model.addAttribute("vouchers", brakesCouponFacade.getCouponsForCurrentAccount());
			model.addAttribute("voucherForm", new VoucherForm());
		}
		model.addAttribute("couponEnabled", couponEnabled);
	}

	/**
	 * @return the brakesUpdateProfileValidator
	 */
	public BrakesUpdateProfileValidator getBrakesUpdateProfileValidator()
	{
		return brakesUpdateProfileValidator;
	}


	/**
	 * @param brakesUpdateProfileValidator
	 *           the brakesUpdateProfileValidator to set
	 */
	public void setBrakesUpdateProfileValidator(final BrakesUpdateProfileValidator brakesUpdateProfileValidator)
	{
		this.brakesUpdateProfileValidator = brakesUpdateProfileValidator;
	}

}
