package com.envoydigital.brakes.brakesaddon.controllers.pages;

import de.hybris.platform.acceleratorservices.controllers.page.PageType;
import de.hybris.platform.acceleratorservices.data.RequestContextData;
import de.hybris.platform.acceleratorstorefrontcommons.constants.WebConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractCategoryPageController;
import de.hybris.platform.acceleratorstorefrontcommons.util.MetaSanitizerUtil;
import de.hybris.platform.category.model.CategoryModel;
import de.hybris.platform.cms2.model.pages.CategoryPageModel;
import de.hybris.platform.commercefacades.product.data.CategoryData;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commercefacades.search.data.SearchQueryData;
import de.hybris.platform.commercefacades.search.data.SearchStateData;
import de.hybris.platform.commerceservices.enums.SearchQueryContext;
import de.hybris.platform.commerceservices.search.facetdata.FacetRefinement;
import de.hybris.platform.commerceservices.search.facetdata.ProductCategorySearchPageData;
import de.hybris.platform.commerceservices.search.pagedata.PageableData;
import de.hybris.platform.commerceservices.search.pagedata.SearchPageData;
import de.hybris.platform.commerceservices.url.UrlResolver;
import de.hybris.platform.servicelayer.dto.converter.ConversionException;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.ui.Model;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.util.Optional;
import java.util.stream.Collectors;


/**
 * @author thomas.domin
 */
public class AbstractBrakesCategoryPageController extends AbstractCategoryPageController
{


	@Resource(name = "facetCategoryModelUrlResolver")
	private UrlResolver<CategoryModel> categoryModelUrlResolver;


	@Override
	protected String performSearchAndGetResultsPage(final String categoryCode, final String searchQuery, final int page,
			final ShowMode showMode, final String sortCode, final Model model, final HttpServletRequest request,
			final HttpServletResponse response) throws UnsupportedEncodingException
	{
		final int emendPageValue = getEmendPageValue(page);
		final CategoryModel category = getCommerceCategoryService().getCategoryForCode(categoryCode);

		final String redirection = checkRequestUrl(request, response, getCategoryModelUrlResolver().resolve(category));
		if (StringUtils.isNotEmpty(redirection))
		{
			return redirection;
		}

		final CategoryPageModel categoryPage = getCategoryPage(category);

		final DirectCategorySearchEvaluator categorySearch = new DirectCategorySearchEvaluator(categoryCode, searchQuery, emendPageValue,
				showMode,
				sortCode, categoryPage);

		ProductCategorySearchPageData<SearchStateData, ProductData, CategoryData> searchPageData = null;
		try
		{
			categorySearch.doSearch();
			searchPageData = categorySearch.getSearchPageData();
		}
		catch (final ConversionException e) // NOSONAR
		{
			searchPageData = createEmptySearchResult(categoryCode);
		}

		final boolean showCategoriesOnly = categorySearch.isShowCategoriesOnly();

		storeCmsPageInModel(model, categorySearch.getCategoryPage());
		storeContinueUrl(request);

		populateModel(model, searchPageData, showMode);
		model.addAttribute(WebConstants.BREADCRUMBS_KEY, getSearchBreadcrumbBuilder().getBreadcrumbs(categoryCode, searchPageData));
		model.addAttribute("showCategoriesOnly", Boolean.valueOf(showCategoriesOnly));
		model.addAttribute("categoryName", category.getName());
		model.addAttribute("pageType", PageType.CATEGORY.name());
		model.addAttribute("userLocation", getCustomerLocationService().getUserLocation());

		updatePageTitle(category, model);

		final RequestContextData requestContextData = getRequestContextData(request);
		requestContextData.setCategory(category);
		requestContextData.setSearch(searchPageData);

		if (searchQuery != null)
		{
			model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_FOLLOW);
		}

		final String metaKeywords = MetaSanitizerUtil.sanitizeKeywords(
				category.getKeywords().stream().map(keywordModel -> keywordModel.getKeyword()).collect(Collectors.toSet()));
		final String metaDescription = MetaSanitizerUtil.sanitizeDescription(category.getDescription());
		setUpMetaData(model, metaKeywords, metaDescription);

		final String viewPage = getViewPage(categorySearch.getCategoryPage());

		Optional.ofNullable((SearchPageData) model.asMap().get("searchPageData")).map(SearchPageData::getPagination)
				.ifPresent(p -> p.setCurrentPage(emendPageValue + 1));

		return viewPage;
	}

	@Override
	protected FacetRefinement<SearchStateData> performSearchAndGetFacets(final String categoryCode, final String searchQuery,
			final int page, final ShowMode showMode, final String sortCode)
	{
		return super.performSearchAndGetFacets(categoryCode, searchQuery, getEmendPageValue(page), showMode, sortCode);
	}

	@Override
	protected SearchResultsData<ProductData> performSearchAndGetResultsData(final String categoryCode, final String searchQuery,
			final int page, final ShowMode showMode, final String sortCode)
	{
		final int emendPageValue = getEmendPageValue(page);
		final SearchResultsData<ProductData> productDataSearchResultsData = super.performSearchAndGetResultsData(categoryCode,
				searchQuery, emendPageValue, showMode, sortCode);

		Optional.ofNullable(productDataSearchResultsData).map(SearchResultsData::getPagination)
				.ifPresent(p -> p.setCurrentPage(emendPageValue + 1));

		return productDataSearchResultsData;
	}


	@Override
	protected ProductCategorySearchPageData<SearchStateData, ProductData, CategoryData> populateSearchPageData(
			final String categoryCode, final String searchQuery, final int page, final ShowMode showMode, final String sortCode)
	{
		final int emendPageValue = getEmendPageValue(page);
		final ProductCategorySearchPageData<SearchStateData, ProductData, CategoryData> productCategorySearchPageData = super.populateSearchPageData(
				categoryCode, searchQuery, emendPageValue, showMode, sortCode);
		Optional.ofNullable(productCategorySearchPageData).map(ProductCategorySearchPageData::getPagination)
				.ifPresent(p -> p.setCurrentPage(emendPageValue + 1));

		return productCategorySearchPageData;
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

	/**
	 * @return the categoryModelUrlResolver
	 */
	@Override
	public UrlResolver<CategoryModel> getCategoryModelUrlResolver()
	{
		return categoryModelUrlResolver;
	}

	/**
	 *  This evaluator is used for direct queries with category code , with using SearchQueryContext
	 */
	protected class DirectCategorySearchEvaluator
	{
		private final String categoryCode;
		private final SearchQueryData searchQueryData = new SearchQueryData();
		private final int page;
		private final ShowMode showMode;
		private final String sortCode;
		private CategoryPageModel categoryPage;
		private boolean showCategoriesOnly;
		private ProductCategorySearchPageData<SearchStateData, ProductData, CategoryData> searchPageData;

		public DirectCategorySearchEvaluator(final String categoryCode, final String searchQuery, final int page, final ShowMode showMode,
									   final String sortCode, final CategoryPageModel categoryPage)
		{
			this.categoryCode = categoryCode;
			this.searchQueryData.setValue(searchQuery);
			this.page = page;
			this.showMode = showMode;
			this.sortCode = sortCode;
			this.categoryPage = categoryPage;
		}

		public void doSearch() {
			showCategoriesOnly = false;
			searchQueryData.setSearchQueryContext(SearchQueryContext.CATEGORY_PAGE);
			if (searchQueryData.getValue() == null) {
				// Direct category link without filtering using SearchQueryContext
				searchPageData = getProductSearchFacade().categorySearch(categoryCode, SearchQueryContext.CATEGORY_PAGE);
				if (categoryPage != null) {
					showCategoriesOnly = !categoryHasDefaultPage(categoryPage)
							&& CollectionUtils.isNotEmpty(searchPageData.getSubCategories());
				}
			}else
			{
				// We have some search filtering
				if (categoryPage == null || !categoryHasDefaultPage(categoryPage))
				{
					// Load the default category page
					categoryPage = getDefaultCategoryPage();
				}

				final SearchStateData searchState = new SearchStateData();
				searchState.setQuery(searchQueryData);

				final PageableData pageableData = createPageableData(page, getSearchPageSize(), sortCode, showMode);
				searchPageData = getProductSearchFacade().categorySearch(categoryCode, searchState, pageableData);

			}

			//Encode SearchPageData
			if(null != searchPageData) {
				searchPageData = (ProductCategorySearchPageData) encodeSearchPageData(searchPageData);
			}
		}

		public int getPage()
		{
			return page;
		}

		public CategoryPageModel getCategoryPage()
		{
			return categoryPage;
		}

		public boolean isShowCategoriesOnly()
		{
			return showCategoriesOnly;
		}

		public ProductCategorySearchPageData<SearchStateData, ProductData, CategoryData> getSearchPageData()
		{
			return searchPageData;
		}

	}

}
