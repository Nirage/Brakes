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
import com.envoydigital.brakes.core.model.BrakesCustomerSFRegistrationModel;
import com.envoydigital.brakes.facades.BrakesCompanyFacade;
import com.envoydigital.brakes.facades.BrakesCustomerFacade;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.RegisterForm;
import com.envoydigital.brakes.storefront.populators.CustomerRegisterFormPopulator;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractRegisterPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.acceleratorstorefrontcommons.forms.GuestForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.LoginForm;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.AbstractPageModel;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import de.hybris.platform.commercefacades.user.data.RegisterData;
import de.hybris.platform.commerceservices.customer.DuplicateUidException;
import de.hybris.platform.core.HybrisEnumValue;
import de.hybris.platform.enumeration.EnumerationService;
import de.hybris.platform.servicelayer.exceptions.ModelNotFoundException;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Validator;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.WebUtils;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * Register Controller . Handles login and register for the account flow.
 */
@Controller
public class SFRegisterPageController extends AbstractRegisterPageController {

	private static final String LOCAL_OTHER = "Local Other";
	private static final String REGIONAL_OTHER = "Regional Other";
	private static final String OTHER = "Other";
	private static final String NATIONAL_OTHER = "National Other";
	private static final String PREVIOUS_STEP_URL = "previousStepUrl";
	private static final String STEP = "step";
	private static final String CURRENT_SUPPLIERS = "currentSuppliers";
	private static final String BUDGETS = "budgets";
	private static final String SECTORS = "sectors";
	private static final String COMPANY_TYPES = "companyTypes";
	
	private static final String REPLACE_CHAR_DELIVERY_RESTRICTIONS = "\r\n";
    private static final String SESSION_ATTRIBUTE_MEET_THE_CRITERIA = "meetTheCriteria";
    private static final String SESSION_ATTRIBUTE_REGISTRATION_FORM = "registrationFrom";
    private static final String STEP_URL_COMPANY_DETAILS = "/brakes/become-a-customer-register/company-details";
    private static final String STEP_URL_ABOUT_YOUR_BUSINESS = "/brakes/become-a-customer-register/about-your-business";
    private static final String STEP_URL_SUBMIT = "/brakes/become-a-customer-register/submit";
    private static final String SESSION_ATTRIBUTE_LAST_COMPLETED_STEPS =  "lastCompletedSteps";
    private static final String ANNUAL_STORE_TURN_OVERS = "annualStoreTurnOvers";
    private static final String SEO_STEP_URL_COMPANY_DETAILS = "/become-a-customer-register/company-details";
    private static final String SEO_STEP_URL_ABOUT_YOUR_BUSINESS = "/become-a-customer-register/about-your-business";
    private static final String SEO_STEP_URL_SUBMIT = "/become-a-customer-register/submit";
    private static final String REDIRECT_HOME = "redirect:/";
    private static final Logger LOG = LoggerFactory.getLogger(SFRegisterPageController.class);

    private HttpSessionRequestCache httpSessionRequestCache;

    @Resource(name = "brakesCompanyFacade")
    private BrakesCompanyFacade brakesCompanyFacade;

    @Resource(name = "brakesSFRegistrationValidator")
    private Validator brakesSFRegistrationValidator;

    @Resource(name = "brakesCustomerFacade")
    private BrakesCustomerFacade brakesCustomerFacade;

    @Resource(name = "brakesSFRegCompanyDetailsValidator")
    private Validator brakesSFRegCompanyDetailsValidator;

    @Resource(name = "brakesSFRegAboutYourBusinessValidator")
    private Validator brakesSFRegAboutYourBusinessValidator;

    @Resource(name = "enumerationService")
    private EnumerationService enumerationService;

    @Resource(name = "customerRegisterFormPopulator")
    private CustomerRegisterFormPopulator customerRegisterFormPopulator;

    private static final String FORM_GLOBAL_ERROR = "form.global.error";

    private static final Map<String, String> REGISTER_STEP_REDIRECT_MAP;

    static {
        REGISTER_STEP_REDIRECT_MAP = new HashMap<>();
        REGISTER_STEP_REDIRECT_MAP.put("STEP_ONE", SEO_STEP_URL_COMPANY_DETAILS);
        REGISTER_STEP_REDIRECT_MAP.put("STEP_TWO", SEO_STEP_URL_ABOUT_YOUR_BUSINESS);
        REGISTER_STEP_REDIRECT_MAP.put("STEP_THREE", SEO_STEP_URL_SUBMIT);
    }

    @RequestMapping(value = STEP_URL_COMPANY_DETAILS, method = RequestMethod.POST)
    public String doRegisterStepOnePost() throws CMSItemNotFoundException {
        getSessionService().setAttribute(SESSION_ATTRIBUTE_MEET_THE_CRITERIA, Boolean.TRUE);

        return REDIRECT_PREFIX + REGISTER_STEP_REDIRECT_MAP.get("STEP_ONE");
    }

    @RequestMapping(value = STEP_URL_COMPANY_DETAILS, method = RequestMethod.GET)
    public String doSFRegisterStepOne(final Model model) throws CMSItemNotFoundException {
        if (Boolean.TRUE.equals(checkMeetTheCriteria())) {
            storeCmsPageInModel(model, getCmsPage());
            setUpMetaDataForContentPage(model, (ContentPageModel) getCmsPage());
            model.addAttribute(COMPANY_TYPES, brakesCompanyFacade.getSFCompanyTypes());
            model.addAttribute(STEP, RegistrationStep.STEP_ONE.getCode());
            setRegFormToModel(model);
            return getView();
        }
        return REDIRECT_PREFIX + "/become-a-customer-eligible";
    }

    @RequestMapping(value = STEP_URL_SUBMIT, method = RequestMethod.POST)
    public String doRegister(final RegisterForm form, final BindingResult bindingResult, final Model model,
                             final HttpServletRequest request, final RedirectAttributes redirectModel)
            throws CMSItemNotFoundException {
        return processRegisterUserRequest(form, bindingResult, model, request, redirectModel);
    }

    private void setRegFormToModel(final Model model) {
        if (null != getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM)) {
            model.addAttribute(getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM));
        } else {
            model.addAttribute(new RegisterForm());
        }
    }

    @RequestMapping(value = STEP_URL_SUBMIT, method = RequestMethod.GET)
    public String doRegisterStepFour(final Model model) throws CMSItemNotFoundException {
        if(Boolean.TRUE.equals(checkMeetTheCriteria())) {
            storeCmsPageInModel(model, getCmsPage());
            setUpMetaDataForContentPage(model, (ContentPageModel) getCmsPage());
            model.addAttribute(STEP, RegistrationStep.STEP_THREE.getCode());
            model.addAttribute(PREVIOUS_STEP_URL, REGISTER_STEP_REDIRECT_MAP.get("STEP_TWO"));
            setLastCompletedStep(model);
            setRegFormToModel(model);
            if(!hasCompletedPreviousStep(RegistrationStep.STEP_THREE.getCode())) {

                return REDIRECT_PREFIX + REGISTER_STEP_REDIRECT_MAP.get("STEP_TWO");
            }
            return getView();
        }

        return REDIRECT_PREFIX + "/become-a-customer-eligible";
    }

    protected Boolean checkMeetTheCriteria() {
        return getSessionService().getAttribute(SESSION_ATTRIBUTE_MEET_THE_CRITERIA);
    }

    @Override
    protected AbstractPageModel getCmsPage() throws CMSItemNotFoundException {
        return getContentPageForLabelOrId("sfRegister");
    }

    @Override
    protected String getSuccessRedirect(HttpServletRequest request, HttpServletResponse response) {
        if (httpSessionRequestCache.getRequest(request, response) != null) {
            return httpSessionRequestCache.getRequest(request, response).getRedirectUrl();
        }
        return "/";
    }

    @Override
    protected String getView() {
        return ControllerConstants.Views.Pages.Account.AccountMultiStepSFRegPage;
    }

    protected String processRegisterUserRequest(final RegisterForm form, final BindingResult bindingResult,
                                                final Model model, final HttpServletRequest request,
                                                final RedirectAttributes redirectModel) throws CMSItemNotFoundException // NOSONAR
    {
        if (form.getStep().equals(RegistrationStep.STEP_ONE.getCode())) {
            return processRegisterUserRequestStepOne(form, bindingResult, model, false, request);
        }

        if (form.getStep().equals(RegistrationStep.STEP_TWO.getCode())) {
            return processRegisterUserRequestStepTwo(form, bindingResult, model, false, request);
        }

        if (null != getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM) && form.getStep().equals(RegistrationStep.STEP_THREE.getCode())) {
            //Just use form instead of sessionRegForm, if need to fallback to previous registration

            RegisterForm sessionRegForm = updateStepFourDataInSessionForm(form);
            brakesSFRegistrationValidator.validate(sessionRegForm, bindingResult);
            if (bindingResult.hasErrors()) {
                model.addAttribute(sessionRegForm);
                model.addAttribute(SECTORS, brakesCompanyFacade.getSFSectors());
                model.addAttribute(BUDGETS, brakesCompanyFacade.getAnnualSpends());
                model.addAttribute(COMPANY_TYPES, brakesCompanyFacade.getSFCompanyTypes());
                model.addAttribute(CURRENT_SUPPLIERS, brakesCompanyFacade.getCurrentSuppliers());
                model.addAttribute(STEP, RegistrationStep.STEP_FOUR.getCode());
                model.addAttribute(PREVIOUS_STEP_URL, REGISTER_STEP_REDIRECT_MAP.get("STEP_TWO"));
                GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
                return handleRegistrationError(model);
            }
            sessionRegForm.setStep(RegistrationStep.STEP_THREE.getCode());
            boolean isSaved = saveSFRegisterForm(sessionRegForm, request, model, bindingResult);
            if(!isSaved) {
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

    private boolean saveSFRegisterForm(final RegisterForm sessionRegForm, final HttpServletRequest request,
                                       final Model model, final BindingResult bindingResult) {

        final RegisterData data = new RegisterData();
        populateRegisterData(sessionRegForm, data, request);
        try {
            String customerRegistrationPK = brakesCustomerFacade.sfRegister(data);
            if(sessionRegForm.getPk() == null) {
            	sessionRegForm.setPk(customerRegistrationPK);
            }

        } catch (final DuplicateUidException e) {
            model.addAttribute(sessionRegForm);
            model.addAttribute(new LoginForm());
            model.addAttribute(new GuestForm());
            bindingResult.rejectValue("email", "registration.error.account.exists.title");
            GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
            return false;
        }
        return true;
    }

    @RequestMapping(value = STEP_URL_ABOUT_YOUR_BUSINESS, method = RequestMethod.GET)
    public String doSFRegisterStepTwo(final Model model) throws CMSItemNotFoundException {

        if(Boolean.TRUE.equals(checkMeetTheCriteria())) {
            storeCmsPageInModel(model, getCmsPage());
            setUpMetaDataForContentPage(model, (ContentPageModel) getCmsPage());
            model.addAttribute(SECTORS, brakesCompanyFacade.getSFSectors());
            model.addAttribute(BUDGETS, brakesCompanyFacade.getAnnualSpends());
            model.addAttribute(STEP, RegistrationStep.STEP_TWO.getCode());
            model.addAttribute(CURRENT_SUPPLIERS, brakesCompanyFacade.getCurrentSuppliers());
            model.addAttribute(ANNUAL_STORE_TURN_OVERS, brakesCompanyFacade.getAnnualStoreTurnOvers());
            model.addAttribute(PREVIOUS_STEP_URL, REGISTER_STEP_REDIRECT_MAP.get("STEP_ONE"));
            setLastCompletedStep(model);
            setRegFormToModel(model);
            if(!hasCompletedPreviousStep(RegistrationStep.STEP_TWO.getCode())) {

                return REDIRECT_PREFIX + REGISTER_STEP_REDIRECT_MAP.get("STEP_ONE");
            }
            return getView();
        }

        return REDIRECT_PREFIX + "/become-a-customer-eligible";
    }

    @RequestMapping(value = "/brakes/become-a-customer-save-and-exit-revisit", method = RequestMethod.GET)
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

            RegisterData registerData = brakesCustomerFacade.getPartiallySavedSFRegisterData(token);
            RegisterForm savedDataForm = new RegisterForm();
            customerRegisterFormPopulator.populate(registerData, savedDataForm);
            getSessionService().setAttribute("meetTheCriteria", Boolean.TRUE);
            getSessionService().setAttribute("registrationFrom", savedDataForm);
            storeCmsPageInModel(model, getCmsPage());
            setUpMetaDataForContentPage(model, (ContentPageModel) getCmsPage());
            model.addAttribute("step", registerData.getStep());
            model.addAttribute("previousStepUrl", getPreviousStepUrl(registerData.getStep()));
            updateLastCompletedStepForRevisit(registerData.getStep());
            model.addAttribute(SECTORS, brakesCompanyFacade.getSFSectors());
            model.addAttribute(BUDGETS, brakesCompanyFacade.getAnnualSpends());
            model.addAttribute(CURRENT_SUPPLIERS, brakesCompanyFacade.getCurrentSuppliers());
            model.addAttribute(COMPANY_TYPES, brakesCompanyFacade.getSFCompanyTypes());
            model.addAttribute(ANNUAL_STORE_TURN_OVERS, brakesCompanyFacade.getAnnualStoreTurnOvers());
            setLastCompletedStep(model);
            setRegFormToModel(model);
            if(registerData.isHybrisLockedLead()) {
                getSessionService().removeAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM);
                getSessionService().removeAttribute(SESSION_ATTRIBUTE_MEET_THE_CRITERIA);
                getSessionService().removeAttribute(SESSION_ATTRIBUTE_LAST_COMPLETED_STEPS);
                brakesCustomerFacade.deletePartiallySavedRegisterData(token);
                return ControllerConstants.Views.Pages.Account.AccountMultiStepSFRegLockedPage;
            }
            return getView();

        }catch (ModelNotFoundException ex) {

            return REDIRECT_HOME;
        }
    }

    @PostMapping(value = "/sf/customer-register-save-and-exit/submit")
    public String doSaveAndExit(final RegisterForm form, final BindingResult bindingResult, final Model model,
                                final HttpServletRequest request, final RedirectAttributes redirectModel)
            throws CMSItemNotFoundException
    {
        return processRegisterUserSaveAndExitRequest(form, bindingResult, model, request, redirectModel);
    }

    private String processRegisterUserSaveAndExitRequest(RegisterForm form, BindingResult bindingResult, Model model, HttpServletRequest request, final RedirectAttributes redirectModel) throws CMSItemNotFoundException {
        if(form.getStep().equals(RegistrationStep.STEP_ONE.getCode())) {
            processRegisterUserRequestStepOne(form, bindingResult,model, true, request);
        }

        if(form.getStep().equals(RegistrationStep.STEP_TWO.getCode())) {
            processRegisterUserRequestStepTwo(form, bindingResult,model, true, request);
        }

        if(null !=  getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM)) {
            //Just use form instead of sessionRegForm, if need to fallback to previous registration
            RegisterForm sessionRegForm = updateStepFourDataInSessionForm(form);
            sessionRegForm.setStep(form.getStep());

            final RegisterData data = new RegisterData();
            populateRegisterData(sessionRegForm, data, request);

            try {

                brakesCustomerFacade.registerSfSaveAndExit(data);

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


    protected String processRegisterUserRequestStepOne(final RegisterForm form, final BindingResult bindingResult,
                                                       final Model model, final boolean isSaveAndExit, final HttpServletRequest request) throws CMSItemNotFoundException // NOSONAR
    {
        RegisterForm sessionRegForm = null;
        if(null !=  getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM)) {
            sessionRegForm = getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM);
            sessionRegForm.setCompanyType(form.getCompanyType());
            sessionRegForm.setCompanyRegNumber(form.getCompanyRegNumber());
            sessionRegForm.setCompanyRegName(form.getCompanyRegName());
            sessionRegForm.setTradingName(form.getTradingName());
            sessionRegForm.setPostCode(form.getPostCode());
            sessionRegForm.setLine1(form.getLine1());
            sessionRegForm.setCity(form.getCity());
            sessionRegForm.setCounty(form.getCounty());
            sessionRegForm.setPhoneNumber(form.getPhoneNumber());
            sessionRegForm.setMobileNumber(form.getMobileNumber());
            sessionRegForm.setFirstName(form.getFirstName());
            sessionRegForm.setLastName(form.getLastName());
            sessionRegForm.setJobTitle(form.getJobTitle());
            sessionRegForm.setTitle(form.getTitle());
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
        sessionRegForm.setStep(RegistrationStep.STEP_ONE.getCode());
        if(!isSaveAndExit) {
            brakesSFRegCompanyDetailsValidator.validate(sessionRegForm, bindingResult);
            if (bindingResult.hasErrors()) {
                model.addAttribute(sessionRegForm);
                model.addAttribute(COMPANY_TYPES, brakesCompanyFacade.getSFCompanyTypes());
                model.addAttribute(STEP, RegistrationStep.STEP_ONE.getCode());
                GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
                return handleRegistrationError(model);
            }
            boolean isSaved = saveSFRegisterForm(sessionRegForm, request, model, bindingResult);
            if(!isSaved) {
                return handleRegistrationError(model);
            }
        }
        updateLastCompletedSteps(RegistrationStep.STEP_ONE.getCode());
        return REDIRECT_PREFIX + REGISTER_STEP_REDIRECT_MAP.get("STEP_TWO");
    }

    protected String processRegisterUserRequestStepTwo(final RegisterForm form, final BindingResult bindingResult,
                                                       final Model model, final boolean isSaveAndExit, final HttpServletRequest request) throws CMSItemNotFoundException // NOSONAR
    {
        RegisterForm sessionRegForm = null;
        if(null !=  getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM)) {
            sessionRegForm = getSessionService().getAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM);
            sessionRegForm.setBudget(form.getBudget());
            sessionRegForm.setCurrentSupplier(form.getCurrentSupplier());
            populateCurrentSupplierComment(form, sessionRegForm);
            sessionRegForm.setSector(form.getSector());
            sessionRegForm.setSubSector(form.getSubSector());
            sessionRegForm.setDeliveryRestrictions(form.getDeliveryRestrictions());

        }else {
            getSessionService().setAttribute(SESSION_ATTRIBUTE_REGISTRATION_FORM, form);
            sessionRegForm = form;
        }
        sessionRegForm.setStep(RegistrationStep.STEP_TWO.getCode());
        if(!isSaveAndExit) {
            brakesSFRegCompanyDetailsValidator.validate(sessionRegForm, bindingResult);
            brakesSFRegAboutYourBusinessValidator.validate(sessionRegForm, bindingResult);
            if (bindingResult.hasErrors()) {
                model.addAttribute(sessionRegForm);
                model.addAttribute(SECTORS, brakesCompanyFacade.getSFSectors());
                model.addAttribute(BUDGETS, brakesCompanyFacade.getAnnualSpends());
                model.addAttribute(CURRENT_SUPPLIERS, brakesCompanyFacade.getCurrentSuppliers());
                model.addAttribute(STEP, RegistrationStep.STEP_TWO.getCode());
                model.addAttribute(PREVIOUS_STEP_URL, REGISTER_STEP_REDIRECT_MAP.get("STEP_ONE"));
                model.addAttribute(ANNUAL_STORE_TURN_OVERS, brakesCompanyFacade.getAnnualStoreTurnOvers());
                GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
                return handleRegistrationError(model);
            }

            boolean isSaved = saveSFRegisterForm(sessionRegForm, request, model, bindingResult);
            if(!isSaved) {
                return handleRegistrationError(model);
            }
        }
        updateLastCompletedSteps(RegistrationStep.STEP_TWO.getCode());
        return REDIRECT_PREFIX + REGISTER_STEP_REDIRECT_MAP.get("STEP_THREE");
    }

	/**
	 * @param form
	 * @param sessionRegForm
	 */
	private void populateCurrentSupplierComment(final RegisterForm form, RegisterForm sessionRegForm)
	{
		if (form.getCurrentSupplier().equalsIgnoreCase(NATIONAL_OTHER) || form.getCurrentSupplier().equalsIgnoreCase(OTHER)
				|| form.getCurrentSupplier().equalsIgnoreCase(REGIONAL_OTHER)
				|| form.getCurrentSupplier().equalsIgnoreCase(LOCAL_OTHER))
		{
			sessionRegForm.setCurrentSupplierComments(form.getCurrentSupplierComments());
		}else {
			sessionRegForm.setCurrentSupplierComments("");
		}
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
        data.setCustomerPk(sessionRegForm.getPk());
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
        data.setCurrentSupplier(sessionRegForm.getCurrentSupplier());
        data.setCurrentSupplierComments(StringUtils.isNotEmpty(sessionRegForm.getCurrentSupplier()) ? sessionRegForm.getCurrentSupplierComments().replaceAll("[\\t\\n\\r]+", " ")
                : StringUtils.EMPTY);
        data.setBusinessTelephoneNumber(sessionRegForm.getBusinessTelephoneNumber());
        data.setTermsCheck(sessionRegForm.getTermsCheck() != null?sessionRegForm.getTermsCheck().booleanValue() : false);
        data.setPrivacyPolicy(sessionRegForm.getPrivacyPolicy() != null?sessionRegForm.getPrivacyPolicy().booleanValue() : false);
        data.setStep(sessionRegForm.getStep());
        data.setHybrisLockedLead(false);
        setGAVariables(data,request);
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
            LOG.info(String.format("Last touch cookie values %s", lastTouchCookie.getValue()));
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
        final String output = input.replace("{", "");
        return output.replace("}", "");
    }
}
