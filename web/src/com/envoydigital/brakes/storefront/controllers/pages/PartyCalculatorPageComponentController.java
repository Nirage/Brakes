package com.envoydigital.brakes.storefront.controllers.pages;

import com.envoydigital.brakes.core.model.components.PartyCalculatorPageComponentModel;
import com.envoydigital.brakes.storefront.controllers.cms.AbstractAcceleratorCMSComponentController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.ContentPageModel;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.envoydigital.brakes.facades.BrakesPartyCalculatorFacade;
import com.envoydigital.brakes.facades.data.BrakesPartyCalculatorPerPersonData;
import com.envoydigital.brakes.facades.data.PartyCalculatorResponseData;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;


@Controller("PartyCalculatorPageComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.PartyCalculatorPageComponent)
public class PartyCalculatorPageComponentController extends AbstractAcceleratorCMSComponentController<PartyCalculatorPageComponentModel>
{
	private static final String PART_CALCULATOR_CMS_PAGE = "party-calculator";

	@Resource
	private BrakesPartyCalculatorFacade brakesPartyCalculatorFacade;

	@Override
	protected void fillModel(HttpServletRequest request, Model model, PartyCalculatorPageComponentModel component) {

		model.addAttribute("eventTypes", brakesPartyCalculatorFacade.getEventTypes());
	}

    @RequestMapping(value = "/eventTypePerPerson", produces = MediaType.APPLICATION_JSON)
    @ResponseBody
    public PartyCalculatorResponseData getPartyCalculatorPerPersonByEvent(@RequestParam("eventType")
                                                                          final String eventType, @RequestParam("noOfGuests")
                                                                          final Integer noOfGuests, final Model model)
    {
        final BrakesPartyCalculatorPerPersonData partyCalculatorPerPersonByEvent = brakesPartyCalculatorFacade
                .getPartyCalculatorPerPersonByEvent(eventType);
        final BrakesPartyCalculatorPerPersonData partyCalculatorPerBitesByEvent = brakesPartyCalculatorFacade
                .getPartyCalculaterPerBites(noOfGuests, eventType);
        final PartyCalculatorResponseData partyCalculatorResponseData = new PartyCalculatorResponseData();
        partyCalculatorResponseData.setPerPerson(partyCalculatorPerPersonByEvent);
        partyCalculatorResponseData.setPerBites(partyCalculatorPerBitesByEvent);
        model.addAttribute("perPerson", partyCalculatorPerPersonByEvent);
        model.addAttribute("perBites", partyCalculatorPerBitesByEvent);
        return partyCalculatorResponseData;
    }

}
