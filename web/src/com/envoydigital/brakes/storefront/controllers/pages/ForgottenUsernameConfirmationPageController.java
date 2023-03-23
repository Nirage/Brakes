package com.envoydigital.brakes.storefront.controllers.pages;

import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.AbstractPageModel;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(value = "/forgot-username-confirmation")
public class ForgottenUsernameConfirmationPageController extends AbstractPageController {

    @RequestMapping(method = RequestMethod.GET)
    public String showPage(final Model model)
            throws CMSItemNotFoundException
    {
        storeCmsPageInModel(model, getCmsPage());
        setUpMetaDataForContentPage(model, (ContentPageModel) getCmsPage());
        model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.INDEX_NOFOLLOW);
        return getView();
    }

    private AbstractPageModel getCmsPage() throws CMSItemNotFoundException
    {
        return getContentPageForLabelOrId("forgottenUsernameConfirmationPage");
    }

    private String getView() {
        return ControllerConstants.Views.Pages.Account.SimpleCustomerDialogPage;
    }


}
