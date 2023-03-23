package com.envoydigital.brakes.storefront.controllers.cms;

import com.envoydigital.brakes.core.model.MyToolsTrainingModulesComponentModel;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.TrainingModulesForm;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;


/**
 * Controller for CMS MyToolsTrainingModulesComponentController
 */
@Controller("MyToolsTrainingModulesComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.MyToolsTrainingModulesComponent)
@RequireHardLogIn
public class MyToolsTrainingModulesComponentController extends AbstractAcceleratorCMSComponentController<MyToolsTrainingModulesComponentModel> {

    @Override
    protected void fillModel(final HttpServletRequest request, final Model model, final MyToolsTrainingModulesComponentModel component) {
        model.addAttribute("trainingModulesForm", new TrainingModulesForm ());
    }
}
