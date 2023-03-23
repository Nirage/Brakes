/**
 *
 */
package com.envoydigital.brakes.storefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.ContentPageModel;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


/**
 * @author Lakshmi
 *
 */
@Controller
@RequestMapping(value = "/my-country-choice")
public class MyCountryChoicePageController extends AbstractPageController
{

	private static final String MY_COUNTRY_CHOICE_CMS_PAGE = "myCountryChoice";

	@RequestMapping(method = RequestMethod.GET)
	public String myCountryChoice(final HttpServletRequest request, final HttpServletResponse response, final Model model)
			throws CMSItemNotFoundException
	{
		final ContentPageModel cmsPage = getContentPageForLabelOrId(MY_COUNTRY_CHOICE_CMS_PAGE);
		storeCmsPageInModel(model, cmsPage);
		setUpMetaDataForContentPage(model, cmsPage);
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
		setUpMetaData(model, null, cmsPage.getMetaDescription());
		return getViewForPage(model);
	}

}
