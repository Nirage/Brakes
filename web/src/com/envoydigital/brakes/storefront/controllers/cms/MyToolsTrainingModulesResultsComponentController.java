package com.envoydigital.brakes.storefront.controllers.cms;

import com.envoydigital.brakes.core.model.MyToolsTrainingModulesResultsComponentModel;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.TrainingModulesResultsForm;
import de.hybris.platform.acceleratorservices.config.SiteConfigService;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;


/**
 * Controller for CMS MyToolsTrainingModulesResultsComponentController
 */
@Controller("MyToolsTrainingModulesResultsComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.MyToolsTrainingModulesResultsComponent)
@RequireHardLogIn
public class MyToolsTrainingModulesResultsComponentController extends AbstractAcceleratorCMSComponentController<MyToolsTrainingModulesResultsComponentModel> {

    @Resource(name = "siteConfigService")
    private SiteConfigService siteConfigService;

    @Override
    protected void fillModel(final HttpServletRequest request, final Model model, final MyToolsTrainingModulesResultsComponentModel component) {
        model.addAttribute ( "trainingModulesResultsForm", new TrainingModulesResultsForm () );
        model.addAttribute ( "quizResultDatePattern" ,siteConfigService.getString ( "storefront.quiz.result.date.pattern", "dd/MM/yyyy hh:mm a" ) );
    }
}
