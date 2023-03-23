package com.envoydigital.brakes.storefront.controllers.misc;

import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class CSRFTokenController extends AbstractController {

    @RequestMapping(value = "/csrftoken",  method = RequestMethod.GET)
    public String getCXRFToken() {
        return ControllerConstants.Views.Pages.Misc.MiscSiteCsrfTokenPage;
    }
}
