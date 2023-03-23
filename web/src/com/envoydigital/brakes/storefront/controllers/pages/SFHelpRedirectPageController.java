package com.envoydigital.brakes.storefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class SFHelpRedirectPageController extends AbstractPageController {

    private String SF_REDIRECT_CMS_PAGE = "sfExpCloudRedirectPage";
    @RequestMapping(value = "/sf-help-redirect",  method = RequestMethod.GET)
    public String getViewForSFHelpRedirect(final Model model) throws CMSItemNotFoundException {
        storeCmsPageInModel(model, getContentPageForLabelOrId(SF_REDIRECT_CMS_PAGE));
        setUpMetaDataForContentPage(model, getContentPageForLabelOrId(SF_REDIRECT_CMS_PAGE));
        return getViewForPage(model);
    }
}
