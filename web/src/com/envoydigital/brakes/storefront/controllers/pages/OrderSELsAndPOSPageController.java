package com.envoydigital.brakes.storefront.controllers.pages;

import com.envoydigital.brakes.core.enums.CategoryPOSandSELType;
import com.envoydigital.brakes.core.services.BrakesOrderPOSandSELService;
import com.envoydigital.brakes.facades.BrakesOrderPOSandSELFacade;
import com.envoydigital.brakes.facades.orderPosSel.data.*;
import com.envoydigital.brakes.storefront.forms.OrderSELsAndPOSForm;
import com.sap.security.core.server.csi.XSSEncoder;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.ResourceBreadcrumbBuilder;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.impl.ContentPageBreadcrumbBuilder;
import de.hybris.platform.acceleratorstorefrontcommons.constants.WebConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Optional;


/**
 * @author thomas.domin
 *
 */
@Controller
@RequestMapping(value = "**/" + OrderSELsAndPOSPageController.ORDER_SELS_AND_POS_CMS_PAGE)
public class OrderSELsAndPOSPageController extends AbstractPageController
{
	public static final String ORDER_SELS_AND_POS_CMS_PAGE = "order-sels-and-pos";
	public static final String ORDER_SELS_CMS_PAGE = "order-sels";
	public static final String ORDER_POS_CMS_PAGE = "order-pos";
	public static final String ORDER_SELS_AND_POS_SUBMIT_CMS_PAGE = "order-sels-and-pos-submit";
    private static final Logger LOG = LoggerFactory.getLogger ( OrderSELsAndPOSPageController.class );
    private static final String FORM_GLOBAL_ERROR = "form.global.error";

    public static final int DEFAULT_SUGGEST_LIMIT = 5; // is configurable

	@Resource(name = "contentPageBreadcrumbBuilder")
	private ContentPageBreadcrumbBuilder contentPageBreadcrumbBuilder;

	@Resource(name = "brakesOrderPOSandSELFacade")
	private BrakesOrderPOSandSELFacade brakesOrderPOSandSELFacade;


    @Resource(name = "selAndPosBreadcrumbBuilder")
    private ResourceBreadcrumbBuilder selAndPosBreadcrumbBuilder;


	@RequireHardLogIn
	@RequestMapping(method = RequestMethod.GET)
	public String orderSELsAndPOSPage(@RequestParam(required = false) final String categoryCode, final Model model)
			throws CMSItemNotFoundException
	{
        return getView ( categoryCode, model );
	}

	@RequireHardLogIn
	@RequestMapping(method = RequestMethod.POST)
    public String submitOrderSELsAndPOS(@Valid final OrderSELsAndPOSForm form,
                                        final BindingResult bindingResult, final Model model,
                                        final HttpServletRequest request, final HttpServletResponse response, final RedirectAttributes redirectModel) throws CMSItemNotFoundException {
        return processOrderRequest ( form, bindingResult, model );
	}

	@RequireHardLogIn
	@RequestMapping(value = "/confirmation/{orderCode:.*}", method = RequestMethod.GET)
	public String confirmationOrderSELsAndPOSPage(@PathVariable final String orderCode, final Model model)
			throws CMSItemNotFoundException
	{
		try {
            model.addAttribute ( "orderPage", brakesOrderPOSandSELFacade.getOrderPage ( orderCode ) );
		} catch (final Exception e) {
			LOG.warn("Attempted to load an order result that does not exist or is not visible. Redirect to sels and pos start page.", e.getMessage ());
            return REDIRECT_PREFIX + ORDER_SELS_AND_POS_CMS_PAGE;
        }

		return getContentPage (model, ORDER_SELS_AND_POS_SUBMIT_CMS_PAGE, null);
	}

	@RequireHardLogIn
	@RequestMapping(value = "/autocompleteProduct", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<List<CCProductForPOSandSELData>> productSuggestions(
			@RequestParam(required = false) final String categoryCode,
			@RequestParam(value = "term", required = false) String term)
	{
        try {
            term = XSSEncoder.encodeHTML(term);
        }
        catch (final UnsupportedEncodingException e) {
            LOG.info("Free text query is invalid: " + e.getMessage());
        }

        int limit = getSiteConfigService().getInt("storefront.orderSELsAndPOS.product.suggestion.limit", DEFAULT_SUGGEST_LIMIT);
        return new ResponseEntity ( brakesOrderPOSandSELFacade.getProductSuggestions(term, categoryCode, limit), HttpStatus.OK );
	}

    protected String processOrderRequest(final OrderSELsAndPOSForm form, final BindingResult bindingResult, final Model model)
            throws CMSItemNotFoundException
    {
        if (bindingResult.hasErrors ()) {
            model.addAttribute ( form );
            return getView ( form.getCategoryCode (), model );
        }

        final OrderPOSandSELData data = new OrderPOSandSELData ();
        data.setFirstName ( form.getFirstName () );
        data.setSurname ( form.getSurname () );
        data.setBusinessName ( form.getBusinessName () );
        data.setAddressLine1 ( form.getAddressLine1 () );
        data.setAddressLine2 ( form.getAddressLine2 () );
        data.setAddressLine3 ( form.getAddressLine3 () );
        data.setPostcode ( form.getPostcode () );
        data.setOption ( form.getOption () );
        data.setProducts ( form.getProducts () );
        data.setNote( form.getNote() );
        final CategoryPOSandSELData category = new CategoryPOSandSELData ();
        category.setCode ( form.getCategoryCode () );
        data.setCategory ( category );

        try {
            OrderPOSandSELModificationData modificationData = brakesOrderPOSandSELFacade.placeOrder ( data );
            if (BrakesOrderPOSandSELService.SUCCESS.equals ( modificationData.getStatusCode () ))
                return REDIRECT_PREFIX + ORDER_SELS_AND_POS_CMS_PAGE + "/confirmation/" + modificationData.getCode ();
            else
                return getView ( form.getCategoryCode (), model );
        } catch (final Exception e) {
            LOG.error ( e.getMessage () );
            model.addAttribute ( form );
            GlobalMessages.addErrorMessage ( model, FORM_GLOBAL_ERROR );
            return getView ( form.getCategoryCode (), model );
        }

    }

    protected String getView(String categoryCode, Model model) throws CMSItemNotFoundException {
        POSandSELPageData pageData = null;
        if (StringUtils.isEmpty ( categoryCode )) {
            pageData = brakesOrderPOSandSELFacade.getFirstLevelPOSandSELPage ();
            return getViewPage ( ORDER_SELS_AND_POS_CMS_PAGE, model, pageData );
        } else {
            pageData = brakesOrderPOSandSELFacade.getPOSandSELPage ( categoryCode );
            if (CategoryPOSandSELType.POS.getCode ().equals ( pageData.getType () )) {
                return getViewPage ( ORDER_POS_CMS_PAGE, model, pageData );
            } else if (CategoryPOSandSELType.SEL.getCode ().equals ( pageData.getType () )) {
                return getViewPage ( ORDER_SELS_CMS_PAGE, model, pageData );
            }
        }

        return FORWARD_PREFIX + "/404";
    }

	protected String getViewPage(String view, Model model, POSandSELPageData pageData) throws CMSItemNotFoundException {
        OrderSELsAndPOSForm form = (OrderSELsAndPOSForm) model.asMap ().get ( "orderSELsAndPOSForm" );
        if (form == null) {
            form = new OrderSELsAndPOSForm ();
            model.addAttribute ( form );
        }
        form.setCategoryCode (
                Optional.ofNullable ( pageData )
                        .map ( POSandSELPageData::getCurrentCategory )
                        .map ( CategoryPOSandSELData::getCode )
                        .orElse ( null )
        );
		model.addAttribute ( "pageData", pageData );
		return getContentPage ( model, view , pageData.getType());
	}

	private String getContentPage(Model model, String cmsPageName, String type) throws CMSItemNotFoundException {
		final ContentPageModel cmsPage = getContentPageForLabelOrId ( cmsPageName );
		storeCmsPageInModel ( model, cmsPage );
		setUpMetaDataForContentPage ( model, cmsPage );
		if(null == type) {
            model.addAttribute(WebConstants.BREADCRUMBS_KEY, contentPageBreadcrumbBuilder.getBreadcrumbs(cmsPage));
        }else if(CategoryPOSandSELType.POS.getCode ().equals (type)) {
            model.addAttribute(WebConstants.BREADCRUMBS_KEY, selAndPosBreadcrumbBuilder.getBreadcrumbs("breadcrumb.pointOfSale"));
        }else if(CategoryPOSandSELType.SEL.getCode ().equals ( type )) {
            model.addAttribute(WebConstants.BREADCRUMBS_KEY, selAndPosBreadcrumbBuilder.getBreadcrumbs("breadcrumb.shelfEdgeLabels"));
        }
		model.addAttribute ( ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW );
		setUpMetaData ( model, null, cmsPage.getMetaDescription () );
		return getViewForPage ( model );
	}


}
