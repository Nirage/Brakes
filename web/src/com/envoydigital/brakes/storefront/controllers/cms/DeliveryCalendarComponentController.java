package com.envoydigital.brakes.storefront.controllers.cms;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.envoydigital.brakes.core.data.DeliveryCalendarData;
import com.envoydigital.brakes.core.model.DeliveryCalendarComponentModel;
import com.envoydigital.brakes.facades.BrakesDeliveryCalendarFacade;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.DeliveryCalendarForm;


/**
 * @author pantk
 *
 */
@Controller("DeliveryCalendarComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.DeliveryCalendarComponent)
public class DeliveryCalendarComponentController extends AbstractAcceleratorCMSComponentController<DeliveryCalendarComponentModel>
{
	@Resource
	BrakesDeliveryCalendarFacade brakesDeliveryCalendarFacade;

	@Override
	protected void fillModel(final HttpServletRequest request, final Model model, final DeliveryCalendarComponentModel component)
	{
		final DeliveryCalendarData deliveryCal = brakesDeliveryCalendarFacade.getDeliveryCalendar();
		model.addAttribute("deliveryCal", deliveryCal);

		model.addAttribute("delCalForm", new DeliveryCalendarForm());
	}
}
