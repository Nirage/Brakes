package com.envoydigital.brakes.storefront.controllers.cms;

import com.envoydigital.brakes.core.model.components.QuickAddItemToFavouriteComponentModel;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.QuickAddItemToFavouriteForm;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;


/**
 * Controller for CMS QuickAddItemToFavouriteComponent
 */
@Controller("QuickAddItemToFavouriteComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.QuickAddItemToFavouriteComponent)
@RequireHardLogIn
public class QuickAddItemToFavouriteComponentController extends AbstractAcceleratorCMSComponentController<QuickAddItemToFavouriteComponentModel> {

    @Override
    protected void fillModel(final HttpServletRequest request, final Model model, final QuickAddItemToFavouriteComponentModel component) {
        QuickAddItemToFavouriteForm quickAddItemToFavouriteForm = new QuickAddItemToFavouriteForm ();
        quickAddItemToFavouriteForm.setQty ( 1L );
        model.addAttribute("quickAddItemToFavouriteForm", quickAddItemToFavouriteForm);
    }
}
