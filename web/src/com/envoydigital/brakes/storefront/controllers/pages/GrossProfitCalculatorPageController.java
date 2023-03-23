package com.envoydigital.brakes.storefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.ResourceBreadcrumbBuilder;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.core.model.user.UserModel;
import de.hybris.platform.servicelayer.user.UserService;
import de.hybris.platform.site.BaseSiteService;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


@Controller
@RequestMapping("/gross-profit-calculator")
public class GrossProfitCalculatorPageController extends AbstractPageController
{

	private static final String GROSS_PROFIT_CALCULATOR_CMS_PAGE = "grossProfitCalculator";
	private static final String REDIRECT_LOGIN_URL = REDIRECT_PREFIX + "/sign-in";
	private static final String BREADCRUMBS_ATTR = "breadcrumbs";

	@Resource(name = "userService")
	private UserService userService;

	@Resource(name = "baseSiteService")
	private BaseSiteService baseSiteService;

	@Resource(name = "gpcBreadcrumbBuilder")
	private ResourceBreadcrumbBuilder gpcBreadcrumbBuilder;


	@RequestMapping(method = RequestMethod.GET)
	public String showGPC(final Model model, final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		if (baseSiteService.getCurrentBaseSite().getUid().equals("countryChoice"))
		{

			final UserModel currentUser = userService.getCurrentUser();
			if (userService.isAnonymousUser(currentUser))
			{
				return REDIRECT_LOGIN_URL;
			}
		}
		storeCmsPageInModel(model, getContentPageForLabelOrId(GROSS_PROFIT_CALCULATOR_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(GROSS_PROFIT_CALCULATOR_CMS_PAGE));
		model.addAttribute(BREADCRUMBS_ATTR, gpcBreadcrumbBuilder.getBreadcrumbs("breadcrumb.gpc"));
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.INDEX_FOLLOW);
		return getViewForPage(model);
	}
}
