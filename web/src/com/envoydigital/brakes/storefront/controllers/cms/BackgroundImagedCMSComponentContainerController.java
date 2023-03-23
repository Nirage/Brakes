package com.envoydigital.brakes.storefront.controllers.cms;

import com.envoydigital.brakes.model.BackgroundImagedCMSComponentContainerModel;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import de.hybris.platform.acceleratorcms.model.components.CMSTabParagraphContainerModel;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller("BackgroundImagedCMSComponentContainerController")
@RequestMapping(value = ControllerConstants.Actions.Cms.BackgroundImagedCMSComponentContainer)
public class BackgroundImagedCMSComponentContainerController extends AbstractAcceleratorCMSComponentController<BackgroundImagedCMSComponentContainerModel> {

    @Override
    protected void fillModel(HttpServletRequest request, Model model, BackgroundImagedCMSComponentContainerModel component) {
        model.addAttribute("components", component.getSimpleCMSComponents());
        model.addAttribute("backgroundImage", component.getBackgroundImage().getURL());
    }

}
