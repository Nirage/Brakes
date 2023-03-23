package com.envoydigital.brakes.storefront.controllers.pages;

import com.envoydigital.brakes.facades.BrakesPromotionalProductFacade;
import com.envoydigital.brakes.facades.constants.BrakesFacadesConstants;
import com.envoydigital.brakes.facades.user.BrakesUserFacade;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractSearchPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commercefacades.search.data.SearchQueryData;
import de.hybris.platform.commercefacades.search.data.SearchStateData;
import de.hybris.platform.commerceservices.enums.SearchQueryContext;
import de.hybris.platform.commerceservices.search.facetdata.ProductSearchPageData;
import de.hybris.platform.commerceservices.search.pagedata.PageableData;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;


@Controller
@RequestMapping(value =
{ "/my-promo-products","/promotions"})
public class MyPromotionalProductsController extends AbstractSearchPageController
{
	private static final Logger LOG = LoggerFactory.getLogger(MyPromotionalProductsController.class);

	private static final String REDIRECT_HOMEPAGE_URL = REDIRECT_PREFIX + "/";

	private static final String DEFAULT_SORT_CODE = "price-desc";

	private static final String MY_PROMO_PRODUCTS_CMS_PAGE_ID = "myPromoProducts";

	private static final String MY_PROMO_PRODUCTS_CC_PAGINATION_URL = "/my-promo-products/getPromoProducts?";
	
	private static final String MY_PROMO_PRODUCTS_BRAKES_PAGINATION_URL = "/promotions/monthly-promotions?";

	@Resource
	private BrakesPromotionalProductFacade brakesPromotionalProductFacade;


	@Resource
	private BrakesUserFacade brakesUserFacade;

	@RequestMapping(value = {"/getPromoProducts","/monthly-promotions"}, method = RequestMethod.GET)
	public String getPromoProducts(@RequestParam(value = "q", defaultValue = " ")
								   final String searchQuery, @RequestParam(value = "page", defaultValue = "0")
								   final int page, @RequestParam(value = "show", defaultValue = "Page")
								   final ShowMode showMode, @RequestParam(value = "sort", defaultValue = DEFAULT_SORT_CODE, required = false)
								   final String sortCode, @RequestParam(value = "text", required = false)
								   final String searchText, final HttpServletRequest request, final Model model) throws CMSItemNotFoundException
	{
		if (!brakesUserFacade.isUserEligibleForPromotion())
		{
			return REDIRECT_HOMEPAGE_URL;
		}
		final ProductSearchPageData<SearchStateData, ProductData> searchPageData = performSearch(searchQuery, page, showMode,
				sortCode, getSearchPageSize(), request);

		populateModel(model, searchPageData, showMode);

		final ContentPageModel cmsPage = getContentPageForLabelOrId(MY_PROMO_PRODUCTS_CMS_PAGE_ID);
		storeContinueUrl(request);
		updatePageTitle(cmsPage, model);
		storeCmsPageInModel(model, cmsPage);


		return getViewForPage(model);
	}

	@ResponseBody
	@RequestMapping(value = "/resultsandfacets", method = RequestMethod.GET)
	public ProductSearchPageData<SearchStateData, ProductData> getResultsAndFacets(
			@RequestParam(value = "q", required = false) final String searchQuery,
			@RequestParam(value = "page", defaultValue = "1") final int page,
			@RequestParam(value = "show", defaultValue = "Page") final ShowMode showMode,
			@RequestParam(value = "sort", required = false) final String sortCode, final HttpServletRequest request) throws UnsupportedEncodingException
	{
		return performSearch(searchQuery, page, showMode, sortCode, getSearchPageSize(),request);
	}



	protected ProductSearchPageData<SearchStateData, ProductData> performSearch(final String searchQuery, final int page,
																				final ShowMode showMode, final String sortCode, final int pageSize, final HttpServletRequest request)
	{

		final int emendPageValue = getEmendPageValue(page);
		final PageableData pageableData = createPageableData(emendPageValue, pageSize, sortCode, showMode);

		final SearchStateData searchState = new SearchStateData();
		final SearchQueryData searchQueryData = new SearchQueryData();
		searchQueryData.setSearchQueryContext(SearchQueryContext.PROMOTION);
		searchQueryData.setValue(searchQuery);
		searchState.setQuery(searchQueryData);
		String url=null;
		final ProductSearchPageData<SearchStateData, ProductData> productSearchPageData = encodeSearchPageData(
				getBrakesPromotionalProductFacade().getPromotionalProducts(searchState, pageableData));

		//Setting The Search Query Data from current query, which is getting encoded after above call
		if(null != productSearchPageData.getCurrentQuery()
				&& null != productSearchPageData.getCurrentQuery().getQuery()
				&& StringUtils.isNotEmpty(productSearchPageData.getCurrentQuery().getQuery().getValue())) {
			searchQueryData.setValue(productSearchPageData.getCurrentQuery().getQuery().getValue());
			if(getSiteUid().equalsIgnoreCase(BrakesFacadesConstants.SITE_BRAKES)) {
				url = MY_PROMO_PRODUCTS_BRAKES_PAGINATION_URL;
			}else {
				url = MY_PROMO_PRODUCTS_CC_PAGINATION_URL;
			}
			searchState.setPaginationUrl(url+"q=" + productSearchPageData.getCurrentQuery().getQuery().getValue());
			searchState.setUrl(request.getRequestURI()+"?"+productSearchPageData.getCurrentQuery().getQuery().getValue());
		}else{
			searchState.setPaginationUrl(url);
			searchState.setUrl(request.getRequestURI());
		}

		productSearchPageData.getPagination().setCurrentPage(emendPageValue + 1);
		productSearchPageData.setCurrentQuery(searchState);

		return productSearchPageData;
	}

	private int getEmendPageValue(final int page)
	{
		if (page > 0)
		{
			return page - 1;
		}
		else
		{
			return 0;
		}
	}




	protected void updatePageTitle(final ContentPageModel cmsPage, final Model model)
	{
		storeContentPageTitleInModel(model, cmsPage.getTitle());
	}

	/**
	 * @return the brakesPromotionalProductFacade
	 */
	public BrakesPromotionalProductFacade getBrakesPromotionalProductFacade()
	{
		return brakesPromotionalProductFacade;
	}

	/**
	 * @param brakesPromotionalProductFacade
	 *           the brakesPromotionalProductFacade to set
	 */
	public void setBrakesPromotionalProductFacade(final BrakesPromotionalProductFacade brakesPromotionalProductFacade)
	{
		this.brakesPromotionalProductFacade = brakesPromotionalProductFacade;
	}

	/**
	 * @return the brakesUserFacade
	 */
	public BrakesUserFacade getBrakesUserFacade()
	{
		return brakesUserFacade;
	}


	/**
	 * @param brakesUserFacade
	 *           the brakesUserFacade to set
	 */
	public void setBrakesUserFacade(final BrakesUserFacade brakesUserFacade)
	{
		this.brakesUserFacade = brakesUserFacade;
	}
}
