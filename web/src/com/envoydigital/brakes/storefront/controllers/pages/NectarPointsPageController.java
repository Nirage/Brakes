package com.envoydigital.brakes.storefront.controllers.pages;

import com.envoydigital.brakes.facades.BrakesNectarFacade;
import com.envoydigital.brakes.facades.nectar.data.NectarBonusRequestData;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.CollectNectarBonusForm;
import com.envoydigital.brakes.storefront.forms.CollectNectarForm;
import com.envoydigital.brakes.storefront.forms.validation.BrakesNectarCollectBonusValidator;
import com.envoydigital.brakes.storefront.forms.validation.BrakesNectarCollectValidator;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.ResourceBreadcrumbBuilder;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commercefacades.nectar.data.NectarItemData;
import de.hybris.platform.commercefacades.nectar.data.NectarLinkData;
import de.hybris.platform.commercefacades.user.UserFacade;
import de.hybris.platform.commercefacades.user.data.CompanyData;
import de.hybris.platform.commercefacades.user.data.TitleData;
import de.hybris.platform.commerceservices.customer.DuplicateUidException;
import de.hybris.platform.servicelayer.exceptions.ModelSavingException;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;


@Controller
@RequestMapping("/nectar-points")
public class NectarPointsPageController extends AbstractPageController
{

	private static final String NECTAR_CMS_PAGE = "nectarLandingPage";
	private static final String NECTAR_COLLECT_CMS_PAGE = "collectNectarPointsPage";
	private static final String NECTAR_COLLECT_BONUS_CMS_PAGE = "collectNectarBonusPointsPage";
	private static final String NECTAR_HELP_CMS_PAGE = "helpNectarPointsPage";
	private static final String BREADCRUMBS_ATTR = "breadcrumbs";
	private static final String FORM_GLOBAL_ERROR = "form.global.error";
	private static final String SUCCESSFULLY_LINKED_MSG = "nectarCollect.success.message";
	private static final String NECTAR_LINK_WEB_REQUEST_SOURCE = "Nectar Registration";

	@Resource(name = "userFacade")
	private UserFacade userFacade;

	@Resource(name = "brakesNectarFacade")
	private BrakesNectarFacade brakesNectarFacade;

	@Resource(name = "brakesNectarCollectValidator")
	private BrakesNectarCollectValidator brakesNectarCollectValidator;

	@Resource(name = "brakesNectarCollectBonusValidator")
	private BrakesNectarCollectBonusValidator brakesNectarCollectBonusValidator;

	@Resource(name = "nectarPointsBreadcrumbBuilder")
	private ResourceBreadcrumbBuilder nectarPointsBreadcrumbBuilder;

	@Resource(name = "nectarPointsSubBreadcrumbBuilder")
	private ResourceBreadcrumbBuilder nectarPointsSubBreadcrumbBuilder;

	@ModelAttribute("titles")
	public Collection<TitleData> getTitles()
	{
		return userFacade.getTitles();
	}

	@ModelAttribute("accountTypes")
	public List<CompanyData> getAccountTypes()
	{
		return brakesNectarFacade.getAccountTypes();
	}


	@RequestMapping(method = RequestMethod.GET)
	@RequireHardLogIn
	public String nectarPointsDetails(final Model model, final RedirectAttributes redirectModel,
			final HttpServletResponse httpServletResponse) throws CMSItemNotFoundException
	{
		String returnTarget;
		if (brakesNectarFacade.currentStoreSupportsNectar())
		{
			storeCmsPageInModel(model, getContentPageForLabelOrId(NECTAR_CMS_PAGE));
			setUpMetaDataForContentPage(model, getContentPageForLabelOrId(NECTAR_CMS_PAGE));
			model.addAttribute(BREADCRUMBS_ATTR, nectarPointsBreadcrumbBuilder.getBreadcrumbs("breadcrumb.nectarpoints"));
			returnTarget = getViewForPage(model);
		}
		else
		{
			returnTarget = getNotFoundPage(model, httpServletResponse);
		}
		return returnTarget;
	}

	@RequestMapping(value = "/link-your-account", method = RequestMethod.GET)
	@RequireHardLogIn
	public String collectNectarPoints(final Model model, final RedirectAttributes redirectModel,
			final HttpServletResponse httpServletResponse) throws CMSItemNotFoundException
	{
		String returnTarget;
		if (brakesNectarFacade.currentStoreSupportsNectar())
		{
			storeCmsPageInModel(model, getContentPageForLabelOrId(NECTAR_COLLECT_CMS_PAGE));
			model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
			setUpMetaDataForContentPage(model, getContentPageForLabelOrId(NECTAR_COLLECT_CMS_PAGE));
			model.addAttribute(BREADCRUMBS_ATTR, nectarPointsSubBreadcrumbBuilder.getBreadcrumbs("breadcrumb.collect.nectarpoints"));
			model.addAttribute(new CollectNectarForm());
			returnTarget = getViewForPage(model);
		}
		else
		{
			returnTarget = getNotFoundPage(model, httpServletResponse);
		}
		return returnTarget;
	}

	@RequestMapping(value = "/link-your-account", method = RequestMethod.POST)
	@RequireHardLogIn
	public String collectNectarPointsSubmit(final CollectNectarForm form, final Model model, final BindingResult bindingResult,
			final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		brakesNectarCollectValidator.validate(form, bindingResult);
		if (bindingResult.hasErrors())
		{
			model.addAttribute(form);
			GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
			return setUpViewForPage(NECTAR_COLLECT_CMS_PAGE, "breadcrumb.collect.nectarpoints", model);
		}

		final NectarLinkData nectarLinkData = new NectarLinkData();
		nectarLinkData.setNectarCardNo(form.getNectarCardNo());
		nectarLinkData.setBusinessName(form.getBusinessName());
		nectarLinkData.setAddressLine1(form.getAddressLine1());
		nectarLinkData.setAddressLine2(form.getAddressLine2());
		nectarLinkData.setTown(form.getTown());
		nectarLinkData.setCounty(form.getCounty());
		nectarLinkData.setPostCode(form.getPostCode());
		nectarLinkData.setEmail(form.getEmail());
		nectarLinkData.setConfirmEmail(form.getConfirmEmail());
		nectarLinkData.setPhoneNumber(form.getPhoneNumber());
		nectarLinkData.setMobileNumber(form.getMobileNumber());

		final List<NectarItemData> accounts = new ArrayList<>();

		int loopIndex = 0;
		for (final String accountNumber : form.getAccountNumber())
		{

			if (StringUtils.isNotEmpty(accountNumber))
			{

				final NectarItemData nectarItemData = new NectarItemData();
				nectarItemData.setAccountNumber(accountNumber);

				if (form.getAccountType().size() > loopIndex)
				{
					nectarItemData.setTypeOfAccount(form.getAccountType().get(loopIndex));
				}

				accounts.add(nectarItemData);
			}

			loopIndex++;
		}

		nectarLinkData.setAccounts(accounts);

		nectarLinkData.setTitle(form.getTitle());
		nectarLinkData.setFirstName(form.getFirstName());
		nectarLinkData.setLastName(form.getLastName());
		nectarLinkData.setOwnersTitle(form.getOwnersTitle());
		nectarLinkData.setOwnersFirstName(form.getOwnersFirstName());
		nectarLinkData.setOwnersLastName(form.getOwnersLastName());

		switch (form.getRelationType()) {
			case CollectNectarForm.LEGAL_OWNER:
				nectarLinkData.setRelationType(CollectNectarForm.LEGAL_OWNER);
				break;
			case CollectNectarForm.AUTHORISED_SIGNATORY:
				nectarLinkData.setRelationType(CollectNectarForm.AUTHORISED_SIGNATORY);
				break;
			case CollectNectarForm.EMPLOYEE:
				nectarLinkData.setRelationType(CollectNectarForm.EMPLOYEE);
				break;
			default:
				nectarLinkData.setRelationType(CollectNectarForm.LEGAL_OWNER);
		}

		nectarLinkData.setConsent(Boolean.TRUE);
		nectarLinkData.setRequestSource(NECTAR_LINK_WEB_REQUEST_SOURCE);

		try
		{

			brakesNectarFacade.linkAccount(nectarLinkData);
			model.addAttribute(new CollectNectarForm());
			GlobalMessages.addConfMessage(model, SUCCESSFULLY_LINKED_MSG);

		}
		catch (final DuplicateUidException | ModelSavingException e)
		{

			GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
			model.addAttribute(form);
		}

		return setUpViewForPage(NECTAR_COLLECT_CMS_PAGE, "breadcrumb.collect.nectarpoints", model);
	}

	@RequestMapping(value = "/validate-account", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public boolean validateAccount(@RequestParam("accountNumber")
	final String accountNumber, final Model model)
	{
		return brakesNectarCollectValidator.validateAccount(accountNumber);
	}

	@RequestMapping(value = "/validate-card-exists", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public boolean validateCardExists(@RequestParam("cardNumber")
								   final String cardNumber, final Model model)
	{
		return brakesNectarCollectValidator.validateCardExists(cardNumber);
	}


	@RequestMapping(value = "/bonus-points", method = RequestMethod.GET)
	@RequireHardLogIn
	public String collectNectarBonusPoints(final Model model, final RedirectAttributes redirectModel,
			final HttpServletResponse httpServletResponse) throws CMSItemNotFoundException
	{
		String returnTarget;
		if (brakesNectarFacade.currentStoreSupportsNectar())
		{
			storeCmsPageInModel(model, getContentPageForLabelOrId(NECTAR_COLLECT_BONUS_CMS_PAGE));
			setUpMetaDataForContentPage(model, getContentPageForLabelOrId(NECTAR_COLLECT_BONUS_CMS_PAGE));
			model.addAttribute(BREADCRUMBS_ATTR,
					nectarPointsSubBreadcrumbBuilder.getBreadcrumbs("breadcrumb.collect.bonus.nectarpoints"));
			model.addAttribute(new CollectNectarBonusForm());
			returnTarget = getViewForPage(model);
		}
		else
		{
			returnTarget = getNotFoundPage(model, httpServletResponse);
		}
		return returnTarget;
	}

	@RequestMapping(value = "/bonus-points", method = RequestMethod.POST)
	@RequireHardLogIn
	public String collectNectarBonusPointsSubmit(final CollectNectarBonusForm form, final BindingResult bindingResult,
			final Model model, final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		brakesNectarCollectBonusValidator.validate(form, bindingResult);
		if (bindingResult.hasErrors())
		{
			model.addAttribute(form);
			GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
			return setUpViewForPage(NECTAR_COLLECT_BONUS_CMS_PAGE, "breadcrumb.collect.bonus.nectarpoints", model);
		}

		final NectarBonusRequestData nectarBonusRequestData = new NectarBonusRequestData();
		nectarBonusRequestData.setEmail(form.getEmail());
		nectarBonusRequestData.setFirstName(form.getFirstName());
		nectarBonusRequestData.setLastName(form.getLastName());
		nectarBonusRequestData.setTitle(form.getTitle());
		nectarBonusRequestData.setNectarCardNo(form.getNectarCardNo());
		nectarBonusRequestData.setOptInCode(form.getOptInCode());

		try
		{

			brakesNectarFacade.linkBonusRequest(nectarBonusRequestData);
			model.addAttribute(new CollectNectarBonusForm());
			GlobalMessages.addConfMessage(model, SUCCESSFULLY_LINKED_MSG);

		}
		catch (final DuplicateUidException e)
		{

			bindingResult.rejectValue("nectarCardNo", "collectNectar.error.account.exists.title");
			GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
			model.addAttribute(form);
		}

		return setUpViewForPage(NECTAR_COLLECT_BONUS_CMS_PAGE, "breadcrumb.collect.bonus.nectarpoints", model);
	}

	@RequestMapping(value = "/help-faq", method = RequestMethod.GET)
	@RequireHardLogIn
	public String helpNectarPoints(final Model model, final RedirectAttributes redirectModel,
			final HttpServletResponse httpServletResponse) throws CMSItemNotFoundException
	{
		String returnTarget;
		if (brakesNectarFacade.currentStoreSupportsNectar())
		{
			storeCmsPageInModel(model, getContentPageForLabelOrId(NECTAR_HELP_CMS_PAGE));
			setUpMetaDataForContentPage(model, getContentPageForLabelOrId(NECTAR_HELP_CMS_PAGE));
			model.addAttribute(BREADCRUMBS_ATTR, nectarPointsSubBreadcrumbBuilder.getBreadcrumbs("breadcrumb.help.nectarpoints"));
			returnTarget = getViewForPage(model);
		}
		else
		{
			returnTarget = getNotFoundPage(model, httpServletResponse);
		}
		return returnTarget;
	}

	private String getNotFoundPage(final Model model, final HttpServletResponse httpServletResponse)
			throws CMSItemNotFoundException
	{
		prepareNotFoundPage(model, httpServletResponse);
		return ControllerConstants.Views.Pages.Error.ErrorNotFoundPage;
	}

	protected String setUpViewForPage(final String pageId, final String breadCrumbKey, final Model model)
			throws CMSItemNotFoundException
	{

		storeCmsPageInModel(model, getContentPageForLabelOrId(pageId));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(pageId));
		model.addAttribute(BREADCRUMBS_ATTR, nectarPointsSubBreadcrumbBuilder.getBreadcrumbs(breadCrumbKey));
		return getViewForPage(model);

	}
}
