package com.envoydigital.brakes.storefront.controllers.cms;

import de.hybris.platform.acceleratorcms.model.components.CategoryNavigationComponentModel;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractSearchPageController.ShowMode;
import de.hybris.platform.cms2.model.contents.components.CMSLinkComponentModel;
import de.hybris.platform.cms2.model.navigation.CMSNavigationEntryModel;
import de.hybris.platform.cms2.model.navigation.CMSNavigationNodeModel;
import de.hybris.platform.cms2.servicelayer.services.CMSSiteService;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commercefacades.search.ProductSearchFacade;
import de.hybris.platform.commercefacades.search.data.SearchStateData;
import de.hybris.platform.commerceservices.enums.SearchQueryContext;
import de.hybris.platform.commerceservices.search.facetdata.FacetData;
import de.hybris.platform.commerceservices.search.facetdata.FacetValueData;
import de.hybris.platform.commerceservices.search.facetdata.ProductSearchPageData;
import de.hybris.platform.commerceservices.search.pagedata.PageableData;
import de.hybris.platform.util.Config;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.envoydigital.brakes.facades.constants.BrakesFacadesConstants;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;


/**
 * @author maheshroyal
 *
 */
@Controller("CategoryNavigationComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.CategoryNavigationComponent)
public class CategoryNavigationComponentController
		extends AbstractAcceleratorCMSComponentController<CategoryNavigationComponentModel>
{

	@Resource(name = "productSearchFacade")
	ProductSearchFacade<ProductData> productSearchFacade;
	
	@Resource(name = "cmsSiteService")
	private CMSSiteService cmsSiteService;

	private static final String ALL_CATEGORIES = "category";
	private static final String PROMO_CC_URL = "/my-promo-products/getPromoProducts";
	private static final String PROMO_BRAKES_URL = "/promotions/monthly-promotions";
	private static final Logger LOG = Logger.getLogger(CategoryNavigationComponentController.class);


	@Override
	protected void fillModel(final HttpServletRequest request, final Model model, final CategoryNavigationComponentModel component)
	{
		String siteUid = cmsSiteService.getCurrentSite().getUid();
		model.addAttribute("name", component.getNavigationNode().getEntries());
		final boolean enableRestrictions = Config.getBoolean("enable.restrictions", false);
		if (enableRestrictions)
		{

			if (LOG.isDebugEnabled())
			{
				LOG.debug("********* START SOLR SEARCH FOR NAVIGATION *****");
			}
			final ProductSearchPageData searchresults = productSearchFacade.textSearch("", SearchQueryContext.NAVIGATION);
			final FacetData facetData = getAllCategories(searchresults);
			if (LOG.isDebugEnabled())
			{
				LOG.debug("********* END SOLR SEARCH FOR NAVIGATION *****");
			}
			final Set<String> categoriesList = facetData != null ? getFacetCategories(facetData) : null;
			if (request.getParameterMap() != null && request.getParameterMap().containsKey("debg"))
			{
				model.addAttribute("categoryList", categoriesList);
			}
			if (LOG.isDebugEnabled())
			{
				LOG.debug("********* START PROCESSING NODES ON COMPONENT *****");
			}
			if (categoriesList != null && CollectionUtils.isNotEmpty(categoriesList))
			{
				if(siteUid.equalsIgnoreCase(BrakesFacadesConstants.SITE_BRAKES)) {
					categoriesList.add(PROMO_BRAKES_URL);
				}else {
					categoriesList.add(PROMO_CC_URL);
				}
				setVisibleToNode(component, categoriesList);
			}
			else
			{
				setVisibleToNode(component, new HashSet<String>());
			}
			if (LOG.isDebugEnabled())
			{
				LOG.debug("*********END PROCESSING NODES ON COMPONENT  *****");
			}

		}

	}

	/**
	 * @param component
	 * @param nodeMap
	 * @param categoriesList
	 */
	private void setVisibleToNode(final CategoryNavigationComponentModel component, final Set<String> categoriesList)
	{
		for (final CMSNavigationNodeModel childLevel1 : component.getNavigationNode().getChildren())
		{
			boolean visible = false;
			for (final CMSNavigationEntryModel childLink1 : childLevel1.getEntries())
			{
				if (childLink1.getItem() instanceof CMSLinkComponentModel)
				{
					if (((CMSLinkComponentModel) childLink1.getItem()).getUrl() != null)
					{

						if (categoriesList.contains(((CMSLinkComponentModel) childLink1.getItem()).getUrl()))
						{
							visible = true;
						}
						childLevel1.setVisible(visible);
					}
					else if (((CMSLinkComponentModel) childLink1.getItem()).getCategory() != null)
					{

						if (categoriesList
								.contains(prepareCategoryUrl(((CMSLinkComponentModel) childLink1.getItem()).getCategory().getCode())))
						{
							visible = true;
						}
						childLevel1.setVisible(visible);
					}
				}
			}
			if (CollectionUtils.isNotEmpty(childLevel1.getChildren()))
			{
				for (final CMSNavigationNodeModel childLevel2 : childLevel1.getChildren())
				{
					for (final CMSNavigationEntryModel childLink2 : childLevel2.getEntries())
					{
						if (childLink2.getItem() instanceof CMSLinkComponentModel)
						{
							if (((CMSLinkComponentModel) childLink2.getItem()).getUrl() != null)
							{
								if (categoriesList.contains(((CMSLinkComponentModel) childLink2.getItem()).getUrl()))
								{
									visible = true;
								}
								childLevel2.setVisible(visible);
								childLevel1.setVisible(visible);
							}
							else if (((CMSLinkComponentModel) childLink2.getItem()).getCategory() != null)
							{
								if (categoriesList.contains(
										prepareCategoryUrl(((CMSLinkComponentModel) childLink2.getItem()).getCategory().getCode())))
								{
									visible = true;
								}
								childLevel2.setVisible(visible);
								childLevel1.setVisible(visible);
							}

						}

					}

					for (final CMSNavigationNodeModel childLevel3 : childLevel2.getChildren())
					{
						for (final CMSNavigationEntryModel childLink3 : childLevel3.getEntries())
						{
							if (childLink3.getItem() instanceof CMSLinkComponentModel)
							{
								if (((CMSLinkComponentModel) childLink3.getItem()).getUrl() != null)
								{
									if (categoriesList.contains(((CMSLinkComponentModel) childLink3.getItem()).getUrl()))
									{
										visible = true;
									}
									childLevel3.setVisible(visible);
									childLevel2.setVisible(visible);
									childLevel1.setVisible(visible);
								}
								else if (((CMSLinkComponentModel) childLink3.getItem()).getCategory() != null)
								{
									if (categoriesList.contains(
											prepareCategoryUrl(((CMSLinkComponentModel) childLink3.getItem()).getCategory().getCode())))
									{
										visible = true;
									}
									childLevel3.setVisible(visible);
									childLevel2.setVisible(visible);
									childLevel1.setVisible(visible);
								}
							}
						}
					}
				}
			}
		}
	}

	protected PageableData createPageableData(final int pageNumber, final int pageSize, final String sortCode,
			final ShowMode showMode)
	{
		final PageableData pageableData = new PageableData();
		pageableData.setCurrentPage(pageNumber);
		pageableData.setSort(sortCode);

		if (ShowMode.All == showMode)
		{
			pageableData.setPageSize(1000);
		}
		else
		{
			pageableData.setPageSize(pageSize);
		}
		return pageableData;
	}

	private FacetData<SearchStateData> getAllCategories(final ProductSearchPageData<SearchStateData, ProductData> searchPageData)
	{
		final Optional<FacetData<SearchStateData>> facetData = searchPageData.getFacets().stream()
				.filter(fd -> fd.getName().equalsIgnoreCase(ALL_CATEGORIES)).findFirst();
		if (facetData.isPresent())
		{
			return facetData.get();
		}
		else
		{
			return null;
		}

	}

	/**
	 *
	 * This method gets the all category strings from facetdata
	 *
	 * @param facetData
	 *
	 * @return Set<String>
	 */
	private Set<String> getFacetCategories(final FacetData facetData)
	{
		final List<FacetValueData> facetValueList = facetData.getValues();
		return facetValueList.stream().map(fv -> prepareCategoryUrl(fv.getCode())).collect(Collectors.toSet());
	}


	private String prepareCategoryUrl(final String categoryCode)
	{
		return new StringBuilder().append("/c/").append(categoryCode).toString();
	}

}
