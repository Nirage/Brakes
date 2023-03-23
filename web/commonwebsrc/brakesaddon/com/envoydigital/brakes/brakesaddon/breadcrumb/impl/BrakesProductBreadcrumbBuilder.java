package com.envoydigital.brakes.brakesaddon.breadcrumb.impl;

import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.Breadcrumb;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.impl.ProductBreadcrumbBuilder;
import de.hybris.platform.catalog.model.classification.ClassificationClassModel;
import de.hybris.platform.category.model.CategoryModel;
import de.hybris.platform.core.model.product.ProductModel;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

import com.envoydigital.brakes.core.services.BrakesProductService;


/**
 * ProductBreadcrumbBuilder implementation for {@link ProductData}
 */
public class BrakesProductBreadcrumbBuilder extends ProductBreadcrumbBuilder
{

	private BrakesProductService brakesProductService;

	private static final String LAST_LINK_CLASS = "active";

	@Override
	protected CategoryModel processCategoryModels(final Collection<CategoryModel> categoryModels, final CategoryModel toDisplay)
	{
		CategoryModel categoryToDisplay = toDisplay;

		for (final CategoryModel categoryModel : categoryModels)
		{
			if (!(categoryModel instanceof ClassificationClassModel)
					&& (categoryModel.getShowInFrontEnd() == null || Boolean.TRUE.equals(categoryModel.getShowInFrontEnd())))
			{
				if (categoryToDisplay == null)
				{
					categoryToDisplay = categoryModel;
				}
				if (getBrowseHistory().findEntryMatchUrlEndsWith(categoryModel.getCode()) != null)
				{
					break;
				}
			}
		}
		return categoryToDisplay;
	}

	/**
	 * Returns a list of breadcrumbs for the given product.
	 *
	 * @param productCode
	 * @return breadcrumbs for the given product
	 */
	@Override
	public List<Breadcrumb> getBreadcrumbs(final String productCode)
	{
		final ProductModel productModel = getBrakesProductService().getProductForCode(productCode, false);
		final List<Breadcrumb> breadcrumbs = new ArrayList<>();

		final Collection<CategoryModel> categoryModels = new ArrayList<>();
		final Breadcrumb last;

		final ProductModel baseProductModel = getBaseProduct(productModel);
		last = getProductBreadcrumb(baseProductModel);
		categoryModels.addAll(baseProductModel.getSupercategories());
		last.setLinkClass(LAST_LINK_CLASS);

		breadcrumbs.add(last);

		while (!categoryModels.isEmpty())
		{
			CategoryModel toDisplay = null;
			toDisplay = processCategoryModels(categoryModels, toDisplay);
			categoryModels.clear();
			if (toDisplay != null)
			{
				breadcrumbs.add(getCategoryBreadcrumb(toDisplay));
				categoryModels.addAll(toDisplay.getSupercategories());
			}
		}
		Collections.reverse(breadcrumbs);
		return breadcrumbs;
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

}


