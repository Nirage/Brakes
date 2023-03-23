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


import com.envoydigital.brakes.facades.metadata.BrakesMetaDataFacade;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.util.MetaSanitizerUtil;
import de.hybris.platform.category.model.CategoryModel;
import de.hybris.platform.cms2.model.pages.CategoryPageModel;
import de.hybris.platform.commercefacades.product.data.CategoryData;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commercefacades.search.data.SearchStateData;
import de.hybris.platform.commerceservices.search.facetdata.FacetRefinement;
import de.hybris.platform.commerceservices.search.facetdata.ProductCategorySearchPageData;

import java.io.UnsupportedEncodingException;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.envoydigital.brakes.brakesaddon.controllers.pages.AbstractBrakesCategoryPageController;
import com.envoydigital.brakes.facades.BrakesAdditionalCategoryFacade;
import com.envoydigital.brakes.storefront.util.EnhancedXssFilterUtil;


/**
 * Controller for a category page
 */
@Controller
@RequestMapping(value = "/**/c")
public class CategoryPageController extends AbstractBrakesCategoryPageController
{

	@Resource(name = "brakesAdditionalCategoryFacade")
	private BrakesAdditionalCategoryFacade brakesAdditionalCategoryFacade;

	@Resource(name = "metaDataFacade")
	private BrakesMetaDataFacade metaDataFacade;

	@RequestMapping(value = CATEGORY_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
	public String category(@PathVariable("categoryCode")
	final String categoryCode, // NOSONAR
			@RequestParam(value = "q", required = false)
			final String searchQuery, @RequestParam(value = "page", defaultValue = "1")
			final int page, @RequestParam(value = "show", defaultValue = "Page")
			final ShowMode showMode, @RequestParam(value = "sort", required = false)
			final String sortCode, final Model model, final HttpServletRequest request, final HttpServletResponse response)
			throws UnsupportedEncodingException
	{
		System.out.println("search query" + searchQuery);
		final String sanitizedSearchQuery = EnhancedXssFilterUtil.filter(searchQuery);
		final CategoryModel category = getCommerceCategoryService().getCategoryForCode(categoryCode);
		final String view = performSearchAndGetResultsPage(categoryCode, sanitizedSearchQuery, page, showMode, sortCode, model,
				request, response);
		model.addAttribute("additionalCategories", brakesAdditionalCategoryFacade.getAdditionalCategories(category));

		if (category != null)
		{
			model.addAttribute("categoryDescription", category.getDescription());
			final String metaKeywords = MetaSanitizerUtil.sanitizeKeywords(
					category.getKeywords().stream().map(keywordModel -> keywordModel.getKeyword()).collect(Collectors.toSet()));
			final String metaDescription = MetaSanitizerUtil.sanitizeDescription(metaDataFacade.getCategoryPageMetaDescription(category));
			setUpMetaData(model, metaKeywords, metaDescription);
		}

		final RequestCache requestCache = new HttpSessionRequestCache();
		requestCache.saveRequest(request, response);
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.INDEX_FOLLOW);


		return view;
	}

	@ResponseBody
	@RequestMapping(value = CATEGORY_CODE_PATH_VARIABLE_PATTERN + "/facets", method = RequestMethod.GET)
	public FacetRefinement<SearchStateData> getFacets(@PathVariable("categoryCode")
	final String categoryCode, @RequestParam(value = "q", required = false)
	final String searchQuery, @RequestParam(value = "page", defaultValue = "1")
	final int page, @RequestParam(value = "show", defaultValue = "Page")
	final ShowMode showMode, @RequestParam(value = "sort", required = false)
	final String sortCode) throws UnsupportedEncodingException
	{
		final String sanitizedSearchQuery = EnhancedXssFilterUtil.filter(searchQuery);
		return performSearchAndGetFacets(categoryCode, sanitizedSearchQuery, page, showMode, sortCode);
	}

	@ResponseBody
	@RequestMapping(value = CATEGORY_CODE_PATH_VARIABLE_PATTERN + "/results", method = RequestMethod.GET)
	public SearchResultsData<ProductData> getResults(@PathVariable("categoryCode")
	final String categoryCode, @RequestParam(value = "q", required = false)
	final String searchQuery, @RequestParam(value = "page", defaultValue = "1")
	final int page, @RequestParam(value = "show", defaultValue = "Page")
	final ShowMode showMode, @RequestParam(value = "sort", required = false)
	final String sortCode) throws UnsupportedEncodingException
	{
		final String sanitizedSearchQuery = EnhancedXssFilterUtil.filter(searchQuery);
		return performSearchAndGetResultsData(categoryCode, sanitizedSearchQuery, page, showMode, sortCode);
	}


	@ResponseBody
	@RequestMapping(value = CATEGORY_CODE_PATH_VARIABLE_PATTERN + "/resultsandfacets", method = RequestMethod.GET)
	public ProductCategorySearchPageData<SearchStateData, ProductData, CategoryData> getResultsAndFacets(
			@PathVariable("categoryCode")
			final String categoryCode, @RequestParam(value = "q", required = false)
			final String searchQuery, @RequestParam(value = "page", defaultValue = "1")
			final int page, @RequestParam(value = "show", defaultValue = "Page")
			final ShowMode showMode, @RequestParam(value = "sort", required = false)
			final String sortCode) throws UnsupportedEncodingException
	{
		final String sanitizedSearchQuery = EnhancedXssFilterUtil.filter(searchQuery);
		return populateSearchPageData(categoryCode, sanitizedSearchQuery, page, showMode, sortCode);
	}

}
