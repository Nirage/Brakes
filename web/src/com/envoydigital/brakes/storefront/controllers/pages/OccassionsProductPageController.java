/**
 *
 */
package com.envoydigital.brakes.storefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractSearchPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commercefacades.search.data.SearchQueryData;
import de.hybris.platform.commercefacades.search.data.SearchStateData;
import de.hybris.platform.commerceservices.enums.SearchQueryContext;
import de.hybris.platform.commerceservices.search.facetdata.ProductSearchPageData;
import de.hybris.platform.commerceservices.search.pagedata.PageableData;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.envoydigital.brakes.facades.BrakesOccasionProductFacade;
import com.envoydigital.brakes.storefront.util.EnhancedXssFilterUtil;


@Controller
@RequestMapping("/occasions")
public class OccassionsProductPageController extends AbstractSearchPageController
{
	private static final String PRODUCT_TILE_COMPONENT_CODE = "{code:.*}";
	private static final String DEFAULT_SORT_CODE = "price-desc";
	private static final String OCCASIONS_PRODUCTS_CMS_PAGE_ID = "OccasionsSearchGrid";
	private static final String OCCASIONS_PRODUCTS_PAGINATION_URL = "/occasions/";

	@Resource(name = "brakesOccasionProductFacade")
	private BrakesOccasionProductFacade brakesOccasionProductFacade;

	@RequestMapping(value = "/" + PRODUCT_TILE_COMPONENT_CODE, method = RequestMethod.GET)
	public String getPromoProducts(@RequestParam(value = "q", defaultValue = " ")
	final String searchQuery, @RequestParam(value = "page", defaultValue = "0")
	final int page, @RequestParam(value = "show", defaultValue = "Page")
	final ShowMode showMode, @RequestParam(value = "sort", defaultValue = DEFAULT_SORT_CODE, required = false)
	final String sortCode, @PathVariable("code")
	final String code, final HttpServletRequest request, final Model model) throws CMSItemNotFoundException
	{
		final ProductSearchPageData<SearchStateData, ProductData> searchPageData = performSearch(code, searchQuery, page, showMode,
				sortCode, getSearchPageSize(), request);

		populateModel(model, searchPageData, showMode);

		final ContentPageModel cmsPage = getContentPageForLabelOrId(OCCASIONS_PRODUCTS_CMS_PAGE_ID);
		storeContinueUrl(request);
		updatePageTitle(cmsPage, model);
		storeCmsPageInModel(model, cmsPage);


		return getViewForPage(model);
	}

	@ResponseBody
	@RequestMapping(value = "/" + PRODUCT_TILE_COMPONENT_CODE + "/resultsandfacets", method = RequestMethod.GET)
	public ProductSearchPageData<SearchStateData, ProductData> getResultsAndFacets(@RequestParam("q")
	final String searchQuery, @RequestParam(value = "page", defaultValue = "1")
	final int page, @RequestParam(value = "show", defaultValue = "Page")
	final ShowMode showMode, @RequestParam(value = "sort", required = false)
	final String sortCode, @PathVariable("code")
	final String code, final HttpServletRequest request) throws CMSItemNotFoundException
	{
		final String sanitizedSearchQuery = EnhancedXssFilterUtil.filter(searchQuery);
		return performSearch(code, sanitizedSearchQuery, page, showMode, sortCode, getSearchPageSize(), request);

	}

	protected void updatePageTitle(final ContentPageModel cmsPage, final Model model)
	{
		storeContentPageTitleInModel(model, cmsPage.getTitle());
	}

	protected ProductSearchPageData<SearchStateData, ProductData> performSearch(final String code, final String searchQuery,
			final int page,
			final ShowMode showMode, final String sortCode, final int pageSize, final HttpServletRequest request)
	{

		final int emendPageValue = getEmendPageValue(page);
		final PageableData pageableData = createPageableData(emendPageValue, pageSize, sortCode, showMode);

		final SearchStateData searchState = new SearchStateData();
		final SearchQueryData searchQueryData = new SearchQueryData();
		searchQueryData.setSearchQueryContext(SearchQueryContext.OCCASSIONS);
		searchQueryData.setValue(searchQuery);
		searchState.setQuery(searchQueryData);

		final ProductSearchPageData<SearchStateData, ProductData> productSearchPageData = encodeSearchPageData(
				brakesOccasionProductFacade.getOccasionProducts(code, searchState, pageableData));

		//Setting The Search Query Data from current query, which is getting encoded after above call
		if (null != productSearchPageData.getCurrentQuery() && null != productSearchPageData.getCurrentQuery().getQuery()
				&& StringUtils.isNotEmpty(productSearchPageData.getCurrentQuery().getQuery().getValue()))
		{
			searchQueryData.setValue(productSearchPageData.getCurrentQuery().getQuery().getValue());
			searchState.setPaginationUrl(
					OCCASIONS_PRODUCTS_PAGINATION_URL + code + "?q=" + productSearchPageData.getCurrentQuery().getQuery().getValue());
			searchState.setUrl(request.getRequestURI() + "?" + productSearchPageData.getCurrentQuery().getQuery().getValue());
		}
		else
		{
			searchState.setPaginationUrl(request.getRequestURI());
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
}
