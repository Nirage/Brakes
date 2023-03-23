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

import com.envoydigital.brakes.facades.BrakesB2BOrderFacade;
import com.envoydigital.brakes.facades.BrakesB2BUnitFacade;
import com.envoydigital.brakes.facades.amend.eligible.data.AmendEligibleData;
import com.envoydigital.brakes.facades.data.SwitchAccountResponseData;
import com.envoydigital.brakes.facades.exception.AmendOrderDeletedException;
import com.envoydigital.brakes.facades.order.data.AmendableOrderHistoryWrapperData;
import com.envoydigital.brakes.facades.order.data.OrderSearchPageData;
import com.envoydigital.brakes.facades.order.evaluator.impl.BrakesAmendOrderDetailsSearchPageEvaluator;
import com.envoydigital.brakes.facades.order.evaluator.impl.BrakesOrderDetailsSearchPageEvaluator;
import com.envoydigital.brakes.facades.search.impl.SearchContext;
import com.envoydigital.brakes.facades.unavailable.data.UnavailableProductData;
import com.envoydigital.brakes.facades.utils.BrakesAmendOrderSessionUtils;
import com.envoydigital.brakes.integration.json.OrderDeliveryStatusData;
import com.envoydigital.brakes.storefront.annotations.NoCache;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.QuickOrderForm;
import com.envoydigital.brakes.storefront.forms.SubstituteProductForm;
import com.envoydigital.brakes.storefront.forms.SwitchAccountForm;
import com.envoydigital.brakes.storefront.forms.validation.QuickOrderValidator;
import com.envoydigital.brakes.storefront.util.BrakesOrderDeadLockUtils;
import com.google.common.base.Joiner;
import de.hybris.platform.acceleratorfacades.ordergridform.OrderGridFormFacade;
import de.hybris.platform.acceleratorfacades.product.data.ReadOnlyOrderGridData;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.Breadcrumb;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.ResourceBreadcrumbBuilder;
import de.hybris.platform.acceleratorstorefrontcommons.constants.WebConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractSearchPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.acceleratorstorefrontcommons.forms.AddressForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.UpdateEmailForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.UpdatePasswordForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.UpdateProfileForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.validation.AddressValidator;
import de.hybris.platform.acceleratorstorefrontcommons.forms.validation.EmailValidator;
import de.hybris.platform.acceleratorstorefrontcommons.forms.validation.PasswordValidator;
import de.hybris.platform.acceleratorstorefrontcommons.forms.validation.ProfileValidator;
import de.hybris.platform.acceleratorstorefrontcommons.forms.verification.AddressVerificationResultHandler;
import de.hybris.platform.acceleratorstorefrontcommons.strategy.CustomerConsentDataStrategy;
import de.hybris.platform.acceleratorstorefrontcommons.util.AddressDataUtil;
import de.hybris.platform.assistedservicefacades.AssistedServiceFacade;
import de.hybris.platform.b2bcommercefacades.company.data.B2BUnitData;
import de.hybris.platform.b2bpunchoutaddon.constants.B2bpunchoutaddonConstants;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.AbstractPageModel;
import de.hybris.platform.commercefacades.address.AddressVerificationFacade;
import de.hybris.platform.commercefacades.address.data.AddressVerificationResult;
import de.hybris.platform.commercefacades.customer.CustomerFacade;
import de.hybris.platform.commercefacades.i18n.I18NFacade;
import de.hybris.platform.commercefacades.order.CheckoutFacade;
import de.hybris.platform.commercefacades.order.data.CCPaymentInfoData;
import de.hybris.platform.commercefacades.order.data.OrderData;
import de.hybris.platform.commercefacades.order.data.OrderEntryData;
import de.hybris.platform.commercefacades.order.data.OrderHistoryData;
import de.hybris.platform.commercefacades.product.ProductOption;
import de.hybris.platform.commercefacades.user.UserFacade;
import de.hybris.platform.commercefacades.user.data.AddressData;
import de.hybris.platform.commercefacades.user.data.CountryData;
import de.hybris.platform.commercefacades.user.data.CustomerData;
import de.hybris.platform.commercefacades.user.data.TitleData;
import de.hybris.platform.commercefacades.user.exceptions.PasswordMismatchException;
import de.hybris.platform.commerceservices.address.AddressVerificationDecision;
import de.hybris.platform.commerceservices.customer.DuplicateUidException;
import de.hybris.platform.commerceservices.order.CommerceCartRestorationException;
import de.hybris.platform.commerceservices.search.pagedata.PageableData;
import de.hybris.platform.commerceservices.search.pagedata.SearchPageData;
import de.hybris.platform.commerceservices.util.ResponsiveUtils;
import de.hybris.platform.core.enums.OrderStatus;
import de.hybris.platform.servicelayer.exceptions.AmbiguousIdentifierException;
import de.hybris.platform.servicelayer.exceptions.ModelNotFoundException;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import de.hybris.platform.util.Config;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import java.util.*;
import java.util.stream.Collector;
import java.util.stream.Collectors;


/**
 * Controller for home page
 */
@Controller
@RequestMapping("/my-account")
public class AccountPageController extends AbstractSearchPageController {
    private static final String TEXT_ACCOUNT_ADDRESS_BOOK = "text.account.addressBook";
    private static final String BREADCRUMBS_ATTR = "breadcrumbs";
    private static final String IS_DEFAULT_ADDRESS_ATTR = "isDefaultAddress";
    private static final String COUNTRY_DATA_ATTR = "countryData";
    private static final String ADDRESS_BOOK_EMPTY_ATTR = "addressBookEmpty";
    private static final String TITLE_DATA_ATTR = "titleData";
    private static final String FORM_GLOBAL_ERROR = "form.global.error";
    private static final String PROFILE_CURRENT_PASSWORD_INVALID = "profile.currentPassword.invalid";
    private static final String TEXT_ACCOUNT_PROFILE = "text.account.profile";
    private static final String ADDRESS_DATA_ATTR = "addressData";
    private static final String ADDRESS_FORM_ATTR = "addressForm";
    private static final String COUNTRY_ATTR = "country";
    private static final String REGIONS_ATTR = "regions";
    private static final String MY_ACCOUNT_ADDRESS_BOOK_URL = "/my-account/address-book";
    private static final String TEXT_ACCOUNT_CONSENT_MANAGEMENT = "text.account.consent.consentManagement";
    private static final String TEXT_ACCOUNT_CONSENT_GIVEN = "text.account.consent.given";
    private static final String TEXT_ACCOUNT_CONSENT_WITHDRAWN = "text.account.consent.withdrawn";
    private static final String TEXT_ACCOUNT_CONSENT_NOT_FOUND = "text.account.consent.notFound";
    private static final String TEXT_ACCOUNT_CONSENT_TEMPLATE_NOT_FOUND = "text.account.consent.template.notFound";
    private static final String TEXT_ACCOUNT_CLOSE = "text.account.close";

    // Internal Redirects
    private static final String REDIRECT_TO_ADDRESS_BOOK_PAGE = REDIRECT_PREFIX + MY_ACCOUNT_ADDRESS_BOOK_URL;
    private static final String REDIRECT_TO_PAYMENT_INFO_PAGE = REDIRECT_PREFIX + "/my-account/payment-details";
    private static final String REDIRECT_TO_EDIT_ADDRESS_PAGE = REDIRECT_PREFIX + "/my-account/edit-address/";
    private static final String REDIRECT_TO_UPDATE_EMAIL_PAGE = REDIRECT_PREFIX + "/my-account/update-email";
    private static final String REDIRECT_TO_UPDATE_PROFILE = REDIRECT_PREFIX + "/my-account/update-profile";
    private static final String REDIRECT_TO_PASSWORD_UPDATE_PAGE = REDIRECT_PREFIX + "/my-account/update-password";
    private static final String REDIRECT_TO_ORDER_HISTORY_PAGE = REDIRECT_PREFIX + "/my-account/orders";
    private static final String REDIRECT_CART_URL = REDIRECT_PREFIX + "/cart";
    private static final String REDIRECT_TO_CONSENT_MANAGEMENT = REDIRECT_PREFIX + "/my-account/consents";
    private static final String REDIRECT_TO_HOMEPAGE = REDIRECT_PREFIX + "/";
    private static final String REDIRECT_TO_AMEND_ORDER_PAGE = REDIRECT_PREFIX + "/my-account/amend/order/";
    private static final String REDIRECT_TO_ORDER_DETAILS_PAGE = REDIRECT_PREFIX + "/my-account/order/";

    private static final String REDIRECT_TO_ORDER_AMENDMENT_WAITING_SUFFIX = "/amend/submit/success";
    private static final String CHECKOUT_ORDER_AMENDEMENT_WAITING_OOS_CMS_PAGE_LABEL = "orderAmendmentWaitingPage";
    private static final String CONTINUE_URL_KEY = "continueUrl";

    /**
     * We use this suffix pattern because of an issue with Spring 3.1 where a Uri value is incorrectly extracted if it
     * contains on or more '.' characters. Please see https://jira.springsource.org/browse/SPR-6164 for a discussion on the
     * issue and future resolution.
     */
    private static final String ORDER_CODE_PATH_VARIABLE_PATTERN = "{orderCode:.*}";
    private static final String ADDRESS_CODE_PATH_VARIABLE_PATTERN = "{addressCode:.*}";

    // CMS Pages
    private static final String ACCOUNT_CMS_PAGE = "account";
    private static final String PROFILE_CMS_PAGE = "profile";
    private static final String UPDATE_PASSWORD_CMS_PAGE = "updatePassword";
    private static final String UPDATE_PROFILE_CMS_PAGE = "update-profile";
    private static final String UPDATE_EMAIL_CMS_PAGE = "update-email";
    private static final String ADDRESS_BOOK_CMS_PAGE = "address-book";
    private static final String ADD_EDIT_ADDRESS_CMS_PAGE = "add-edit-address";
    private static final String PAYMENT_DETAILS_CMS_PAGE = "payment-details";
    private static final String ORDER_HISTORY_CMS_PAGE = "orders";
    private static final String ORDER_DETAIL_CMS_PAGE = "order";
    private static final String CONSENT_MANAGEMENT_CMS_PAGE = "consents";
    private static final String CLOSE_ACCOUNT_CMS_PAGE = "close-account";
    private static final String AMEND_ORDER_DETAIL_CMS_PAGE = "amendorder";
    private static final String ORDER_DELIVERY_STATUS_CMS_PAGE = "orderDeliveryStatusPage";

    // Http Header Extra Information
    private static final String METAINFO_TOTAL_NUMBER_OF_ACTIVE_ORDERS = "TOTAL_NUMBER_OF_ACTIVE_ORDERS";

    private static final Logger LOG = Logger.getLogger(AccountPageController.class);

    @Resource(name = "brakesOrderDetailsSearchPageEvaluator")
    private BrakesOrderDetailsSearchPageEvaluator brakesOrderDetailsSearchPageEvaluator;

    @Resource(name = "brakesAmendOrderDetailsSearchPageEvaluator")
    private BrakesAmendOrderDetailsSearchPageEvaluator brakesAmendOrderDetailsSearchPageEvaluator;

    @Resource(name = "b2bOrderFacade")
    private BrakesB2BOrderFacade orderFacade;

    @Resource(name = "acceleratorCheckoutFacade")
    private CheckoutFacade checkoutFacade;

    @Resource(name = "userFacade")
    private UserFacade userFacade;

    @Resource(name = "customerFacade")
    private CustomerFacade customerFacade;

    @Resource(name = "accountBreadcrumbBuilder")
    private ResourceBreadcrumbBuilder accountBreadcrumbBuilder;

    @Resource(name = "passwordValidator")
    private PasswordValidator passwordValidator;

    @Resource(name = "addressValidator")
    private AddressValidator addressValidator;

    @Resource(name = "profileValidator")
    private ProfileValidator profileValidator;

    @Resource(name = "emailValidator")
    private EmailValidator emailValidator;

    @Resource(name = "i18NFacade")
    private I18NFacade i18NFacade;

    @Resource(name = "addressVerificationFacade")
    private AddressVerificationFacade addressVerificationFacade;

    @Resource(name = "addressVerificationResultHandler")
    private AddressVerificationResultHandler addressVerificationResultHandler;

    @Resource(name = "orderGridFormFacade")
    private OrderGridFormFacade orderGridFormFacade;

    @Resource(name = "customerConsentDataStrategy")
    protected CustomerConsentDataStrategy customerConsentDataStrategy;

    @Resource(name = "addressDataUtil")
    private AddressDataUtil addressDataUtil;

    @Resource(name = "brakesAmendOrderSessionUtils")
    private BrakesAmendOrderSessionUtils brakesAmendOrderSessionUtils;

    @Resource(name = "cartFacade")
    private com.envoydigital.brakes.facades.cart.BrakesCartFacade brakesCartFacade;


    @Resource(name = "brakesB2BUnitFacade")
    private BrakesB2BUnitFacade brakesB2BUnitFacade;

    @Resource(name = "quickOrderValidator")
    private QuickOrderValidator quickOrderValidator;

    @Resource(name = "assistedServiceFacade")
    private AssistedServiceFacade assistedServiceFacade;

    @Resource(name = "brakesOrderDeadLockUtils")
    private BrakesOrderDeadLockUtils brakesOrderDeadLockUtils;


    protected PasswordValidator getPasswordValidator() {
        return passwordValidator;
    }

    protected AddressValidator getAddressValidator() {
        return addressValidator;
    }

    protected ProfileValidator getProfileValidator() {
        return profileValidator;
    }

    protected EmailValidator getEmailValidator() {
        return emailValidator;
    }

    protected I18NFacade getI18NFacade() {
        return i18NFacade;
    }

    protected AddressVerificationFacade getAddressVerificationFacade() {
        return addressVerificationFacade;
    }

    protected AddressVerificationResultHandler getAddressVerificationResultHandler() {
        return addressVerificationResultHandler;
    }

    @ModelAttribute("countries")
    public Collection<CountryData> getCountries() {
        return checkoutFacade.getDeliveryCountries();
    }

    @ModelAttribute("titles")
    public Collection<TitleData> getTitles() {
        return userFacade.getTitles();
    }

    @ModelAttribute("countryDataMap")
    public Map<String, CountryData> getCountryDataMap() {
        final Map<String, CountryData> countryDataMap = new HashMap<>();
        for (final CountryData countryData : getCountries()) {
            countryDataMap.put(countryData.getIsocode(), countryData);
        }
        return countryDataMap;
    }


    @RequestMapping(value = "/addressform", method = RequestMethod.GET)
    public String getCountryAddressForm(@RequestParam("addressCode") final String addressCode,
                                        @RequestParam("countryIsoCode") final String countryIsoCode, final Model model) {
        model.addAttribute("supportedCountries", getCountries());
        populateModelRegionAndCountry(model, countryIsoCode);

        final AddressForm addressForm = new AddressForm();
        model.addAttribute(ADDRESS_FORM_ATTR, addressForm);
        for (final AddressData addressData : userFacade.getAddressBook()) {
            if (addressData.getId() != null && addressData.getId().equals(addressCode)
                    && countryIsoCode.equals(addressData.getCountry().getIsocode())) {
                model.addAttribute(ADDRESS_DATA_ATTR, addressData);
                addressDataUtil.convert(addressData, addressForm);
                break;
            }
        }
        return ControllerConstants.Views.Fragments.Account.CountryAddressForm;
    }

    protected void populateModelRegionAndCountry(final Model model, final String countryIsoCode) {
        model.addAttribute(REGIONS_ATTR, getI18NFacade().getRegionsForCountryIso(countryIsoCode));
        model.addAttribute(COUNTRY_ATTR, countryIsoCode);
    }

    @RequestMapping(method = RequestMethod.GET)
    @RequireHardLogIn
    public String account(final Model model, final RedirectAttributes redirectModel) throws CMSItemNotFoundException {
        if (ResponsiveUtils.isResponsive()) {
            GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "system.error.page.not.found",
                    null);
            return REDIRECT_PREFIX + "/";
        }
        storeCmsPageInModel(model, getContentPageForLabelOrId(ACCOUNT_CMS_PAGE));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(ACCOUNT_CMS_PAGE));
        model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(null));
        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
        return getViewForPage(model);
    }

    @RequestMapping(value = "/orders", method = RequestMethod.GET)
    @RequireHardLogIn
    public String orders(final HttpServletRequest request,
                         final RedirectAttributes redirectModel,
                         @RequestParam(value = "page", defaultValue = "1") final int page,
                         @RequestParam(value = "show", defaultValue = "Page") final ShowMode showMode,
                         @RequestParam(value = "sort", required = false) final String sortCode,
                         @RequestParam(value = "status", required = false) final OrderStatus[] status, final Model model)
            throws CMSItemNotFoundException {
        //Redirecting to home , for punch-out user
        if (StringUtils.isNotBlank((String) request.getSession().getAttribute(B2bpunchoutaddonConstants.PUNCHOUT_USER)))
        {
            GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "system.error.page.not.found",
                    null);
            return REDIRECT_PREFIX + "/";
        }
        // Handle paged search results
        final PageableData pageableData = createPageableData(page, 12, sortCode, showMode);
        SearchPageData<OrderHistoryData> searchPageData = null;
        if (null != status) {
            searchPageData = orderFacade.getPagedOrderHistoryForB2BUnitAndStatuses(pageableData, status);

        } else {
            searchPageData = orderFacade.getPagedOrderHistoryForB2BUnitAndStatuses(pageableData);

        }
        populateModel(model, searchPageData, showMode);
        final Map<String, Boolean> orderFilterStatus = getOrderStatusFilter(status);
        final Integer count = orderFacade.findOrdersCountOfLastTwelveMonths();
        model.addAttribute("noPreviousOrders", count > 0 ? false : true);
        model.addAttribute("isAssistedServiceAgentLoggedIn", assistedServiceFacade.isAssistedServiceAgentLoggedIn());
        model.addAttribute("orderStatuFilters", orderFilterStatus);
        model.addAttribute("appliedFilters", getSelectedFilters(orderFilterStatus));
        storeCmsPageInModel(model, getContentPageForLabelOrId(ORDER_HISTORY_CMS_PAGE));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(ORDER_HISTORY_CMS_PAGE));
        model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs("text.account.orderHistory"));
        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
        return getViewForPage(model);
    }

    @ResponseBody
    @RequestMapping(value = "/amendableOrders", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequireHardLogIn
    public ResponseEntity<String> amendableOrders(@RequestParam(value = "pageSize", defaultValue = "2") final int pageSize,
                                                  final Model model)
    {
        final PageableData pageableData = createPageableData(1, pageSize*10, "byDeliveryDate", ShowMode.Page);
        AmendableOrderHistoryWrapperData searchPageData = orderFacade.getAmendableOrderHistoryForB2BUnit(pageableData, pageSize);

        final HttpHeaders headers = new HttpHeaders();
        headers.add(METAINFO_TOTAL_NUMBER_OF_ACTIVE_ORDERS, "" + orderFacade.getActiveOrdersCountByB2BUnitAndStore());

        return new ResponseEntity(searchPageData, headers, HttpStatus.OK);
    }

    @RequestMapping(value = "/orders/deliveryStatus", method = RequestMethod.GET)
    @RequireHardLogIn
    public String getOrderDeliveryStatusPage(final HttpServletRequest httpServletRequest, final Model model)
            throws CMSItemNotFoundException {
        final String id = httpServletRequest.getParameter("id");
        final String deliveryDate = httpServletRequest.getParameter("deliveryDate");
        final String messageType = httpServletRequest.getParameter("messageType");
        final OrderDeliveryStatusData orderDeliveryStatusData = orderFacade.getDeliveryStatus(id, deliveryDate, messageType);
        storeCmsPageInModel(model, getContentPageForLabelOrId(ORDER_DELIVERY_STATUS_CMS_PAGE));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(ORDER_DELIVERY_STATUS_CMS_PAGE));
        model.addAttribute("orderDeliveryStatusData", orderDeliveryStatusData);
        return getViewForPage(model);
    }

    @RequestMapping(value = "/order/results/" + ORDER_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
    @ResponseBody
    @RequireHardLogIn
    public OrderSearchPageData<List<OrderEntryData>, OrderHistoryData> orderById(
            @RequestParam(value = "page", defaultValue = "1") final int page,
            @RequestParam(value = "show", defaultValue = "Page") final SearchContext.ShowMode showMode,
            @RequestParam(value = "sort", required = false) final String sortCode,
            @PathVariable("orderCode") final String orderCode, final Model model, final RedirectAttributes redirectModel)
            throws CMSItemNotFoundException {
        final SearchContext searchContext = new SearchContext(orderCode, page, null, showMode,
                Collections.singletonMap(sortCode, null));
        return brakesOrderDetailsSearchPageEvaluator.doSearch(searchContext);
    }

    @RequestMapping(value = "/order/" + ORDER_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
    @RequireHardLogIn
    public String order(@RequestParam(value = "page", defaultValue = "1") final int page,
                        @RequestParam(value = "show", defaultValue = "Page") final SearchContext.ShowMode showMode,
                        @RequestParam(value = "sort", required = false) final String sortCode,
                        @PathVariable("orderCode") final String orderCode, final Model model, final RedirectAttributes redirectModel)
            throws CMSItemNotFoundException {
        // Fetching original OrderHistoryData and OrderEntries with pagination.
        try {
            final SearchContext searchContext = new SearchContext(orderCode, page, null, showMode,
                    Collections.singletonMap(sortCode, null));
            final OrderSearchPageData<List<OrderEntryData>, OrderHistoryData> orderDetails = brakesOrderDetailsSearchPageEvaluator
                    .doSearch(searchContext);
            final List<UnavailableProductData> unavailableProducts = (List<UnavailableProductData>) model.asMap()
                    .get("unavailableProducts");

            if (null != unavailableProducts) {
                model.addAttribute("unavailableProducts", unavailableProducts);
            }
            model.addAttribute("orderDetails", orderDetails);
            if (orderDetails.getOrder().isSubstitutionInProcess()) {
                model.addAttribute(new SubstituteProductForm());
            }
        } catch (final UnknownIdentifierException | ModelNotFoundException e) {
            LOG.warn("Attempted to load a order that does not exist or is not visible", e);
            GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "text.account.order.error.notfound",
                    Arrays.asList(orderCode == null ? StringUtils.EMPTY : orderCode).toArray());
            return REDIRECT_TO_ORDER_HISTORY_PAGE;
        }

        model.addAttribute("isAssistedServiceAgentLoggedIn", assistedServiceFacade.isAssistedServiceAgentLoggedIn());
        model.addAttribute("isOrderDetailsPage", true);
        storeCmsPageInModel(model, getContentPageForLabelOrId(ORDER_DETAIL_CMS_PAGE));
        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(ORDER_DETAIL_CMS_PAGE));
        return getViewForPage(model);
    }

    @RequestMapping(value = "/cancel/amend/order/" + ORDER_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
    @RequireHardLogIn
    public String cancelAmendOrder(@PathVariable("orderCode") final String orderCode, final Model model, final RedirectAttributes redirectModel,
                             final HttpServletRequest request) throws CMSItemNotFoundException {
        orderFacade.removeAmendOrder(orderCode);
        brakesAmendOrderSessionUtils.releaseAmendOrderSession();
        return REDIRECT_TO_HOMEPAGE;

    }

    @RequestMapping(value = "/amend/order/" + ORDER_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
    @RequireHardLogIn
    public String amendOrder(@RequestParam(value = "page", defaultValue = "1") final int page,
                             @RequestParam(value = "show", defaultValue = "Page") final SearchContext.ShowMode showMode,
                             @RequestParam(value = "sort", required = false) final String sortCode,
                             @PathVariable("orderCode") final String orderCode, final Model model, final RedirectAttributes redirectModel,
                             final HttpServletRequest request) throws CMSItemNotFoundException {
        if (!model.containsAttribute("quickOrderForm")) {
            model.addAttribute(new QuickOrderForm());
        }

        // Checking order is eligible to amend or not
        if (!model.containsAttribute("redirectFromSubsReject") && !orderFacade.checkorderEligibleForAmend(orderCode, assistedServiceFacade.isAssistedServiceAgentLoggedIn()).isEligible()) {

            GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "order.not.eligible.for.amend",
                    null);
            return REDIRECT_TO_ORDER_HISTORY_PAGE;
        }
        // setting order code in request session so it will be available to fetch and release order lock when time of session timeout.
        brakesOrderDeadLockUtils.addOrderIDToSession(request, orderCode);

        return getAmendOrderDetails(orderCode, page, showMode, sortCode, model, redirectModel, request,true);
    }

    @RequestMapping(value = "/start/amending/order/" + ORDER_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
    @RequireHardLogIn
    public String startAmendingOrder(@RequestParam(value = "page", defaultValue = "1") final int page,
                             @RequestParam(value = "show", defaultValue = "Page") final SearchContext.ShowMode showMode,
                             @RequestParam(value = "sort", required = false) final String sortCode,
                             @PathVariable("orderCode") final String orderCode, final Model model, final RedirectAttributes redirectModel,
                             final HttpServletRequest request) throws CMSItemNotFoundException {
        // Checking order is eligible to amend or not
        if (!model.containsAttribute("redirectFromSubsReject") && !orderFacade.checkorderEligibleForAmend(orderCode, assistedServiceFacade.isAssistedServiceAgentLoggedIn()).isEligible()) {

            GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "order.not.eligible.for.amend",
                    null);
            return REDIRECT_TO_ORDER_HISTORY_PAGE;
        }
        // setting order code in request session so it will be available to fetch and release order lock when time of session timeout.
        brakesOrderDeadLockUtils.addOrderIDToSession(request, orderCode);

        return getAmendOrderDetails(orderCode, page, showMode, sortCode, model, redirectModel, request,false);
    }

    String getAmendOrderDetails(final String orderCode, final int page, final SearchContext.ShowMode showMode,
                                final String sortCode, final Model model, final RedirectAttributes redirectModel, final HttpServletRequest request, boolean showAmendOrderPage) throws CMSItemNotFoundException {
        try {
            // Fetching amend OrderHistoryData and OrderEntries with pagination.

            final SearchContext searchContext = new SearchContext(orderCode, page, null, showMode,
                    Collections.singletonMap(sortCode, null));
            final OrderSearchPageData<List<OrderEntryData>, OrderHistoryData> orderDetails = brakesAmendOrderDetailsSearchPageEvaluator
                    .doSearch(searchContext);// TO-DO change to OOTB
            brakesAmendOrderSessionUtils.createAmendOrderSession(orderDetails);
            if(showAmendOrderPage) {
                final List<UnavailableProductData> unavailableProducts = (List<UnavailableProductData>) model.asMap()
                        .get("unavailableProducts");

                if (null != unavailableProducts) {
                    model.addAttribute("unavailableProducts", unavailableProducts);
                }
                model.addAttribute("orderDetails", orderDetails);
                if (orderDetails.getOrder().isSubstitutionInProcess()) {
                    model.addAttribute(new SubstituteProductForm());
                }
            }

        } catch (final UnknownIdentifierException e) {
            LOG.warn("Attempted to load a order that does not exist or is not visible", e);
            GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "system.error.page.not.found",
                    null);
            return REDIRECT_TO_ORDER_HISTORY_PAGE;
        }
        if(showAmendOrderPage) {
            model.addAttribute("isAmendOrderDetailsPage", true);
            storeCmsPageInModel(model, getContentPageForLabelOrId(AMEND_ORDER_DETAIL_CMS_PAGE));
            model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
            setUpMetaDataForContentPage(model, getContentPageForLabelOrId(AMEND_ORDER_DETAIL_CMS_PAGE));
            return getViewForPage(model);
        }
        return REDIRECT_TO_HOMEPAGE;
    }

    @RequestMapping(value = "/amend/order/results/" + ORDER_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
    @ResponseBody
    @RequireHardLogIn
    public OrderSearchPageData<List<OrderEntryData>, OrderHistoryData> amendOrderById(
            @RequestParam(value = "page", defaultValue = "1") final int page,
            @RequestParam(value = "show", defaultValue = "Page") final SearchContext.ShowMode showMode,
            @RequestParam(value = "sort", required = false) final String sortCode,
            @PathVariable("orderCode") final String orderCode, final Model model, final RedirectAttributes redirectModel)
            throws CMSItemNotFoundException {

        // Fetching amend OrderHistoryData and OrderEntries with pagination.

        final SearchContext searchContext = new SearchContext(orderCode, page, null, showMode,
                Collections.singletonMap(sortCode, null));
        return brakesAmendOrderDetailsSearchPageEvaluator.doSearch(searchContext);
    }

    @RequestMapping(value = "/checkOrderEligibiltyForAmend/" + ORDER_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
    @ResponseBody
    @RequireHardLogIn
    public AmendEligibleData checkOrderEligibiltyForAmend(@PathVariable("orderCode") final String orderCode, final Model model) {
        // Checking order is eligible to amend or not
        return orderFacade.checkorderEligibleForAmend(orderCode, assistedServiceFacade.isAssistedServiceAgentLoggedIn());

    }

    @RequestMapping(value = "/removeAmendOrder/" + ORDER_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
    @RequireHardLogIn
    public String removeAmendOrderAndRedirectToOrderPage(@PathVariable("orderCode") final String orderCode, final Model model) {
        // remove amend order
        orderFacade.removeAmendOrder(orderCode);

        return REDIRECT_TO_ORDER_DETAILS_PAGE + orderCode;
    }

    @RequestMapping(value = "/order/substitute", method = RequestMethod.POST)
    @RequireHardLogIn
    public RedirectView substituteOrder(@RequestHeader(value = "referer", required = false) final String referer,
                                        final SubstituteProductForm form, final Model model, final RedirectAttributes redirectModel) {

        try {


            if (form.isAcceptSubstitute()) {
                orderFacade.replaceBySubstituteEntry(form.getOrderNumber(), form.getEntryNumber(),
                        form.getSubstituteProductCode());
            } else {
                orderFacade.rejectSubstituteEntry(form.getOrderNumber(), form.getEntryNumber(), form.getSubstituteProductCode());

            }
        } catch (final Exception e) {
            LOG.warn("Attempted to modify substitute products ", e);
            GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "substitute.modification.error",
                    null);
        }
        GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "substitute.modification.success", null);
        redirectModel.addFlashAttribute("redirectFromSubsReject", true);
        return new RedirectView(referer);
    }

    @RequestMapping(value = "/checkAmendOrderEligibiltyForResubmit/"
            + ORDER_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    @RequireHardLogIn
    public AmendEligibleData checkAmendOrderEligibiltyForResubmit(@PathVariable("orderCode") final String orderCode,
                                                                  final Model model) {
        //Checking amend order is eligible to Resubmit or not
        return orderFacade.checkorderEligibleForResubmit(orderCode, assistedServiceFacade.isAssistedServiceAgentLoggedIn());
    }

    @RequestMapping(value = "/order/" + ORDER_CODE_PATH_VARIABLE_PATTERN
            + "/getReadOnlyProductVariantMatrix", method = RequestMethod.GET)
    @RequireHardLogIn
    public String getProductVariantMatrixForResponsive(@PathVariable("orderCode") final String orderCode,
                                                       @RequestParam("productCode") final String productCode, final Model model) {
        final OrderData orderData = orderFacade.getOrderDetailsForCodeWithoutUser(orderCode);

        final Map<String, ReadOnlyOrderGridData> readOnlyMultiDMap = orderGridFormFacade.getReadOnlyOrderGridForProductInOrder(
                productCode, Arrays.asList(ProductOption.BASIC, ProductOption.CATEGORIES), orderData);
        model.addAttribute("readOnlyMultiDMap", readOnlyMultiDMap);

        return ControllerConstants.Views.Fragments.Checkout.ReadOnlyExpandedOrderForm;
    }

    @RequestMapping(value = "/addToAmendOrder", method = RequestMethod.POST)
    @RequireHardLogIn
    public String quickOrder(@ModelAttribute("quickOrderForm") final QuickOrderForm quickOrderForm,
                             final BindingResult bindingResult, final Model model, final RedirectAttributes attributes)
            throws CMSItemNotFoundException {
        // validating product code and qty as per the rules
        quickOrderValidator.validate(quickOrderForm, bindingResult);
        if (!orderFacade.checkorderEligibleForAmend(quickOrderForm.getOrderCode(),
                assistedServiceFacade.isAssistedServiceAgentLoggedIn()).isEligible()) {
            bindingResult.rejectValue("productCode", "order.not.eligible.to.amend");
        }
        if (bindingResult.hasErrors()) {
            attributes.addFlashAttribute("org.springframework.validation.BindingResult.quickOrderForm", bindingResult);
            attributes.addFlashAttribute("quickOrderForm", quickOrderForm);
            return REDIRECT_TO_AMEND_ORDER_PAGE + quickOrderForm.getOrderCode();

        }
        modifyAmendOrderEntries(quickOrderForm.getProductCode(), quickOrderForm.getQty(),
                quickOrderForm.getOrderCode(), attributes);
        return REDIRECT_TO_AMEND_ORDER_PAGE + quickOrderForm.getOrderCode();
    }

    private void modifyAmendOrderEntries(final String productCode, final Long quantity,
                final String orderCode, final RedirectAttributes redirectAttributes) {
        try {
            orderFacade.modifyingAmendOrderEntries(productCode, quantity,
                    orderCode);
            GlobalMessages.addFlashMessage(redirectAttributes, GlobalMessages.CONF_MESSAGES_HOLDER, "basket.entry.qty.update");
        } catch (final AmendOrderDeletedException ex) {
            GlobalMessages.addFlashMessage(redirectAttributes, GlobalMessages.ERROR_MESSAGES_HOLDER,
                    "text.order.delivery.changedbyecc.popup.msg", null);
        }
    }

    @RequestMapping(value = "/resubmit/amend/order", method = RequestMethod.GET)
    @RequireHardLogIn
    public String submittingAmendOrder(final Model model, @RequestParam("orderCode") final String orderCode,
                                       final RedirectAttributes redirectModel) throws CMSItemNotFoundException {
        //submitting amendingOrder with customer customized data.
        try {
            orderFacade.submitAmendOrder(orderCode);
            brakesAmendOrderSessionUtils.releaseAmendOrderSession();
        } catch (final AmendOrderDeletedException e) {
            GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
                    "text.order.delivery.changedbyecc.popup.msg", null);
            return REDIRECT_TO_AMEND_ORDER_PAGE + orderCode;
        }

        return REDIRECT_PREFIX  + "/my-account/" + orderCode + REDIRECT_TO_ORDER_AMENDMENT_WAITING_SUFFIX;
    }

    @RequireHardLogIn
    @RequestMapping(value = "/{orderCode:.*}/amend/submit/success", method = RequestMethod.GET)
    public String amendmentRequestSubmitted(@PathVariable("orderCode") final String orderCode, final Model model,
                                         final RedirectAttributes redirectModel) throws CMSItemNotFoundException
    {
        final OrderData orderData = orderFacade.getOrderDetailsForCodeWithoutUser(orderCode);
        model.addAttribute("orderData", orderData);

        final String continueUrl = (String) getSessionService().getAttribute(WebConstants.CONTINUE_URL);
        model.addAttribute(CONTINUE_URL_KEY, (continueUrl != null && !continueUrl.isEmpty()) ? continueUrl : ROOT);

        final AbstractPageModel cmsPage = getContentPageForLabelOrId(CHECKOUT_ORDER_AMENDEMENT_WAITING_OOS_CMS_PAGE_LABEL);
        storeCmsPageInModel(model, cmsPage);
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(CHECKOUT_ORDER_AMENDEMENT_WAITING_OOS_CMS_PAGE_LABEL));
        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);

        if (ResponsiveUtils.isResponsive())
        {
            return getViewForPage(model);
        }

        // We are reusing the template of the confirmation page
        return "pages/checkout/checkoutConfirmationLayoutPage";
    }

    @RequestMapping(value = "/profile", method = RequestMethod.GET)
    @RequireHardLogIn
    public String profile(final Model model) throws CMSItemNotFoundException {
        final List<TitleData> titles = userFacade.getTitles();

        final CustomerData customerData = customerFacade.getCurrentCustomer();
        if (customerData.getTitleCode() != null) {
            model.addAttribute("title", findTitleForCode(titles, customerData.getTitleCode()));
        }

        model.addAttribute("customerData", customerData);

        storeCmsPageInModel(model, getContentPageForLabelOrId(PROFILE_CMS_PAGE));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(PROFILE_CMS_PAGE));
        model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(TEXT_ACCOUNT_PROFILE));
        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
        return getViewForPage(model);
    }

    protected TitleData findTitleForCode(final List<TitleData> titles, final String code) {
        if (code != null && !code.isEmpty() && titles != null && !titles.isEmpty()) {
            for (final TitleData title : titles) {
                if (code.equals(title.getCode())) {
                    return title;
                }
            }
        }
        return null;
    }

    @RequestMapping(value = "/update-email", method = RequestMethod.GET)
    @RequireHardLogIn
    public String editEmail(final Model model) throws CMSItemNotFoundException {
        final CustomerData customerData = customerFacade.getCurrentCustomer();
        final UpdateEmailForm updateEmailForm = new UpdateEmailForm();

        updateEmailForm.setEmail(customerData.getDisplayUid());

        model.addAttribute("updateEmailForm", updateEmailForm);

        storeCmsPageInModel(model, getContentPageForLabelOrId(UPDATE_EMAIL_CMS_PAGE));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(UPDATE_EMAIL_CMS_PAGE));
        model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(TEXT_ACCOUNT_PROFILE));
        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
        return getViewForPage(model);
    }

    @RequestMapping(value = "/update-email", method = RequestMethod.POST)
    @RequireHardLogIn
    public String updateEmail(final UpdateEmailForm updateEmailForm, final BindingResult bindingResult, final Model model,
                              final RedirectAttributes redirectAttributes) throws CMSItemNotFoundException {
        getEmailValidator().validate(updateEmailForm, bindingResult);
        String returnAction = REDIRECT_TO_UPDATE_EMAIL_PAGE;

        if (!bindingResult.hasErrors() && !updateEmailForm.getEmail().equals(updateEmailForm.getChkEmail())) {
            bindingResult.rejectValue("chkEmail", "validation.checkEmail.equals", new Object[]{},
                    "validation.checkEmail.equals");
        }

        if (bindingResult.hasErrors()) {
            returnAction = setErrorMessagesAndCMSPage(model, UPDATE_EMAIL_CMS_PAGE);
        } else {
            try {
                customerFacade.changeUid(updateEmailForm.getEmail(), updateEmailForm.getPassword());
                GlobalMessages.addFlashMessage(redirectAttributes, GlobalMessages.CONF_MESSAGES_HOLDER,
                        "text.account.profile.confirmationUpdated", null);

                // Replace the spring security authentication with the new UID
                final String newUid = customerFacade.getCurrentCustomer().getUid().toLowerCase();
                final Authentication oldAuthentication = SecurityContextHolder.getContext().getAuthentication();
                final UsernamePasswordAuthenticationToken newAuthentication = new UsernamePasswordAuthenticationToken(newUid,
                        null, oldAuthentication.getAuthorities());
                newAuthentication.setDetails(oldAuthentication.getDetails());
                SecurityContextHolder.getContext().setAuthentication(newAuthentication);
            } catch (final DuplicateUidException e) {
                bindingResult.rejectValue("email", "profile.email.unique");
                returnAction = setErrorMessagesAndCMSPage(model, UPDATE_EMAIL_CMS_PAGE);
            } catch (final PasswordMismatchException passwordMismatchException) {
                bindingResult.rejectValue("password", PROFILE_CURRENT_PASSWORD_INVALID);
                returnAction = setErrorMessagesAndCMSPage(model, UPDATE_EMAIL_CMS_PAGE);
            }
        }

        return returnAction;
    }

    protected String setErrorMessagesAndCMSPage(final Model model, final String cmsPageLabelOrId) throws CMSItemNotFoundException {
        GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
        storeCmsPageInModel(model, getContentPageForLabelOrId(cmsPageLabelOrId));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(cmsPageLabelOrId));
        model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(TEXT_ACCOUNT_PROFILE));
        return getViewForPage(model);
    }


    @RequestMapping(value = "/update-profile", method = RequestMethod.GET)
    @RequireHardLogIn
    public String editProfile(final Model model) throws CMSItemNotFoundException {
        model.addAttribute(TITLE_DATA_ATTR, userFacade.getTitles());

        final CustomerData customerData = customerFacade.getCurrentCustomer();
        final UpdateProfileForm updateProfileForm = new UpdateProfileForm();

        updateProfileForm.setTitleCode(customerData.getTitleCode());
        updateProfileForm.setFirstName(customerData.getFirstName());
        updateProfileForm.setLastName(customerData.getLastName());

        model.addAttribute("updateProfileForm", updateProfileForm);

        storeCmsPageInModel(model, getContentPageForLabelOrId(UPDATE_PROFILE_CMS_PAGE));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(UPDATE_PROFILE_CMS_PAGE));

        model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(TEXT_ACCOUNT_PROFILE));
        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
        return getViewForPage(model);
    }

    @RequestMapping(value = "/update-profile", method = RequestMethod.POST)
    @RequireHardLogIn
    public String updateProfile(final UpdateProfileForm updateProfileForm, final BindingResult bindingResult, final Model model,
                                final RedirectAttributes redirectAttributes) throws CMSItemNotFoundException {
        getProfileValidator().validate(updateProfileForm, bindingResult);

        String returnAction = REDIRECT_TO_UPDATE_PROFILE;
        final CustomerData currentCustomerData = customerFacade.getCurrentCustomer();
        final CustomerData customerData = new CustomerData();
        customerData.setTitleCode(updateProfileForm.getTitleCode());
        customerData.setFirstName(updateProfileForm.getFirstName());
        customerData.setLastName(updateProfileForm.getLastName());
        customerData.setUid(currentCustomerData.getUid());
        customerData.setDisplayUid(currentCustomerData.getDisplayUid());

        model.addAttribute(TITLE_DATA_ATTR, userFacade.getTitles());

        storeCmsPageInModel(model, getContentPageForLabelOrId(UPDATE_PROFILE_CMS_PAGE));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(UPDATE_PROFILE_CMS_PAGE));

        if (bindingResult.hasErrors()) {
            returnAction = setErrorMessagesAndCMSPage(model, UPDATE_PROFILE_CMS_PAGE);
        } else {
            try {
                customerFacade.updateProfile(customerData);
                GlobalMessages.addFlashMessage(redirectAttributes, GlobalMessages.CONF_MESSAGES_HOLDER,
                        "text.account.profile.confirmationUpdated", null);

            } catch (final DuplicateUidException e) {
                bindingResult.rejectValue("email", "registration.error.account.exists.title");
                returnAction = setErrorMessagesAndCMSPage(model, UPDATE_PROFILE_CMS_PAGE);
            }
        }


        model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(TEXT_ACCOUNT_PROFILE));
        return returnAction;
    }

    @RequestMapping(value = "/update-password", method = RequestMethod.GET)
    @RequireHardLogIn
    public String updatePassword(final Model model) throws CMSItemNotFoundException {
        final UpdatePasswordForm updatePasswordForm = new UpdatePasswordForm();

        model.addAttribute("updatePasswordForm", updatePasswordForm);

        storeCmsPageInModel(model, getContentPageForLabelOrId(UPDATE_PASSWORD_CMS_PAGE));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(UPDATE_PASSWORD_CMS_PAGE));

        model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs("text.account.profile.updatePasswordForm"));
        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
        return getViewForPage(model);
    }

    @RequestMapping(value = "/update-password", method = RequestMethod.POST)
    @RequireHardLogIn
    public String updatePassword(final UpdatePasswordForm updatePasswordForm, final BindingResult bindingResult,
                                 final Model model, final RedirectAttributes redirectAttributes) throws CMSItemNotFoundException {
        getPasswordValidator().validate(updatePasswordForm, bindingResult);
        if (!bindingResult.hasErrors()) {
            if (updatePasswordForm.getNewPassword().equals(updatePasswordForm.getCheckNewPassword())) {
                try {
                    customerFacade.changePassword(updatePasswordForm.getCurrentPassword(), updatePasswordForm.getNewPassword());
                } catch (final PasswordMismatchException localException) {
                    bindingResult.rejectValue("currentPassword", PROFILE_CURRENT_PASSWORD_INVALID, new Object[]{},
                            PROFILE_CURRENT_PASSWORD_INVALID);
                }
            } else {
                bindingResult.rejectValue("checkNewPassword", "validation.checkPwd.equals", new Object[]{},
                        "validation.checkPwd.equals");
            }
        }

        if (bindingResult.hasErrors()) {
            GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
            storeCmsPageInModel(model, getContentPageForLabelOrId(UPDATE_PASSWORD_CMS_PAGE));
            setUpMetaDataForContentPage(model, getContentPageForLabelOrId(UPDATE_PASSWORD_CMS_PAGE));

            model.addAttribute(BREADCRUMBS_ATTR,
                    accountBreadcrumbBuilder.getBreadcrumbs("text.account.profile.updatePasswordForm"));
            return getViewForPage(model);
        } else {
            GlobalMessages.addFlashMessage(redirectAttributes, GlobalMessages.CONF_MESSAGES_HOLDER,
                    "text.account.confirmation.password.updated", null);
            return REDIRECT_TO_PASSWORD_UPDATE_PAGE;
        }
    }

    @RequestMapping(value = "/address-book", method = RequestMethod.GET)
    @RequireHardLogIn
    public String getAddressBook(final Model model) throws CMSItemNotFoundException {
        model.addAttribute(ADDRESS_DATA_ATTR, userFacade.getAddressBook());

        storeCmsPageInModel(model, getContentPageForLabelOrId(ADDRESS_BOOK_CMS_PAGE));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(ADDRESS_BOOK_CMS_PAGE));
        model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(TEXT_ACCOUNT_ADDRESS_BOOK));
        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
        return getViewForPage(model);
    }

    @RequestMapping(value = "/add-address", method = RequestMethod.GET)
    @RequireHardLogIn
    public String addAddress(final Model model) throws CMSItemNotFoundException {
        model.addAttribute(COUNTRY_DATA_ATTR, checkoutFacade.getDeliveryCountries());
        model.addAttribute(TITLE_DATA_ATTR, userFacade.getTitles());
        final AddressForm addressForm = getPreparedAddressForm();
        model.addAttribute(ADDRESS_FORM_ATTR, addressForm);
        model.addAttribute(ADDRESS_BOOK_EMPTY_ATTR, Boolean.valueOf(CollectionUtils.isEmpty(userFacade.getAddressBook())));
        model.addAttribute(IS_DEFAULT_ADDRESS_ATTR, Boolean.FALSE);
        storeCmsPageInModel(model, getContentPageForLabelOrId(ADD_EDIT_ADDRESS_CMS_PAGE));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(ADD_EDIT_ADDRESS_CMS_PAGE));

        final List<Breadcrumb> breadcrumbs = accountBreadcrumbBuilder.getBreadcrumbs(null);
        breadcrumbs.add(new Breadcrumb(MY_ACCOUNT_ADDRESS_BOOK_URL,
                getMessageSource().getMessage(TEXT_ACCOUNT_ADDRESS_BOOK, null, getI18nService().getCurrentLocale()), null));
        breadcrumbs.add(new Breadcrumb("#", getMessageSource().getMessage("text.account.addressBook.addEditAddress", null,
                getI18nService().getCurrentLocale()), null));
        model.addAttribute(BREADCRUMBS_ATTR, breadcrumbs);
        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
        return getViewForPage(model);
    }

    protected AddressForm getPreparedAddressForm() {
        final CustomerData currentCustomerData = customerFacade.getCurrentCustomer();
        final AddressForm addressForm = new AddressForm();
        addressForm.setFirstName(currentCustomerData.getFirstName());
        addressForm.setLastName(currentCustomerData.getLastName());
        addressForm.setTitleCode(currentCustomerData.getTitleCode());
        return addressForm;
    }

    @RequestMapping(value = "/add-address", method = RequestMethod.POST)
    @RequireHardLogIn
    public String addAddress(final AddressForm addressForm, final BindingResult bindingResult, final Model model,
                             final RedirectAttributes redirectModel) throws CMSItemNotFoundException {
        getAddressValidator().validate(addressForm, bindingResult);
        if (bindingResult.hasErrors()) {
            GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
            storeCmsPageInModel(model, getContentPageForLabelOrId(ADD_EDIT_ADDRESS_CMS_PAGE));
            setUpMetaDataForContentPage(model, getContentPageForLabelOrId(ADD_EDIT_ADDRESS_CMS_PAGE));
            setUpAddressFormAfterError(addressForm, model);
            return getViewForPage(model);
        }

        final AddressData newAddress = addressDataUtil.convertToVisibleAddressData(addressForm);

        if (CollectionUtils.isEmpty(userFacade.getAddressBook())) {
            newAddress.setDefaultAddress(true);
        } else {
            newAddress
                    .setDefaultAddress(addressForm.getDefaultAddress() != null && addressForm.getDefaultAddress().booleanValue());
        }

        final AddressVerificationResult<AddressVerificationDecision> verificationResult = getAddressVerificationFacade()
                .verifyAddressData(newAddress);
        final boolean addressRequiresReview = getAddressVerificationResultHandler().handleResult(verificationResult, newAddress,
                model, redirectModel, bindingResult, getAddressVerificationFacade().isCustomerAllowedToIgnoreAddressSuggestions(),
                "checkout.multi.address.added");

        populateModelRegionAndCountry(model, addressForm.getCountryIso());
        model.addAttribute("edit", Boolean.TRUE);
        model.addAttribute(IS_DEFAULT_ADDRESS_ATTR, Boolean.valueOf(userFacade.isDefaultAddress(addressForm.getAddressId())));

        if (addressRequiresReview) {
            storeCmsPageInModel(model, getContentPageForLabelOrId(ADD_EDIT_ADDRESS_CMS_PAGE));
            setUpMetaDataForContentPage(model, getContentPageForLabelOrId(ADD_EDIT_ADDRESS_CMS_PAGE));
            return getViewForPage(model);
        }

        userFacade.addAddress(newAddress);


        GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "account.confirmation.address.added",
                null);

        return REDIRECT_TO_EDIT_ADDRESS_PAGE + newAddress.getId();
    }

    protected void setUpAddressFormAfterError(final AddressForm addressForm, final Model model) {
        model.addAttribute(COUNTRY_DATA_ATTR, checkoutFacade.getDeliveryCountries());
        model.addAttribute(TITLE_DATA_ATTR, userFacade.getTitles());
        model.addAttribute(ADDRESS_BOOK_EMPTY_ATTR, Boolean.valueOf(CollectionUtils.isEmpty(userFacade.getAddressBook())));
        model.addAttribute(IS_DEFAULT_ADDRESS_ATTR, Boolean.valueOf(userFacade.isDefaultAddress(addressForm.getAddressId())));
        if (addressForm.getCountryIso() != null) {
            populateModelRegionAndCountry(model, addressForm.getCountryIso());
        }
    }

    @RequestMapping(value = "/edit-address/" + ADDRESS_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
    @RequireHardLogIn
    public String editAddress(@PathVariable("addressCode") final String addressCode, final Model model)
            throws CMSItemNotFoundException {
        final AddressForm addressForm = new AddressForm();
        model.addAttribute(COUNTRY_DATA_ATTR, checkoutFacade.getDeliveryCountries());
        model.addAttribute(TITLE_DATA_ATTR, userFacade.getTitles());
        model.addAttribute(ADDRESS_FORM_ATTR, addressForm);
        final List<AddressData> addressBook = userFacade.getAddressBook();
        model.addAttribute(ADDRESS_BOOK_EMPTY_ATTR, Boolean.valueOf(CollectionUtils.isEmpty(addressBook)));


        for (final AddressData addressData : addressBook) {
            if (addressData.getId() != null && addressData.getId().equals(addressCode)) {
                model.addAttribute(REGIONS_ATTR, getI18NFacade().getRegionsForCountryIso(addressData.getCountry().getIsocode()));
                model.addAttribute(COUNTRY_ATTR, addressData.getCountry().getIsocode());
                model.addAttribute(ADDRESS_DATA_ATTR, addressData);
                addressDataUtil.convert(addressData, addressForm);

                if (userFacade.isDefaultAddress(addressData.getId())) {
                    addressForm.setDefaultAddress(Boolean.TRUE);
                    model.addAttribute(IS_DEFAULT_ADDRESS_ATTR, Boolean.TRUE);
                } else {
                    addressForm.setDefaultAddress(Boolean.FALSE);
                    model.addAttribute(IS_DEFAULT_ADDRESS_ATTR, Boolean.FALSE);
                }
                break;
            }
        }

        storeCmsPageInModel(model, getContentPageForLabelOrId(ADD_EDIT_ADDRESS_CMS_PAGE));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(ADD_EDIT_ADDRESS_CMS_PAGE));

        final List<Breadcrumb> breadcrumbs = accountBreadcrumbBuilder.getBreadcrumbs(null);
        breadcrumbs.add(new Breadcrumb(MY_ACCOUNT_ADDRESS_BOOK_URL,
                getMessageSource().getMessage(TEXT_ACCOUNT_ADDRESS_BOOK, null, getI18nService().getCurrentLocale()), null));
        breadcrumbs.add(new Breadcrumb("#", getMessageSource().getMessage("text.account.addressBook.addEditAddress", null,
                getI18nService().getCurrentLocale()), null));
        model.addAttribute(BREADCRUMBS_ATTR, breadcrumbs);
        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
        model.addAttribute("edit", Boolean.TRUE);
        return getViewForPage(model);
    }

    @RequestMapping(value = "/edit-address/" + ADDRESS_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.POST)
    @RequireHardLogIn
    public String editAddress(final AddressForm addressForm, final BindingResult bindingResult, final Model model,
                              final RedirectAttributes redirectModel) throws CMSItemNotFoundException {
        getAddressValidator().validate(addressForm, bindingResult);
        if (bindingResult.hasErrors()) {
            GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
            storeCmsPageInModel(model, getContentPageForLabelOrId(ADD_EDIT_ADDRESS_CMS_PAGE));
            setUpMetaDataForContentPage(model, getContentPageForLabelOrId(ADD_EDIT_ADDRESS_CMS_PAGE));
            setUpAddressFormAfterError(addressForm, model);
            return getViewForPage(model);
        }

        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);

        final AddressData newAddress = addressDataUtil.convertToVisibleAddressData(addressForm);

        if (Boolean.TRUE.equals(addressForm.getDefaultAddress()) || userFacade.getAddressBook().size() <= 1) {
            newAddress.setDefaultAddress(true);
        }

        final AddressVerificationResult<AddressVerificationDecision> verificationResult = getAddressVerificationFacade()
                .verifyAddressData(newAddress);
        final boolean addressRequiresReview = getAddressVerificationResultHandler().handleResult(verificationResult, newAddress,
                model, redirectModel, bindingResult, getAddressVerificationFacade().isCustomerAllowedToIgnoreAddressSuggestions(),
                "checkout.multi.address.updated");

        model.addAttribute(REGIONS_ATTR, getI18NFacade().getRegionsForCountryIso(addressForm.getCountryIso()));
        model.addAttribute(COUNTRY_ATTR, addressForm.getCountryIso());
        model.addAttribute("edit", Boolean.TRUE);
        model.addAttribute(IS_DEFAULT_ADDRESS_ATTR, Boolean.valueOf(userFacade.isDefaultAddress(addressForm.getAddressId())));

        if (addressRequiresReview) {
            storeCmsPageInModel(model, getContentPageForLabelOrId(ADD_EDIT_ADDRESS_CMS_PAGE));
            setUpMetaDataForContentPage(model, getContentPageForLabelOrId(ADD_EDIT_ADDRESS_CMS_PAGE));
            return getViewForPage(model);
        }

        userFacade.editAddress(newAddress);

        GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "account.confirmation.address.updated",
                null);
        return REDIRECT_TO_EDIT_ADDRESS_PAGE + newAddress.getId();
    }

    @RequestMapping(value = "/select-suggested-address", method = RequestMethod.POST)
    public String doSelectSuggestedAddress(final AddressForm addressForm, final RedirectAttributes redirectModel) {
        final Set<String> resolveCountryRegions = org.springframework.util.StringUtils
                .commaDelimitedListToSet(Config.getParameter("resolve.country.regions"));

        final AddressData selectedAddress = addressDataUtil.convertToVisibleAddressData(addressForm);

        final CountryData countryData = selectedAddress.getCountry();

        if (!resolveCountryRegions.contains(countryData.getIsocode())) {
            selectedAddress.setRegion(null);
        }

        if (Boolean.TRUE.equals(addressForm.getEditAddress())) {
            userFacade.editAddress(selectedAddress);
        } else {
            userFacade.addAddress(selectedAddress);
        }

        GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, "account.confirmation.address.added");

        return REDIRECT_TO_ADDRESS_BOOK_PAGE;
    }

    @RequestMapping(value = "/remove-address/" + ADDRESS_CODE_PATH_VARIABLE_PATTERN, method =
            {RequestMethod.GET, RequestMethod.POST})
    @RequireHardLogIn
    public String removeAddress(@PathVariable("addressCode") final String addressCode, final RedirectAttributes redirectModel) {
        final AddressData addressData = new AddressData();
        addressData.setId(addressCode);
        userFacade.removeAddress(addressData);

        GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER,
                "account.confirmation.address.removed");
        return REDIRECT_TO_ADDRESS_BOOK_PAGE;
    }

    @RequestMapping(value = "/set-default-address/" + ADDRESS_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
    @RequireHardLogIn
    public String setDefaultAddress(@PathVariable("addressCode") final String addressCode, final RedirectAttributes redirectModel) {
        final AddressData addressData = new AddressData();
        addressData.setDefaultAddress(true);
        addressData.setVisibleInAddressBook(true);
        addressData.setId(addressCode);
        userFacade.setDefaultAddress(addressData);
        GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER,
                "account.confirmation.default.address.changed");
        return REDIRECT_TO_ADDRESS_BOOK_PAGE;
    }

    @RequestMapping(value = "/payment-details", method = RequestMethod.GET)
    @RequireHardLogIn
    public String paymentDetails(final Model model) throws CMSItemNotFoundException {
        model.addAttribute("customerData", customerFacade.getCurrentCustomer());
        model.addAttribute("paymentInfoData", userFacade.getCCPaymentInfos(true));
        storeCmsPageInModel(model, getContentPageForLabelOrId(PAYMENT_DETAILS_CMS_PAGE));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(ADD_EDIT_ADDRESS_CMS_PAGE));
        model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs("text.account.paymentDetails"));
        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
        return getViewForPage(model);
    }

    @RequestMapping(value = "/set-default-payment-details", method = RequestMethod.POST)
    @RequireHardLogIn
    public String setDefaultPaymentDetails(@RequestParam final String paymentInfoId) {
        CCPaymentInfoData paymentInfoData = null;
        if (StringUtils.isNotBlank(paymentInfoId)) {
            paymentInfoData = userFacade.getCCPaymentInfoForCode(paymentInfoId);
        }
        userFacade.setDefaultPaymentInfo(paymentInfoData);
        return REDIRECT_TO_PAYMENT_INFO_PAGE;
    }

    @RequestMapping(value = "/remove-payment-method", method = RequestMethod.POST)
    @RequireHardLogIn
    public String removePaymentMethod(@RequestParam(value = "paymentInfoId") final String paymentMethodId,
                                      final RedirectAttributes redirectAttributes) throws CMSItemNotFoundException {
        userFacade.unlinkCCPaymentInfo(paymentMethodId);
        GlobalMessages.addFlashMessage(redirectAttributes, GlobalMessages.CONF_MESSAGES_HOLDER,
                "text.account.profile.paymentCart.removed");
        return REDIRECT_TO_PAYMENT_INFO_PAGE;
    }

    @RequestMapping(value = "/consents", method = RequestMethod.GET)
    @RequireHardLogIn
    public String consentManagement(final Model model) throws CMSItemNotFoundException {
        model.addAttribute("consentTemplateDataList", getConsentFacade().getConsentTemplatesWithConsents());
        storeCmsPageInModel(model, getContentPageForLabelOrId(CONSENT_MANAGEMENT_CMS_PAGE));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(CONSENT_MANAGEMENT_CMS_PAGE));
        model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(TEXT_ACCOUNT_CONSENT_MANAGEMENT));
        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
        return getViewForPage(model);
    }

    @RequestMapping(value = "/consents/give/{consentTemplateId}/{version}", method = RequestMethod.POST)
    @RequireHardLogIn
    public String giveConsent(@PathVariable final String consentTemplateId, @PathVariable final Integer version,
                              final RedirectAttributes redirectModel) {
        try {
            getConsentFacade().giveConsent(consentTemplateId, version);
            GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, TEXT_ACCOUNT_CONSENT_GIVEN);
        } catch (final ModelNotFoundException | AmbiguousIdentifierException e) {
            LOG.warn(String.format("ConsentTemplate with code [%s] and version [%s] was not found", consentTemplateId, version),
                    e);
            GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
                    TEXT_ACCOUNT_CONSENT_TEMPLATE_NOT_FOUND, null);
        }
        customerConsentDataStrategy.populateCustomerConsentDataInSession();
        return REDIRECT_TO_CONSENT_MANAGEMENT;
    }

    @RequestMapping(value = "/consents/withdraw/{consentCode}", method = RequestMethod.POST)
    @RequireHardLogIn
    public String withdrawConsent(@PathVariable final String consentCode, final RedirectAttributes redirectModel)
            throws CMSItemNotFoundException {
        try {
            getConsentFacade().withdrawConsent(consentCode);
            GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER, TEXT_ACCOUNT_CONSENT_WITHDRAWN);
        } catch (final ModelNotFoundException e) {
            LOG.warn(String.format("Consent with code [%s] was not found", consentCode), e);
            GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, TEXT_ACCOUNT_CONSENT_NOT_FOUND,
                    null);
        }
        customerConsentDataStrategy.populateCustomerConsentDataInSession();
        return REDIRECT_TO_CONSENT_MANAGEMENT;
    }

    @RequestMapping(value = "/close-account", method = RequestMethod.GET)
    @RequireHardLogIn
    public String showCloseAccountPage(final Model model) throws CMSItemNotFoundException {
        storeCmsPageInModel(model, getContentPageForLabelOrId(CLOSE_ACCOUNT_CMS_PAGE));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(CLOSE_ACCOUNT_CMS_PAGE));
        model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(TEXT_ACCOUNT_CLOSE));
        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
        return getViewForPage(model);
    }

    @RequestMapping(value = "/close-account", method = RequestMethod.POST)
    @ResponseStatus(value = HttpStatus.OK)
    @RequireHardLogIn
    public void closeAccount(final HttpServletRequest request) throws CMSItemNotFoundException, ServletException {
        customerFacade.closeAccount();
        request.logout();
    }

    @RequestMapping(value = "/units", produces = "application/json")
    @ResponseBody
    @NoCache
    public SwitchAccountResponseData getAssignedUnits(final Model model) {
        final B2BUnitData currentB2BUnit = brakesB2BUnitFacade.getCurrentB2BUnit();

        final List<B2BUnitData> listOfB2BUnits = new ArrayList<>();

        listOfB2BUnits.add(currentB2BUnit);

        for (final B2BUnitData b2bUnitData : brakesB2BUnitFacade.getAssignedB2BUnits()) {

            if (!b2bUnitData.getUid().equals(currentB2BUnit.getUid())) {

                listOfB2BUnits.add(b2bUnitData);
            }
        }

        final SwitchAccountResponseData responseData = new SwitchAccountResponseData();
        model.addAttribute("assignedUnits", listOfB2BUnits);
        model.addAttribute("currentB2BUnit", currentB2BUnit);
        responseData.setCurrentB2Bunit(currentB2BUnit);
        responseData.setListOfB2BUnits(listOfB2BUnits);
        return responseData;
    }

    @RequestMapping(value = "/select", method = RequestMethod.POST)
    public String getSelectedUnit(final SwitchAccountForm form, final RedirectAttributes redirectAttributes) {
        if (form.getAccountID() != null) {
            final B2BUnitData unit = brakesB2BUnitFacade.setSelectedB2BUnit(form.getAccountID());

            try {
                brakesCartFacade.restoreSavedCart();
            } catch (final CommerceCartRestorationException e) {
                LOG.error("Error in restoring cart");
            }
        }
        if (validateCart(redirectAttributes)) {
            return REDIRECT_CART_URL;
        }
        return REDIRECT_TO_HOMEPAGE;
    }

    protected boolean validateCart(final RedirectAttributes redirectModel) {
        final boolean invalidDeliveryDate = brakesCartFacade.checkDeliveryDate();
        boolean priceChanged = false;
        if (invalidDeliveryDate) {
            redirectModel.addFlashAttribute("invalidDeliveryDate", invalidDeliveryDate);
            priceChanged = brakesCartFacade.hasPricingChanged();
            if (priceChanged) {
                redirectModel.addFlashAttribute("priceChanged", priceChanged);
            }

        }

		if (priceChanged || invalidDeliveryDate)
		{
            return true;
        }
        return false;
    }

    public Map<String, Boolean> getOrderStatusFilter(final OrderStatus[] status) {

        final Map<String, Boolean> filters = new HashMap<>();
        final String[] filterStatus = Config.getString("order.status.filters",
                "CONFIRMED,PICKED,WAITING_FOR_CONFRMATION,QUEUED,CONFIRMED_AND_MODIFIED,CANCELLED").split(",");
        for (final String ordrStatus : filterStatus) {
            filters.put(ordrStatus, false);
            if (null != status) {
                for (final OrderStatus string : status) {
                    if (ordrStatus.equalsIgnoreCase(string.getCode())) {
                        filters.put(ordrStatus, true);
                    }
                }
            }
        }
        return filters;
    }

    public String getSelectedFilters(final Map<String, Boolean> filterStatus) {
        final List<String> keys = filterStatus.keySet().stream().filter(s -> filterStatus.get(s)).collect(Collectors.toUnmodifiableList());
        if (CollectionUtils.isNotEmpty(keys)) {
            return String.join(",", keys);
        }
        return null;
    }

}
