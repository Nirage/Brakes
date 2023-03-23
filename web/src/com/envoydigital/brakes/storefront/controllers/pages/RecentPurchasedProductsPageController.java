package com.envoydigital.brakes.storefront.controllers.pages;


import com.envoydigital.brakes.core.enums.RecentPurchasesFilterOption;
import com.envoydigital.brakes.facades.BrakesCompanyFacade;
import com.envoydigital.brakes.facades.BrakesCustomerFacade;
import de.hybris.platform.acceleratorservices.config.SiteConfigService;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractSearchPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.AbstractPageModel;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commercefacades.search.data.SearchQueryData;
import de.hybris.platform.commercefacades.search.data.SearchStateData;
import de.hybris.platform.commerceservices.enums.SearchQueryContext;
import de.hybris.platform.commerceservices.search.facetdata.ProductSearchPageData;
import de.hybris.platform.commerceservices.search.pagedata.PageableData;
import de.hybris.platform.commerceservices.search.pagedata.SortData;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.envoydigital.brakes.facades.BrakesRecentProductsSolrSearchFacade;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;


@Controller
@RequestMapping("/my-account/recent-purchased-products")
public class RecentPurchasedProductsPageController extends AbstractSearchPageController
{
	private static final String DEFAULT_SORT_CODE = "relevance";

	private static final String MY_RECENT_PURCASE_PRODUCTS_PAGINATION_URL = "/my-account/recent-purchased-products?";
	private static final int WEEKS_IN_PAST_MIN = 1;
	private static final int WEEKS_IN_PAST_MAX = 8;
	private static final int WEEKS_IN_PAST_STEP = 1;



	@Resource(name = "brakesRecentProductsSolrSearchFacade")
	private BrakesRecentProductsSolrSearchFacade brakesRecentProductsSolrSearchFacade;

	@Resource(name = "siteConfigService")
	private SiteConfigService siteConfigService;

	@Resource(name = "brakesCompanyFacade")
	private BrakesCompanyFacade brakesCompanyFacade;

	@Resource(name = "brakesCustomerFacade")
    private BrakesCustomerFacade brakesCustomerFacade;

	@RequestMapping(method = RequestMethod.GET)
	public String getPurchasedProductsPage(@RequestParam(value = "q", defaultValue = " ")
	final String searchQuery, @RequestParam(value = "weeksInPast", defaultValue = "4") final int weeksInPast,
	@RequestParam(value = "page", defaultValue = "0")
	final int page, @RequestParam(value = "show", defaultValue = "Page")
	final ShowMode showMode, @RequestParam(value = "sort", defaultValue = DEFAULT_SORT_CODE, required = false)
	final String sortCode, @RequestParam(value = "text", required = false)
	final String searchText,  @RequestParam(value = "filterOption", required = false) final String filterOption,
										   HttpServletRequest request, final Model model

	) throws CMSItemNotFoundException
	{
		storeCmsPageInModel(model, getCmsPage());
		setUpMetaDataForContentPage(model, (ContentPageModel) getCmsPage());
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
		final ProductSearchPageData<SearchStateData, ProductData> searchPageData = performSearch(searchQuery, page, showMode,
				sortCode, getSearchPageSize(), request, weeksInPast, filterOption);

		populateModel(model, searchPageData, showMode);
		model.addAttribute("currentWeeksInPast", Integer.toString(weeksInPast));
		model.addAttribute("sorts", populateWeeksInPastFilter());
		model.addAttribute("filterOptions", brakesCompanyFacade.getRecentPurchasesFilterOptions());
        model.addAttribute("selectedFilterOption", brakesCustomerFacade.getCurrentCustomer().getRecentPurchasedFilterOption());
		return getViewForPage(model);
	}



	protected ProductSearchPageData<SearchStateData, ProductData> performSearch(final String searchQuery, final int page,
			final ShowMode showMode, final String sortCode, final int pageSize, final HttpServletRequest request,
			final int weeksInPast, final String filterOption)
	{

		final int emendPageValue = getEmendPageValue(page);
		final PageableData pageableData = createPageableData(emendPageValue, pageSize, sortCode, showMode);

		final SearchStateData searchState = new SearchStateData();
		final SearchQueryData searchQueryData = new SearchQueryData();
		searchQueryData.setSearchQueryContext(SearchQueryContext.RECENT_PURCHASED);
		searchQueryData.setValue(searchQuery);
		searchState.setQuery(searchQueryData);

		ProductSearchPageData<SearchStateData, ProductData> productSearchPageData;
		if(null != filterOption && filterOption.equals(RecentPurchasesFilterOption.OWN.getCode())) {

			productSearchPageData = encodeSearchPageData(
					getBrakesRecentProductsSolrSearchFacade().getRecentPurchaseProducts(searchState, pageableData, weeksInPast,
							ControllerConstants.RecentPurchasedProducts.MAX_COUNT_PRODUCTS_UNLIMITED));
		} else {

			productSearchPageData = encodeSearchPageData(
					getBrakesRecentProductsSolrSearchFacade().getRecentPurchaseProductsByUnit(searchState, pageableData, weeksInPast,
							ControllerConstants.RecentPurchasedProducts.MAX_COUNT_PRODUCTS_UNLIMITED));

		}

		//Setting The Search Query Data from current query, which is getting encoded after above call
		if (null != productSearchPageData && null != productSearchPageData.getCurrentQuery() && null != productSearchPageData.getCurrentQuery().getQuery()
				&& StringUtils.isNotEmpty(productSearchPageData.getCurrentQuery().getQuery().getValue()))
		{
			searchQueryData.setValue(productSearchPageData.getCurrentQuery().getQuery().getValue());
			searchState.setPaginationUrl(
					MY_RECENT_PURCASE_PRODUCTS_PAGINATION_URL + "q=" + productSearchPageData.getCurrentQuery().getQuery().getValue()
							+ "&weeksInPast=" + weeksInPast);
			searchState.setUrl(request.getRequestURI() + "?" + productSearchPageData.getCurrentQuery().getQuery().getValue());
		}
		else
		{
			searchState.setPaginationUrl(MY_RECENT_PURCASE_PRODUCTS_PAGINATION_URL);
			searchState.setUrl(request.getRequestURI());
		}

		if(null != productSearchPageData) {
			productSearchPageData.getPagination().setCurrentPage(emendPageValue + 1);
			productSearchPageData.setCurrentQuery(searchState);
		}

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


	@ResponseBody
	@RequestMapping(value = "/resultsandfacets", method = RequestMethod.GET)
	public ProductSearchPageData<SearchStateData, ProductData> getResultsAndFacets(@RequestParam(value = "q", required = false)
	final String searchQuery, @RequestParam(value = "weeksInPast", defaultValue = "1")
	final int weeksInPast, @RequestParam(value = "page", defaultValue = "1")
	final int page, @RequestParam(value = "show", defaultValue = "Page")
	final ShowMode showMode, @RequestParam(value = "sort", required = false)
	final String sortCode, @RequestParam(value = "filerOption", required = false) final String filerOption, final HttpServletRequest request) throws UnsupportedEncodingException
	{
		return performSearch(searchQuery, page, showMode, sortCode, getSearchPageSize(), request, weeksInPast, filerOption);
	}



	private List<SortData> populateWeeksInPastFilter()
	{
		final int weeksInPastMin = siteConfigService.getInt("storefront.recentpurchasedproducts.weeksInPast.min",
				WEEKS_IN_PAST_MIN);
		final int weeksInPastMax = siteConfigService.getInt("storefront.recentpurchasedproducts.weeksInPast.max",
				WEEKS_IN_PAST_MAX);
		final int weeksInPastStep = siteConfigService.getInt("storefront.recentpurchasedproducts.weeksInPast.step",
				WEEKS_IN_PAST_STEP);
		final List<SortData> weeksInPastFilterOptions = new ArrayList<>();
		for (int i = weeksInPastMin; i <= weeksInPastMax; i += weeksInPastStep)
		{
			final SortData weeksInPastFilterOption = new SortData();
			weeksInPastFilterOption.setCode(Integer.toString(i));
			weeksInPastFilterOptions.add(weeksInPastFilterOption);
		}
		return weeksInPastFilterOptions;
	}

	private AbstractPageModel getCmsPage() throws CMSItemNotFoundException
	{
		return getContentPageForLabelOrId("recentPurchasedProductsPage");
	}


	/**
	 * @return the brakesRecentProductsSolrSearchFacade
	 */
	public BrakesRecentProductsSolrSearchFacade getBrakesRecentProductsSolrSearchFacade()
	{
		return brakesRecentProductsSolrSearchFacade;
	}



	/**
	 * @param brakesRecentProductsSolrSearchFacade
	 *           the brakesRecentProductsSolrSearchFacade to set
	 */
	public void setBrakesRecentProductsSolrSearchFacade(
			final BrakesRecentProductsSolrSearchFacade brakesRecentProductsSolrSearchFacade)
	{
		this.brakesRecentProductsSolrSearchFacade = brakesRecentProductsSolrSearchFacade;
	}



}
