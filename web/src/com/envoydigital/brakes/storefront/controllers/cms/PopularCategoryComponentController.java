package com.envoydigital.brakes.storefront.controllers.cms;

import com.envoydigital.brakes.core.model.PopularCategoryComponentModel;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import de.hybris.platform.category.model.CategoryModel;
import de.hybris.platform.commerceservices.url.UrlResolver;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller("PopularCategoryComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.PopularCategoryComponent)
public class PopularCategoryComponentController extends AbstractAcceleratorCMSComponentController<PopularCategoryComponentModel> {

    @Resource(name = "seoCategoryModelUrlResolver")
    private UrlResolver<CategoryModel> categoryModelUrlResolver;

    @Override
    protected void fillModel(HttpServletRequest request, Model model, PopularCategoryComponentModel component) {

        final Map<String, String> categoryUrlMap = new HashMap<>();

        for (CategoryModel categoryModel :component.getCategories()) {

            categoryUrlMap.put(categoryModel.getCode(), categoryModelUrlResolver.resolve(categoryModel));
        }

        model.addAttribute("categoryUrlMap" , categoryUrlMap);


    }
}
