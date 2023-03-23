
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

import de.hybris.platform.acceleratorcms.model.components.SearchBoxComponentModel;
import de.hybris.platform.acceleratorservices.controllers.page.PageType;
import de.hybris.platform.acceleratorservices.customer.CustomerLocationService;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.impl.SearchBreadcrumbBuilder;
import de.hybris.platform.acceleratorstorefrontcommons.constants.WebConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractSearchPageController;
import de.hybris.platform.acceleratorstorefrontcommons.util.MetaSanitizerUtil;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import de.hybris.platform.cms2.servicelayer.services.CMSComponentService;
import de.hybris.platform.commercefacades.order.CartFacade;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commercefacades.search.data.AutocompleteResultData;
import de.hybris.platform.commercefacades.search.data.SearchQueryData;
import de.hybris.platform.commercefacades.search.data.SearchStateData;
import de.hybris.platform.commerceservices.enums.SearchQueryContext;
import de.hybris.platform.commerceservices.search.facetdata.FacetData;
import de.hybris.platform.commerceservices.search.facetdata.FacetRefinement;
import de.hybris.platform.commerceservices.search.facetdata.FacetValueData;
import de.hybris.platform.commerceservices.search.facetdata.ProductSearchPageData;
import de.hybris.platform.commerceservices.search.pagedata.PageableData;
import de.hybris.platform.commerceservices.search.pagedata.PaginationData;
import de.hybris.platform.servicelayer.dto.converter.ConversionException;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.envoydigital.brakes.core.search.data.CategorySuggestData;
import com.envoydigital.brakes.core.services.BrakesProductService;
import com.envoydigital.brakes.facades.search.solrfacetsearch.BrakesProductSearchFacade;
import com.envoydigital.brakes.storefront.util.EnhancedXssFilterUtil;
import com.sap.security.core.server.csi.XSSEncoder;



@Controller
@RequestMapping("/search")
public class SearchPageController extends AbstractSearchPageController
{
	private static final String SEARCH_META_DESCRIPTION_ON = "search.meta.description.on";
	private static final String SEARCH_META_DESCRIPTION_RESULTS = "search.meta.description.results";
	private static final String LEVEL_ONE_CATEGORIES = "levelOneCategories";

	@SuppressWarnings("unused")
	private static final Logger LOG = LoggerFactory.getLogger(SearchPageController.class);

	private static final String COMPONENT_UID_PATH_VARIABLE_PATTERN = "{componentUid:.*}";
	private static final String FACET_SEPARATOR = ":";

	private static final String SEARCH_CMS_PAGE_ID = "search";
	private static final String NO_RESULTS_CMS_PAGE_ID = "searchEmpty";
	private static final String REFERER = "referer";

	@Resource(name = "productSearchFacade")
	private BrakesProductSearchFacade<ProductData> productSearchFacade;

	@Resource(name = "searchBreadcrumbBuilder")
	private SearchBreadcrumbBuilder searchBreadcrumbBuilder;

	@Resource(name = "customerLocationService")
	private CustomerLocationService customerLocationService;

	@Resource(name = "cmsComponentService")
	private CMSComponentService cmsComponentService;

	@Resource(name = "cartFacade")
	private CartFacade cartFacade;

	@Resource(name = "productService")
	private BrakesProductService productService;

	@RequestMapping(method = RequestMethod.GET, params = "!q")
	public String textSearch(@RequestParam(value = "text", defaultValue = "")
	final String searchText, final HttpServletRequest request , final HttpServletResponse response, final Model model, final RedirectAttributes redirectAttributes) throws CMSItemNotFoundException
	{
		final String sanitizedSearchText = EnhancedXssFilterUtil.filter(searchText);
		if (StringUtils.isNotBlank(sanitizedSearchText))
		{
			final int emendPageValue = getEmendPageValue(1);
			final PageableData pageableData = createPageableData(emendPageValue, getSearchPageSize(), null, ShowMode.Page);

			final SearchStateData searchState = new SearchStateData();
			final SearchQueryData searchQueryData = new SearchQueryData();
			searchQueryData.setValue(sanitizedSearchText);
			searchState.setQuery(searchQueryData);

			ProductSearchPageData<SearchStateData, ProductData> searchPageData = null;
			try
			{
				searchPageData = encodeSearchPageData(productSearchFacade.textSearch(searchState, pageableData));
				searchPageData.getPagination().setCurrentPage(emendPageValue + 1);
				productSearchFacade.populateSuggestions(searchPageData, XSSEncoder.encodeHTML(sanitizedSearchText));
			}
			catch (final ConversionException | UnsupportedEncodingException | UnknownIdentifierException e) // NOSONAR
			{
				searchPageData = new ProductSearchPageData<>();
				final PaginationData paginationData = new PaginationData();
				paginationData.setTotalNumberOfResults(0);
				searchPageData.setPagination(paginationData);
				searchPageData.setFreeTextSearch(sanitizedSearchText);
			}

			if (searchPageData.getKeywordRedirectUrl() != null)
			{
				// if the search engine returns a redirect, just
				return "redirect:" + getKeywordRedirectUrl(searchPageData, request);
			}
			else if (searchPageData.getPagination().getTotalNumberOfResults() == 0)
			{
				final ContentPageModel cmsPage = getContentPageForLabelOrId(NO_RESULTS_CMS_PAGE_ID);
				model.addAttribute("searchPageData", searchPageData);
				storeCmsPageInModel(model, cmsPage);
				updatePageTitle(cmsPage, model);
			}
			else if (searchPageData.getPagination().getTotalNumberOfResults() == 1)
			{

				final ProductData productData = searchPageData.getResults().get(0);
				try
				{
					redirectAttributes.addAttribute("term", searchText);
					return "redirect:" + productData.getUrl();
				}
				catch (final UnknownIdentifierException e)
				{
					final ContentPageModel cmsPage = getContentPageForLabelOrId(NO_RESULTS_CMS_PAGE_ID);
					model.addAttribute("searchPageData", searchPageData);
					storeCmsPageInModel(model, cmsPage);
					updatePageTitle(cmsPage, model);
				}

			}
			else
			{

				final ContentPageModel cmsPage = getContentPageForLabelOrId(SEARCH_CMS_PAGE_ID);
				storeContinueUrl(request);
				populateModel(model, searchPageData, ShowMode.Page);
				storeCmsPageInModel(model, cmsPage);
				updatePageTitle(cmsPage, model);
			}
			model.addAttribute("userLocation", customerLocationService.getUserLocation());
			getRequestContextData(request).setSearch(searchPageData);
			model.addAttribute(WebConstants.BREADCRUMBS_KEY, searchBreadcrumbBuilder.getBreadcrumbs(null, sanitizedSearchText,
					CollectionUtils.isEmpty(searchPageData.getBreadcrumbs())));

		}
		else
		{
			storeCmsPageInModel(model, getContentPageForLabelOrId(NO_RESULTS_CMS_PAGE_ID));
		}
		model.addAttribute("pageType", PageType.PRODUCTSEARCH.name());
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_FOLLOW);

		final String metaKeywords = MetaSanitizerUtil.sanitizeKeywords(sanitizedSearchText);
		setUpMetaData(model, metaKeywords,
				MetaSanitizerUtil.sanitizeDescription(getContentPageForLabelOrId(SEARCH_CMS_PAGE_ID).getMetaDescription()));

		final RequestCache requestCache = new HttpSessionRequestCache();
		requestCache.saveRequest(request, response);
		return getViewForPage(model);
	}

	/**
	 * To remove unwanted characters used by FE js scripts for spaces
	 *
	 * @param searchText
	 * @return
	 */
	private String sanitizeSearchText(final String searchText) {

		return searchText.replaceAll("(&amp;)|(amp&#x3b;)|(x20&#x3b;)|(x20&amp;)|(x3b&#x3b;)", " ").replaceAll("\\s+", " ");
	}

	private String getKeywordRedirectUrl(final ProductSearchPageData<SearchStateData, ProductData> searchPageData,
			final HttpServletRequest request)
	{
		if (StringUtils.equals(searchPageData.getKeywordRedirectUrl(), REFERER))
		{
			return request.getHeader(REFERER);
		}
		else
		{
			return searchPageData.getKeywordRedirectUrl();
		}
	}

	@RequestMapping(method = RequestMethod.GET, params = "q")
	public String refineSearch(@RequestParam("q")
	final String searchQuery, @RequestParam(value = "page", defaultValue = "1")
	final int page, @RequestParam(value = "show", defaultValue = "Page")
	final ShowMode showMode, @RequestParam(value = "sort", required = false)
	final String sortCode, @RequestParam(value = "text", required = false)
	final String searchText, final HttpServletRequest request, final Model model) throws CMSItemNotFoundException
	{
		final String sanitizedSearchText = EnhancedXssFilterUtil.filter(searchText);
		final String sanitizedSearchQuery = EnhancedXssFilterUtil.filter(searchQuery);
		final ProductSearchPageData<SearchStateData, ProductData> searchPageData = performSearch(sanitizedSearchQuery, page, showMode,
				sortCode, getSearchPageSize());
		//productSearchFacade.populateSuggestions(searchPageData, searchText);

		searchPageData.setFreeTextSearch(sanitizeSearchText(searchPageData.getFreeTextSearch()));
		populateModel(model, searchPageData, showMode);
		model.addAttribute("userLocation", customerLocationService.getUserLocation());

		if (searchPageData.getPagination().getTotalNumberOfResults() == 0)
		{
			final ContentPageModel cmsPage = getContentPageForLabelOrId(NO_RESULTS_CMS_PAGE_ID);
			updatePageTitle(cmsPage, model);
			storeCmsPageInModel(model, cmsPage);
		}
		else
		{
			final ContentPageModel cmsPage = getContentPageForLabelOrId(SEARCH_CMS_PAGE_ID);
			storeContinueUrl(request);
			updatePageTitle(cmsPage, model);
			storeCmsPageInModel(model, cmsPage);
		}
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
		model.addAttribute(WebConstants.BREADCRUMBS_KEY, searchBreadcrumbBuilder.getBreadcrumbs(null, searchPageData));
		model.addAttribute("pageType", PageType.PRODUCTSEARCH.name());

		final String metaKeywords = MetaSanitizerUtil.sanitizeKeywords(sanitizedSearchText);
		setUpMetaData(model, metaKeywords,
				MetaSanitizerUtil.sanitizeDescription(getContentPageForLabelOrId(SEARCH_CMS_PAGE_ID).getMetaDescription()));

		return getViewForPage(model);
	}

	protected ProductSearchPageData<SearchStateData, ProductData> performSearch(final String searchQuery, final int page,
			final ShowMode showMode, final String sortCode, final int pageSize)
	{
		final int emendPageValue = getEmendPageValue(page);

		final PageableData pageableData = createPageableData(emendPageValue, pageSize, sortCode, showMode);

		final SearchStateData searchState = new SearchStateData();
		final SearchQueryData searchQueryData = new SearchQueryData();
		searchQueryData.setValue(searchQuery);
		searchState.setQuery(searchQueryData);

		final ProductSearchPageData<SearchStateData, ProductData> productSearchPageData = encodeSearchPageData(
				productSearchFacade.textSearch(searchState, pageableData));

		productSearchPageData.getPagination().setCurrentPage(emendPageValue + 1);

		return productSearchPageData;
	}

	@ResponseBody
	@RequestMapping(value = "/results", method = RequestMethod.GET)
	public ProductSearchPageData<SearchStateData, ProductData> jsonSearchResults(@RequestParam("q")
	final String searchQuery, @RequestParam(value = "page", defaultValue = "1")
	final int page, @RequestParam(value = "show", defaultValue = "Page")
	final ShowMode showMode, @RequestParam(value = "sort", required = false)
	final String sortCode) throws CMSItemNotFoundException
	{
		final String sanitizedSearchQuery = EnhancedXssFilterUtil.filter(searchQuery);
		final ProductSearchPageData<SearchStateData, ProductData> searchPageData = performSearch(sanitizedSearchQuery, page, showMode,
				sortCode, getSearchPageSize());

		return searchPageData;
	}


	@ResponseBody
	@RequestMapping(value = "/resultsandfacets", method = RequestMethod.GET)
	public ProductSearchPageData<SearchStateData, ProductData> getResultsAndFacets(@RequestParam("q")
	final String searchQuery, @RequestParam(value = "page", defaultValue = "1")
	final int page, @RequestParam(value = "show", defaultValue = "Page")
	final ShowMode showMode, @RequestParam(value = "sort", required = false)
	final String sortCode) throws CMSItemNotFoundException
	{
	   final String sanitizedSearchQuery = EnhancedXssFilterUtil.filter(searchQuery);
		return performSearch(sanitizedSearchQuery, page, showMode, sortCode, getSearchPageSize());

	}

	@ResponseBody
	@RequestMapping(value = "/facets", method = RequestMethod.GET)
	public FacetRefinement<SearchStateData> getFacets(@RequestParam("q")
	final String searchQuery, @RequestParam(value = "page", defaultValue = "1")
	final int page, @RequestParam(value = "show", defaultValue = "Page")
	final ShowMode showMode, @RequestParam(value = "sort", required = false)
	final String sortCode) throws CMSItemNotFoundException
	{
	   final String sanitizedSearchQuery = EnhancedXssFilterUtil.filter(searchQuery);
		final SearchStateData searchState = new SearchStateData();
		final SearchQueryData searchQueryData = new SearchQueryData();
		searchQueryData.setValue(sanitizedSearchQuery);
		searchState.setQuery(searchQueryData);

		final int emendPageValue = getEmendPageValue(page);
		final ProductSearchPageData<SearchStateData, ProductData> searchPageData = productSearchFacade.textSearch(searchState,
				createPageableData(emendPageValue, getSearchPageSize(), sortCode, showMode));
		searchPageData.getPagination().setCurrentPage(emendPageValue + 1);

		final List<FacetData<SearchStateData>> facets = refineFacets(searchPageData.getFacets(),
				convertBreadcrumbsToFacets(searchPageData.getBreadcrumbs()));
		final FacetRefinement<SearchStateData> refinement = new FacetRefinement<>();
		refinement.setFacets(facets);
		refinement.setCount(searchPageData.getPagination().getTotalNumberOfResults());
		refinement.setBreadcrumbs(searchPageData.getBreadcrumbs());
		return refinement;
	}

	@ResponseBody
	@RequestMapping(value = "/autocomplete/" + COMPONENT_UID_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
	public AutocompleteResultData getAutocompleteSuggestions(@PathVariable
	final String componentUid, @RequestParam("term") String term) throws CMSItemNotFoundException
	{

		final AutocompleteResultData resultData = new AutocompleteResultData();

		try
		{
			//Filter all special charecters
			term = term.replaceAll("[^a-zA-Z0-9 ]", "");

			term = XSSEncoder.encodeHTML(term);

		}
		catch (final UnsupportedEncodingException e)
		{

			LOG.info("Free text query is invalid: " + e.getMessage());
		}

		final SearchBoxComponentModel component = (SearchBoxComponentModel) cmsComponentService.getSimpleCMSComponent(componentUid);

		if (component.isDisplaySuggestions())
		{
			resultData.setSuggestions(subList(productSearchFacade.getAutocompleteSuggestions(term), component.getMaxSuggestions()));
		}

		if (component.isDisplayProducts())
		{
			final ProductSearchPageData<SearchStateData, ProductData> searchResultData = productSearchFacade.textSearch(term, SearchQueryContext.SUGGESTIONS);
			resultData.setProducts(subList(searchResultData.getResults(),
					component.getMaxProducts()));

			// We are restricting the result for categories as the related url were producing empty results (Please see BRAKESP2-1970) - TBI
			final ProductSearchPageData<SearchStateData, ProductData> searchResultDataForCategories = productSearchFacade.textSearch(term, SearchQueryContext.DEFAULT);
			populateCategorySuggestions(searchResultDataForCategories, resultData, component.getMaxCategorySuggestions());
		}
		LOG.info(CollectionUtils.isEmpty(resultData.getSuggestions()) ? " Suggestions are EMPTY " : " Suggestions are not EMPTY");
		if (CollectionUtils.isEmpty(resultData.getSuggestions()) && CollectionUtils.isEmpty(resultData.getProducts()))
		{
			LOG.info("Fetching Suggestions : ");

			resultData.setSpellingSuggestions(
					subList(productSearchFacade.getAutocompleteSpellingSuggestions(term), component.getMaxSpellSuggestions()));

		}

		return resultData;
	}

	/**
	 * @param searchResultData
	 * @param resultData
	 * @param maxSuggestions
	 */
	private void populateCategorySuggestions(final ProductSearchPageData<SearchStateData, ProductData> searchResultData,
			final AutocompleteResultData resultData, final Integer maxSuggestions)
	{
		final List<CategorySuggestData> categorySuggestionData = new ArrayList<>();
		if (CollectionUtils.isNotEmpty(searchResultData.getFacets()))
		{
			for (final FacetData<SearchStateData> facetData : searchResultData.getFacets())
			{
				if (facetData.getCode().equalsIgnoreCase(LEVEL_ONE_CATEGORIES))
				{
					final List<FacetValueData<SearchStateData>> values = facetData.getValues();
					for (final FacetValueData<SearchStateData> facetValueData : values)
					{
						final CategorySuggestData suggestionData = new CategorySuggestData();
						suggestionData.setCode(facetValueData.getCode());
						suggestionData.setName(facetValueData.getName());
						suggestionData.setCount(Long.valueOf(facetValueData.getCount()));
						suggestionData.setUrl(facetValueData.getQuery().getUrl());
						categorySuggestionData.add(suggestionData);
						if (categorySuggestionData.size() == maxSuggestions)
						{
							break;
						}
					}
					resultData.setCategorySuggestions(categorySuggestionData);
					break;
				}
			}
		}
		else
		{
			resultData.setCategorySuggestions(Collections.emptyList());
		}
	}

	protected <E> List<E> subList(final List<E> list, final int maxElements)
	{
		if (CollectionUtils.isEmpty(list))
		{
			return Collections.emptyList();
		}

		if (list.size() > maxElements)
		{
			return list.subList(0, maxElements);
		}

		return list;
	}

	protected void updatePageTitle(final ContentPageModel cmsPage, final Model model)
	{
		storeContentPageTitleInModel(model, cmsPage.getTitle());
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
