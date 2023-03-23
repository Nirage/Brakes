package com.envoydigital.brakes.storefront.util;

import com.envoydigital.brakes.core.services.BrakesMetaDataService;
import de.hybris.platform.acceleratorservices.storefront.util.PageTitleResolver;
import de.hybris.platform.category.model.CategoryModel;
import de.hybris.platform.cms2.model.site.CMSSiteModel;
import de.hybris.platform.core.model.product.ProductModel;
import com.envoydigital.brakes.core.services.BrakesProductService;

public class BrakesPageTitleResolver extends PageTitleResolver
{
	private BrakesProductService brakesProductService;

	private BrakesMetaDataService metaDataService;

	@Override
	public String resolveProductPageTitle(final String productCode)
	{
		final ProductModel product = getBrakesProductService().getProductForCode(productCode, false);
		final CMSSiteModel currentSite = getCmsSiteService().getCurrentSite();

		return metaDataService.getProductPageMetaTitle(product, currentSite);
	}

	@Override
	public String resolveCategoryPageTitle(final CategoryModel category)
	{
		final CMSSiteModel currentSite = getCmsSiteService().getCurrentSite();

		return metaDataService.getCategoryPageMetaTitle(category, currentSite);
	}

	/**
	 * @return the brakesProductService
	 */
	public BrakesProductService getBrakesProductService()
	{
		return brakesProductService;
	}

	/**
	 * @param brakesProductService
	 *           the brakesProductService to set
	 */
	public void setBrakesProductService(final BrakesProductService brakesProductService)
	{
		this.brakesProductService = brakesProductService;
	}

	public BrakesMetaDataService getMetaDataService() {
		return metaDataService;
	}

	public void setMetaDataService(BrakesMetaDataService metaDataService) {
		this.metaDataService = metaDataService;
	}
}
