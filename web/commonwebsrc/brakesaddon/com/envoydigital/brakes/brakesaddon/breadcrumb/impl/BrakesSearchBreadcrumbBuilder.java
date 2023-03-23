package com.envoydigital.brakes.brakesaddon.breadcrumb.impl;

import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.Breadcrumb;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.impl.SearchBreadcrumbBuilder;
import de.hybris.platform.catalog.model.classification.ClassificationClassModel;
import de.hybris.platform.category.model.CategoryModel;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

public class BrakesSearchBreadcrumbBuilder extends SearchBreadcrumbBuilder {

    private static final String LAST_LINK_CLASS = "active";

    @Override
    protected void createBreadcrumbCategoryHierarchyPath(final String categoryCode, final boolean emptyBreadcrumbs,
                                                         final List<Breadcrumb> breadcrumbs)
    {
        // Create category hierarchy path for breadcrumb
        final List<Breadcrumb> categoryBreadcrumbs = new ArrayList<>();
        final Collection<CategoryModel> categoryModels = new ArrayList<>();
        final CategoryModel lastCategoryModel = getCommerceCategoryService().getCategoryForCode(categoryCode);
        categoryModels.addAll(lastCategoryModel.getSupercategories());
        categoryBreadcrumbs.add(getCategoryBreadcrumb(lastCategoryModel, !emptyBreadcrumbs ? LAST_LINK_CLASS : ""));

        while (!categoryModels.isEmpty())
        {
            final CategoryModel categoryModel = categoryModels.iterator().next();

            if (!(categoryModel instanceof ClassificationClassModel) && (categoryModel.getShowInFrontEnd() == null || Boolean.TRUE.equals(categoryModel.getShowInFrontEnd())))
            {
                if (categoryModel != null)
                {
                    categoryBreadcrumbs.add(getCategoryBreadcrumb(categoryModel));
                    categoryModels.clear();
                    categoryModels.addAll(categoryModel.getSupercategories());
                }
            }
            else
            {
                categoryModels.remove(categoryModel);
            }
        }
        Collections.reverse(categoryBreadcrumbs);
        breadcrumbs.addAll(categoryBreadcrumbs);
    }
}

