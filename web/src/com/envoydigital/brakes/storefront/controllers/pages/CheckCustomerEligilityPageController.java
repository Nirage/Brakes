package com.envoydigital.brakes.storefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.Breadcrumb;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.ContentPageModel;

import java.util.Collections;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.envoydigital.brakes.storefront.controllers.ControllerConstants;


@Controller
@RequestMapping(value = "/become-a-customer-eligible")
public class CheckCustomerEligilityPageController extends AbstractPageController
{


	@RequestMapping(method = RequestMethod.GET)
	public String doLogin(final Model model) throws CMSItemNotFoundException
	{
		storeCmsPageInModel(model, getCmsPage());
		setUpMetaDataForContentPage(model, getCmsPage());
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.INDEX_NOFOLLOW);
		final Breadcrumb breadcrumbEntry = new Breadcrumb("#", getMessageSource().getMessage("header.link.eligilitypage", null,
				"header.link.eligilitypage", getI18nService().getCurrentLocale()), null);
		model.addAttribute("breadcrumbs", Collections.singletonList(breadcrumbEntry));
		return ControllerConstants.Views.Pages.Account.AccountCheckCustomerEligilityPage;
	}

	private ContentPageModel getCmsPage() throws CMSItemNotFoundException
	{
		return getContentPageForLabelOrId("checkCustomerEligilityPage");
	}

}
