/**
 *
 */
package com.envoydigital.brakes.storefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.servicelayer.i18n.I18NService;

import java.util.List;
import java.util.Locale;
import java.util.Objects;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.Pattern;
import javax.ws.rs.QueryParam;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.envoydigital.brakes.facades.BrakesSalesRepFacade;
import com.envoydigital.brakes.facades.salesRepo.data.SalesRepData;


/**
 * @author Lakshmi
 *
 */
@Controller
public class MyCCSalesRepController extends AbstractPageController
{
	private static final Logger LOG = LoggerFactory.getLogger(MyCCSalesRepController.class);
	private static final String REGEX_PATTREN_SALESREP_POSTCODE = "^([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z]))))\\s?[0-9][A-Za-z]{2})$";
	@Resource
	private BrakesSalesRepFacade brakesSalesRepFacade;

	@Resource
	private MessageSource messageSource;

	@Resource
	private I18NService i18nService;

	@ResponseBody
	@RequestMapping(value = "/localSalesRepResults", method = RequestMethod.GET, produces = "application/json")
	public ResponseEntity<SalesRepData> jsonSearchResults(
			@QueryParam("postCode") @Pattern(regexp = REGEX_PATTREN_SALESREP_POSTCODE) final String postCode, final Model model,
			final HttpServletRequest request) throws CMSItemNotFoundException
	{
		final Locale locale = i18nService.getCurrentLocale();
		final List<SalesRepData> searchSalesRepResultsDataList = brakesSalesRepFacade.getSalesRepResultsByPostcode(postCode.split(" ")[0]);
		final String response;
		if (Objects.nonNull(searchSalesRepResultsDataList))
		{
			model.addAttribute("searchSalesRepResultsData", searchSalesRepResultsDataList);
			return new ResponseEntity(searchSalesRepResultsDataList, HttpStatus.OK);
		}
		response = messageSource.getMessage("salesRep.postcode.noResults", null, locale);
		return new ResponseEntity(response, HttpStatus.INTERNAL_SERVER_ERROR);


	}
}
