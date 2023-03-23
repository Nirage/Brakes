package com.envoydigital.brakes.storefront.controllers.cms;

import com.envoydigital.brakes.core.model.MyToolsTrainingModulePerformComponentModel;
import com.envoydigital.brakes.facades.quiz.QuizFacade;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.TrainingModulePerformForm;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;


/**
 * Controller for CMS MyToolsTrainingModulePerformComponentController
 */
@Controller("MyToolsTrainingModulePerformComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.MyToolsTrainingModulePerformComponent)
@RequireHardLogIn
public class MyToolsTrainingModulePerformComponentController extends AbstractAcceleratorCMSComponentController<MyToolsTrainingModulePerformComponentModel> {

    @Resource(name = "quizFacade")
    private QuizFacade quizFacade;

    @Override
    protected void fillModel(final HttpServletRequest request, final Model model, final MyToolsTrainingModulePerformComponentModel component) {
        model.addAttribute ( "trainingModulePerformForm", new TrainingModulePerformForm () );
        model.addAttribute ( "quizSession", quizFacade.getQuizSession () );
    }
}
