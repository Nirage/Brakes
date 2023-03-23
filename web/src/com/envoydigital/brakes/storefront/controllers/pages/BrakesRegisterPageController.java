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

import com.envoydigital.brakes.core.enums.RegistrationStep;
import com.envoydigital.brakes.facades.site.BrakesSiteFacade;
import com.envoydigital.brakes.storefront.populators.CustomerRegisterFormPopulator;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.Breadcrumb;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractRegisterPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.acceleratorstorefrontcommons.forms.GuestForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.LoginForm;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.AbstractPageModel;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import de.hybris.platform.commercefacades.user.data.CompanyData;
import de.hybris.platform.commercefacades.user.data.RegisterData;
import de.hybris.platform.commerceservices.customer.DuplicateUidException;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import de.hybris.platform.core.HybrisEnumValue;
import de.hybris.platform.enumeration.EnumerationService;
import de.hybris.platform.servicelayer.exceptions.ModelNotFoundException;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Validator;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.WebUtils;

import com.envoydigital.brakes.facades.BrakesCompanyFacade;
import com.envoydigital.brakes.facades.BrakesCustomerFacade;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.RegisterForm;


/**
 * Register Controller for mobile. Handles login and register for the account flow.
 */
@Controller
public class BrakesRegisterPageController extends AbstractRegisterPageController
{
	private static final Logger LOG = LoggerFactory.getLogger(BrakesRegisterPageController.class);
	private static final String FORM_GLOBAL_ERROR = "form.global.error";
	private static final String CUSTOMER_REGISTER_CONFIRM_CMS_PAGE = "newcustomerregister-confirm";
	private static final String REPLACE_CHAR_DELIVERY_RESTRICTIONS = "\r\n";
	private static final String REDIRECT_HOME = "redirect:/";
	private static final String STEP_URL_COMPANY_DETAILS = "/become-a-customer-register/company-details";
	private static final String STEP_URL_ABOUT_YOUR_BUSINESS = "/become-a-customer-register/about-your-business";
	private static final String STEP_URL_ABOUT_YOU =  "/become-a-customer-register/about-you";
	private static final String STEP_URL_SUBMIT =  "/become-a-customer-register/submit";
	private static final String SESSION_ATTRIBUTE_REGISTRATION_FORM = "registrationFrom";
	private static final String SESSION_ATTRIBUTE_MEET_THE_CRITERIA = "meetTheCriteria";
	private static final String SESSION_ATTRIBUTE_LAST_COMPLETED_STEPS =  "lastCompletedSteps";
	private static final String REG_FORM_DATE_FORMAT = "dd/mm/yyyy";
	private static final String ANNUAL_STORE_TURN_OVERS = "annualStoreTurnOvers";

	private static final Map<String, String> REGISTER_STEP_REDIRECT_MAP;
	static  {
		REGISTER_STEP_REDIRECT_MAP = new HashMap<>();
		REGISTER_STEP_REDIRECT_MAP.put("STEP_ONE", STEP_URL_COMPANY_DETAILS);
		REGISTER_STEP_REDIRECT_MAP.put("STEP_TWO", STEP_URL_ABOUT_YOUR_BUSINESS);
		REGISTER_STEP_REDIRECT_MAP.put("STEP_THREE", STEP_URL_ABOUT_YOU);
		REGISTER_STEP_REDIRECT_MAP.put("STEP_FOUR", STEP_URL_SUBMIT);
	}

	private HttpSessionRequestCache httpSessionRequestCache;

	@Resource(name = "brakesCompanyFacade")
	private BrakesCompanyFacade brakesCompanyFacade;

	@Resource(name = "brakesCustomerFacade")
	private BrakesCustomerFacade brakesCustomerFacade;

	@Resource(name = "brakesRegistrationValidator")
	private Validator registrationValidator;

    @Resource(name = "brakesRegCompanyDetailsValidator")
    private Validator brakesRegCompanyDetailsValidator;

    @Resource(name = "brakesRegisterRetargetFormValidator")
	private Validator brakesRegisterRetargetFormValidator;

	@Resource(name = "brakesRegAboutYourBusinessValidator")
	private Validator brakesRegAboutYourBusinessValidator;

	@Resource(name = "brakesRegAboutYouValidator")
	private Validator brakesRegAboutYouValidator;

	@ModelAttribute("companyTypes")
	public List<CompanyData> getCompanyTypes()
	{
		return brakesCompanyFacade.getCompanyTypes();
	}

	@Resource(name = "enumerationService")
	private EnumerationService enumerationService;

	@Resource(name = "customerRegisterFormPopulator")
	private CustomerRegisterFormPopulator customerRegisterFormPopulator;

	@Resource
	private BrakesSiteFacade brakesSiteFacade;

	@Override
	protected AbstractPageModel getCmsPage() throws CMSItemNotFoundException
	{
		return getContentPageForLabelOrId("register");
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
	protected String getView()
	{
		return ControllerConstants.Views.Pages.Account.AccountMultiStepRegPage;
	}

	@Resource(name = "httpSessionRequestCache")
	public void setHttpSessionRequestCache(final HttpSessionRequestCache accHttpSessionRequestCache)
	{
		this.httpSessionRequestCache = accHttpSessionRequestCache;
	}

	@RequestMapping(value = "/become-a-customer-register", method = RequestMethod.GET)
	public String doRegister() throws CMSItemNotFoundException
	{

		return REDIRECT_PREFIX + "/become-a-customer-eligible";
	}

	@RequestMapping(value = "/become-a-customer-register", method = RequestMethod.POST)
	public String checkEligibility(final Model model) throws CMSItemNotFoundException
	{
		return getDefaultRegistrationPage(model);
	}

	@Override
	protected String getDefaultRegistrationPage(final Model model) throws CMSItemNotFoundException
	{
		storeCmsPageInModel(model, getCmsPage());
		setUpMetaDataForContentPage(model, (ContentPageModel) getCmsPage());
		final Breadcrumb loginBreadcrumbEntry = new Breadcrumb("#",
				getMessageSource().getMessage("header.link.login", null, getI18nService().getCurrentLocale()), null);
		model.addAttribute("breadcrumbs", Collections.singletonList(loginBreadcrumbEntry));
		model.addAttribute("sectors", brakesCompanyFacade.getSectors());
		model.addAttribute("budgets", brakesCompanyFacade.getMonthlyBudgets());
		model.addAttribute("companyTypes", brakesCompanyFacade.getCompanyTypes());
		model.addAttribute("leadSources", brakesCompanyFacade.getLeadSources());
		model.addAttribute(new RegisterForm());
		return getView();
	}

	@RequestMapping(value = STEP_URL_SUBMIT, method = RequestMethod.POST)
	public String doRegister(final RegisterForm form, final BindingResult bindingResult, final Model model,
			final HttpServletRequest request, final RedirectAttributes redirectModel)
			throws CMSItemNotFoundException
	{
        return processRegisterUserRequest(form, bindingResult, model, request, redirectModel);
	}

	@PostMapping(value = "/customer-register-retarget/submit")
	@ResponseBody
	public ResponseEntity<String> doSaveForRetarget(final RegisterForm form, final BindingResult bindingResult, final Model model,
								final HttpServletRequest request, final RedirectAttributes redirectModel)
			throws CMSItemNotFoundException
	{
		processRegisterUserRetargetRequest(form, bindingResult, model, request, redirectModel);
		return new ResponseEntity(HttpStatus.OK);
	}


	@PostMapping(value = "/customer-register-save-and-exit/submit")
	public String doSaveAndExit(final RegisterForm form, final BindingResult bindingResult, final Model model,
							 final HttpServletRequest request, final RedirectAttributes redirectModel)
			throws CMSItemNotFoundException
	{
		return processRegisterUserSaveAndExitRequest(form, bindingResult, model, request, redirectModel);
	}

	private void processRegisterUserRetargetRequest(RegisterForm form, BindingResult bindingResult, Model model, HttpServletRequest request, final RedirectAttributes redirectModel) throws CMSItemNotFoundException {
		brakesRegisterRetargetFormValidator.validate(form, bindingResult);
		if(!bindingResult.hasErrors()) {
			final RegisterData data = new RegisterData();
			populateRegisterData(form, data, request);
			try {
				brakesCustomerFacade.registerSaveForRetarget(data);

			} catch (IllegalArgumentException ex) {
				GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
						"registration.error.account.email.empty");
			}
		}
	}

	private String processRegisterUserSaveAndExitRequest(RegisterForm form, BindingResult bindingResult, Model model, HttpServletRequest request, final RedirectAttributes redirectModel) throws CMSItemNotFoundException {
		if(form.getStep().equals(RegistrationStep.STEP_ONE.getCode())) {
			 processRegisterUserRequestStepOne(form, bindingResult,model, true);
		}

		if(form.getStep().equals(RegistrationStep.STEP_TWO.getCode())) {
			 processRegisterUserRequestStepTwo(form, bindingResult,model, true);
		}

		if(form.getStep().equals(RegistrationStep.STEP_THREE.getCode())) {
			processRegisterUserRequestStepThree(form, bindingResult,model, true);
		}


		if(null !=  getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM)) {
			//Just use form instead of sessionRegForm, if need to fallback to previous registration
			RegisterForm sessionRegForm = updateStepFourDataInSessionForm(form);
			sessionRegForm.setStep(form.getStep());

			final RegisterData data = new RegisterData();
			populateRegisterData(sessionRegForm, data, request);

			try {

				brakesCustomerFacade.registerSaveAndExit(data);

			}catch (IllegalArgumentException  ex) {
				GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
						"registration.error.account.email.empty");
				return REDIRECT_PREFIX + STEP_URL_COMPANY_DETAILS;
			}

			getSessionService().removeAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM);
			getSessionService().removeAttribute(SESSION_ATTRIBUTE_MEET_THE_CRITERIA);
			getSessionService().removeAttribute(SESSION_ATTRIBUTE_LAST_COMPLETED_STEPS);
		}

		return REDIRECT_HOME;
	}

	private RegisterForm updateStepFourDataInSessionForm(RegisterForm form) {
		RegisterForm sessionRegForm = getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM);
		sessionRegForm.setTermsCheck(form.getTermsCheck());
		sessionRegForm.setPrivacyPolicy(form.getPrivacyPolicy());

		return sessionRegForm;
	}

	private void populateRegisterData(final RegisterForm sessionRegForm, final RegisterData data, HttpServletRequest request) {
		data.setFirstName(sessionRegForm.getFirstName());
		data.setLastName(sessionRegForm.getLastName());
		data.setTitleCode(sessionRegForm.getTitle());
		data.setEmail(sessionRegForm.getEmail());
		data.setMobileNumber(sessionRegForm.getMobileNumber());
		data.setJobTitle(sessionRegForm.getJobTitle());
		data.setTradingName(sessionRegForm.getTradingName());
		data.setBudget(sessionRegForm.getBudget());
		data.setSector(sessionRegForm.getSector());
		data.setSubSector(sessionRegForm.getSubSector());
		if (StringUtils.isNotEmpty(sessionRegForm.getDeliveryRestrictions()))
		{
			data.setDeliveryRestrictions(sessionRegForm.getDeliveryRestrictions().replace(REPLACE_CHAR_DELIVERY_RESTRICTIONS, " "));
		}
		data.setPostCode(sessionRegForm.getPostCode());
		data.setLine1(sessionRegForm.getLine1());
		data.setLine2(sessionRegForm.getLine2());
		data.setLine3(sessionRegForm.getLine3());
		data.setCity(sessionRegForm.getCity());
		data.setCounty(sessionRegForm.getCounty());
		data.setCompanyType(sessionRegForm.getCompanyType());
		data.setCompanyRegNumber(sessionRegForm.getCompanyRegNumber());
		data.setCompanyRegName(sessionRegForm.getCompanyRegName());
		data.setCompanyPhoneNumber(sessionRegForm.getPhoneNumber());
		data.setLegalOwner(sessionRegForm.isLegalOwner());
		data.setBusinessGroup(sessionRegForm.isBusinessGroup());
		data.setLegalOwnerName(sessionRegForm.getLegalOwnerName());
		data.setBusinessGroupName(sessionRegForm.getBusinessGroupName());
		data.setMarketingPreference(sessionRegForm.getMarketingPreference() != null ? sessionRegForm.getMarketingPreference().booleanValue() : false);
		data.setLeadSource(sessionRegForm.getLeadSource());
		data.setLeadSourceText(sessionRegForm.getLeadSourceText());
		data.setLeadReason(StringUtils.isNotEmpty(sessionRegForm.getLeadReason()) ? sessionRegForm.getLeadReason().replaceAll("[\\t\\n\\r]+", " ")
				: StringUtils.EMPTY);
		data.setPreviousSupplier(StringUtils.isNotEmpty(sessionRegForm.getPreviousSupplier()) ? sessionRegForm.getPreviousSupplier().replaceAll("[\\t\\n\\r]+", " ")
				: StringUtils.EMPTY);
		data.setBusinessPostCode(sessionRegForm.getBusinessPostCode());
        data.setBusinessLine1(sessionRegForm.getBusinessLine1());
        data.setBusinessLine2(sessionRegForm.getBusinessLine2());
        data.setBusinessLine3(sessionRegForm.getBusinessLine3());
		data.setBusinessCity(sessionRegForm.getBusinessCity());
		data.setBusinessCounty(sessionRegForm.getBusinessCounty());
        data.setBusinessAddressDifferent(sessionRegForm.getBusinessAddressDifferent() != null? sessionRegForm.getBusinessAddressDifferent().booleanValue() : false);
		data.setBusinessTelephoneNumber(sessionRegForm.getBusinessTelephoneNumber());

		if(StringUtils.isNotEmpty(sessionRegForm.getDateEstablished())) {
			try {
				Date establishedDate = new SimpleDateFormat(REG_FORM_DATE_FORMAT).parse(sessionRegForm.getDateEstablished());
				data.setDateEstablished(establishedDate);
			} catch (ParseException e) {
				LOG.info(e.getMessage());
			}
		}

		if(StringUtils.isNotEmpty(sessionRegForm.getNumberOfFullTimeEmployees()))
		{
			try {
				long numberOfFullTimeEmployees = Long.parseLong(sessionRegForm.getNumberOfFullTimeEmployees());
				data.setNumberOfFullTimeEmployees(numberOfFullTimeEmployees);
			}catch (NumberFormatException e) {
				LOG.info(e.getMessage());
			}
		}

		if(StringUtils.isNotEmpty(sessionRegForm.getAnnualStoreTurnover())) {
			data.setAnnualStoreTurnover(sessionRegForm.getAnnualStoreTurnover());
		}

		setGAVariables(data, request);
		data.setTermsCheck(sessionRegForm.getTermsCheck() != null?sessionRegForm.getTermsCheck().booleanValue() : false);
		data.setPrivacyPolicy(sessionRegForm.getPrivacyPolicy() != null?sessionRegForm.getPrivacyPolicy().booleanValue() : false);
		data.setStep(sessionRegForm.getStep());

	}

	private void updateLastCompletedSteps(String stepCode)
	{
		final List<String> lastCompletedSteps = new ArrayList<>();
		if(null !=  getSessionService().getAttribute(SESSION_ATTRIBUTE_LAST_COMPLETED_STEPS)) {
			((List<String>) getSessionService().getAttribute(SESSION_ATTRIBUTE_LAST_COMPLETED_STEPS)).forEach(lastCompletedStep -> lastCompletedSteps.add(lastCompletedStep));
		}
		lastCompletedSteps.add(stepCode);
		getSessionService().setAttribute(SESSION_ATTRIBUTE_LAST_COMPLETED_STEPS, lastCompletedSteps);
	}

	protected String processRegisterUserRequest(final RegisterForm form, final BindingResult bindingResult,
			final Model model, final HttpServletRequest request,
			final RedirectAttributes redirectModel) throws CMSItemNotFoundException // NOSONAR
	{
		if(form.getStep().equals(RegistrationStep.STEP_ONE.getCode())) {
			return processRegisterUserRequestStepOne(form, bindingResult,model, false);
		}

		if(form.getStep().equals(RegistrationStep.STEP_TWO.getCode())) {
			return processRegisterUserRequestStepTwo(form, bindingResult,model, false);
		}

		if(form.getStep().equals(RegistrationStep.STEP_THREE.getCode())) {
			return processRegisterUserRequestStepThree(form, bindingResult,model, false);
		}

		if(null !=  getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM) && form.getStep().equals(RegistrationStep.STEP_FOUR.getCode())) {
            //Just use form instead of sessionRegForm, if need to fallback to previous registration
			RegisterForm sessionRegForm = updateStepFourDataInSessionForm(form);
			registrationValidator.validate(sessionRegForm, bindingResult);
			if (bindingResult.hasErrors())
			{
				model.addAttribute(sessionRegForm);
				model.addAttribute("sectors", brakesCompanyFacade.getSectors());
				model.addAttribute("budgets", brakesCompanyFacade.getMonthlyBudgets());
				model.addAttribute("companyTypes", brakesCompanyFacade.getCompanyTypes());
				model.addAttribute("leadSources", brakesCompanyFacade.getLeadSources());
				model.addAttribute("step", RegistrationStep.STEP_FOUR.getCode());
				model.addAttribute("previousStepUrl", STEP_URL_ABOUT_YOU);
				GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
				return handleRegistrationError(model);
			}
			final RegisterData data = new RegisterData();
			populateRegisterData(sessionRegForm, data, request);
			try
			{
				brakesCustomerFacade.register(data);

			}
			catch (final DuplicateUidException e)
			{
				model.addAttribute(sessionRegForm);
				model.addAttribute(new LoginForm());
				model.addAttribute(new GuestForm());
				bindingResult.rejectValue("email", "registration.error.account.exists.title");
				GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
				return handleRegistrationError(model);
			}

			getSessionService().removeAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM);
			getSessionService().removeAttribute(SESSION_ATTRIBUTE_MEET_THE_CRITERIA);
			getSessionService().removeAttribute(SESSION_ATTRIBUTE_LAST_COMPLETED_STEPS);
			redirectModel.addFlashAttribute("isValid", Boolean.TRUE);

			return REDIRECT_PREFIX + "/become-a-customer-confirmation";
		}

		return REDIRECT_PREFIX + "/become-a-customer-eligible";
	}

	protected String processRegisterUserRequestStepOne(final RegisterForm form, final BindingResult bindingResult,
												final Model model, final boolean isSaveAndExit) throws CMSItemNotFoundException // NOSONAR
	{
		if(brakesSiteFacade.isBrakesSite())
		{
			forwardForBrakes();
		}

		RegisterForm sessionRegForm = null;
		if(null !=  getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM)) {
			sessionRegForm = getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM);
			sessionRegForm.setCompanyType(form.getCompanyType());
			sessionRegForm.setCompanyRegNumber(form.getCompanyRegNumber());
			sessionRegForm.setCompanyRegName(form.getCompanyRegName());
			sessionRegForm.setPhoneNumber(form.getPhoneNumber());
			sessionRegForm.setLegalOwner(form.isLegalOwner());
			sessionRegForm.setBusinessGroup(form.isBusinessGroup());
			sessionRegForm.setLegalOwnerName(form.getLegalOwnerName());
			sessionRegForm.setBusinessGroupName(form.getBusinessGroupName());
			sessionRegForm.setEmail(form.getEmail());
			sessionRegForm.setConfirmEmail(form.getConfirmEmail());
			sessionRegForm.setMarketingPreference(form.getMarketingPreference());

		}else {

			getSessionService().setAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM, form);
			sessionRegForm = form;
		}

		if(!isSaveAndExit) {
			brakesRegCompanyDetailsValidator.validate(sessionRegForm, bindingResult);
			if (bindingResult.hasErrors()) {
				model.addAttribute(sessionRegForm);
				model.addAttribute("companyTypes", brakesCompanyFacade.getCompanyTypes());
				model.addAttribute("step", RegistrationStep.STEP_ONE.getCode());
				GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
				return handleRegistrationError(model);
			}
		}
		updateLastCompletedSteps(RegistrationStep.STEP_ONE.getCode());
		return REDIRECT_PREFIX + STEP_URL_ABOUT_YOUR_BUSINESS;
	}

	protected String processRegisterUserRequestStepTwo(final RegisterForm form, final BindingResult bindingResult,
													   final Model model, final boolean isSaveAndExit) throws CMSItemNotFoundException // NOSONAR
	{
		if(brakesSiteFacade.isBrakesSite())
		{
			forwardForBrakes();
		}
		RegisterForm sessionRegForm = null;
		if(null !=  getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM)) {
			sessionRegForm = getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM);
			sessionRegForm.setTradingName(form.getTradingName());
			sessionRegForm.setBudget(form.getBudget());
			sessionRegForm.setSector(form.getSector());
			sessionRegForm.setSubSector(form.getSubSector());
			sessionRegForm.setDeliveryRestrictions(form.getDeliveryRestrictions());
			sessionRegForm.setPostCode(form.getPostCode());
			sessionRegForm.setLine1(form.getLine1());
			sessionRegForm.setLine2(form.getLine2());
			sessionRegForm.setLine3(form.getLine3());
			sessionRegForm.setCity(form.getCity());
			sessionRegForm.setCounty(form.getCounty());
			sessionRegForm.setBusinessAddressDifferent(form.getBusinessAddressDifferent());
			sessionRegForm.setBusinessPostCode(form.getBusinessPostCode());
			sessionRegForm.setBusinessLine1(form.getBusinessLine1());
			sessionRegForm.setBusinessLine2(form.getBusinessLine2());
			sessionRegForm.setBusinessLine3(form.getBusinessLine3());
			sessionRegForm.setBusinessCity(form.getBusinessCity());
			sessionRegForm.setBusinessCounty(form.getBusinessCounty());
			sessionRegForm.setDateEstablished(form.getDateEstablished());
			sessionRegForm.setNumberOfFullTimeEmployees(form.getNumberOfFullTimeEmployees());
			sessionRegForm.setAnnualStoreTurnover(form.getAnnualStoreTurnover());

		}else {
			getSessionService().setAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM, form);
			sessionRegForm = form;
		}
		if(!isSaveAndExit) {
			brakesRegCompanyDetailsValidator.validate(sessionRegForm, bindingResult);
			brakesRegAboutYourBusinessValidator.validate(sessionRegForm, bindingResult);
			if (bindingResult.hasErrors()) {
				model.addAttribute(sessionRegForm);
				model.addAttribute("sectors", brakesCompanyFacade.getSectors());
				model.addAttribute("budgets", brakesCompanyFacade.getMonthlyBudgets());
				model.addAttribute("step", RegistrationStep.STEP_TWO.getCode());
				model.addAttribute("previousStepUrl", STEP_URL_COMPANY_DETAILS);
				model.addAttribute(ANNUAL_STORE_TURN_OVERS, brakesCompanyFacade.getAnnualStoreTurnOvers());
				GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
				return handleRegistrationError(model);
			}
		}

		updateLastCompletedSteps(RegistrationStep.STEP_TWO.getCode());
		return REDIRECT_PREFIX + STEP_URL_ABOUT_YOU;
	}


	protected String processRegisterUserRequestStepThree(final RegisterForm form, final BindingResult bindingResult,
													   final Model model, final boolean isSaveAndExit) throws CMSItemNotFoundException // NOSONAR
	{
		if(brakesSiteFacade.isBrakesSite())
		{
			forwardForBrakes();
		}
		RegisterForm sessionRegForm = null;
		if(null !=  getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM)) {
			sessionRegForm = getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM);
			sessionRegForm.setFirstName(form.getFirstName());
			sessionRegForm.setLastName(form.getLastName());
			sessionRegForm.setTitle(form.getTitle());
			sessionRegForm.setMobileNumber(form.getMobileNumber());
			sessionRegForm.setBusinessTelephoneNumber(form.getBusinessTelephoneNumber());
			sessionRegForm.setJobTitle(form.getJobTitle());
			sessionRegForm.setLeadReason(form.getLeadReason());
			sessionRegForm.setLeadSource(form.getLeadSource());
			sessionRegForm.setLeadSourceText(form.getLeadSourceText());
			sessionRegForm.setPreviousSupplier(form.getPreviousSupplier());
		}else {
			getSessionService().setAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM, form);
			sessionRegForm = form;
		}

		if(!isSaveAndExit) {
			brakesRegCompanyDetailsValidator.validate(sessionRegForm, bindingResult);
			brakesRegAboutYourBusinessValidator.validate(sessionRegForm, bindingResult);
			brakesRegAboutYouValidator.validate(sessionRegForm, bindingResult);
			if (bindingResult.hasErrors()) {
				model.addAttribute(sessionRegForm);
				model.addAttribute("leadSources", brakesCompanyFacade.getLeadSources());
				model.addAttribute("step", RegistrationStep.STEP_THREE.getCode());
				model.addAttribute("previousStepUrl", STEP_URL_ABOUT_YOUR_BUSINESS);
				GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
				return handleRegistrationError(model);
			}
		}

		updateLastCompletedSteps(RegistrationStep.STEP_THREE.getCode());
		return REDIRECT_PREFIX + STEP_URL_SUBMIT;
	}


	private String forwardForBrakes() {

		return FORWARD_PREFIX + "/404";
	}



	/**
	 * To set the GA variables that get from corresponding GA cookies
	 *
	 * @param data
	 * @param request
	 */
	private void setGAVariables(final RegisterData data, final HttpServletRequest request)
	{

		final Cookie lastTouchCookie = WebUtils.getCookie(request, ControllerConstants.Cookies.LAST_TOUCH_COOKIE);
		final Cookie acquisitionKeywordCookie = WebUtils.getCookie(request, ControllerConstants.Cookies.ACQUISITION_KEYWORD_COOKIE);

		if (null != lastTouchCookie && StringUtils.isNotEmpty(lastTouchCookie.getValue()))
		{
			LOG.info("Last touch cookie values" + lastTouchCookie.getValue());
			final String[] lastTouchCookieValues = lastTouchCookie.getValue().split("\\|");
			final String channel = lastTouchCookieValues[0].trim();
			final String source = (lastTouchCookieValues.length >= 2) ? lastTouchCookieValues[1].trim() : "";
			final String campaign = (lastTouchCookieValues.length >= 3) ? lastTouchCookieValues[2].trim() : "";
			data.setGaChannel(removeCharacter(channel));
			data.setGaSource(removeCharacter(source));
			data.setGaCampaign(removeCharacter(campaign));
		}

		if (null != acquisitionKeywordCookie && StringUtils.isNotEmpty(acquisitionKeywordCookie.getValue())
				&& !acquisitionKeywordCookie.getValue().trim().equals("(No Keyword)"))
		{

			data.setGaKeyword(acquisitionKeywordCookie.getValue());
		}
	}

	private String removeCharacter(final String input)
	{
		final String output = input.replaceAll("\\{", "");
		return output.replaceAll("\\}", "");
	}

	@RequestMapping(value = "/become-a-customer-confirmation", method = RequestMethod.GET)
	public String getRegisterConfirmation(final Model model) throws CMSItemNotFoundException
	{

		if (!Boolean.TRUE.equals(model.asMap().get("isValid")))
		{
			return REDIRECT_PREFIX + "/become-a-customer-eligible";
		}

		storeCmsPageInModel(model, getContentPageForLabelOrId(CUSTOMER_REGISTER_CONFIRM_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(CUSTOMER_REGISTER_CONFIRM_CMS_PAGE));
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
		return ControllerConstants.Views.Pages.Account.RegisterConfirmationPage;
	}



	@RequestMapping(value = STEP_URL_COMPANY_DETAILS, method = RequestMethod.POST)
	public String doRegisterStepOnePost() throws CMSItemNotFoundException
	{
		getSessionService().setAttribute(SESSION_ATTRIBUTE_MEET_THE_CRITERIA, Boolean.TRUE);

		return REDIRECT_PREFIX + STEP_URL_COMPANY_DETAILS;
	}

	@RequestMapping(value = STEP_URL_COMPANY_DETAILS, method = RequestMethod.GET)
	public String doRegisterStepOne(final Model model) throws CMSItemNotFoundException {
		if(Boolean.TRUE.equals(checkMeetTheCriteria())) {

			storeCmsPageInModel(model, getCmsPage());
			setUpMetaDataForContentPage(model, (ContentPageModel) getCmsPage());
			model.addAttribute("companyTypes", brakesCompanyFacade.getCompanyTypes());
			model.addAttribute("step", RegistrationStep.STEP_ONE.getCode());
			setRegFormToModel(model);
			return getView();
		}

		return REDIRECT_PREFIX + "/become-a-customer-eligible";
	}


    @RequestMapping(value = STEP_URL_ABOUT_YOUR_BUSINESS, method = RequestMethod.GET)
    public String doRegisterStepTwo(final Model model) throws CMSItemNotFoundException {

		if(Boolean.TRUE.equals(checkMeetTheCriteria())) {
            storeCmsPageInModel(model, getCmsPage());
            setUpMetaDataForContentPage(model, (ContentPageModel) getCmsPage());
            model.addAttribute("sectors", brakesCompanyFacade.getSectors());
            model.addAttribute("budgets", brakesCompanyFacade.getMonthlyBudgets());
            model.addAttribute("step", RegistrationStep.STEP_TWO.getCode());
			model.addAttribute(ANNUAL_STORE_TURN_OVERS, brakesCompanyFacade.getAnnualStoreTurnOvers());
			model.addAttribute("previousStepUrl", STEP_URL_COMPANY_DETAILS);
			setLastCompletedStep(model);
           	setRegFormToModel(model);
			if(!hasCompletedPreviousStep(RegistrationStep.STEP_TWO.getCode())) {

				return REDIRECT_PREFIX + STEP_URL_COMPANY_DETAILS;
			}
           	return getView();
        }

        return REDIRECT_PREFIX + "/become-a-customer-eligible";
    }

	@RequestMapping(value = STEP_URL_ABOUT_YOU, method = RequestMethod.GET)
	public String doRegisterStepThree(final Model model) throws CMSItemNotFoundException {

		if(Boolean.TRUE.equals(checkMeetTheCriteria())) {
			storeCmsPageInModel(model, getCmsPage());
			setUpMetaDataForContentPage(model, (ContentPageModel) getCmsPage());
			model.addAttribute("leadSources", brakesCompanyFacade.getLeadSources());
			model.addAttribute("step", RegistrationStep.STEP_THREE.getCode());
			model.addAttribute("previousStepUrl", STEP_URL_ABOUT_YOUR_BUSINESS);
			setLastCompletedStep(model);
			setRegFormToModel(model);
			if(!hasCompletedPreviousStep(RegistrationStep.STEP_THREE.getCode())) {

				return REDIRECT_PREFIX + STEP_URL_COMPANY_DETAILS;
			}
			return getView();
		}

		return REDIRECT_PREFIX + "/become-a-customer-eligible";
	}

	@RequestMapping(value = STEP_URL_SUBMIT, method = RequestMethod.GET)
	public String doRegisterStepFour(final Model model) throws CMSItemNotFoundException {

		if(brakesSiteFacade.isBrakesSite())
		{
			forwardForBrakes();
		}
		if(Boolean.TRUE.equals(checkMeetTheCriteria())) {
			storeCmsPageInModel(model, getCmsPage());
			setUpMetaDataForContentPage(model, (ContentPageModel) getCmsPage());
			model.addAttribute("step", RegistrationStep.STEP_FOUR.getCode());
			model.addAttribute("previousStepUrl", STEP_URL_ABOUT_YOU);
			setLastCompletedStep(model);
			setRegFormToModel(model);
			if(!hasCompletedPreviousStep(RegistrationStep.STEP_FOUR.getCode())) {

				return REDIRECT_PREFIX + STEP_URL_COMPANY_DETAILS;
			}
			return getView();
		}

		return REDIRECT_PREFIX + "/become-a-customer-eligible";
	}

	@RequestMapping(value = "/become-a-customer-save-and-exit-revisit", method = RequestMethod.GET)
	public String revisit(final RegisterForm form, final BindingResult bindingResult, final Model model,
						  final HttpServletRequest request, final RedirectAttributes redirectModel,
						  @RequestParam(value = "token") final String token)
			throws CMSItemNotFoundException
	{

		if (StringUtils.isBlank(token))
		{
			return REDIRECT_HOME;
		}

		if(brakesCustomerFacade.isTokenExpiredForSaveAndExit(token)) {
			return REDIRECT_PREFIX + "/become-a-customer-eligible";
		}

		try {

			RegisterData registerData = brakesCustomerFacade.getPartiallySavedRegisterData(token);
			RegisterForm savedDataForm = new RegisterForm();
			customerRegisterFormPopulator.populate(registerData, savedDataForm);
			getSessionService().setAttribute("meetTheCriteria", Boolean.TRUE);
			getSessionService().setAttribute("registrationFrom", savedDataForm);
			storeCmsPageInModel(model, getCmsPage());
			setUpMetaDataForContentPage(model, (ContentPageModel) getCmsPage());
			model.addAttribute("step", registerData.getStep());
			model.addAttribute("previousStepUrl", getPreviousStepUrl(registerData.getStep()));
			updateLastCompletedStepForRevisit(registerData.getStep());
            model.addAttribute("sectors", brakesCompanyFacade.getSectors());
            model.addAttribute("budgets", brakesCompanyFacade.getMonthlyBudgets());
            model.addAttribute("companyTypes", brakesCompanyFacade.getCompanyTypes());
            model.addAttribute("leadSources", brakesCompanyFacade.getLeadSources());
			model.addAttribute(ANNUAL_STORE_TURN_OVERS, brakesCompanyFacade.getAnnualStoreTurnOvers());
			setLastCompletedStep(model);
			setRegFormToModel(model);
			return getView();

		}catch (ModelNotFoundException ex) {

			return REDIRECT_HOME;
		}
	}

	private Boolean checkMeetTheCriteria() {
        return getSessionService().getAttribute(SESSION_ATTRIBUTE_MEET_THE_CRITERIA);
    }

    private void setRegFormToModel(final Model model) {
		if(null !=  getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM)) {
			model.addAttribute(getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM));
		}else {
			model.addAttribute(new RegisterForm());
		}
	}

	private void setLastCompletedStep(final Model model) {
		String lastCompletedStep = getSessionService().getAttribute("lastCompletedStep");
		model.addAttribute("lastCompletedStep", lastCompletedStep);
	}

	private boolean hasCompletedPreviousStep(String currentStep) {

		RegisterForm registrationForm = (RegisterForm) getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM);
		if(null != registrationForm && !currentStep.equals(RegistrationStep.STEP_ONE.getCode())) {
			final List<HybrisEnumValue> registrationSteps = enumerationService.getEnumerationValues("RegistrationStep");
			int currentStepIndex = registrationSteps.lastIndexOf(enumerationService.getEnumerationValue(RegistrationStep.class, currentStep));
			List<String> lastCompletedSteps = getSessionService().getAttribute(SESSION_ATTRIBUTE_LAST_COMPLETED_STEPS);
			if(null != lastCompletedSteps) {
				HybrisEnumValue previousStep = registrationSteps.get(currentStepIndex - 1);
				return  lastCompletedSteps.contains(previousStep.getCode());
			}else {
				return false;
			}

		}else {
			return false;
		}
	}

	private String getPreviousStepUrl(String currentStep) {
		final List<HybrisEnumValue> registrationSteps = enumerationService.getEnumerationValues("RegistrationStep");
		int currentStepIndex = registrationSteps.lastIndexOf(enumerationService.getEnumerationValue(RegistrationStep.class, currentStep));
		if(currentStepIndex != 0) {
			HybrisEnumValue previousStep = registrationSteps.get(currentStepIndex - 1);
			if(null != previousStep) {
				return REGISTER_STEP_REDIRECT_MAP.get(previousStep.getCode());
			}
		}
		return REGISTER_STEP_REDIRECT_MAP.get("STEP_ONE");
	}

	private void updateLastCompletedStepForRevisit(String currentStep) {

		final List<String> lastCompletedSteps = new ArrayList<>();
		final List<HybrisEnumValue> registrationSteps = enumerationService.getEnumerationValues("RegistrationStep");
		final int currentStepIndex = registrationSteps.lastIndexOf(enumerationService.getEnumerationValue(RegistrationStep.class, currentStep));
		registrationSteps.forEach(step -> {
			int stepIndex = registrationSteps.lastIndexOf(step);
			if(currentStepIndex != 0 &&  stepIndex < currentStepIndex) {
				lastCompletedSteps.add(step.getCode());
			}
		});
		getSessionService().setAttribute(SESSION_ATTRIBUTE_LAST_COMPLETED_STEPS, lastCompletedSteps);
	}
}
